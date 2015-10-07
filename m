From: "Ketan Mukadam" <ketan.mukadam@avagotech.com>
Subject: RE: [PATCH 1/1] be2iscsi : Add warning message for unsupported adapter
Date: Wed, 7 Oct 2015 15:02:54 +0530
Message-ID: <002801d100e3$2802e6b0$7808b410$@avagotech.com>
References: <1438381208-7780-1-git-send-email-ketan.mukadam@avagotech.com> <5613EDF2.605@cs.wisc.edu>
Reply-To: <ketan.mukadam@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36207 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbbJGJdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2015 05:33:02 -0400
Received: by pablk4 with SMTP id lk4so16427954pab.3
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2015 02:33:01 -0700 (PDT)
In-Reply-To: <5613EDF2.605@cs.wisc.edu>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Mike,

We will not support these cards going forward and hence a warning message. 

Ketan


-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Tuesday, October 06, 2015 9:21 PM
To: Ketan Mukadam; linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] be2iscsi : Add warning message for unsupported
adapter

On 07/31/2015 05:20 PM, Ketan Mukadam wrote:
> Add a warning message to indicate obsolete/unsupported
> BE2 Adapter Family devics
> 
> Signed-off-by: Ketan Mukadam <ketan.mukadam@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 ++  
> drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c 
> b/drivers/scsi/be2iscsi/be_main.c index 7a6dbfb..9b0c5cc 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5619,6 +5619,8 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
>  	case OC_DEVICE_ID2:
>  		phba->generation = BE_GEN2;
>  		phba->iotask_fn = beiscsi_iotask;
> +		dev_warn(&pcidev->dev,
> +			 "Obsolete, Unsupported BE2 Adapter Family\n");

I think you wanted this to be a "/" instead of a "," to match below, but I
am not sure if it matters too much.

>  		break;
>  	case BE_DEVICE_ID2:
>  	case OC_DEVICE_ID3:
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c 
> b/drivers/scsi/be2iscsi/be_mgmt.c index ca4016f..ac08adb 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1535,7 +1535,8 @@ beiscsi_adap_family_disp(struct device *dev, struct
device_attribute *attr,
>  	case BE_DEVICE_ID1:
>  	case OC_DEVICE_ID1:
>  	case OC_DEVICE_ID2:
> -		return snprintf(buf, PAGE_SIZE, "BE2 Adapter Family\n");
> +		return snprintf(buf, PAGE_SIZE, "Obsolete/Unsupported "
> +						"BE2 Adapter Family\n");
>  		break;

Were these the cards that were obsolete when the driver was first added.
If so then this seem fine.



