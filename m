From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] scsi: hisi_sas: Add support for DIX feature for v3 hw
Date: Fri, 08 Feb 2019 18:13:55 -0500
Message-ID: <yq1zhr5vpos.fsf@oracle.com>
References: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
        <1549450376-114929-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549450376-114929-2-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 6 Feb 2019 18:52:51 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org


John,

Just noticed this while inspecting the resulting complete diff:

>  static u32 get_prot_chk_msk_v3_hw(struct scsi_cmnd *scsi_cmnd)
>  {
>  	unsigned char prot_flags = scsi_cmnd->prot_flags;
>  
> -	if (prot_flags & SCSI_PROT_TRANSFER_PI) {
> -		if (prot_flags & SCSI_PROT_REF_CHECK)
> -			return 0xc << 16;
> -		return 0xfc << 16;
> -	}
> -	return 0;
> +	if (prot_flags & SCSI_PROT_REF_CHECK)
> +		return T10_CHK_APP_TAG_MSK;

Polarity is a bit unclear here. Is this statement disabling checking of
the app tag?

> +	return T10_CHK_REF_TAG_MSK | T10_CHK_APP_TAG_MSK;
>  }

-- 
Martin K. Petersen	Oracle Linux Engineering
