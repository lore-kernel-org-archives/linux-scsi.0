Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2246C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 16:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FF164E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 16:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhBIQAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhBIQAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 11:00:37 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C1BC061574;
        Tue,  9 Feb 2021 07:59:56 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hs11so32542926ejc.1;
        Tue, 09 Feb 2021 07:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=D7icV6wZnYllCDXKRZgj7Pgh7LAoUGJqDx/rYoNkik8=;
        b=KpcBE4lsG4ncrA4t/pVb07Ifs/irhnb834OGugkxRUJ2f6feLPTzCsk+Ku5Ie63Ci7
         JsZRFXT72qlgA6kaSmnOuAy7xRJGRuL7+uqNIYyLqfLWvpDpEptJ1+iegfAFnONjMC8g
         1qrlewdTWkjBNyd8WdkY3Kh/XLT1bLWrb3VieERbLoIuZlqIJ+q013K68dMyFRKemEgq
         taIn+RI5svFdKIYXdIjEelY2NSwcWlCMC/5PC93ZH7Zm1IMgL7ZEHTLVxBI58imENRIh
         JSC0wbXkPU8VEGFyQhY+pArYjTT5ha6dHZoSsNI1U3gHqvZcKXYN3mgUnQR+AvMfxLxi
         pRPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D7icV6wZnYllCDXKRZgj7Pgh7LAoUGJqDx/rYoNkik8=;
        b=Fa1nOZlrbSd8a3eSiVHFvEVLFD92oDjDQcz5uN4Dn3CGEXNm2MknkE0LAgltH5/cBq
         bzZYgirCDEtH8P/2fQD8euaNU80x5TJnkG7eCGSDG4LAtjw+qYXuCUNMz2TdCj817Bj4
         54Z0dalZT6Zq7l753xFbKqgHBBKkzJWuh+wgGfwtJUhazoEdpDo7e0AYeIG591bpmtPK
         Tn1VHj/v7UaZDzhFlNjqDtFqriPBUSUiJfKewOMKZaXty7zjtTA4/EV3EK65kXhFEbo1
         boCMGN40HmYDHrsaSZ9WEedXTPKkquN/xwZD8RoXFy/UN5zbf7cZB9b6ZkpoJK3fcD9F
         u+xw==
X-Gm-Message-State: AOAM530TP60qg9ST/fYO/B4tL699Wvfu6Tcn9UCGoLTA+EB8BnT/ogrV
        75w2FhR4bLOEyzsP3+quu26HtRv0piE=
X-Google-Smtp-Source: ABdhPJzBkufzbjTVLwoi+aT6Kf6ZJWuRZ8hiJS9dP+5kI9lYv5KEwlblfTdXEQOZoLBQXokIbf6INA==
X-Received: by 2002:a17:906:a099:: with SMTP id q25mr12472519ejy.549.1612886395434;
        Tue, 09 Feb 2021 07:59:55 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id b6sm8384548edy.31.2021.02.09.07.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 07:59:54 -0800 (PST)
Subject: Re: [PATCH 06/13] tcm loop: use lio wq cmd submission helper
To:     Mike Christie <michael.christie@oracle.com>,
        Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210209123845.4856-1-michael.christie@oracle.com>
 <20210209123845.4856-7-michael.christie@oracle.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <70353be9-f6cd-6931-ea87-5a393e418a35@gmail.com>
Date:   Tue, 9 Feb 2021 16:59:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209123845.4856-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.21 13:38, Mike Christie wrote:
> @@ -179,6 +184,11 @@ static void tcm_loop_submission_work(struct work_struct *work)
>   static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>   {
>   	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
> +	struct tcm_loop_hba *tl_hba;
> +	struct tcm_loop_tpg *tl_tpg;
> +
> +	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
> +	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
>   
>   	pr_debug("%s() %d:%d:%d:%llu got CDB: 0x%02x scsi_buf_len: %u\n",
>   		 __func__, sc->device->host->host_no, sc->device->id,

AFAICS these new lines are not needed. Or am I missing something?
