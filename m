From: Jeffrey Phillips Freeman <jeffreyfreeman@syncleus.com>
Subject: Re: [patch 30/31] scsi: clean up warnings in Advansys driver
Date: Fri, 09 Jun 2006 02:53:41 -0400
Message-ID: <44891AF5.30406@syncleus.com>
References: <200606090524.k595O5dX032361@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 70.88.236.253-BusName-floridaave.dc.hfc.comcastbusiness.net ([70.88.236.253]:46781
	"EHLO mail.syncleus.com") by vger.kernel.org with ESMTP
	id S1750940AbWFIGxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 02:53:31 -0400
In-Reply-To: <200606090524.k595O5dX032361@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, ken@krwtech.com

Oh, its great to see my name on the advansys list as a tester. You 
almost got filed away with the rest of my spam. I would love to test 
this patch but before i do is there some howto or overview document to 
help familarize me as a tester. I am comfortable with linuc and the 
kernel as well as patching. But i wasnt sure if there was a perticular 
version of the kernal i should try this patch on or a procedure i should 
follow. Any information that can be provided to go about this properly 
would be apprecaited. I would love to contribute, and if im going to 
contribute it should be done right!

akpm@osdl.org wrote:

>From: Ken Witherow <ken@krwtech.com>
>
>Fix typecast warnings and switch from check_region to request_region
>
>(akpm: Ken and Jeffrey Phillips Freeman <jeffreyfreeman@syncleus.com> are
>possible advansys testers)
>
>Signed-off-by: Ken Witherow <ken@krwtech.com>
>Signed-off-by: Andrew Morton <akpm@osdl.org>
>---
>
> drivers/scsi/advansys.c |    7 +++++--
> 1 files changed, 5 insertions(+), 2 deletions(-)
>
>diff -puN drivers/scsi/advansys.c~scsi-clean-up-warnings-in-advansys-driver drivers/scsi/advansys.c
>--- devel/drivers/scsi/advansys.c~scsi-clean-up-warnings-in-advansys-driver	2006-04-30 00:13:25.000000000 -0700
>+++ devel-akpm/drivers/scsi/advansys.c	2006-04-30 00:13:25.000000000 -0700
>@@ -4415,7 +4415,7 @@ advansys_detect(struct scsi_host_templat
>                         ASC_DBG1(1,
>                                 "advansys_detect: probing I/O port 0x%x...\n",
>                             iop);
>-                        if (check_region(iop, ASC_IOADR_GAP) != 0) {
>+			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
>                             printk(
> "AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
>                             /* Don't try this I/O port twice. */
>@@ -4425,6 +4425,7 @@ advansys_detect(struct scsi_host_templat
>                             printk(
> "AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
>                             /* Don't try this I/O port twice. */
>+			    release_region(iop, ASC_IOADR_GAP);
>                             asc_ioport[ioport] = 0;
>                             goto ioport_try_again;
>                         } else {
>@@ -4443,6 +4444,7 @@ advansys_detect(struct scsi_host_templat
>                                   * 'ioport' past this board.
>                                   */
>                                  ioport++;
>+				 release_region(iop, ASC_IOADR_GAP);
>                                  goto ioport_try_again;
>                             }
>                         }
>@@ -9752,13 +9754,14 @@ AscSearchIOPortAddr11(
>     }
>     for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
>         iop_base = _asc_def_iop_base[i];
>-        if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
>+	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")){
>             ASC_DBG1(1,
>                "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
>                      iop_base);
>             continue;
>         }
>         ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n", iop_base);
>+	release_region(iop_base, ASC_IOADR_GAP);
>         if (AscFindSignature(iop_base)) {
>             return (iop_base);
>         }
>_
>
>  
>

