From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: Re: [RFC PATCH 07/10] scsi/trace: Use scsi_show_result trace
 point instead of printk
Date: Wed, 03 Sep 2014 10:17:10 +0900
Message-ID: <54066C16.7070900@hitachi.com>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115022.6768.33712.stgit@yuno-kbuild.novalocal> <53FDE743.2040705@suse.de> <20140829005039.GA2876@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140829005039.GA2876@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

Sorry for the late reply.

(2014/08/29 9:50), Christoph Hellwig wrote:
>> I'm not sure this is the correct way.
>> Currently we have quite some code duplication in scsi_trace.c and
>> constants.c, correct.
>> So I definitely would like to see them both merged.
>>
>> But constants.c is influenced by CONFIG_SCSI_CONSTANTS, whereas
>> scsi_trace isn't, and the functions in constants.c are used throughout the
>> scsi stack.
>> So I'd rather see to have scsi_trace to be updated to use the functions
>> from constants.c, and remove the duplicate code in
>> scsi_trace.
>
> The tracepoints need to use the magic print_flags & co helpers so that
> output works properly if using the binary tracebuffer and user space tools that
> decoded it (e.g. trace-cmd or perf), so using a kernel function for decoding is
> not an option.

Ah, I see.
The "format" files in SCSI traceevents output decoders, so we don't
need to implement own decoders in userland.

I think the current problem is duplicated decoders, so we'll
consolidate those. If we use decoders in constants.c, the decoders are
not output in format file, so user tools cannot decode the binary.
On the other hand, if we use decoders in scsi_trace.c, the output format
of command names is changed and there are unsupported command names.

We would use decoders in scsi_trace.c and add new command names to
decoders in scsi_trace.c, I think.
How do you think about this? Hannes?


As another topic, we found that we cannot decode SCSI traceevents by
using current decoder in format files. For example, format file of
scsi_dispatch_cmd_timeout outputs prot_op as follows:

__print_symbolic(REC->prot_op, { SCSI_PROT_NORMAL, "SCSI_PROT_NORMAL" }, 
{ SCSI_PROT_READ_INSERT, "SCSI_PROT_READ_INSERT" }, { 
SCSI_PROT_WRITE_STRIP, "SCSI_PROT_WRITE_STRIP" }, { 
SCSI_PROT_READ_STRIP, "SCSI_PROT_READ_STRIP" }, { 
SCSI_PROT_WRITE_INSERT, "SCSI_PROT_WRITE_INSERT" }, { 
SCSI_PROT_READ_PASS, "SCSI_PROT_READ_PASS" }, { SCSI_PROT_WRITE_PASS, 
"SCSI_PROT_WRITE_PASS" })

Decoding will fail to do macro expansion here, so we need to fix this.
(We don't use enum for traceevents.)

Thanks,
Yoshihiro YUNOMAE

> But we can make these tracepoints dependent on CONFIG_SCSI_CONSTANTS to
> still allow building lighter kernels if we really care about it.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
