From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi : Add warning message for unsupported adapter
Date: Tue, 06 Oct 2015 10:51:14 -0500
Message-ID: <5613EDF2.605@cs.wisc.edu>
References: <1438381208-7780-1-git-send-email-ketan.mukadam@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41748 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbbJFPvW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Oct 2015 11:51:22 -0400
In-Reply-To: <1438381208-7780-1-git-send-email-ketan.mukadam@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ketan Mukadam <ketan.mukadam@avagotech.com>, linux-scsi@vger.kernel.org

On 07/31/2015 05:20 PM, Ketan Mukadam wrote:
> Add a warning message to indicate obsolete/unsupported
> BE2 Adapter Family devics
> 
> Signed-off-by: Ketan Mukadam <ketan.mukadam@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 ++
>  drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 7a6dbfb..9b0c5cc 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5619,6 +5619,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
>  	case OC_DEVICE_ID2:
>  		phba->generation = BE_GEN2;
>  		phba->iotask_fn = beiscsi_iotask;
> +		dev_warn(&pcidev->dev,
> +			 "Obsolete, Unsupported BE2 Adapter Family\n");

I think you wanted this to be a "/" instead of a "," to match below, but
I am not sure if it matters too much.

>  		break;
>  	case BE_DEVICE_ID2:
>  	case OC_DEVICE_ID3:
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index ca4016f..ac08adb 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1535,7 +1535,8 @@ beiscsi_adap_family_disp(struct device *dev, struct device_attribute *attr,
>  	case BE_DEVICE_ID1:
>  	case OC_DEVICE_ID1:
>  	case OC_DEVICE_ID2:
> -		return snprintf(buf, PAGE_SIZE, "BE2 Adapter Family\n");
> +		return snprintf(buf, PAGE_SIZE, "Obsolete/Unsupported "
> +						"BE2 Adapter Family\n");
>  		break;

Were these the cards that were obsolete when the driver was first added.
If so then this seem fine.


