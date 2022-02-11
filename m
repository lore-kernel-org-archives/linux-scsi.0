Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87A6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 12:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349957AbiBKMZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:25:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243940AbiBKMZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 07:25:08 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F17DC3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:25:07 -0800 (PST)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JwCPv6HHSz689Nw;
        Fri, 11 Feb 2022 20:20:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 11 Feb 2022 13:25:04 +0100
Received: from [10.47.87.89] (10.47.87.89) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Feb
 2022 12:25:03 +0000
Message-ID: <df7b31cc-557d-ce12-dbb7-a2873100a587@huawei.com>
Date:   Fri, 11 Feb 2022 12:25:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 23/24] scsi: pm8001: Introduce ccb alloc/free helpers
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
 <20220211073704.963993-24-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220211073704.963993-24-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.89]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/02/2022 07:37, Damien Le Moal wrote:
> Introduce the pm8001_ccb_alloc() and pm8001_ccb_free() helpers to
> replace the typical code pattern:
> 
> 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
> 	...
> 	ccb = &pm8001_ha->ccb_info[ccb_tag];
> 	ccb->device = pm8001_ha_dev;
> 	ccb->ccb_tag = ccb_tag;
> 	ccb->task = task;
> 	ccb->n_elem = 0;
> 
> With a simpler single function call:
> 
> 	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
> 
> The pm8001_ccb_alloc() helper ensures that all fields of the ccb info
> structure for the newly allocated tag are all initialized, except the
> buf_prd field. All call site of the pm8001_tag_alloc() function that
> use the ccb info associated with the allocated tag are converted to use
> the new helpers.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/pm8001/pm8001_hwi.c | 153 ++++++++++++++-----------------
>   drivers/scsi/pm8001/pm8001_sas.c |  37 +++-----
>   drivers/scsi/pm8001/pm8001_sas.h |  33 +++++++
>   drivers/scsi/pm8001/pm80xx_hwi.c |  66 ++++++-------
>   4 files changed, 141 insertions(+), 148 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index d853e8d0195a..8c4cf4e254ba 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1757,8 +1757,6 @@ int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
>   static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>   		struct pm8001_device *pm8001_ha_dev)
>   {
> -	int res;
> -	u32 ccb_tag;
>   	struct pm8001_ccb_info *ccb;
>   	struct sas_task *task = NULL;
>   	struct task_abort_req task_abort;
> @@ -1780,28 +1778,26 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>   
>   	task->task_done = pm8001_task_done;
>   
> -	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
> -	if (res)
> +	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
> +	if (!ccb) {
> +		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");

Should we print this always and move it into pm8001_ccb_alloc()?

> +		sas_free_task(task);
>   		return;
> -
> -	ccb = &pm8001_ha->ccb_info[ccb_tag];
> -	ccb->device = pm8001_ha_dev;
> -	ccb->ccb_tag = ccb_tag;
> -	ccb->task = task;
> -	ccb->n_elem = 0;
> +	}
>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   
>   	memset(&task_abort, 0, sizeof(task_abort));
>   	task_abort.abort_all = cpu_to_le32(1);
>   	task_abort.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
> -	task_abort.tag = cpu_to_le32(ccb_tag);
> +	task_abort.tag = cpu_to_le32(ccb->ccb_tag);
>   
>   	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
>   			sizeof(task_abort), 0);
> -	if (ret)
> -		pm8001_tag_free(pm8001_ha, ccb_tag);
> -
> +	if (ret) {
> +		sas_free_task(task);
> +		pm8001_ccb_free(pm8001_ha, ccb);
> +	}
>   }
>   
>   static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
> @@ -1809,7 +1805,6 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   {
>   	struct sata_start_req sata_cmd;
>   	int res;
> -	u32 ccb_tag;
>   	struct pm8001_ccb_info *ccb;
>   	struct sas_task *task = NULL;
>   	struct host_to_dev_fis fis;
> @@ -1825,20 +1820,13 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   	}
>   	task->task_done = pm8001_task_done;
>   
> -	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
> -	if (res) {
> -		sas_free_task(task);
> -		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
> -		return;
> -	}
> -
> -	/* allocate domain device by ourselves as libsas
> -	 * is not going to provide any
> -	*/
> +	/*
> +	 * Allocate domain device by ourselves as libsas is not going to
> +	 * provide any.
> +	 */
>   	dev = kzalloc(sizeof(struct domain_device), GFP_ATOMIC);
>   	if (!dev) {
>   		sas_free_task(task);
> -		pm8001_tag_free(pm8001_ha, ccb_tag);
>   		pm8001_dbg(pm8001_ha, FAIL,
>   			   "Domain device cannot be allocated\n");
>   		return;
> @@ -1846,11 +1834,14 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   	task->dev = dev;
>   	task->dev->lldd_dev = pm8001_ha_dev;
>   
> -	ccb = &pm8001_ha->ccb_info[ccb_tag];
> -	ccb->device = pm8001_ha_dev;
> -	ccb->ccb_tag = ccb_tag;
> -	ccb->task = task;
> -	ccb->n_elem = 0;
> +	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
> +	if (!ccb) {
> +		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate tag !!!\n");
> +		sas_free_task(task);
> +		kfree(dev);
> +		return;
> +	}
> +
>   	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
>   	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
>   
> @@ -1865,7 +1856,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   	fis.lbal = 0x10;
>   	fis.sector_count = 0x1;
>   
> -	sata_cmd.tag = cpu_to_le32(ccb_tag);
> +	sata_cmd.tag = cpu_to_le32(ccb->ccb_tag);
>   	sata_cmd.device_id = cpu_to_le32(pm8001_ha_dev->device_id);
>   	sata_cmd.ncqtag_atap_dir_m = cpu_to_le32((0x1 << 7) | (0x5 << 9));
>   	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
> @@ -1874,7 +1865,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   			sizeof(sata_cmd), 0);
>   	if (res) {
>   		sas_free_task(task);
> -		pm8001_tag_free(pm8001_ha, ccb_tag);
> +		pm8001_ccb_free(pm8001_ha, ccb);
>   		kfree(dev);
>   	}
>   }
> @@ -4433,7 +4424,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>   	u32 stp_sspsmp_sata = 0x4;
>   	struct inbound_queue_table *circularQ;
>   	u32 linkrate, phy_id;
> -	int rc, tag = 0xdeadbeef;
> +	int rc;
>   	struct pm8001_ccb_info *ccb;
>   	u8 retryFlag = 0x1;
>   	u16 firstBurstSize = 0;
> @@ -4444,13 +4435,11 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,

