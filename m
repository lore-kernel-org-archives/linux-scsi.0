From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Linux-usb-users] Read errors on Flash Drive Transcend TS1GJF2A
Date: Mon, 26 Nov 2007 17:55:05 +0200
Message-ID: <474AEC59.9050805@panasas.com>
References: <Pine.LNX.4.44L0.0711261034090.4250-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:35721 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbXKZQpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2007 11:45:43 -0500
In-Reply-To: <Pine.LNX.4.44L0.0711261034090.4250-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <ltuikov@yahoo.com>, RTE <raszilki@yandex.ru>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Nov 26 2007 at 17:35 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> Not all devices correctly report the error-causing LBA in the
> Information field of their sense data -- even when they set the Valid
> bit.  This patch (as1019) makes sd much more cautious about accepting
> the reported LBA.  If the value isn't within the range of blocks
> accessed during the I/O operation it is rejected, and instead the
> driver will try looking at the residue field (which currently it
> ignores completely).
> 
> This fixes a data-corruption bug reported here:
> 
> 	http://marc.info/?t=118745764700005&r=1&w=2
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Luben Tuikov <ltuikov@yahoo.com>
> 
> ---
> 
> This patch should be considered for inclusion in 2.6.24.  The bug in
> question has always existed, as far as I know, but before 2.6.18 it was
> masked by a different bug.
> 
> This doesn't use the new SCSI accessors.  In the development trees
> I've seen, those accessors haven't yet been imported into sd.c.  If
> the patch needs to be rebased, please let me know where to find the
> current sd source.
> 
It's currently only in mm patchset has:
bidi-support-sr-sd-remove-dead-code.patch 
&&
bidi-support-scsi_data_buffer.patch

> Presumably sr should use the same algorithm.  That's grist for another
> patch.
> 
> 
> Index: usb-2.6/drivers/scsi/sd.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/sd.c
> +++ usb-2.6/drivers/scsi/sd.c
> @@ -968,7 +968,17 @@ static int sd_done(struct scsi_cmnd *SCp
<snip>

If this is a bugfix for 2.6.24 than I will be the one to rebase,
as scsi_data_buffer is only for 2.6.25, I hope ;)

Andrew once above goes into scsi-rc-fixes or scsi-misc I will send
a rebase, if I've fallen asleep please bang me on the head, thanks.

Alen thanks for doing this It was on my must-investigate list.
(Though I'm usually not using sd)

Boaz
