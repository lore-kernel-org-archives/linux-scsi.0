From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v2] megaraid: fix out-of-bound array accesses
Date: Tue, 18 Dec 2018 23:24:50 -0500
Message-ID: <yq1y38mgn3h.fsf@oracle.com>
References: <20181206212252.36732-1-cai@lca.pw>
        <20181213132727.57058-1-cai@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213132727.57058-1-cai@lca.pw> (Qian Cai's message of "Thu,
        13 Dec 2018 08:27:27 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, thenzl@redhat.com, hch@lst.de, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
> index 59ecbb3b53b5..a33628550425 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> @@ -1266,7 +1266,7 @@ void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *drv_map,
>  
>  	for (ldCount = 0; ldCount < MAX_LOGICAL_DRIVES_EXT; ldCount++) {
>  		ld = MR_TargetIdToLdGet(ldCount, drv_map);
> -		if (ld >= MAX_LOGICAL_DRIVES_EXT) {
> +		if (ld >= MAX_LOGICAL_DRIVES_EXT - 1) {
>  			lbInfo[ldCount].loadBalanceFlag = 0;
>  			continue;
>  		}
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index f74b5ea24f0f..49eaa87608f6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2832,7 +2832,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
>  		device_id < instance->fw_supported_vd_count)) {
>  
>  		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
> -		if (ld >= instance->fw_supported_vd_count)
> +		if (ld >= instance->fw_supported_vd_count - 1)
>  			fp_possible = 0;
>  		else {
>  			raid = MR_LdRaidGet(ld, local_map_ptr);

Kashyap, Sumit, Shivasharan: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
