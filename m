Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0975C47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 03:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AFA5208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 03:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgEHDVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 23:21:16 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44707 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgEHDVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 23:21:15 -0400
Received: by mail-pl1-f193.google.com with SMTP id b8so101342plm.11;
        Thu, 07 May 2020 20:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=da5oMheN5lG+SeQ+I9TkRnall/h6ZF7W6yQOT8flUV8=;
        b=Sp/9Mc1MIYi/icO0Wojc/Gq9Qjd8BwNPP0xWUVIax94D1z+fzyUOh6Yjmo8jfHuf3o
         pIFoAQiOz83M0wx5G/D3xggFg/B1g6eTKLtl+M9qhGoNpWf1C5HTG1th6LzdcHmMTWVx
         qCrDmIHAKkoZHh42SUZGSrluNmYu2HLt8p2UQPFStKtNCrr8xkX0gXDVKTYex+pVO86+
         meTe7UpjTPn9Hin62kkeoQ2LZB64mPXoJbbyCTiYmI8Dd8OgvZx4dKAHlbM+7ZeHgW0r
         PtLq3qw8ExhVpfdF/Yf1rW7dtxAf+l73MG7Gv6vHOceunyBCCc//ykgNT59VjeE8gYPu
         regQ==
X-Gm-Message-State: AGi0PubzRdAAyY4XFT2j0U7136y6eXieZqDUy2dQz75nfaP0fuwUzCjf
        t/Q5QtoLFlcxbay4WaNhPz0=
X-Google-Smtp-Source: APiQypJEhT7ywBFLtCI8RJm6tEYQ2vSeRzMsaQ7di1lrur+Y+cnogUdDQ95FUtx89o1jQaFYYzMAag==
X-Received: by 2002:a17:90a:5b:: with SMTP id 27mr3827166pjb.190.1588908073074;
        Thu, 07 May 2020 20:21:13 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8ce8:d4c:1f4f:21e0? ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id g10sm209129pfk.103.2020.05.07.20.21.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 20:21:12 -0700 (PDT)
Subject: Re: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
References: <20200504142032.16619-1-beanhuo@micron.com>
 <20200504142032.16619-6-beanhuo@micron.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <7b3e127f-a25f-e821-6704-2680ea619c6d@acm.org>
Date:   Thu, 7 May 2020 20:21:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504142032.16619-6-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-04 07:20, huobean@gmail.com wrote:
> +config SCSI_UFSHPB
> +	bool "UFS Host Performance Booster (EXPERIMENTAL)"
> +	depends on SCSI_UFSHCD
> +	[ ... ]
> +
> +config UFSHPB_MAX_MEM_SIZE
> +	int "UFS HPB maximum memory size per controller (in MiB)"
> +	depends on SCSI_UFSHPB
> +	default 128
> +	range 0 65536
> +	[ ... ]

Kernel module parameters are an inflexible mechanism because the value
of these parameters cannot be changed without rebuilding the kernel
followed by a reboot. Has it been considered to make these two
parameters configurable through sysfs? Has it been considered to make
these parameters UFS device parameters instead of global parameters that
apply to all UFS devices?

> +static int ufshcd_clear_cmd(struct ufs_hba *hba, int tag);

Is it possible to reorder the function definitions such that this
function declaration can be left out?

>  static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
>  {
>  	return tag >= 0 && tag < hba->nutrs;
> @@ -2391,6 +2392,12 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
>  						lrbp->cmd->sc_data_direction);
>  		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
> +
> +#if defined(CONFIG_SCSI_UFSHPB)
> +		/* If HPB works, prepare for the HPB READ */
> +		if (hba->ufshpb_state == HPB_PRESENT)
> +			ufshpb_prep_fn(hba, lrbp);
> +#endif
>  	} else {
>  		ret = -EINVAL;
>  	}

What does the name "HPB_PRESENT" mean? If it means that HPB is enabled,
wouldn't HPB_ENABLED be a better name for this constant? If so, is the
comment above the if-statement useful?