I think that this needs to be fixed to release the ccb when 
pm8001_mip_build_cmd() fails (not shown).

>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   
>   	memset(&payload, 0, sizeof(payload));
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc)
> -		return rc;
> -	ccb = &pm8001_ha->ccb_info[tag];
> -	ccb->device = pm8001_dev;
> -	ccb->ccb_tag = tag;
> -	payload.tag = cpu_to_le32(tag);
> +	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
> +	if (!ccb)
> +		return SAS_QUEUE_FULL;
> +
> +	payload.tag = cpu_to_le32(ccb->ccb_tag);
>   	if (flag == 1)
>   		stp_sspsmp_sata = 0x02; /*direct attached sata */
>   	else {
> @@ -4642,7 +4631,6 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>   	u32 opc = OPC_INB_GET_NVMD_DATA;
>   	u32 nvmd_type;
>   	int rc;
> -	u32 tag;
>   	struct pm8001_ccb_info *ccb;
>   	struct inbound_queue_table *circularQ;
>   	struct get_nvm_data_req nvmd_req;
> @@ -4657,15 +4645,15 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>   	fw_control_context->len = ioctl_payload->rd_length;
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   	memset(&nvmd_req, 0, sizeof(nvmd_req));
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc) {
> +
> +	ccb = pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
> +	if (!ccb) {
>   		kfree(fw_control_context);
> -		return rc;
> +		return -EBUSY;
>   	}
> -	ccb = &pm8001_ha->ccb_info[tag];
> -	ccb->ccb_tag = tag;
>   	ccb->fw_control_context = fw_control_context;
> -	nvmd_req.tag = cpu_to_le32(tag);
> +
> +	nvmd_req.tag = cpu_to_le32(ccb->ccb_tag);
>   
>   	switch (nvmd_type) {
>   	case TWI_DEVICE: {
> @@ -4726,7 +4714,7 @@ int pm8001_chip_get_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>   			sizeof(nvmd_req), 0);
>   	if (rc) {
>   		kfree(fw_control_context);
> -		pm8001_tag_free(pm8001_ha, tag);
> +		pm8001_ccb_free(pm8001_ha, ccb);
>   	}
>   	return rc;
>   }
> @@ -4737,7 +4725,6 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>   	u32 opc = OPC_INB_SET_NVMD_DATA;
>   	u32 nvmd_type;
>   	int rc;
> -	u32 tag;
>   	struct pm8001_ccb_info *ccb;
>   	struct inbound_queue_table *circularQ;
>   	struct set_nvm_data_req nvmd_req;
> @@ -4753,15 +4740,15 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>   		&ioctl_payload->func_specific,
>   		ioctl_payload->wr_length);
>   	memset(&nvmd_req, 0, sizeof(nvmd_req));
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc) {
> +
> +	ccb = pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
> +	if (!ccb) {
>   		kfree(fw_control_context);
>   		return -EBUSY;
>   	}
> -	ccb = &pm8001_ha->ccb_info[tag];
>   	ccb->fw_control_context = fw_control_context;
> -	ccb->ccb_tag = tag;
> -	nvmd_req.tag = cpu_to_le32(tag);
> +
> +	nvmd_req.tag = cpu_to_le32(ccb->ccb_tag);
>   	switch (nvmd_type) {
>   	case TWI_DEVICE: {
>   		u32 twi_addr, twi_page_size;
> @@ -4811,7 +4798,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
>   			sizeof(nvmd_req), 0);
>   	if (rc) {
>   		kfree(fw_control_context);
> -		pm8001_tag_free(pm8001_ha, tag);
> +		pm8001_ccb_free(pm8001_ha, ccb);
>   	}
>   	return rc;
>   }
> @@ -4856,8 +4843,6 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
>   	struct fw_flash_updata_info flash_update_info;
>   	struct fw_control_info *fw_control;
>   	struct fw_control_ex *fw_control_context;
> -	int rc;
> -	u32 tag;
>   	struct pm8001_ccb_info *ccb;
>   	void *buffer = pm8001_ha->memoryMap.region[FW_FLASH].virt_ptr;
>   	dma_addr_t phys_addr = pm8001_ha->memoryMap.region[FW_FLASH].phys_addr;
> @@ -4881,17 +4866,16 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
>   	fw_control_context->virtAddr = buffer;
>   	fw_control_context->phys_addr = phys_addr;
>   	fw_control_context->len = fw_control->len;
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc) {
> +
> +	ccb = pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
> +	if (!ccb) {
>   		kfree(fw_control_context);
>   		return -EBUSY;
>   	}
> -	ccb = &pm8001_ha->ccb_info[tag];
>   	ccb->fw_control_context = fw_control_context;
> -	ccb->ccb_tag = tag;
> -	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
> -		tag);
> -	return rc;
> +
> +	return pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
> +						 ccb->ccb_tag);

