From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V3 6/9] aacraid: Fundamental reset support for Series 7
Date: Tue, 19 Jan 2016 16:43:54 +0100
Message-ID: <569E59BA.8060503@redhat.com>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-7-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbcASPn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jan 2016 10:43:58 -0500
In-Reply-To: <1452842182-684-7-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, shane.seymour@hpe.com, David.Carroll@pmcs.com

On 15.1.2016 08:16, Raghava Aditya Renukunta wrote:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>
> Series 7 does not support PCI hot reset used by EEH.
>
> Enabled fundamental reset only for Series 7
>
> Changes in V2:
> None
>
> Changes in V3:
> None

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

>
> Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/aacraid/linit.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 6d79181..6944560 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -1135,6 +1135,12 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>  	u64 dmamask;
>  	extern int aac_sync_mode;
>  
> +	/*
> +	 * Only series 7 needs freset.
> +	 */
> +	 if (pdev->device == PMC_DEVICE_S7)
> +		pdev->needs_freset = 1;
> +
>  	list_for_each_entry(aac, &aac_devices, entry) {
>  		if (aac->id > unique_id)
>  			break;

