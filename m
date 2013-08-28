From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284
Date: Wed, 28 Aug 2013 18:48:48 +0300
Message-ID: <20130828154848.GA571@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41548 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3H1Ps7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 11:48:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ching2048@areca.com.tw
Cc: linux-scsi@vger.kernel.org

Hello =E9=BB=83=E6=B8=85=E9=9A=86,

The patch 17628f3a062b: "[SCSI] arcmsr: Support Areca new SATA Raid
Adapter ARC1214/1224/1264/1284" from Aug 26, 2013, leads to the
following Smatch warning:
"drivers/scsi/arcmsr/arcmsr_hba.c:3580 arcmsr_hbaD_get_config()
	 warn: signedness bug returning '(-12)'"

drivers/scsi/arcmsr/arcmsr_hba.c
  3576          dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->un=
cache_size,
  3577          &dma_coherent_handle, GFP_KERNEL);
  3578          if (!dma_coherent) {
  3579                  pr_notice("DMA allocation failed...\n");
  3580                  return -ENOMEM;
                        ^^^^^^^^^^^^^^
This should be returning false.

  3581          }

Line 3577 has messed up indenting.

Also this patch says it adds support for new hardware but almost 900
lines out of this 3605 line patch are white space changes.  Do the
unrelated white space changes in a separate patch.

This patch also re-introduces a bug which I fixed in the mainline kerne=
l
a year ago.

drivers/scsi/arcmsr/arcmsr_hba.c
  4525                          writel(0xD, &pmuC->write_sequence);
  4526                  } while ((((temp =3D readl(&pmuC->host_diagnost=
ic)) |
                                                                       =
   ^
This should be a '&' not a '|'.  Please fix this again back to the way
it was.

  4527                  ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) &&
  4528                  (count < 5));

The indenting here is messed up as well.  This is a very low quality
patch.

I think you are not using git internally in your company and that is wh=
y
you are messing up so badly.  Please learn to use it.  Keep track of th=
e
fixes which go into the mainline kernel.  Separate the white space
cleanups from the new features.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
