From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 17:56:43 +0400
Message-ID: <4C50371B.7010102@vlnb.net>
References: <20100727165627.GA474@lst.de> <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C4FF592.9090800@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Tejun Heo, on 07/28/2010 01:17 PM wrote:
> On 07/28/2010 11:00 AM, Christoph Hellwig wrote:
>> On Wed, Jul 28, 2010 at 10:58:30AM +0200, Tejun Heo wrote:
>>> I see.  It probably would be good to have ordering requirements
>>> carried in the bio / request, so that filesystems can mix and match
>>> barriers of different strengths as necesasry.  As you seem to be
>>> already working on it, are you interested in pursuing that direction?
>>
>> I've been working on that for a while, but it got a lot more urgent
>> as there's been an application hit particularly hard by the barrier
>> semantics on cache less devices and people started getting angry
>> about it.  That's why fixing this for cache less devices has become
>> a higher priority than solving the big picture.
>
> Well, if disabling barrier works around the problem for them (which is
> basically what was suggeseted in the first message), that's not too
> bad for short term, I think.  At least, there's a handy workaround.
> I'll re-read barrier code and see how hard it would be to implement a
> proper solution.

For all the people working on barriers I'd recommend to use a 
Linux-based software SCSI device implemented using SCST framework 
(http://scst.sourceforge.net). This isn't an advertisement, SCST is 
really handy for such tasks. With it you can make your device be write 
through/write back/FUA/NV cache/etc., you can fully see the flow of 
commands sent by your Linux initiator, you can insert filters on some of 
them, perform various failure injections to check how robust your 
implementation, etc. SCST fully processed ORDERED commands as required 
by SAM.

You can start from iSCSI target and vdisk backend dev handler. For it, 
for example, to see the full flow of commands you should perform (with 
proc interface) "echo "add scsi" >/proc/scsi_tgt/trace_level", to see 
FUA/sync cache commands only: "echo "add order" 
 >/proc/scsi_tgt/vdisk/trace_level". The output will be in the kernel 
log, so you may need to increase CONFIG_LOG_BUF_SHIFT.

For 1.0.1.x I have a patch implementing ACA developed by one SCST using 
company, which is going to be integrated in the trunk in v2.1. This 
patch was needed for AIX to work in full performance and now used in 
production. With it implementation of UA_INTLCK is trivial and I can do 
it upon request.

Vlad