> @@ -2430,6 +2437,181 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
>  	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
>  }
>  
> +#if defined(CONFIG_SCSI_UFSHPB)
> +static void ufshcd_prepare_ureq_upiu(struct ufshcd_lrb *lrbp, struct ufs_req
> +				     *ureq, u32 *upiu_flags)
> +{
> +	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
> +	unsigned short cdb_len;
> +
> +	/* command descriptor fields */
> +	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
> +					UPIU_TRANSACTION_COMMAND, *upiu_flags,
> +					lrbp->lun, lrbp->task_tag);
> +	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
> +					UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
> +
> +	/* Total EHS length and Data segment length will be zero */
> +	ucd_req_ptr->header.dword_2 = 0;
> +
> +	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(ureq->payload_len);
> +
> +	cdb_len = min_t(unsigned short, ureq->cmd_len, UFS_CDB_SIZE);
> +	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
> +	memcpy(ucd_req_ptr->sc.cdb, ureq->cmd, cdb_len);
> +
> +	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
> +}

Please add a comment above this function that explains what "ureq_upiu"
means and that also explains the meaning of the function arguments.
Please also keep "struct ufs_req *ureq" on a single line.

> +static void ufshcd_comp_ureq_upiu(struct ufshcd_lrb *lrbp, struct ufs_req *ureq)
> +{
> +	u32 upiu_flags;
> +
> +	lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
> +	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, ureq->cmd_dir);
> +	ufshcd_prepare_ureq_upiu(lrbp, ureq, &upiu_flags);
> +}

To me the abbreviation "comp" suggests completion. Since this function
prepares a command, how about changing _comp_ into _prep_?

> +static int ufshcd_ureq_dma_map(struct ufs_hba *hba, struct ufs_req *ureq,
> +			       struct ufshcd_lrb *lrbp)
> +{
> +	int nseg = 0;
> +	struct ufshcd_sg_entry *prdt;
> +	struct scatterlist *sg;
> +	int i;
> +	struct device *dev = hba->host->dma_dev;
> +
> +	nseg = dma_map_sg(dev, ureq->sgt.sgl, ureq->sgt.nents, ureq->cmd_dir);
> +	if (nseg < 0)
> +		return nseg;
> +
> +	if (nseg == 0) {
> +		lrbp->utr_descriptor_ptr->prd_table_length = 0;
> +		return 0;
> +	}
> +
> +	lrbp->utr_descriptor_ptr->prd_table_length = cpu_to_le16((u16)nseg);
> +	prdt = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
> +	for_each_sg(ureq->sgt.sgl, sg, nseg, i) {
> +		prdt[i].size  = cpu_to_le32(((u32)sg_dma_len(sg)) - 1);
> +		prdt[i].base_addr =
> +			cpu_to_le32(lower_32_bits(sg_dma_address(sg)));
> +		prdt[i].upper_addr =
> +			cpu_to_le32(upper_32_bits(sg_dma_address(sg)));
> +		prdt[i].reserved = 0;
> +	}
> +	wmb();
> +	return 0;
> +}

Is the if (nseg == 0) ... statement necessary?

Is the (u16) cast in front of nseg necessary?

Is the (u32) cast in front of sg_dma_len() necessary? Is it useful?

Can the definition of ufshcd_sg_entry be changed such that the base_addr
and upper_addr members are combined into a single __le64 member
variable? Would that allow to write the DMA address using
put_unaligned_le64()?

Please move the wmb() call to the caller of this function and add a
comment about why it is necessary. wmb() calls should not occur at the
end of a function.

> +static int ufshcd_wait_for_ureq(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
> +				struct ufs_req *ureq, int max_timeout)
> +{
> +	int err = 0;
> +	unsigned long time_left;
> +	unsigned long flags;
> +
> +	time_left = wait_for_completion_timeout(ureq->complete,
> +			msecs_to_jiffies(max_timeout));
> +
> +	/* Make sure descriptors are ready before ringing the doorbell */
> +	wmb();
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ureq->complete = NULL;
> +	if (likely(time_left))
> +		err = ufshcd_get_tr_ocs(lrbp);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +	if (!time_left) {
> +		err = -ETIMEDOUT;
> +		dev_warn(hba->dev, "%s: ureq timedout, tag %d\n", __func__,
> +			 lrbp->task_tag);
> +		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
> +			/* successfully cleared the command, retry if needed */
> +			err = -EAGAIN;
> +		/*
> +		 * in case of an error, after clearing the doorbell,
> +		 * we also need to clear the outstanding_request
> +		 * field in hba
> +		 */
> +		ufshcd_outstanding_req_clear(hba, lrbp->task_tag);
> +	}
> +
> +	return err;
> +}