Same as pm8001_chip_reg_dev_req()

>   }
>   
>   ssize_t
> @@ -4979,24 +4963,21 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
>   	struct set_dev_state_req payload;
>   	struct inbound_queue_table *circularQ;
>   	struct pm8001_ccb_info *ccb;
> -	int rc;
> -	u32 tag;
>   	u32 opc = OPC_INB_SET_DEVICE_STATE;
> +
>   	memset(&payload, 0, sizeof(payload));
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc)
> +
> +	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, NULL);
> +	if (!ccb)
>   		return -1;
> -	ccb = &pm8001_ha->ccb_info[tag];
> -	ccb->ccb_tag = tag;
> -	ccb->device = pm8001_dev;
> +
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
> -	payload.tag = cpu_to_le32(tag);
> +	payload.tag = cpu_to_le32(ccb->ccb_tag);
>   	payload.device_id = cpu_to_le32(pm8001_dev->device_id);
>   	payload.nds = cpu_to_le32(state);
> -	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> -			sizeof(payload), 0);
> -	return rc;
>   
> +	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> +				    sizeof(payload), 0);

As above

>   }
>   
>   static int
> @@ -5006,25 +4987,27 @@ pm8001_chip_sas_re_initialization(struct pm8001_hba_info *pm8001_ha)
>   	struct inbound_queue_table *circularQ;
>   	struct pm8001_ccb_info *ccb;
>   	int rc;
> -	u32 tag;
>   	u32 opc = OPC_INB_SAS_RE_INITIALIZE;
> +
>   	memset(&payload, 0, sizeof(payload));
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc)
> +
> +	ccb = pm8001_ccb_alloc(pm8001_ha, NULL, NULL);
> +	if (!ccb)
>   		return -ENOMEM;
> -	ccb = &pm8001_ha->ccb_info[tag];
> -	ccb->ccb_tag = tag;
> +
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
> -	payload.tag = cpu_to_le32(tag);
> +
> +	payload.tag = cpu_to_le32(ccb->ccb_tag);
>   	payload.SSAHOLT = cpu_to_le32(0xd << 25);
>   	payload.sata_hol_tmo = cpu_to_le32(80);
>   	payload.open_reject_cmdretries_data_retries = cpu_to_le32(0xff00ff);
> +
>   	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
> -			sizeof(payload), 0);
> +				  sizeof(payload), 0);
>   	if (rc)
> -		pm8001_tag_free(pm8001_ha, tag);
> -	return rc;
> +		pm8001_ccb_free(pm8001_ha, ccb);
>   
> +	return rc;
>   }
>   
>   const struct pm8001_dispatch pm8001_8001_dispatch = {
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 8cd7e7837f41..6b8843344893 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -74,7 +74,7 @@ void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag)
>     * @pm8001_ha: our hba struct
>     * @tag_out: the found empty tag .
>     */
> -inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
> +int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
>   {
>   	unsigned int tag;
>   	void *bitmap = pm8001_ha->tags;
> @@ -383,7 +383,7 @@ static int pm8001_task_exec(struct sas_task *task,
>   	struct sas_task *t = task;
>   	struct task_status_struct *ts = &t->task_status;
>   	struct pm8001_ccb_info *ccb;
> -	u32 tag = 0xdeadbeef, rc = 0, n_elem;
> +	u32 rc = 0, n_elem;
>   	unsigned long flags = 0;
>   	enum sas_protocol task_proto = t->task_proto;
>   
> @@ -424,11 +424,11 @@ static int pm8001_task_exec(struct sas_task *task,
>   			continue;
>   		}
>   
> -		rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -		if (rc)
> +		ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, t);
> +		if (!ccb) {
> +			rc = -EBUSY;
>   			goto err_out;
> -
> -		ccb = &pm8001_ha->ccb_info[tag];
> +		}
>   
>   		if (!sas_protocol_ata(task_proto)) {
>   			if (t->num_scatter) {
> @@ -438,7 +438,7 @@ static int pm8001_task_exec(struct sas_task *task,
>   					t->data_dir);
>   				if (!n_elem) {
>   					rc = -ENOMEM;
> -					goto err_out_tag;
> +					goto err_out_ccb;
>   				}
>   			} else {
>   				n_elem = 0;
> @@ -449,9 +449,7 @@ static int pm8001_task_exec(struct sas_task *task,
>   
>   		t->lldd_task = ccb;
>   		ccb->n_elem = n_elem;
> -		ccb->ccb_tag = tag;
> -		ccb->task = t;
> -		ccb->device = pm8001_dev;
> +
>   		switch (task_proto) {
>   		case SAS_PROTOCOL_SMP:
>   			atomic_inc(&pm8001_dev->running_req);
> @@ -480,7 +478,7 @@ static int pm8001_task_exec(struct sas_task *task,
>   		if (rc) {
>   			pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
>   			atomic_dec(&pm8001_dev->running_req);
> -			goto err_out_tag;
> +			goto err_out_ccb;
>   		}
>   		/* TODO: select normal or high priority */
>   		spin_lock(&t->task_state_lock);
> @@ -490,8 +488,8 @@ static int pm8001_task_exec(struct sas_task *task,
>   	rc = 0;
>   	goto out_done;
>   
> -err_out_tag:
> -	pm8001_tag_free(pm8001_ha, tag);
> +err_out_ccb:
> +	pm8001_ccb_free(pm8001_ha, ccb);
>   err_out:
>   	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
>   	if (!sas_protocol_ata(task_proto))
> @@ -816,7 +814,6 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>   	u32 task_tag)
>   {
>   	int res, retry;
> -	u32 ccb_tag;
>   	struct pm8001_ccb_info *ccb;
>   	struct sas_task *task = NULL;
>   
> @@ -832,18 +829,12 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>   		task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT * HZ;
>   		add_timer(&task->slow_task->timer);
>   
> -		res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
> -		if (res)
> +		ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
> +		if (!ccb)
>   			goto ex_err;
> -		ccb = &pm8001_ha->ccb_info[ccb_tag];
> -		ccb->device = pm8001_dev;
> -		ccb->ccb_tag = ccb_tag;
> -		ccb->task = task;
> -		ccb->n_elem = 0;
>   
>   		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
> -			pm8001_dev, flag, task_tag, ccb_tag);
> -
> +			pm8001_dev, flag, task_tag, ccb->ccb_tag);
>   		if (res) {
>   			del_timer(&task->slow_task->timer);

We should free the CCB here? I guess that the mainline code is broken :(

>   			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index a17da1cebce1..6aafa48bf235 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -738,6 +738,39 @@ void pm8001_free_dev(struct pm8001_device *pm8001_dev);
>   /* ctl shared API */
>   extern const struct attribute_group *pm8001_host_groups[];
>   
> +/*
> + * Allocate a new tag and return the corresponding ccb after initializing it.
> + */
> +static inline struct pm8001_ccb_info *
> +pm8001_ccb_alloc(struct pm8001_hba_info *pm8001_ha,
> +		 struct pm8001_device *dev, struct sas_task *task)
> +{
> +	struct pm8001_ccb_info *ccb;
> +	u32 tag;
> +
> +	if (pm8001_tag_alloc(pm8001_ha, &tag))
> +		return NULL;
> +
> +	ccb = &pm8001_ha->ccb_info[tag];
> +	ccb->task = task;
> +	ccb->n_elem = 0;
> +	ccb->ccb_tag = tag;
> +	ccb->device = dev;
> +	ccb->fw_control_context = NULL;
> +	ccb->open_retry = 0;

I'd just memset the whole thing to be sure (paranoid). And I think that 
we are also missing clearing the ccb_dma_handle.

> +
> +	return ccb;
> +}
> +
> +/*

Thanks,
John
