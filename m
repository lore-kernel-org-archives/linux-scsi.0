From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 4/5] scsi: hisi_sas: Add support for DIF feature for v3 hw
Date: Wed, 12 Dec 2018 21:20:17 -0500
Message-ID: <yq1o99qgobi.fsf@oracle.com>
References: <1544103284-100497-1-git-send-email-john.garry@huawei.com>
        <1544103284-100497-5-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544103284-100497-5-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 6 Dec 2018 21:34:43 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org


John,

> +static void fill_prot_v3_hw(struct scsi_cmnd *scsi_cmnd,
> +			    struct hisi_sas_protect_iu_v3_hw *prot)
> +{
> +	u8 prot_type = scsi_get_prot_type(scsi_cmnd);
> +	u8 prot_op = scsi_get_prot_op(scsi_cmnd);
> +	unsigned int interval = scsi_prot_interval(scsi_cmnd);
> +	u32 lbrt_chk_val;
> +
> +	if (interval == 4096)
> +		lbrt_chk_val = (u32)(scsi_get_lba(scsi_cmnd) >> 3);
> +	else
> +		lbrt_chk_val = (u32)scsi_get_lba(scsi_cmnd);

lbrt_chk_val = t10_pi_ref_tag(scmd->request);

> +
> +	switch (prot_op) {
> +	case SCSI_PROT_READ_STRIP:
> +		prot->dw0 |= (T10_RMV_EN_MSK | T10_CHK_EN_MSK);
> +		prot->lbrtcv = lbrt_chk_val;
> +		if (prot_type == SCSI_PROT_DIF_TYPE1)
> +			prot->dw4 |= (0xc << 16);
> +		else if (prot_type == SCSI_PROT_DIF_TYPE3)
> +			prot->dw4 |= (0xfc << 16);

We're moving away from prot_type. You should use:

enum scsi_prot_flags {
        SCSI_PROT_TRANSFER_PI           = 1 << 0,
        SCSI_PROT_GUARD_CHECK           = 1 << 1,
        SCSI_PROT_REF_CHECK             = 1 << 2,
        SCSI_PROT_REF_INCREMENT         = 1 << 3,
        SCSI_PROT_IP_CHECKSUM           = 1 << 4,
};

to set your controller flags.

+		if (prot_op == SCSI_PROT_WRITE_INSERT) {
+			unsigned int interval = scsi_prot_interval(scsi_cmnd);
+			unsigned int ilog2_interval = ilog2(interval);
+
+			len = (task->total_xfer_len >> ilog2_interval) * 8;

scsi_transfer_length(struct scsi_cmnd *scmd)

> +	if (hisi_hba->enable_dif) {
> +		dev_info(dev, "Registering for DIF type 1/2/3 protection.\n");
> +		prot |=	SHOST_DIF_TYPE1_PROTECTION |
> +			SHOST_DIF_TYPE2_PROTECTION |
> +			SHOST_DIF_TYPE3_PROTECTION;
> +	}
> +
> +	scsi_host_set_prot(hisi_hba->shost, prot);

I'm not so keen on this enable_dif/enable_dix business in module
parameters. I suggest you just allow the user to specify the host
protection mask instead of having a layer of indirection.

-- 
Martin K. Petersen	Oracle Linux Engineering
