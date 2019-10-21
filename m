Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81946CA9EB9
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 20:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A52B20640
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 20:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LHc+8Guj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfJUUFy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 16:05:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40028 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728543AbfJUUFy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 16:05:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id o28so15392623wro.7
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2019 13:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=am1PuQbvX+/BakviGIgvWZRHrXgIHSrNwUxBGhTMTiI=;
        b=LHc+8Gujy/d4XKn8PuTt19QdlLDR+MqM+hncjp4c0q3vRCwFlAE44CJUAMlu7E1nc3
         MIrDjneiRVD4VyN7IeuRXaIOPFBtlTSd5If7IcinYMMR6dvGs8jtKz+maZB21PlwiEZ5
         hfWqw5aqDUvASt9BRBPNoCBXigcxbrv09JQ1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=am1PuQbvX+/BakviGIgvWZRHrXgIHSrNwUxBGhTMTiI=;
        b=mk5Lm2qEDo5f3TaAfDVc0faTItZ19NixJo0q5v/t5zC2lItf2WLRV0A1ylw9QfCT4f
         Tk3gaxnr/xG4Ks1T6PKl9wEdBVGdfeK6CX73q2mZBBydMxRn8uCsftL2//5dcsRu1yxh
         0ygXe8MTjcnbdPQ0uu1i8jUKF/o3rZ62YXE+THgyTaZtpzyJq2aYluIY/DtflOAZ28Jg
         U+i+w0uSp+6e8qPPh2rl/AK8BtAEkwCFPp+gMAoKk3/R2merV6AHIQUNZiceBOzc5Aw1
         nqqrVKAARNfcoGRJC/S9P0/zmReOUw3fMZz5wDMmhDfnlAxLsrOea5EyiJuAFojSJfyu
         2nzw==
X-Gm-Message-State: APjAAAUQ6U+v32xlh0oMT6a6VbinmcDQvNiUw3JvvMwR+J8RcEvYEZKl
        v6H3JUsQe9DSTKUFQBuj/FaUz6Sqyog=
X-Google-Smtp-Source: APXvYqzmoDODHyRKlQqbQkQrTZEMa/sc2WJ3055sjdUZSkSlJrjw3IOLjMZKWkqBQtSvmjE0Y4DgfQ==
X-Received: by 2002:a5d:5690:: with SMTP id f16mr58135wrv.380.1571688351990;
        Mon, 21 Oct 2019 13:05:51 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 36sm18934617wrp.30.2019.10.21.13.05.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 13:05:51 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: Honor module parameter lpfc_use_adisc
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20191021100542.24136-1-dwagner@suse.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <3956fdcf-4537-d9c1-74d4-6e937eed05e3@broadcom.com>
Date:   Mon, 21 Oct 2019 13:05:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021100542.24136-1-dwagner@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/2019 3:05 AM, Daniel Wagner wrote:
> The initial lpfc_desc_set_adisc implementation dea3101e0a5c ("lpfc:
> add Emulex FC driver version 8.0.28") enabled ADISC if
>
> 	cfg_use_adisc && RSCN_MODE && FCP_2_DEVICE
>
> In commit 92d7f7b0cde3 ("[SCSI] lpfc: NPIV: add NPIV support on top of
> SLI-3") this changed to
>
> 	(cfg_use_adisc && RSC_MODE) || FCP_2_DEVICE
>
> and later in ffc954936b13 ("[SCSI] lpfc 8.3.13: FC Discovery Fixes and
> enhancements.") to
>
> 	(cfg_use_adisc && RSC_MODE) || (FCP_2_DEVICe && FCP_TARGET)
>
> A customer reports that after a Devlos, an ADISC failure is logged. It
> turns out the ADISC flag is set even the user explicitly set
> lpfc_use_adisc = 0.
>
> [Sat Dec 22 22:55:58 2018] lpfc 0000:82:00.0: 2:(0):0203 Devloss timeout on WWPN 50:01:43:80:12:8e:40:20 NPort x05df00 Data: x82000000 x8 xa
> [Sat Dec 22 23:08:20 2018] lpfc 0000:82:00.0: 2:(0):2755 ADISC failure DID:05DF00 Status:x9/x70000
>
> Fixes: 92d7f7b0cde3 ("[SCSI] lpfc: NPIV: add NPIV support on top of SLI-3")
> Cc: James Smart <James.Smart@emulex.com>
> Cc: Alex Iannicelli <alex.iannicelli@emulex.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> Hi,
>
> Unfortunatly, I don't really know all the procotols involved. So this
> is just a rough guess what is wrong.
>
> Thanks,
> Daniel
>
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index cc6b1b0bae83..d27ae84326df 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -940,9 +940,9 @@ lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   
>   	if (!(vport->fc_flag & FC_PT2PT)) {
>   		/* Check config parameter use-adisc or FCP-2 */
> -		if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
> +		if (vport->cfg_use_adisc && ((vport->fc_flag & FC_RSCN_MODE) ||
>   		    ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) &&
> -		     (ndlp->nlp_type & NLP_FCP_TARGET))) {
> +		     (ndlp->nlp_type & NLP_FCP_TARGET)))) {
>   			spin_lock_irq(shost->host_lock);
>   			ndlp->nlp_flag |= NLP_NPR_ADISC;
>   			spin_unlock_irq(shost->host_lock);

Looks good.

Reviewed-by: James Smart <james.smart@broadcom.com>

Thank You

-- james

