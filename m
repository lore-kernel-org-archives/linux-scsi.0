From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c8xx_2: Use standard command-names
Date: Mon, 6 Sep 2004 09:49:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906094945.B4262@infradead.org>
References: <Pine.LNX.4.60.0409052225100.2062@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:61190 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267652AbUIFItw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Sep 2004 04:49:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409052225100.2062@poirot.grange>; from g.liakhovetski@gmx.de on Sun, Sep 05, 2004 at 10:27:40PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Sun, Sep 05, 2004 at 10:27:40PM +0200, Guennadi Liakhovetski wrote:
> Hi
> 
> A trivial patch to use standard names for INQUIRY and TEST_UNIT_READY.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski

> Use standard command-names.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> diff -u a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c	17 Aug 2004 20:34:58
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	5 Sep 2004 20:19:45
> @@ -536,7 +536,7 @@
>  	 *  devices behave badly when asked for some non 
>  	 *  zero LUN. Btw, this is an absolute hack.:-)
>  	 */
> -	if (ccb->cmnd[0] == 0x12 || ccb->cmnd[0] == 0x0) {
> +	if (ccb->cmnd[0] == INQUIRY || ccb->cmnd[0] == TEST_UNIT_READY) {
>  		if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
>  		    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && 
>  		     ccb->device->lun != 0)) {

Note that this code should go away completely.  sym2 should check in
->slave_configure for the nvram flags and not in queuecommand.

