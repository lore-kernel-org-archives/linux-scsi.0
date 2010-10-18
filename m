From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Mon, 18 Oct 2010 17:09:23 +0900
Message-ID: <4CBC00B3.7090603@ce.jp.nec.com>
References: <20100825155918.GB8509@redhat.com>	<4C7B984E.4070802@suse.de>	<4C7B9F14.9080900@mvista.com>	<4C7BA670.2060303@suse.de> <4C7BC5B4.3010707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C7BC5B4.3010707@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, jack@suse.cz, vst@vlnb.net, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@suse.de, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, Sergei Shtylyov <sshtylyov@mvista.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

Thank you for working on this issue and sorry for very late reply...

(08/30/10 23:52), Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.de>
> Date: Mon, 30 Aug 2010 16:21:10 +0200
> Subject: [RFC][PATCH] scsi: Detailed I/O errors
> 
> Instead of just passing 'EIO' for any I/O errors we should be
> notifying the upper layers with some more details about the cause
> of this error.
> This patch updates the possible I/O errors to:
> 
> - ENOLINK: Link failure between host and target
> - EIO: Retryable I/O error
> - EREMOTEIO: Non-retryable I/O error
> 
> 'Retryable' in this context means that an I/O error _might_ be
> restricted to the I_T_L nexus (vulgo: path), so retrying on another
> nexus / path might succeed.

Does 'retryable' of EIO mean retryable in multipath layer?
If so, what is the difference between EIO and ENOLINK?

I've heard of a case where just retrying within path-group is
preferred to (relatively costly) switching group.
So, if EIO (or other error code) can be used to indicate such type
of errors, it's nice.


Also (although this might be a bit off topic from your patch),
can we expand such a distinction to what should be logged?
Currently, it's difficult to distinguish important SCSI/block errors
and less important ones in kernel log.
For example, when I get a link failure on sda, kernel prints something
like below, regardless of whether the I/O is recovered by multipathing or not:
  end_request: I/O error, dev sda, sector XXXXX

Setting REQ_QUIET in dm-multipath could mask the message
but also other important ones in SCSI.


Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
