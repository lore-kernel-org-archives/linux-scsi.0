Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1700BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 01:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDBDE64F91
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 01:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCLBUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 20:20:41 -0500
Received: from z11.mailgun.us ([104.130.96.11]:21677 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhCLBUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 20:20:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615512013; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=i1rLI2849axKxL19lxDHqUeq6hMWiO7j2pQh0uXZGgY=;
 b=mAXI+vibsBtmC9ERh1x1QIVw+dEdM7HyVZuqymUGIW4THF3HnQJNIhA9Cec5ximiOc3ADmE4
 6F1VyAzzVqexrCgyuy/cEM4KAbumS+Jr4poPYrpSFhJeiebRAJFybcNf7DEL8qMFfRVDBPrd
 SuDXvwqOZ1X7aF5ERTpxFrDWe1E=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 604ac1c11de5dd7b992dd2b8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Mar 2021 01:20:01
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76C9EC43465; Fri, 12 Mar 2021 01:20:00 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9CF8C433C6;
        Fri, 12 Mar 2021 01:19:58 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Mar 2021 09:19:58 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, huobean@gmail.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v26 2/4] scsi: ufs: L2P map management for HPB read
In-Reply-To: <20210303062829epcms2p678450953f611c340a2b8e88b5542fe73@epcms2p6>
References: <20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p2>
 <CGME20210303062633epcms2p252227acd30ad15c1ca821d7e3f547b9e@epcms2p6>
 <20210303062829epcms2p678450953f611c340a2b8e88b5542fe73@epcms2p6>
Message-ID: <27fe9c42f4b9539f07f75b7978ab305e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-03 14:28, Daejun Park wrote:
> This is a patch for managing L2P map in HPB module.
> 
> The HPB divides logical addresses into several regions. A region 
> consists
> of several sub-regions. The sub-region is a basic unit where L2P 
> mapping is
> managed. The driver loads L2P mapping data of each sub-region. The 
> loaded
> sub-region is called active-state. The HPB driver unloads L2P mapping 
> data
> as region unit. The unloaded region is called inactive-state.
> 
> Sub-region/region candidates to be loaded and unloaded are delivered 
> from
> the UFS device. The UFS device delivers the recommended active 
> sub-region
> and inactivate region to the driver using sensedata.
> The HPB module performs L2P mapping management on the host through the
> delivered information.
> 
> A pinned region is a pre-set regions on the UFS device that is always
> activate-state.
> 
> The data structure for map data request and L2P map uses mempool API,
> minimizing allocation overhead while avoiding static allocation.
> 
> The mininum size of the memory pool used in the HPB is implemented
> as a module parameter, so that it can be configurable by the user.
> 
> To gurantee a minimum memory pool size of 4MB: 
> ufshpb_host_map_kbytes=4096
> 
> The map_work manages active/inactive by 2 "to-do" lists.
> Each hpb lun maintains 2 "to-do" lists:
>   hpb->lh_inact_rgn - regions to be inactivated, and
>   hpb->lh_act_srgn - subregions to be activated
> Those lists are maintained on IO completion.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Can Guo <cang@codeaurora.org>
> Acked-by: Avri Altman <Avri.Altman@wdc.com>
> Tested-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufs.h    |   36 ++
>  drivers/scsi/ufs/ufshcd.c |    4 +
>  drivers/scsi/ufs/ufshpb.c | 1091 ++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/ufs/ufshpb.h |   65 +++
>  4 files changed, 1181 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 65563635e20e..957763db1006 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -472,6 +472,41 @@ struct utp_cmd_rsp {
>  	u8 sense_data[UFS_SENSE_SIZE];
>  };
> ...
> +/*
> + * This function will parse recommended active subregion information 
> in sense
> + * data field of response UPIU with SAM_STAT_GOOD state.
> + */
> +void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> +{
> +	struct ufshpb_lu *hpb = ufshpb_get_hpb_data(lrbp->cmd->device);
> +	struct utp_hpb_rsp *rsp_field = &lrbp->ucd_rsp_ptr->hr;
> +	int data_seg_len;
> +
> +	if (unlikely(lrbp->lun != rsp_field->lun)) {
> +		struct scsi_device *sdev;
> +		bool found = false;
> +
> +		__shost_for_each_device(sdev, hba->host) {
> +			hpb = ufshpb_get_hpb_data(sdev);
> +
> +			if (!hpb)
> +				continue;
> +
> +			if (rsp_field->lun == hpb->lun) {
> +				found = true;
> +				break;
> +			}
> +		}
> +
> +		if (!found)
> +			return;
> +	}
> +
> +	if (!hpb)
> +		return;
> +
> +	if ((ufshpb_get_state(hpb) != HPB_PRESENT) &&
> +	    (ufshpb_get_state(hpb) != HPB_SUSPEND)) {
> +		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
> +			   "%s: ufshpb state is not PRESENT/SUSPEND\n",
> +			   __func__);

Please mute these prints before hpb is fully initilized, otherwise
there can be tons of these prints during bootup. Say set a flag in
ufshpb_hpb_lu_prepared() and check for that flag - just a rough idea.

Thanks,
Can Guo.

> +		return;
> +	}
> +
