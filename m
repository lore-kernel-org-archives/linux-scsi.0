Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FB5C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 08:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbhK3IrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 03:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbhK3IrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 03:47:07 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FA3C061574
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 00:43:47 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id i12so16730724wmq.4
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 00:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CeK/4g7dqCTilfZaEdtQLbwiUq00sFDcAegjsV//Gqk=;
        b=ZwyL8NF2sBrqaFSZ9Izq/M+Dao364Hv/S8Lzi/ZFSDI+SI++qMbMB9ZFl0QIfvKm7+
         8hrVe0+oySMGHEmh0B8VA7lH69xlqT3SIdPo0vc8S2kk4R9cZ8YubqcuxTZ0yKtunimV
         7fM1Mu8Hqiq2uFRXAGzwyt/FIDVcO82UcHG90k9CuPk8TT5tU1bqL49dnBGC2oNnDEt/
         g4GS9McDQX5gC55Yu4E3oscvbDeo/+5XA+ccEsQMDd6CfUrTSkEj4yvT/Tp4H8Jjl8dN
         a7zgkkNFxDfeO54FP7mIlhBBZTggYh1ryAf3MX8VpMyPNJz09aT5BBI5S/wkbNUVaUz9
         iupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CeK/4g7dqCTilfZaEdtQLbwiUq00sFDcAegjsV//Gqk=;
        b=BjKZ1AbgEV4atf2TGP3lvT42ZuQ3uLP7el2/eBXQDeP5XZqRYaYliykjP6VtPS85er
         JqkiUSP3c8FZ07Qk5g4hkJfW63KwVbLWxjIBhuSGL95o3kha45eQJGs0vkNLqBP+GgnG
         uvGUqAbiLMFWc/VCdwoAP00aeS2bW0ZD22HjQwKZI8fDKe6xwO3bP8ji8dYzFuKxqUHM
         6OMDwqmwbFxjPnykA7Hz/NwYAuHValwRDGXCPQNtDJ91zAD9w9vkDsXLtXfLfYdbbzn1
         WjUfcE4r1CpADahag36ugjdQg3bp0Ls73fs5MljNmXJvxROUnLEbftoocbCEOgetCFba
         tfmg==
X-Gm-Message-State: AOAM533Iu/4ZVnR4vGlBU6bI095+we6H297c+ns9LkJ2/UZqQXqz1AIC
        ArFuMpxkCXqUndwk6ayF1d0=
X-Google-Smtp-Source: ABdhPJzKfoOesaVMBN80gce/hdlZxuiLEGsOCplSQ16l5Zq5TtD7CVii/ULAjldXfn1NhRKL/bjBeQ==
X-Received: by 2002:a05:600c:2195:: with SMTP id e21mr3367259wme.187.1638261826441;
        Tue, 30 Nov 2021 00:43:46 -0800 (PST)
Received: from p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de (p200300e94719c91f05d9351815d7236e.dip0.t-ipconnect.de. [2003:e9:4719:c91f:5d9:3518:15d7:236e])
        by smtp.googlemail.com with ESMTPSA id bg12sm2057595wmb.5.2021.11.30.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 00:43:45 -0800 (PST)
Message-ID: <e0dc15c742c2f626a7149c3c44d53493fe1a9a44.camel@gmail.com>
Subject: Re: [PATCH v2 19/20] scsi: ufs: Implement polling support
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Tue, 30 Nov 2021 09:43:44 +0100
In-Reply-To: <20211119195743.2817-20-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-20-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart, 

We look forward to the support of UFSHCD polling, I did a review and
test. comments as below:


On Fri, 2021-11-19 at 11:57 -0800, Bart Van Assche wrote:
> The time spent in io_schedule() and also the interrupt latency are
> significant when submitting direct I/O to a UFS device. Hence this
> patch
> that implements polling support. User space software can enable
> polling by
> passing the RWF_HIPRI flag to the preadv2() system call or the
> IORING_SETUP_IOPOLL flag to the io_uring interface.
> 
> Although the block layer supports to partition the tag space for
> interrupt-based completions (HCTX_TYPE_DEFAULT) purposes and polling
> (HCTX_TYPE_POLL), the choice has been made to use the same hardware
> queue for both hctx types because partitioning the tag space would
> negatively affect performance.
> 
> On my test setup this patch increases IOPS from 2736 to 22000 (8x)
> for the
> following test:
> 
> for hipri in 0 1; do
>     fio --ioengine=io_uring --iodepth=1 --rw=randread \
>     --runtime=60 --time_based=1 --direct=1 --name=qd1 \
>     --filename=/dev/block/sda --ioscheduler=none --gtod_reduce=1 \
>     --norandommap --hipri=$hipri
> done

For 4KB random read, direct IO, and iodepth=1, we did not see an
improvement in IOPS due to this patch. Maybe the test case above is not
sufficient.


> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 85 ++++++++++++++++++++++++++++++-------
> --
>  1 file changed, 65 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9cf4a22f1950..14043d74389d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2629,6 +2629,36 @@ static inline bool is_device_wlun(struct
> scsi_device *sdev)
>  		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN)
> ;
>  }
>  
> +/*
> + * Associate the UFS controller queue with the default and poll HCTX
> types.
> + * Initialize the mq_map[] arrays.
> + */
> +static int ufshcd_map_queues(struct Scsi_Host *shost)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < shost->nr_maps; i++) {
> +		struct blk_mq_queue_map *map = &shost->tag_set.map[i];
> +
> +		switch (i) {
> +		case HCTX_TYPE_DEFAULT:
> +		case HCTX_TYPE_POLL:
> +			map->nr_queues = 1;
> +			break;
> +		case HCTX_TYPE_READ:
> +			map->nr_queues = 0;
> +			break;
> +		default:
> +			WARN_ON_ONCE(true);
> +		}
> +		map->queue_offset = 0;
> +		ret = blk_mq_map_queues(map);
> +		WARN_ON_ONCE(ret);
> +	}
> +
> +	return 0;
> +}
> +
>  static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb
> *lrb, int i)
>  {
>  	struct utp_transfer_cmd_desc *cmd_descp = hba->ucdl_base_addr;
> @@ -2664,7 +2694,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  	struct ufshcd_lrb *lrbp;
>  	int err = 0;
>  
> -	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> +	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n",
> tag);
>  
>  	/*
>  	 * Allows the UFS error handler to wait for prior
> ufshcd_queuecommand()
> @@ -2925,7 +2955,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>  	}
>  	req = scsi_cmd_to_rq(scmd);
>  	tag = req->tag;
> -	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> +	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n",
> tag)
probably this change should not in this patch?

>  	/*
>  	 * Start the request such that blk_mq_tag_idle() is called when
> the
>  	 * device management request finishes.
> @@ -5272,6 +5302,31 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>  	}
>  }
>  
> +/*
> + * Returns > 0 if one or more commands have been completed or 0 if
> no
> + * requests have been completed.
> + */
> +static int ufshcd_poll(struct Scsi_Host *shost, unsigned int
> queue_num)
> +{
> +	struct ufs_hba *hba = shost_priv(shost);
> +	unsigned long completed_reqs, flags;
> +	u32 tr_doorbell;
> +
> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
> +	tr_doorbell = ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
> +	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> +		  "completed: %#lx; outstanding: %#lx\n",
> completed_reqs,
> +		  hba->outstanding_reqs);
> +	hba->outstanding_reqs &= ~completed_reqs;
> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +
> +	if (completed_reqs)
> +		__ufshcd_transfer_req_compl(hba, completed_reqs);
> +
> +	return completed_reqs;
> +}
> +
>  /**
>   * ufshcd_transfer_req_compl - handle SCSI and query command
> completion
>   * @hba: per adapter instance
> @@ -5282,9 +5337,6 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>   */
>  static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  {
> -	unsigned long completed_reqs, flags;
> -	u32 tr_doorbell;
> -
>  	/* Resetting interrupt aggregation counters first and reading
> the
>  	 * DOOR_BELL afterward allows us to handle all the completed
> requests.
>  	 * In order to prevent other interrupts starvation the DB is
> read once
> @@ -5299,21 +5351,9 @@ static irqreturn_t
> ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  	if (ufs_fail_completion())
>  		return IRQ_HANDLED;
>  
> -	spin_lock_irqsave(&hba->outstanding_lock, flags);
> -	tr_doorbell = ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
> -	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> -		  "completed: %#lx; outstanding: %#lx\n",
> completed_reqs,
> -		  hba->outstanding_reqs);
> -	hba->outstanding_reqs &= ~completed_reqs;
> -	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> +	ufshcd_poll(hba->host, 0);
>  
> -	if (completed_reqs) {
> -		__ufshcd_transfer_req_compl(hba, completed_reqs);
> -		return IRQ_HANDLED;
> -	} else {
> -		return IRQ_NONE;
> -	}
> +	return IRQ_HANDLED;
>  }
>  

ufshcd_transfer_req_compl() will never return IRQ_NONE,
but ufshcd_intr() needs this return to check the fake interrupt.


>  int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
> @@ -6564,6 +6604,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
> *hba,
>  	spin_lock_irqsave(host->host_lock, flags);
>  
>  	task_tag = req->tag;
> +	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag
> %d\n",
> +		  task_tag);
>  	hba->tmf_rqs[req->tag] = req;
>  	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
>  
> @@ -6705,7 +6747,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	}
>  	req = scsi_cmd_to_rq(scmd);
>  	tag = req->tag;
> -	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> +	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n",
> tag);
>  	/*
>  	 * Start the request such that blk_mq_tag_idle() is called when
> the
>  	 * device management request finishes.
> @@ -8147,7 +8189,9 @@ static struct scsi_host_template
> ufshcd_driver_template = {
>  	.module			= THIS_MODULE,
>  	.name			= UFSHCD,
>  	.proc_name		= UFSHCD,
> +	.map_queues		= ufshcd_map_queues,
>  	.queuecommand		= ufshcd_queuecommand,
> +	.mq_poll		= ufshcd_poll,
>  	.slave_alloc		= ufshcd_slave_alloc,
>  	.slave_configure	= ufshcd_slave_configure,
>  	.slave_destroy		= ufshcd_slave_destroy,
> @@ -9437,6 +9481,7 @@ int ufshcd_alloc_host(struct device *dev,
> struct ufs_hba **hba_handle)
>  		err = -ENOMEM;
>  		goto out_error;
>  	}
> +	host->nr_maps = 3;

I don't understand why not directly uses HCTX_MAX_TYPES, 3 is already
maximum.

>  	hba = shost_priv(host);
>  	hba->host = host;
>  	hba->dev = dev;

