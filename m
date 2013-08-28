From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: re: [SCSI] arcmsr: Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284
Date: Wed, 28 Aug 2013 20:25:39 +0400
Message-ID: <117626e3-2685-4e78-aedf-0df85ae03983@email.android.com>
References: <20130828154848.GA571@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42454 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab3H1QZp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 12:25:45 -0400
In-Reply-To: <20130828154848.GA571@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, ching2048@areca.com.tw
Cc: linux-scsi@vger.kernel.org



Dan Carpenter <dan.carpenter@oracle.com> wrote:
>Hello =E9=BB=83=E6=B8=85=E9=9A=86,
>
>The patch 17628f3a062b: "[SCSI] arcmsr: Support Areca new SATA Raid
>Adapter ARC1214/1224/1264/1284" from Aug 26, 2013, leads to the
>following Smatch warning:
>"drivers/scsi/arcmsr/arcmsr_hba.c:3580 arcmsr_hbaD_get_config()
>	 warn: signedness bug returning '(-12)'"
>
>drivers/scsi/arcmsr/arcmsr_hba.c
>3576          dma_coherent =3D dma_alloc_coherent(&pdev->dev,
>acb->uncache_size,
>  3577          &dma_coherent_handle, GFP_KERNEL);
>  3578          if (!dma_coherent) {
>  3579                  pr_notice("DMA allocation failed...\n");
>  3580                  return -ENOMEM;
>                        ^^^^^^^^^^^^^^
>This should be returning false.
>
>  3581          }
>
>Line 3577 has messed up indenting.
>
>Also this patch says it adds support for new hardware but almost 900
>lines out of this 3605 line patch are white space changes.  Do the
>unrelated white space changes in a separate patch.
>
>This patch also re-introduces a bug which I fixed in the mainline
>kernel
>a year ago.
>
>drivers/scsi/arcmsr/arcmsr_hba.c
>  4525                          writel(0xD, &pmuC->write_sequence);
>4526                  } while ((((temp =3D readl(&pmuC->host_diagnosti=
c))
>|
>                                                                      =
^
>This should be a '&' not a '|'.  Please fix this again back to the way
>it was.
>
>  4527                  ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) &&
>  4528                  (count < 5));
>
>The indenting here is messed up as well.  This is a very low quality
>patch.
>
>I think you are not using git internally in your company and that is
>why
>you are messing up so badly.  Please learn to use it.  Keep track of
>the
>fixes which go into the mainline kernel.  Separate the white space
>cleanups from the new features.

OK based on this I'll drop the arcmsr updates pending a rewrite.

James
--=20
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
