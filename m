Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D404C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 16:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12DC9604E9
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 16:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237602AbhIMQe2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 12:34:28 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:40775 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbhIMQe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 12:34:27 -0400
Received: by mail-pj1-f41.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso6987503pjh.5
        for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2021 09:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZD/a/8zpZhTenq7GOlaeKggfZpe5vew+CAKplQvNfew=;
        b=uLaV1jhmAG6zx+EeD+Y9lemedOv0WwruuntTQM1zXvqsEkHZpao6z9KarzCYTvvzSH
         6r5A0zKQEqnMPe+PmTRat5j5pQ1MXdmtky+VuJSgiTFwBuCWgJxqkST2mEiMzLdlhPSy
         QrJBrjU9ANSQs8KugBRKMCZ+H+Qrk8TOup9fQ0gTQJ5EX/wPdPSd1hBDI13Xay9dD1gv
         YFSraGxdBA5+rIhziBjvf9lQWQmKFi+OfhYNVv+gzSkjsYg/2SiV1TMviNsmtevtl8qy
         1XiNwbUhpqWPedism1KdejOK7aK3giAPt+nIbfNkxPJVHUC14eIPW9tUqsMo+wbr3jKw
         aIqA==
X-Gm-Message-State: AOAM532WIyOkrgxI14ZnJeGlEW7HNKQPgI6hcx3BO6sClomgfujWNWV5
        9DDAHCcOgcGKr/zjk0tHhwRnxWbpsVU=
X-Google-Smtp-Source: ABdhPJwSy1af1RsUjsFb/KBq1dxiy5eJUdaihDPNGb8vLTkTVw5DE4lluHn+63LJOMNdJ/fbOIVHgA==
X-Received: by 2002:a17:90a:eac4:: with SMTP id ev4mr360789pjb.244.1631550790588;
        Mon, 13 Sep 2021 09:33:10 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6765:113f:d2d7:def9])
        by smtp.gmail.com with ESMTPSA id b20sm2960674pfp.26.2021.09.13.09.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:33:09 -0700 (PDT)
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
 <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
 <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
 <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
 <fae15188-2c1d-b953-f6e4-6e5ac1902b24@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2997f7f9-d136-4bad-6490-5e19abccba00@acm.org>
Date:   Mon, 13 Sep 2021 09:33:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <fae15188-2c1d-b953-f6e4-6e5ac1902b24@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 1:53 AM, Adrian Hunter wrote:
> scsi_dec_host_busy() is called for any non-zero return value like
> SCSI_MLQUEUE_HOST_BUSY:
> 
> i.e.
> 	reason = scsi_dispatch_cmd(cmd);
> 	if (reason) {
> 		scsi_set_blocked(cmd, reason);
> 		ret = BLK_STS_RESOURCE;
> 		goto out_dec_host_busy;
> 	}
> 
> 	return BLK_STS_OK;
> 
> out_dec_host_busy:
> 	scsi_dec_host_busy(shost, cmd);
> 
> And that will wake the error handler:
> 
> static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
> {
> 	unsigned long flags;
> 
> 	rcu_read_lock();
> 	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> 	if (unlikely(scsi_host_in_recovery(shost))) {
> 		spin_lock_irqsave(shost->host_lock, flags);
> 		if (shost->host_failed || shost->host_eh_scheduled)
> 			scsi_eh_wakeup(shost);
> 		spin_unlock_irqrestore(shost->host_lock, flags);
> 	}
> 	rcu_read_unlock();
> }

Returning SCSI_MLQUEUE_HOST_BUSY is not sufficient to wake up the SCSI
error handler because of the following test in scsi_error_handler():

	shost->host_failed != scsi_host_busy(shost)

As I mentioned in a previous email, all pending commands must have failed
or timed out before the error handler is woken up. Returning
SCSI_MLQUEUE_HOST_BUSY from ufshcd_queuecommand() does not fail a command
and prevents it from timing out. Hence my suggestion to change
"return SCSI_MLQUEUE_HOST_BUSY" into set_host_byte(cmd, DID_IMM_RETRY)
followed by cmd->scsi_done(cmd). A possible alternative is to move the
blk_mq_start_request() call in the SCSI core such that the block layer
request timer is not reset if a SCSI LLD returns SCSI_MLQUEUE_HOST_BUSY.

Bart.
