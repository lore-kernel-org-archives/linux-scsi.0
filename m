From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] SCSI: possible cleanups
Date: Mon, 28 Feb 2005 22:25:09 +0000
Message-ID: <20050228222509.GB19376@infradead.org>
References: <20050228213159.GO4021@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:63725 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261787AbVB1WZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 17:25:23 -0500
Content-Disposition: inline
In-Reply-To: <20050228213159.GO4021@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Mon, Feb 28, 2005 at 10:31:59PM +0100, Adrian Bunk wrote:
> Before I'm getting flamed to death:
> This patch contains possible cleanups. If parts of this patch conflict 
> with pending changes these parts of my patch have to be dropped.
> 
> This patch contains the following possible cleanups:
> - make needlessly global code static
> - remove or #if 0 the following unused functions:
>   - scsi.h: print_driverbyte
>   - scsi.h: print_hostbyte

these two please kill.

>   - constants.c: scsi_print_hostbyte
>   - constants.c: scsi_print_driverbyte

these we'll probably keep for now.

>   - scsi_scan.c: scsi_scan_single_target

this one will grow a user soon, but maybe it'll be completely
rewritten before.

> - remove the following unneeded EXPORT_SYMBOL's:
>   - constants.c: __scsi_print_sense

this was put in for a drivea and makes sense as API.

>   - hosts.c: scsi_host_lookup

we should probably kill this export.

>   - scsi.c: scsi_device_cancel
>   - scsi_lib.c: scsi_device_resume

dito.

>   - scsi_error.c: scsi_normalize_sense
>   - scsi_error.c: scsi_sense_desc_find

st is expected to use these soon.

>   - scsi_scan.c: scsi_rescan_device

aacraid was going to use that one, Mark, any chance to get a patch
anytime soon?

>   - scsi_scan.c: scsi_scan_single_target

as mentioned above we'll need this one soon.
