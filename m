Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7668C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 13:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392525AbiEFNb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 09:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386381AbiEFNby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 09:31:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00216140B2
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 06:28:10 -0700 (PDT)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KvrqY4CVtz67NHg;
        Fri,  6 May 2022 21:23:37 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 6 May 2022 15:28:08 +0200
Received: from [10.47.86.119] (10.47.86.119) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 6 May
 2022 14:28:07 +0100
Message-ID: <39ac80da-ce97-55e5-4fb7-5bab02a191ea@huawei.com>
Date:   Fri, 6 May 2022 14:28:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 17/24] snic: reserve tag for TMF
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, "Hannes Reinecke" <hare@suse.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-18-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220502213820.3187-18-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.119]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>   
> diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
> index 29d56396058c..f344cbc27923 100644
> --- a/drivers/scsi/snic/snic_main.c
> +++ b/drivers/scsi/snic/snic_main.c
> @@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
>   
>   	snic->max_tag_id = shost->can_queue;
> +	/* Reserve one reset command */
> +	shost->can_queue--;
> +	snic->tmf_tag_id = shost->can_queue;
>   
>   	shost->max_lun = snic->config.luns_per_tgt;
>   	shost->max_id = SNIC_MAX_TARGET;
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index 5f17666f3e1d..e18c8c5e4b46 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -1018,17 +1018,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
>   		      "reset_cmpl: type = %x, hdr_stat = %x, cmnd_id = %x, hid = %x, ctx = %lx\n",
>   		      typ, hdr_stat, cmnd_id, hid, ctx);
>   
> -	/* spl case, host reset issued through ioctl */
> -	if (cmnd_id == SCSI_NO_TAG) {
> -		rqi = (struct snic_req_info *) ctx;
> -		SNIC_HOST_INFO(snic->shost,
> -			       "reset_cmpl:Tag %d ctx %lx cmpl stat %s\n",
> -			       cmnd_id, ctx, snic_io_status_to_str(hdr_stat));
> -		sc = rqi->sc;
> -
> -		goto ioctl_hba_rst;
> -	}
> -
>   	if (cmnd_id >= snic->max_tag_id) {
>   		SNIC_HOST_ERR(snic->shost,
>   			      "reset_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
> @@ -1039,7 +1028,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
>   	}
>   
>   	sc = scsi_host_find_tag(snic->shost, cmnd_id);
> -ioctl_hba_rst:
>   	if (!sc) {
>   		atomic64_inc(&snic->s_stats.io.sc_null);
>   		SNIC_HOST_ERR(snic->shost,
> @@ -1725,7 +1713,7 @@ snic_dr_clean_single_req(struct snic *snic,
>   {
>   	struct snic_req_info *rqi = NULL;
>   	struct snic_tgt *tgt = NULL;
> -	struct scsi_cmnd *sc = NULL;
> +	struct scsi_cmnd *sc;
>   	spinlock_t *io_lock = NULL;
>   	u32 sv_state = 0, tmf = 0;
>   	DECLARE_COMPLETION_ONSTACK(tm_done);
> @@ -2238,13 +2226,6 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
>   		goto hba_rst_end;
>   	}
>   
> -	if (snic_cmd_tag(sc) == SCSI_NO_TAG) {
> -		memset(scsi_cmd_priv(sc), 0,
> -			sizeof(struct snic_internal_io_state));
> -		SNIC_HOST_INFO(snic->shost, "issu_hr:Host reset thru ioctl.\n");
> -		rqi->sc = sc;
> -	}
> -
>   	req = rqi_to_req(rqi);
>   
>   	io_lock = snic_io_lock_hash(snic, sc);
> @@ -2319,11 +2300,13 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
>   } /* end of snic_issue_hba_reset */
>   
>   int
> -snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
> +snic_reset(struct Scsi_Host *shost)
>   {
>   	struct snic *snic = shost_priv(shost);
> +	struct scsi_cmnd *sc = NULL;
>   	enum snic_state sv_state;
>   	unsigned long flags;
> +	u32 start_time  = jiffies;
>   	int ret = FAILED;
>   
>   	/* Set snic state as SNIC_FWRESET*/
> @@ -2348,6 +2331,18 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
>   	while (atomic_read(&snic->ios_inflight))
>   		schedule_timeout(msecs_to_jiffies(1));
>   
> +	sc = scsi_host_find_tag(shost, snic->tmf_tag_id);

Maybe I am missing something but this does not seem right. As I see, 
blk-mq has driver tags in range [0, snic->tmf_tag_id - 1], so we cannot 
call scsi_host_find_tag() -> blk_mq_unique_tag_to_tag(snic->tmf_tag_id)

thanks,
John
