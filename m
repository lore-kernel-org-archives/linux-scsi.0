From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Tue, 19 Oct 2010 13:03:44 +0900
Message-ID: <4CBD18A0.5070206@ce.jp.nec.com>
References: <20100825155918.GB8509@redhat.com>	<4C7B984E.4070802@suse.de>	<4C7B9F14.9080900@mvista.com>	<4C7BA670.2060303@suse.de> <4C7BC5B4.3010707@suse.de> <4CBC00B3.7090603@ce.jp.nec.com> <4CBC35AE.9050002@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CBC35AE.9050002@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, jack@suse.cz, vst@vlnb.net, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, Sergei Shtylyov <sshtylyov@mvista.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

(10/18/10 20:55), Hannes Reinecke wrote:
>> Does 'retryable' of EIO mean retryable in multipath layer?
>> If so, what is the difference between EIO and ENOLINK?
>>
> Yes, EIO is intended for errors which should be retried at the
> multipath layer. This does _not_ include transport errors, which are
> signalled by ENOLINK.
> 
> Basically, ENOLINK is a transport error, and EIO just means
> something is wrong and we weren't able to classify it properly.
> If we were, it'd be either ENOLINK or EREMOTEIO.
> 
>> I've heard of a case where just retrying within path-group is
>> preferred to (relatively costly) switching group.
>> So, if EIO (or other error code) can be used to indicate such type
>> of errors, it's nice.
>>
> Yes, that was one of the intention.

Great to hear that.

And when it comes to retrying, the next problem is who controls it.
I don't think it's good to duplicate retry logic in multipath and
underlying device like SCSI (i.e. sd retries 5 times).
So perhaps we need a way to disable (or limit) retries in underlying
device at least.

>> Also (although this might be a bit off topic from your patch),
>> can we expand such a distinction to what should be logged?
>> Currently, it's difficult to distinguish important SCSI/block errors
>> and less important ones in kernel log.
>> For example, when I get a link failure on sda, kernel prints something
>> like below, regardless of whether the I/O is recovered by multipathing or not:
>>   end_request: I/O error, dev sda, sector XXXXX
>>
> Indeed, when using the above we could be modifying the above
> message, eg by
> 
> end_request: transport error, dev sda, sector XXXXX
> 
> or
> 
> end_request: target error, dev sda, sector XXXXX
> 
> which would improve the output noticeable.

It improves but still they look like critical errors
even if multipath saves them.

When I see this:

  end_request: target error, dev sda, sector XXXXX

I can't tell whether it's a real error visible to user space
or it's just recoverred by multipath retry/failover afterwards.


>> Setting REQ_QUIET in dm-multipath could mask the message
>> but also other important ones in SCSI.
>>
> Hmm. Not sure about that, but I think the above modifications will
> be useful already.
> 
> I'll be sending an updated patch.

Thank you. I'm looking for that.

-- 
Jun'ichi Nomura, NEC Corporation
