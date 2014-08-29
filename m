From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 07/10] scsi/trace: Use scsi_show_result trace point
	instead of printk
Date: Fri, 29 Aug 2014 02:50:39 +0200
Message-ID: <20140829005039.GA2876@lst.de>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115022.6768.33712.stgit@yuno-kbuild.novalocal> <53FDE743.2040705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53FDE743.2040705@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> I'm not sure this is the correct way.
> Currently we have quite some code duplication in scsi_trace.c and 
> constants.c, correct.
> So I definitely would like to see them both merged.
>
> But constants.c is influenced by CONFIG_SCSI_CONSTANTS, whereas
> scsi_trace isn't, and the functions in constants.c are used throughout the 
> scsi stack.
> So I'd rather see to have scsi_trace to be updated to use the functions 
> from constants.c, and remove the duplicate code in
> scsi_trace.

The tracepoints need to use the magic print_flags & co helpers so that
output works properly if using the binary tracebuffer and user space tools that
decoded it (e.g. trace-cmd or perf), so using a kernel function for decoding is
not an option.

But we can make these tracepoints dependent on CONFIG_SCSI_CONSTANTS to
still allow building lighter kernels if we really care about it.
