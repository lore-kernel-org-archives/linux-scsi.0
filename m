Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263E7CA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 14:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 039EA21783
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 14:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfJ1O6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:58:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40332 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfJ1O6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 10:58:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id 15so7040172pgt.7;
        Mon, 28 Oct 2019 07:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgmUnsjTAz2FEyBL5EV5ObTx34mXAfg+kK1fzwbTqCU=;
        b=IHRs3NEuzqdsqhXSthgObsaUR3ml0+lYpa1YGhf4QLeP9DDlnj4yfCTuUYlTpviGpb
         pvX7V/UKL5B3BL1IkTw18rIYvtJpRHEveNpcSEwF68ZWidV1O/9K+rlfxyWmHO+QnfF3
         vQ2FTdDZfqaN3yY0/McgW4G4147UqK+LwwvcLkduK0ZB/yjrGhByoJsxV7ep754mko+f
         7xt/nJajGFMtJzBfUaWFZxFtSju4Sh+B+LJWCimhVsof12D+IT7s+wFyQIsQMHsyE6CV
         YP3VSSq3ksFOOjzCmwZLyVZWDfMHa6UzS7QTWYI2ocdSMZcFnpd1JSLVDuHRMRjH3c0M
         S7fg==
X-Gm-Message-State: APjAAAUAS5PXkhoA/ZsKVEhmOY/seV8DD5jEXP/KCeryOv6nDbdu+v4K
        V/cjKcOKZS5XBxGJ2/mkNsEnPYyk
X-Google-Smtp-Source: APXvYqy6cw+Aib7+Zv7QP+bzEJtEbvPdGR6idczdfOjchnnwUSJia4e1GEQWgV2hdkKDqhHc3tiF2Q==
X-Received: by 2002:a17:90a:ad44:: with SMTP id w4mr487144pjv.11.1572274721683;
        Mon, 28 Oct 2019 07:58:41 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x10sm10341508pgl.53.2019.10.28.07.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2019 07:58:40 -0700 (PDT)
Subject: Re: [PATCH v1 1/5] scsi: Adjust DBD setting in mode sense for caching
 mode page per LLD
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
 <1572234608-32654-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0ca52845-10ec-3310-83f7-81bdb635ec12@acm.org>
Date:   Mon, 28 Oct 2019 07:58:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1572234608-32654-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/19 8:50 PM, Can Guo wrote:
> Host sends MODE_SENSE_10 with caching mode page, to check if the device
> supports the cache feature.
> Some LLD standards requires DBD field to be set to 1.

Which LLD standard are you referring to? Please mention at least one 
name of such a standard in the patch description.

> Change-Id: I0c8752c1888654942d6d7e6e0f6dc197033ac326

Change-IDs should be left out from upstream patches. Does the presence 
of this ID mean that this patch has not been verified with checkpatch? 
 From the checkpatch source code:

# Check for unwanted Gerrit info
if ($in_commit_log && $line =~ /^\s*change-id:/i) {
	ERROR("GERRIT_CHANGE_ID",
	      "Remove Gerrit Change-Id's before submitting upstream.\n"\
		 . $herecurr);
}

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index aab4ed8..6d8194f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2629,6 +2629,7 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
>   {
>   	int len = 0, res;
>   	struct scsi_device *sdp = sdkp->device;
> +	struct Scsi_Host *host = sdp->host;
>   
>   	int dbd;
>   	int modepage;
> @@ -2660,7 +2661,10 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
>   		dbd = 8;
>   	} else {
>   		modepage = 8;
> -		dbd = 0;
> +		if (host->set_dbd_for_caching)
> +			dbd = 8;
> +		else
> +			dbd = 0;
>   	}
>   
>   	/* cautiously ask */
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 2c3f0c5..3900987 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -650,6 +650,12 @@ struct Scsi_Host {
>   	unsigned no_scsi2_lun_in_cdb:1;
>   
>   	/*
> +	 * Set "DBD" field in mode_sense caching mode page in case it is
> +	 * mandatory by LLD standard.
> +	 */
> +	unsigned set_dbd_for_caching:1;
> +
> +	/*
>   	 * Optional work queue to be utilized by the transport
>   	 */
>   	char work_q_name[20];

Since this patch by itself has no effect, please resubmit this patch 
together with the LLD patch that sets set_dbd_for_caching.

Thanks,

Bart.