The wmb() call above seems superfluous. Calling wmb() after
wait_for_completion() is almost always wrong because
wait_for_completion() already includes a barrier. See also
Documentation/memory-barriers.txt.

> +int ufshcd_exec_internal_req(struct ufs_hba *hba, struct ufs_req *ureq)
> +{

Please document what this function does and also the meaning of the
arguments of this function.

> +	lrbp = &hba->lrb[tag];
> +	WARN_ON(lrbp->cmd);
> +	lrbp->cmd = NULL;
> +	lrbp->ureq = ureq;
> +	lrbp->sense_bufflen = UFS_SENSE_SIZE;
> +	lrbp->sense_buffer = ureq->sense_buffer;
> +	lrbp->task_tag = tag;
> +	lrbp->lun = ufshcd_scsi_to_upiu_lun(ureq->lun);
> +	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
> +	lrbp->req_abort_skip = false;

The "? true : false" part seems superfluous to me.

> +	ufshcd_comp_ureq_upiu(lrbp, ureq);
> +
> +	err = ufshcd_ureq_dma_map(hba, ureq, lrbp);
> +	if (err) {
> +		dev_err(hba->dev,
> +			"%s: ufshcd_ureq_dma_map err %d\n", __func__, err);
> +		goto out;
> +	}
> +	ureq->complete = &wait;
> +	spin_lock_irqsave(hba->host->host_lock, flags);
> +	ufshcd_send_command(hba, tag);
> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +	err = ufshcd_wait_for_ureq(hba, lrbp, ureq, 20000);
> +
> +out:
> +	ufshcd_release(hba);
> +unlock:
> +	up_read(&hba->clk_scaling_lock);
> +	return err;
> +}
> +#endif

Please make command submission asynchronous such that this command can
be sumitted from a context where it is not allowed to sleep.

>  /**
>   * ufshcd_queuecommand - main entry point for SCSI requests
>   * @host: SCSI host pointer
> @@ -4622,7 +4804,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
>  
>  	if (ufshcd_is_rpm_autosuspend_allowed(hba))
>  		sdev->rpm_autosuspend = 1;
> -
> +#if defined(CONFIG_SCSI_UFSHPB)
> +	if (sdev->lun < hba->dev_info.max_lu_supported)
> +		hba->sdev_ufs_lu[sdev->lun] = sdev;
> +#endif
>  	return 0;
>  }

> @@ -4738,6 +4923,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  				 */
>  				pm_runtime_get_noresume(hba->dev);
>  			}
> +
> +#if defined(CONFIG_SCSI_UFSHPB)
> +			/*
> +			 * HPB recommendations are provided in RESPONSE UPIU
> +			 * packets of successfully completed commands, which
> +			 * are commands terminated with GOOD status.
> +			 */
> +			if (scsi_status == SAM_STAT_GOOD)
> +				ufshpb_rsp_handler(hba, lrbp);
> +#endif

How about renaming ufshpb_rsp_handle() into ufshpb_handle_rsp() or
ufshpb_handle_response()?

> @@ -6088,6 +6290,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
>  	hba->req_abort_count = 0;
>  	ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, (u32)err);
>  	if (!err) {
> +#if defined(CONFIG_SCSI_UFSHPB)
> +		if (hba->ufshpb_state == HPB_NEED_RESET)
> +			schedule_delayed_work(&hba->ufshpb_init_work,
> +					      msecs_to_jiffies(10));
> +#endif
>  		err = SUCCESS;
>  	} else {
>  		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);

