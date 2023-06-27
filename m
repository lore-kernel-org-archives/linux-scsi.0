Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8E6EB64D9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 19:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjF0TyN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjF0TyA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 15:54:00 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8CB359E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 12:53:44 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-262b213eddfso171132a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 12:53:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687895624; x=1690487624;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YjxK6QH4bqMEL8Nwwzyyvstv5JD5j1oc1E+A1kqnLeo=;
        b=kCaV8DyAtzwjYowIhwzdYqJ1OlGwpvmXafP1cFOG2lEU68s/RIbeAVm6bjUSd2/Tqk
         gFt+XeV4lUvNEo/7/iPLmKl3OQWzTrtAzeRcWX9Re93s4CgqsE6ApxPT9Z2hLVpgfzRq
         5WUcjlUvtoNpCFFr0nks4O6/HH/vwxXFeGvU3g0he3FOQBuzF8SURsgW6rEdADfCYAmC
         zGoYEuANP9hHR1PMP3oBgRlfE/1DYY9STtdmUbtzxUTHEDhtku8/E+2bnKvAtOcuIbKB
         v5WvsyqrsImjC/SgXlyWmjUegJbsOt+5JWdWeQNZ7oICsK7jnlUDP+aQbgIbTHNC+o0Q
         mCGw==
X-Gm-Message-State: AC+VfDwDqPMmPS6siI/of95wWIhSKm3xXC6Uyl066aMJTkyZaUucNdBL
        gI9ppoYSxlZyO9sI14dIAs0=
X-Google-Smtp-Source: ACHHUZ4sEHGR/L3cPLX+67TomMx8i8S/VkQKs6lHEA3zjgm30bBzi3atdMppJajIWgPwDo5DMm3RGQ==
X-Received: by 2002:a17:90a:d917:b0:262:ec12:7c40 with SMTP id c23-20020a17090ad91700b00262ec127c40mr9775115pjv.11.1687895623661;
        Tue, 27 Jun 2023 12:53:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5a8b:4bea:e452:f031? ([2620:15c:211:201:5a8b:4bea:e452:f031])
        by smtp.gmail.com with ESMTPSA id m7-20020a17090a414700b00262d368b220sm5868060pjg.40.2023.06.27.12.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 12:53:43 -0700 (PDT)
Message-ID: <c8bc7bde-ebdc-aea1-b875-0966e48c29ee@acm.org>
Date:   Tue, 27 Jun 2023 12:53:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
Content-Language: en-US
To:     hoyoung seo <hy50.seo@samsung.com>
Cc:     Arthur.Simchaev@wdc.com, JBottomley@Parallels.com,
        adrian.hunter@intel.com, athierry@redhat.com, avri.altman@wdc.com,
        beanhuo@micron.com, jaegeuk@kernel.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        quic_asutoshd@quicinc.com, quic_ziqichen@quicinc.com,
        santoshsy@gmail.com, stanley.chu@mediatek.com, cpgs@samsung.com,
        sc.suh@samsung.com, kwmad.kim@samsung.com,
        kwangwon.min@samsung.com, sh425.lee@samsung.com
References: <CGME20230627012659epcas2p1961cc5bf75bf1a324f6f4fdebd7f897c@epcas2p1.samsung.com>
 <1891546521.01687833901791.JavaMail.epsvc@epcpadp3>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1891546521.01687833901791.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/26/23 18:26, hoyoung seo wrote:
> @@ -5408,7 +5406,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
>   	struct scsi_cmnd *cmd = lrbp->cmd;
>   
>   	scsi_dma_unmap(cmd);
> -	lrbp->cmd = NULL;	/* Mark the command as completed. */
>   	ufshcd_release(hba);
>   	ufshcd_clk_scaling_update_busy(hba);
>   }
> 
> Hi,
> Is there any reason to delete "lrbp->cmd = NULL"?
> As far as I know, clear to NULL to indicate that cmd is completed.
> 
> When the UFS MCQ mode is activated, check that lrbp->cmd is NULL to check the completion of the command.
> https://lore.kernel.org/linux-scsi/f0d923ee1f009f171a55c258d044e814ec0917ab.1685396241.git.quic_nguyenb@quicinc.com/
> 
> If there is no special reason, why don't you add "lrb->cmd = NULL" again?

The lrbp->cmd = NULL assignment has been removed because if it would be kept
the SCSI error handler would crash if it reuses a SCSI command. See also the
scsi_eh_prep_cmnd() and scsi_eh_restore_cmnd() callers. The MCQ code should
still work because it uses blk_mq_request_started() to check whether or not
a request is still active.

Bart.

