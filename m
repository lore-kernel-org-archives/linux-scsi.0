Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EF0C4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 00:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C458206E3
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 00:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJCAXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 20:23:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40048 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJCAXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 20:23:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id w21so2503703pfc.7;
        Fri, 02 Oct 2020 17:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CtWlc9tOOk7EdLHe8DbuEVwI2UYtcy4XzuaSQSybDAA=;
        b=NVlit/ppejkqJXXyEqshB6DykTMZXNu1mMx4M1/oG8WSGFnh1wmqDR5zx3BxESgxun
         IAyxi/j1lQlRzBZdgmo6SspJVfcXSBYMETHHMmjv1pUxCaOgBFVK/66xMvSR/+kwXmAU
         DmnI/jayfCwulCQeSXV5ZRhmQnS0qsfMJxc65TbZEJINjPUqiWuJBZGmk1Kwu6q7FVyD
         QSh9H1ttJr6voRjeIazmPeDJtgX92GvogOo5ZDBJR61SHt/D8MCRauGf+lLn1TbJY8Eo
         VCTPuENnhmdXX+n+diPTQIqAC1abTEZWcKRt5heqp2eA/kOzTBDXW+7E+W9WCgyRNPTG
         2Nyw==
X-Gm-Message-State: AOAM530UoHerbVWK/tD2NuKS4a9zpv/OdKIOwgxQPZEyecRK3678PTRF
        zNd5FD5saacwI8PWMFB3eRd33ll67P4=
X-Google-Smtp-Source: ABdhPJyEwxKMNfbbclA/aT2WZM/lMuKisnCfxXIDNBG/1U6ujaD4QdhZJV7RnphaN030C4YPj8WLTg==
X-Received: by 2002:aa7:9f4e:0:b029:142:2501:39f1 with SMTP id h14-20020aa79f4e0000b0290142250139f1mr5248880pfr.64.1601684624054;
        Fri, 02 Oct 2020 17:23:44 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id e27sm3368624pfj.62.2020.10.02.17.23.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 17:23:42 -0700 (PDT)
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list
 corruption early"
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20201002073341.12470-1-mlombard@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ce44115e-f8ac-0307-88bd-f6a2e9d7f7f3@acm.org>
Date:   Fri, 2 Oct 2020 17:23:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002073341.12470-1-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/20 12:33 AM, Maurizio Lombardi wrote:
> This reverts commit b0055acaedf56a2717a6e2a4b700f1959a1b60df.
> 
> This warning is duplicated because the very same condition
> is already checked in __iscsit_free_cmd().
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>   drivers/target/iscsi/iscsi_target_util.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 45ba07c6ec27..ff7830ddbd7b 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -764,8 +764,6 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>   	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>   	int rc;
>   
> -	WARN_ON(!list_empty(&cmd->i_conn_node));
> -
>   	__iscsit_free_cmd(cmd, shutdown);
>   	if (se_cmd) {
>   		rc = transport_generic_free_cmd(se_cmd, shutdown);

Hi Maurizio,

I agree that the same WARN_ON() occurs inside __iscsit_free_cmd(). What is not
clear to me is how removing the WARN_ON() statement from iscsit_free_cmd() can
help since an identical statement occurs inside __iscsit_free_cmd()?

Thanks,

Bart.


