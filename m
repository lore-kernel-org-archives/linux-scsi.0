From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Fix device not ready printk
Date: Sun, 23 Sep 2007 08:25:01 -0600
Message-ID: <20070923142501.GI10625@parisc-linux.org>
References: <20070629132126.GA18722@parisc-linux.org> <20070719185145.GU14791@parisc-linux.org> <1190556526.3378.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44603 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbXIWOZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2007 10:25:03 -0400
Content-Disposition: inline
In-Reply-To: <1190556526.3378.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Sep 23, 2007 at 09:08:46AM -0500, James Bottomley wrote:
> The main thing I don't like is that we've spent a lot of time moving
> sense prints into a library so that if someone gullible^Wsensible enough
> to want to do a reporting infrastructure comes along, we have all the
> entry points nicely laid out, this is a retrograde step on that because
> it reintroduces the open coding.

Your patch is certainly an improvement from that point of view; it
consolidates two calls (which would have to be tied together by said
infrastructure) into one.

> How about something like the attached.  It does exactly what you want
> but retains the tap into the constants file for logging?

> +/*
> + * Print normalized SCSI sense header with device information and a prefix.
> + */
> +void
> +scsi_cmd_print_sense_hdr(struct scsi_cmnd *scmd, const char *name,
> +			  struct scsi_sense_hdr *sshdr)
> +{
> +	scmd_printk(KERN_INFO, scmd, "%s: ", name);
> +	scsi_show_sense_hdr(sshdr);
> +	scmd_printk(KERN_INFO, scmd, "%s: ", name);
> +	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
> +}

I think 'name' is wrong.  It's not a name, it's a description.  How
about s/name/desc/g ?

With that change, Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
