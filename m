From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] drivers/scsi/lpfc/lpfc_hw.h: Some minor cleanup.
Date: Tue, 30 Oct 2007 15:44:02 +0000
Message-ID: <200710301544.02765.vda.linux@googlemail.com>
References: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:41861 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbXJ3PoL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 11:44:11 -0400
Received: by ug-out-1314.google.com with SMTP id z38so137573ugc
        for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2007 08:44:09 -0700 (PDT)
In-Reply-To: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: James.Bottomley@steeleye.com, James.Smart@emulex.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tuesday 30 October 2007 10:54, Richard Knutsson wrote:
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Diffed against linus-git
> Checked with script/checkpatch.pl
> 
> 
> diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
> index 451accd..6f56528 100644
> --- a/drivers/scsi/lpfc/lpfc_hw.h
> +++ b/drivers/scsi/lpfc/lpfc_hw.h
> @@ -3158,31 +3158,30 @@ struct lpfc_sli2_slim {
>   *
>   * Parameters:
>   * device : struct pci_dev 's device field
> - *
> - * return 1 => TRUE
> - *        0 => FALSE
>   */
> -static inline int
> +static inline bool
>  lpfc_is_LC_HBA(unsigned short device)
>  {
> -	if ((device == PCI_DEVICE_ID_TFLY) ||
> -	    (device == PCI_DEVICE_ID_PFLY) ||
> -	    (device == PCI_DEVICE_ID_LP101) ||
> -	    (device == PCI_DEVICE_ID_BMID) ||
> -	    (device == PCI_DEVICE_ID_BSMB) ||
> -	    (device == PCI_DEVICE_ID_ZMID) ||
> -	    (device == PCI_DEVICE_ID_ZSMB) ||
> -	    (device == PCI_DEVICE_ID_RFLY))
> -		return 1;
> -	else
> -		return 0;
> +	switch (device) {
> +	case PCI_DEVICE_ID_TFLY:
> +	case PCI_DEVICE_ID_PFLY:
> +	case PCI_DEVICE_ID_LP101:
> +	case PCI_DEVICE_ID_BMID:
> +	case PCI_DEVICE_ID_BSMB:
> +	case PCI_DEVICE_ID_ZMID:
> +	case PCI_DEVICE_ID_ZSMB:
> +	case PCI_DEVICE_ID_RFLY:
> +		return true;
> +	}
> +
> +	return false;
>  }

Why is this patch useful? I'd rather do this instead:

-static inline int
+static int

(this function has three callsites, thus de-inlining will
make code smaller)
--
vda
