From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] aacraid: pci_set_dma_max_seg_size opened up for
	late model controllers
Date: Wed, 06 Feb 2008 11:54:57 -0600
Message-ID: <1202320497.3112.92.camel@localhost.localdomain>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D643D@ADPE2K703.adaptec.com>
	 <20080205234912B.tomof@acm.org>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4397D6932@ADPE2K703.adaptec.com>
	 <20080206101148L.fujita.tomonori@lab.ntt.co.jp>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34475 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbYBFRzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 12:55:16 -0500
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "tomof@acm.org" <tomof@acm.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "jeff@garzik.org" <jeff@garzik.org>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, 2008-02-06 at 09:00 -0800, Salyzyn, Mark wrote:
> This patch depends on 'RE: [patch 048/265] iommu sg merging: aacraid: use pci_set_dma_max_seg_size' and ensures that the modern adapters get a maximum sg segment size on par with the maximum transfer size. Added some localized janitor fixes to the discussion patch I used with Fujita.
> 
> FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] sez:
> > I think that setting the proper maximum segment size for the late
> > model cards (as you did above) makes sense.
> 
> This attached patch is against current linux-2.6. It will not apply to current scsi-misc-2.6 without the above mentioned dependency.
> 
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's handling of patch attachments. Please use the attached file to patch
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

OK, I have this, but someone really needs to do a little more checkpatch
love:

jejb@mulgrave> ./scripts/checkpatch.pl ~/tmp.mail
ERROR: use tabs not spaces
#44: FILE: drivers/scsi/aacraid/linit.c:1138:
+ ^I^Ishost->sg_tablesize = 34;$

ERROR: use tabs not spaces
#45: FILE: drivers/scsi/aacraid/linit.c:1139:
+ ^I^Ishost->max_sectors = (shost->sg_tablesize * 8) + 112;$

ERROR: use tabs not spaces
#54: FILE: drivers/scsi/aacraid/linit.c:1144:
+ ^I^Ishost->sg_tablesize = 17;$

ERROR: use tabs not spaces
#55: FILE: drivers/scsi/aacraid/linit.c:1145:
+ ^I^Ishost->max_sectors = (shost->sg_tablesize * 8) + 112;$

ERROR: use tabs not spaces
#60: FILE: drivers/scsi/aacraid/linit.c:1150:
+ ^I^I^I(shost->max_sectors << 9) : 65536);$

total: 5 errors, 0 warnings, 44 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

James


