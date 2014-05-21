From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND] scsi: Output error messages using structured
 printk in single line
Date: Wed, 21 May 2014 11:22:02 +0900
Message-ID: <1400638922.2481.18.camel@dabdike>
References: <20140227041738.31316.14684.stgit@yunodevel>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140227041738.31316.14684.stgit@yunodevel>
Sender: linux-kernel-owner@vger.kernel.org
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, Prarit Bhargava <prarit@redhat.com>, linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, yrl.pp-manager.tt@hitachi.com, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-02-27 at 13:17 +0900, Yoshihiro YUNOMAE wrote:
> +/* Maximum size of a local buffer for structured printk */
> +#define SCSI_LOG_LINE_MAX 512
> +
> +/* Local buffer for structured printk */
> +struct scsi_log_line {
> +	int offset;
> +	char buf[SCSI_LOG_LINE_MAX];
> +};

This piece isn't going to fly; it's an on stack allocation of 0.5kb;
that's too much for small stack kernels.  Just changing this to a kalloc
is going be problematic too because we're in the io paths and the
allocation may fail.  So I appreciate the problem, but I don't think the
solution works.  Could we just tag the messages and use grep to put them
back together?

James
