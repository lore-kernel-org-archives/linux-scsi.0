From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fixed invalid assignment of 64bit mask to host
 dma_boundary for scatter gather segment boundary limit.
Date: Sun, 15 Feb 2015 10:38:01 -0800
Message-ID: <1424025481.2114.22.camel@HansenPartnership.com>
References: <e20a4b22-45bf-4c2e-9e5e-cdd2a238effd@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46261 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbbBOSiE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2015 13:38:04 -0500
In-Reply-To: <e20a4b22-45bf-4c2e-9e5e-cdd2a238effd@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Cc: "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Mike Christie (michaelc@cs.wisc.edu)" <michaelc@cs.wisc.edu>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>, Sony John-N <Sony.John-N@Emulex.Com>

On Mon, 2015-02-09 at 18:54 +0000, Minh Duc Tran wrote:
> In reference to bug https://bugzilla.redhat.com/show_bug.cgi?id=1097141
> Assert is seen with AMD cpu whenever calling pci_alloc_consistent.
> 
> [   29.406183] ------------[ cut here ]------------ 
> [   29.410505] kernel BUG at lib/iommu-helper.c:13!
> 
> Signed-off-by: Minh Tran <minh.tran@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index f319340..9cc047b 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -586,7 +586,6 @@ static struct beiscsi_hba *beiscsi_hba_alloc(struct pci_dev *pcidev)
>                         "beiscsi_hba_alloc - iscsi_host_alloc failed\n");
>                 return NULL;
>         }
> -       shost->dma_boundary = pcidev->dma_mask;
>         shost->max_id = BE2_MAX_SESSIONS;
>         shost->max_channel = 0;
>         shost->max_cmd_len = BEISCSI_MAX_CMD_LEN;

Please fix your email tool: this patch has all the tabs converted to
spaces.

Plus, this bug was introduced in 2009 by 

commit 6733b39a1301b0b020bbcbf3295852e93e624cb1
Author: Jayamohan Kallickal <jayamohank@serverengines.com>
Date:   Sat Sep 5 07:36:35 2009 +0530

So it needs a cc to stable.  If you added all the information like this
in the first place and use proper email tools, I wouldn't have to dig
for it when reviewing the patch and fix up the whitespace damage.

James


