From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/22] scsi: consolidate scsi_print_status()
Date: Sun, 31 Aug 2014 15:14:39 -0700
Message-ID: <20140831221439.GF16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaHaWOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:14:41 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

>  #if defined(AHA152X_DEBUG)
> -	if (HOSTDATA(shpnt)->debug & debug_status) {
> -		printk(DEBUG_LEAD "inbound status %02x ", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.Status);
> -		scsi_print_status(CURRENT_SC->SCp.Status);
> -		printk("\n");
> -	}
> +	if (HOSTDATA(shpnt)->debug & debug_status)
> +		printk(DEBUG_LEAD "inbound status %02x\n", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.Status);

This one just removes the call.  While this is fine with me it needs to
be mentioned in the changelog.

Also if you change the line above it please make sure it fits into an
80 character line.

> +const char *
>  scsi_print_status(unsigned char scsi_status) {
> -#ifdef CONFIG_SCSI_CONSTANTS

Please explain in the changelog why you're removing this ifdef.

> +	case SAM_STAT_BUSY:
> +		ccp = "Busy"; break;

Please put the break statements on separate lines per normal Linux
style.

>  #define scsi_prot_op_name(result)	{ result, #result }
>  #define show_prot_op_name(val)					\
>  	__print_symbolic(val,					\
> @@ -331,7 +316,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		  show_driverbyte_name(((__entry->result) >> 24) & 0xff),
>  		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
>  		  show_msgbyte_name(((__entry->result) >> 8) & 0xff),
> -		  show_statusbyte_name(__entry->result & 0xff))
> +		  scsi_print_status(__entry->result & 0xff))


Not using __print_symbolic for trace events breaks all tracing tools
that parse the binary trace buffers, please drop the tracing changes
(which weren't mentioned in the changelog anyway and should have been a
separate patch).

