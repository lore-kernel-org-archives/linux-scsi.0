Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95037C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 06:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6792164E41
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 06:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhCOGhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:37:31 -0400
Received: from z11.mailgun.us ([104.130.96.11]:55157 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhCOGg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 02:36:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615790219; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UnMKnQ0upwcZQULIAzy6S4QOxI40VwQxQnJKEVcsB7M=;
 b=gjCKXj+5eK+ysyep/+B0yOB3Oj328trOtPxb3R+zwIi3BkSXq4FIVsSQq/knTyNQIvM8W4bV
 cGMdoKZ19F3KtGLFFVZv5hB5WZwo8AGDHZnn+bcFgx1NsKEYHppR2wzt6nHUPoSmmOuLZhiM
 sRcA/phwVmHiZd2MBqawqlDtVpY=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 604f00884db3bb6801eee7a0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 06:36:56
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13E90C43464; Mon, 15 Mar 2021 06:36:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A670C433CA;
        Mon, 15 Mar 2021 06:36:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 14:36:55 +0800
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
Subject: Re: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
In-Reply-To: <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
References: <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
 <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p8>
 <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
Message-ID: <9eb5f8385f830bdec25828f17527c73f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-15 09:31, Daejun Park wrote:
> This patch supports the HPB 2.0.
> 
> The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
> In the case of Read (<= 32KB) is supported as single HPB read.
> In the case of Read (36KB ~ 512KB) is supported by as a combination of
> write buffer command and HPB read command to deliver more PPN.
> The write buffer commands may not be issued immediately due to busy 
> tags.
> To use HPB read more aggressively, the driver can requeue the write 
> buffer
> command. The requeue threshold is implemented as timeout and can be
> modified with requeue_timeout_ms entry in sysfs.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> +static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct 
> scsi_cmnd *cmd,
> +				int *read_id)
> +{
> +	struct ufshpb_req *pre_req;
> +	struct request *req = NULL;
> +	struct bio *bio = NULL;
> +	unsigned long flags;
> +	int _read_id;
> +	int ret = 0;
> +
> +	req = blk_get_request(cmd->device->request_queue,

To keep symmetry with ufshpb_get_req(), can we use 
hpb->sdev_ufs_lu->request_queue?

Thanks,
Can Guo.

> +			      REQ_OP_SCSI_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
> +	if (IS_ERR(req))
> +		return -EAGAIN;
> +
> +	bio = bio_alloc(GFP_ATOMIC, 1);
> +	if (!bio) {
> +		blk_put_request(req);
> +		return -EAGAIN;
> +	}
> +
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +	pre_req = ufshpb_get_pre_req(hpb);
> +	if (!pre_req) {
> +		ret = -EAGAIN;
> +		goto unlock_out;
> +	}
> +	_read_id = ufshpb_get_read_id(hpb);
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +
> +	pre_req->req = req;
> +	pre_req->bio = bio;
> +
> +	ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
> +	if (ret)
> +		goto free_pre_req;
> +
> +	*read_id = _read_id;
> +
> +	return ret;
> +free_pre_req:
> +	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> +	ufshpb_put_pre_req(hpb, pre_req);
> +unlock_out:
> +	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> +	bio_put(bio);
> +	blk_put_request(req);
> +	return ret;
> +}
> +
