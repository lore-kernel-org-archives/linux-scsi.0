From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
Date: Fri, 08 Aug 2014 15:07:07 +0200
Message-ID: <53E4CB7B.7020705@interlog.com>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33568 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbaHHNHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 09:07:12 -0400
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Christoph Hellwig <hch@lst.de>

On 14-08-08 01:50 PM, Yoshihiro YUNOMAE wrote:
> Hi All,
>
> This patch set introduces new traceevents in order to output continuous error
> messages. Current SCSI printk messages in upstream kernel can be divided by and
> mixed with other messages. Even if each error message has its device id,
> sometimes we can easily be lost in mixed logs because the message's device id
> is separated from it's body. To avoid it, I'd like to use traceevents to
> store error messages into the ftrace or perf buuffer, because traceevents
> are atomically commited to the buffer.
>
> In this patch set, all printk messages are removed based on a local
> discussion with Hannes, but I think printk messages should be kept because all
> users don't enable traceevents and rsyslog can store as files.
>
> However, if printk of logging branch is kept, the messages are duplicate and
> it can induce stack overflow by using local buffer(*1).
>
>   (*1) https://lkml.org/lkml/2014/5/20/742
>
> So, my suggestion is follows:
>
> 1) printk
> Keeps current implemntation of upstream kernel.
> The messages are divided and can be mixed, but all users can check the error
> messages without any settings.
>
> 2) traceevents
> To get the complete messages, we can use ftrace or perf (or something on them).
> Users can always understand correct messages, but they need to set up the
> tracers.
>
> This patch set is based on Hannes' logging branch:
> http://git.kernel.org/cgit/linux/kernel/git/hare/scsi-devel.git/log/?h=logging
>
> [1/10] ~  [6/10]: just cleanup for logging branch
> [7/10] ~ [10/10]: introduce new traceevents
>
> Any comments are welcome!

In sg3_utils there are now string yielding equivalents
to the sense buffer "print" functions. They take a form
like this:
   char * get_sense_str(const unsigned char * sense_buffer,
                        int sb_len, int blen, char * b);

So this just does the hard work of decoding the sense buffer
(or saying it is invalid) the result of which it places in
buffer 'b'. And 'b' is returned (so this function can be in
the arguments of a driver's printing function).

Adding such string functions would give other parts of the
SCSI subsystem the capability of tailoring their own
messages that include sense data information.


Existing sense buffer "print" function could be kept and
implemented using the newer "_str" variants. Would that
be worth the trouble?

Doug Gilbert