So UFS HPB reset work is scheduled instead of being performed
synchronously? I don't like this.

> -	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
> -		hba->dev_info.hpb_control_mode =
> +	if (dev_info->ufs_features & 0x80) {
> +		dev_info->hpb_control_mode =

The change of "desc_buf[DEVICE_DESC_PARAM_UFS_FEAT]" into
"dev_info->ufs_features" should be moved into a previous patch.

> @@ -7188,6 +7395,14 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  
>  	/* Probe and add UFS logical units  */
>  	ret = ufshcd_add_lus(hba);
> +
> +#if defined(CONFIG_SCSI_UFSHPB)
> +	/* Initialize HPB  */
> +	if (hba->ufshpb_state == HPB_NEED_INIT)
> +		schedule_delayed_work(&hba->ufshpb_init_work,
> +				      msecs_to_jiffies(10));
> +#endif

Aargh. More asynchronous work. Can this HPB initialization be done
synchronously?

> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 7ce9cc2f10fe..03890309a963 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -70,6 +70,7 @@
>  
>  #include "ufs.h"
>  #include "ufshci.h"
> +#include "ufshpb.h"
>  
>  #define UFSHCD "ufshcd"
>  #define UFSHCD_DRIVER_VERSION "0.2"
> @@ -162,6 +163,17 @@ struct ufs_pm_lvl_states {
>  	enum uic_link_state link_state;
>  };
>  
> +struct ufs_req {
> +	struct request *req;
> +	u8 cmd[16];
> +	u8 cmd_len;
> +	u8 *sense_buffer;
> +	u8 lun;
> +	unsigned int payload_len;
> +	struct sg_table sgt;
> +	enum dma_data_direction cmd_dir;
> +	struct completion *complete;
> +};

Is ufs_req only used to submit HPB requests and not to submit any other
type of request? If so, please make that clear in the name of this
structure.

Please also add a comment above this data structure that explains its
purpose.

>  /**
>   * struct ufshcd_lrb - local reference block
>   * @utr_descriptor_ptr: UTRD address of the command
> @@ -206,6 +218,7 @@ struct ufshcd_lrb {
>  	bool intr_cmd;
>  	ktime_t issue_time_stamp;
>  	ktime_t compl_time_stamp;
> +	struct ufs_req *ureq;
>  
>  	bool req_abort_skip;
>  };

Please document the meaning of the 'ureq' member.

> @@ -727,6 +740,15 @@ struct ufs_hba {
>  
>  	struct device		bsg_dev;
>  	struct request_queue	*bsg_queue;
> +
> +#if defined(CONFIG_SCSI_UFSHPB)
> +	enum UFSHPB_STATE ufshpb_state;
> +	struct ufshpb_geo hpb_geo;
> +	struct ufshpb_lu *ufshpb_lup[32];
> +	struct delayed_work ufshpb_init_work;
> +	struct work_struct ufshpb_eh_work;
> +	struct scsi_device *sdev_ufs_lu[32];
> +#endif
>  };

If the sdev and ufshpb_lu pointers would be passed directly to
ufshpb_execute_req(), would that make the two above 32-element arrays
superfluous? I don't like these arrays since these duplicate SCSI core
data structures.

> +#define hpb_trace(hpb, args...)						\
> +	do { if ((hpb)->hba->sdev_ufs_lu[(hpb)->lun] &&			\
> +		(hpb)->hba->sdev_ufs_lu[(hpb)->lun]->request_queue)	\
> +		blk_add_trace_msg(					\
> +		(hpb)->hba->sdev_ufs_lu[(hpb)->lun]->request_queue,	\
> +				##args);				\
> +	} while (0)

So a new variable has been introduced at the controller level that
represents the LUN for which a HPB command is being processed? Does this
mean that this implementation forces serialization of all UFS commands
that need HPB support? Aargh! Please don't do that.

> +/*
> + * define global constants
> + */
> +static int sects_per_blk_shift;
> +static int bits_per_dword_shift;
> +static int bits_per_dword_mask;
> +static int bits_per_byte_shift;

From ufshpb_init_constant():

sects_per_blk_shift = ffs(UFS_LOGICAL_BLOCK_SIZE) - ffs(SECTOR_SIZE);
bits_per_dword_shift = ffs(BITS_PER_DWORD) - 1;
bits_per_dword_mask = BITS_PER_DWORD - 1;
bits_per_byte_shift = ffs(BITS_PER_BYTE) - 1;

If you want me to have a look at a later version of this patch series,
please remove these variables and use #define or enum { ... = ... }
instead. Please also use ilog2() instead of ffs(...) - 1. Please use
SECTOR_SHIFT instead of ilog2(SECTOR_SIZE).

> +static void ufshpb_init_constant(struct ufs_hba *hba,
> +				 struct ufshpb_geo_desc *geo_desc)
> +{
> +	struct ufshpb_geo *geo = &hba->hpb_geo;
> +	u64 region_entry_sz;
> +	int entries_per_region;
> +
> +	sects_per_blk_shift = ffs(UFS_LOGICAL_BLOCK_SIZE) - ffs(SECTOR_SIZE);
> +	bits_per_dword_shift = ffs(BITS_PER_DWORD) - 1;
> +	bits_per_dword_mask = BITS_PER_DWORD - 1;
> +	bits_per_byte_shift = ffs(BITS_PER_BYTE) - 1;
> +
> +	geo->region_size_bytes = (u64)
> +			SECTOR_SIZE * (0x01 << geo_desc->hpb_region_size);

Please use 1ULL << ... instead of the (u64) cast.

> +	geo->subregion_size_bytes = (u64)
> +			SECTOR_SIZE * (0x01 << geo_desc->hpb_subregion_size);

Same comment here.

> +	lu_hpb->lu_region_cnt = ((unsigned long long)lu_num_blocks
> +			       + (region_entry_size / HPB_ENTRY_SIZE) - 1) /
> +				(region_entry_size / HPB_ENTRY_SIZE);
> +	lu_hpb->lu_subregion_cnt = ((unsigned long long)lu_num_blocks
> +			+ (subregion_entry_size / HPB_ENTRY_SIZE) - 1) /
> +			(subregion_entry_size / HPB_ENTRY_SIZE);

Please use (u64) or (uint64_t) instead of (unsigned long long).

> +static inline int ufshpb_blocksize_is_supported(struct ufshpb_lu *hpb,
> +						int sectors)
> +{
> +	int ret = true;
> +
> +	if (sectors > SECTORS_PER_BLOCK)
> +		ret = false;
> +		/* HPB 1.0 only supports 4KB TRANSFER LENGTH */
> +
> +	return ret;
> +}

Please document the meaning of the 'sectors' argument and also its unit.

Can the body of the above function be simplified into the following?

	return sectors <= SECTORS_PER_BLOCK;

> +static struct
> +ufshpb_region *ufshpb_victim_region_select(struct active_region_info *lru_info)
> +{
> +	struct ufshpb_region *cb;
> +	struct ufshpb_region *victim_cb = NULL;
> +	u32 hit_count = 0xffffffff;
> +
> +	switch (lru_info->selection_type) {
> +	case LRU:
> +		/*
> +		 * Choose first region from the active region list
> +		 */
> +		victim_cb = list_first_entry(&lru_info->lru,
> +					     struct ufshpb_region, list_region);
> +		break;
> +	case LFU:
> +		/*
> +		 * Choose active region with the lowest hit_count
> +		 */
> +		list_for_each_entry(cb, &lru_info->lru, list_region) {
> +			if (hit_count > cb->hit_count) {
> +				hit_count = cb->hit_count;
> +				victim_cb = cb;
> +			}
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return victim_cb;
> +}

Which synchronization object protects the lru_info->lru list? How about
documenting this with lockdep_assert_held()?

> +static inline struct
> +hpb_sense_data *ufshpb_get_sense_data(struct ufshcd_lrb *lrbp)
> +{
> +	return (struct hpb_sense_data *)&lrbp->ucd_rsp_ptr->sr.sense_data_len;
> +}

The above seems weird to me. sense_data_len has type __be16 and hence a
size of two bytes. hpb_sense_data has a size of 20 bytes. How can it
make sense to cast a pointer to __be16 to a pointer to strut hpb_sense_data?

> +static void ufshpb_prepare_hpb_read(struct ufshpb_lu *hpb,
> +				    struct ufshcd_lrb *lrbp,
> +				    unsigned long long entry, int blk_cnt)
> +{
> +	unsigned char cmd[16] = { };
> +	/*
> +	 * cmd[14] = Transfer length
> +	 */
> +	cmd[0] = UFSHPB_READ;
> +	cmd[2] = lrbp->cmd->cmnd[2];
> +	cmd[3] = lrbp->cmd->cmnd[3];
> +	cmd[4] = lrbp->cmd->cmnd[4];
> +	cmd[5] = lrbp->cmd->cmnd[5];
> +	put_unaligned_be64(entry, &cmd[6]);
> +	cmd[14] = blk_cnt;
> +	cmd[15] = 0x00;
> +	memcpy(lrbp->cmd->cmnd, cmd, 16);
> +	memcpy(lrbp->ucd_req_ptr->sc.cdb, cmd, 16);
> +}

It seems weird to me that there is a copy of the CDB in struct
utp_upiu_cmd. I don't know any other SCSI LLD that maintains two copies
of the SCSI CDB. Can the CDB copy be removed from struct utp_upiu_cmd?

> +
> +/*
> + * Note: hpb->hpb_lock (irq) should be held before calling this function
> + */
> +static inline void ufshpb_l2p_entry_dirty_bit_set(struct ufshpb_lu *hpb,
> +						  struct ufshpb_region *cb,
> +						  struct ufshpb_subregion *cp,
> +						  int dword, int offset,
> +						  unsigned int count)
> +{
> +	struct ufshpb_geo *geo;
> +	const unsigned long mask = ((1UL << count) - 1) & 0xffffffff;

Please change the type of mask into u32 and remove "& 0xffffffff".

> +static inline struct ufshpb_map_ctx *ufshpb_mctx_get(struct ufshpb_lu *hpb,
> +						     int *err)
> +{
> +	struct ufshpb_map_ctx *mctx;
> +
> +	mctx = list_first_entry_or_null(&hpb->lh_map_ctx, struct ufshpb_map_ctx,
> +					list_table);
> +	if (mctx) {
> +		list_del_init(&mctx->list_table);
> +		hpb->free_mctx_count--;
> +		*err = 0;
> +		return mctx;
> +	}
> +	*err = -ENOMEM;
> +
> +	return NULL;
> +}

Please add a lockdep_assert_held() call that documents which
synchronization object serializes accesses.

> +struct ufshpb_map_ctx *ufshpb_subregion_mctx_alloc(struct ufshpb_lu *hpb)
> +{
> +	int i, j;
> +	int entries;
> +	struct ufshpb_map_ctx *mctx;
> +	struct ufshpb_geo *geo;
> +
> +	geo = &hpb->hba->hpb_geo;
> +	entries = geo->entries_per_subregion;
> +
> +	mctx = kzalloc(sizeof(*mctx), GFP_KERNEL);
> +	if (!mctx)
> +		return NULL;
> +
> +	mctx->m_page = kcalloc(geo->mpages_per_subregion, sizeof(struct page *),
> +			       GFP_KERNEL);
> +	if (!mctx->m_page)
> +		goto release_mem;
> +
> +	mctx->ppn_dirty = kvzalloc(entries >> bits_per_byte_shift, GFP_KERNEL);
> +	if (!mctx->ppn_dirty)
> +		goto release_mem;
> +
> +	for (i = 0; i < geo->mpages_per_subregion; i++) {
> +		mctx->m_page[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +		if (!mctx->m_page[i]) {
> +			for (j = 0; j < i; j++)
> +				kfree(mctx->m_page[j]);
> +			goto release_mem;
> +		}
> +	}
> +	return mctx;
> +
> +release_mem:
> +	kfree(mctx->m_page);
> +	kvfree(mctx->ppn_dirty);
> +	kfree(mctx);
> +	return NULL;
> +}

Has it been considered to use vmalloc() or kvmalloc() instead of
multiple alloc_page() calls?

> +static int ufshpb_add_bio_page(struct ufshpb_lu *hpb, struct request_queue *q,
> +			       struct bio *bio, struct bio_vec *bvec,
> +			       struct ufshpb_map_ctx *mctx)
> +{
> +	struct ufshpb_geo *geo;
> +	struct page *page = NULL;
> +	int i, ret = 0;
> +
> +	WARN_ON(!mctx);
> +	WARN_ON(!bvec);
> +
> +	geo = &hpb->hba->hpb_geo;
> +	bio_init(bio, bvec, geo->mpages_per_subregion);
> +
> +	for (i = 0; i < geo->mpages_per_subregion; i++) {
> +		page = mctx->m_page[i];
> +		if (!page)
> +			return -ENOMEM;
> +
> +		ret = bio_add_pc_page(q, bio, page, geo->mpage_bytes, 0);
> +
> +		if (ret != geo->mpage_bytes) {
> +			hpb_err("bio_add_pc_page() error with ret %d\n", ret);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}

Why does the above function use bio_add_pc_page() instead of bio_add_page()?

> +static int ufshpb_l2p_load(struct ufshpb_lu *hpb,
> +			   struct ufshpb_map_req *map_req)
> +{
> +	struct ufs_req *ureq;
> +	struct ufs_hba *hba = hpb->hba;
> +	struct request_queue *q = hpb->hba->cmd_queue;
> +	int retried = 0;
> +	struct bio *bio;
> +	int alloc_len;
> +	int ret;
> +
> +	map_req->ureq = kmalloc(sizeof(struct ufs_req), GFP_KERNEL);
> +	if (!map_req->ureq)
> +		return -ENOMEM;
> +	ureq = map_req->ureq;
> +	ureq->req = NULL;
> +
> +	map_req->ureq->sense_buffer = kmalloc(UFS_SENSE_SIZE, GFP_KERNEL);
> +	if (!map_req->ureq->sense_buffer) {
> +		kfree(map_req->ureq);
> +		return -ENOMEM;
> +	}
> +
> +	bio = &map_req->bio;
> +	ret = ufshpb_add_bio_page(hpb, q, bio, map_req->bvec, map_req->mctx);
> +	if (ret) {
> +		hpb_err("ufshpb_add_bio_page() failed with ret %d\n", ret);
> +		goto free_mem;
> +	}
> +
> +	alloc_len = hpb->hba->hpb_geo.subregion_entry_sz;
> +	/*
> +	 * HPB Sub-Regions are equally sized except for the last one which is
> +	 * smaller if the last hpb Region is not an integer multiple of
> +	 * bHPBSubRegionSize.
> +	 */
> +	if (map_req->region == (hpb->lu_region_cnt - 1) &&
> +	    map_req->subregion == (hpb->subregions_in_last_region - 1))
> +		alloc_len = hpb->last_subregion_entry_size;
> +
> +	ufshpb_prepare_read_buf_cmd(ureq->cmd, map_req->region,
> +				    map_req->subregion, alloc_len);
> +	if (!ureq->req) {
> +		ureq->req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
> +		if (IS_ERR(ureq->req)) {
> +			ret =  PTR_ERR(ureq->req);
> +			goto free_mem;
> +		}
> +	}
> +
> +	blk_rq_append_bio(ureq->req, &bio);
> +
> +	ureq->cmd_len = 10;
> +	ureq->lun = map_req->lun;
> +	ureq->cmd_dir = DMA_FROM_DEVICE;
> +
> +	ufshpb_req_buffer_map(ureq);
> +
> +	map_req->req_issue_t = ktime_to_ns(ktime_get());
> +	atomic64_inc(&hpb->status.map_req_cnt);
> +
> +	hpb_dbg(SCHEDULE_INFO, hpb, "ISSUE READ_BUFFER : (%d-%d) retry = %d\n",
> +		map_req->region, map_req->subregion, map_req->retry_cnt);
> +	hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, map_req->region,
> +		  map_req->subregion);
> +	ret = ufshcd_exec_internal_req(hpb->hba, ureq);
> +
> +	if (hba->ufshpb_state != HPB_PRESENT)
> +		goto free_mem_req;
> +
> +	if (ret) {
> +		hpb_err("ureq Request result %d\n", ret);
> +		ufshpb_l2p_load_error_handler(hpb, map_req, &retried);
> +		if (retried)
> +			return 0;
> +		goto free_mem_req;
> +	}
> +	ufshpb_l2p_load_req_compl(hpb, map_req);
> +
> +free_mem_req:
> +	blk_put_request(map_req->ureq->req);
> +	map_req->ureq->req = NULL;
> +free_mem:
> +	kfree(ureq->sense_buffer);
> +	kfree(ureq->sgt.sgl);
> +	kfree(map_req->ureq);
> +	INIT_LIST_HEAD(&map_req->list_map_req);
> +	spin_lock(&hpb->hpb_lock);
> +	list_add_tail(&map_req->list_map_req, &hpb->lh_map_req_free);
> +	spin_unlock(&hpb->hpb_lock);
> +	return ret;
> +}

Do you agree that there is a lot of overlap between this function and
scsi_execute()? How to prevent such code duplication?

> +static ssize_t ufshpb_sysfs_miss_show(struct ufshpb_lu *hpb, char *buf)
> +{
> +	long long region_miss, subregion_miss, entry_dirty_miss, rb_fail;
> +	int ret = 0, count = 0;
> +
> +	region_miss = atomic64_read(&hpb->status.region_miss);
> +	subregion_miss = atomic64_read(&hpb->status.subregion_miss);
> +	entry_dirty_miss = atomic64_read(&hpb->status.entry_dirty_miss);
> +	rb_fail = atomic64_read(&hpb->status.rb_fail);
> +
> +	ret = sprintf(buf + count, "Total entries missed: %lld\n",
> +		      region_miss + subregion_miss + entry_dirty_miss);
> +	count += ret;
> +
> +	ret = sprintf(buf + count, "Region: %lld\n", region_miss);
> +	count += ret;
> +
> +	ret = sprintf(buf + count, "subregion: %lld, entry dirty: %lld\n",
> +		      subregion_miss, entry_dirty_miss);
> +	count += ret;
> +
> +	ret = sprintf(buf + count, "HPB Read Buffer CMD failure: %lld\n",
> +		      rb_fail);
> +
> +	return (count + ret);
> +}

Please follow the sysfs one value per attribute rule.

> +static ssize_t ufshpb_sysfs_act_subregion_show(struct ufshpb_lu *hpb, char *buf)
> +{
> +	int ret = 0, count = 0, region, sub;
> +	struct ufshpb_region *cb;
> +	int state;
> +
> +	ret = sprintf(buf, "Clean Subregion List:\n");
> +	count = ret;
> +
> +	for (region = 0; region < hpb->lu_region_cnt; region++) {
> +		cb = hpb->region_tbl + region;
> +		for (sub = 0; sub < cb->subregion_count; sub++) {
> +			state = cb->subregion_tbl[sub].subregion_state;
> +			if (state == SUBREGION_CLEAN) {
> +				ret = sprintf(buf + count, "%d:%d ", region,
> +					      sub);
> +				count += ret;
> +			}
> +		}
> +	}
> +
> +	ret = sprintf(buf + count, "\n");
> +	count += ret;
> +
> +	return count;
> +}

Same comment here.

> +#define hpb_warn(fmt, ...)					\
> +	pr_warn("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
> +#define hpb_notice(fmt, ...)					\
> +	pr_notice("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
> +#define hpb_info(fmt, ...)					\
> +	pr_info("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
> +#define hpb_err(fmt, ...)					\
> +	pr_err("%s: %s:" fmt, __func__, DRIVER_NAME,		\
> +					##__VA_ARGS__)

Please define pr_fmt() and use pr_warn() etc. directly instead of
defining the above macros.

Thanks,

Bart.
