Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF5FC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:32:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1F564E7E
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 17:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbhBIRcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhBIRcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 12:32:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C3DC061756;
        Tue,  9 Feb 2021 09:31:43 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id a9so33026676ejr.2;
        Tue, 09 Feb 2021 09:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YxqzVUIoGY1EiccgIinS8fn5LuzwhQtJ2femBLCArsQ=;
        b=EbBQ4/B30cRzldPk3XJ/AGM6Kpm2YtOFHg7z6hVMtSprWZ6QHz0zh91TX24lk2dRDj
         DxUtuDT3VAOWnTzKPWYV3X6oXNNRjeSSZyE+TTWDJsymLtVpz3wS0gC+VXJ2ZtqwW9mO
         iynhBL4hmrt0bhBsySyKM6nfLJg3uQYjmFfYa1/LNafLYTmtZxsuUaAkvXP6alWm/EI6
         sZdXFoOnvJFPWAATYIQwtVf+fhZWgmll+mYtAF+OYDcZP/EPFmqLQcOIp4dColoMwXtQ
         Ly3shiLNbF62fJs6Wby5VtqyEKU/BDNvPhcFqd/+NQtpXKy2K/75XYI8uhdkICfUBtDq
         Mo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YxqzVUIoGY1EiccgIinS8fn5LuzwhQtJ2femBLCArsQ=;
        b=USm3N0tebNzw3elPFRnJgj2usSTVEs09M6Cmy3MFSfNxkCuBWIs5XnOlgtrOwUI8qp
         WKj8d406JTgG70qb8JLF9Q8zpXc39fu8h5dcVjWboRD/PpSVvVb0TMVp5rN8RuirIm8U
         fhdJ9UEUo5vv39Ztg1WMZWsh4xlnUTyWg6WVLVgz6uy0Ag37pb1NKLo6DYu1BRTyX1Wb
         DM0OkTi7b3KK1Jv6nmt1NZPfTfK1u7kOUE8sPDsi4GXSAOXGr6pyMccRwZSiLn7TIHX/
         Y5h01KnsFQQsEWCaRcCr2wDsF59e57wKmJqQWt92ErtBUveFEZh/YD7upGQZsZUDH8V5
         ASng==
X-Gm-Message-State: AOAM530u509a5wcDLRQMZ9nZwIqvHhmwc50tXyJ1QoAZKM61kZ8d3zKj
        BatQ1GRr0xQ1rt+VoK4NMqA=
X-Google-Smtp-Source: ABdhPJwrMaQ4nHcoCMEZ/j44lrq/E174cg7+Et54dgIDKj7XOT5RNOKc4U/AAAkJZVZNXu04xs2YkA==
X-Received: by 2002:a17:906:a00e:: with SMTP id p14mr23691423ejy.532.1612891901959;
        Tue, 09 Feb 2021 09:31:41 -0800 (PST)
Received: from [192.168.178.40] (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id b25sm10218049ejz.100.2021.02.09.09.31.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 09:31:41 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: target: core: Prevent underflow for service
 actions
To:     a.miloserdov@yadro.com, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        r.bolshakov@yadro.com
References: <20210209072202.41154-1-a.miloserdov@yadro.com>
 <20210209072202.41154-3-a.miloserdov@yadro.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <c3fa3f9e-78bb-7d42-25d9-9569bd09cdca@gmail.com>
Date:   Tue, 9 Feb 2021 18:31:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210209072202.41154-3-a.miloserdov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09.02.21 08:22, Aleksandr Miloserdov wrote:
> TCM buffer length doesn't necessarily equal 8 + ADDITIONAL LENGTH which
> might be considered an underflow in case of Data-In size being greater than
> 8 + ADDITIONAL LENGTH. So truncate buffer length to prevent underflow.
> 
> Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>   drivers/target/target_core_pr.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 14db5e568f22..a13140e95b47 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3739,6 +3739,7 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
>   	spin_unlock(&dev->t10_pr.registration_lock);
>   
>   	put_unaligned_be32(add_len, &buf[4]);
> +	target_set_cmd_data_length(cmd, 8 + add_len);
>   
>   	transport_kunmap_data_sg(cmd);
>   
> @@ -3757,7 +3758,7 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
>   	struct t10_pr_registration *pr_reg;
>   	unsigned char *buf;
>   	u64 pr_res_key;
> -	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
> +	u32 add_len = 0;
>   
>   	if (cmd->data_length < 8) {
>   		pr_err("PRIN SA READ_RESERVATIONS SCSI Data Length: %u"
> @@ -3775,8 +3776,9 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
>   	pr_reg = dev->dev_pr_res_holder;
>   	if (pr_reg) {
>   		/*
> -		 * Set the hardcoded Additional Length
> +		 * Set the Additional Length to 16 when a reservation is held
>   		 */
> +		add_len = 16;
>   		put_unaligned_be32(add_len, &buf[4]);
>   
>   		if (cmd->data_length < 22)
> @@ -3812,6 +3814,8 @@ core_scsi3_pri_read_reservation(struct se_cmd *cmd)
>   			  (pr_reg->pr_res_type & 0x0f);
>   	}
>   
> +	target_set_cmd_data_length(cmd, 8 + add_len);
> +
>   err:
>   	spin_unlock(&dev->dev_reservation_lock);
>   	transport_kunmap_data_sg(cmd);
> @@ -3830,7 +3834,7 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
>   	struct se_device *dev = cmd->se_dev;
>   	struct t10_reservation *pr_tmpl = &dev->t10_pr;
>   	unsigned char *buf;
> -	u16 add_len = 8; /* Hardcoded to 8. */
> +	u16 len = 8; /* Hardcoded to 8. */
>   
>   	if (cmd->data_length < 6) {
>   		pr_err("PRIN SA REPORT_CAPABILITIES SCSI Data Length:"
> @@ -3842,7 +3846,7 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
>   	if (!buf)
>   		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>   
> -	put_unaligned_be16(add_len, &buf[0]);
> +	put_unaligned_be16(len, &buf[0]);
>   	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
>   	buf[2] |= 0x08; /* SIP_C: Specify Initiator Ports Capable bit */
>   	buf[2] |= 0x04; /* ATP_C: All Target Ports Capable bit */
> @@ -3871,6 +3875,8 @@ core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
>   	buf[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
>   	buf[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
>   
> +	target_set_cmd_data_length(cmd, len);
> +
>   	transport_kunmap_data_sg(cmd);
>   
>   	return 0;
> @@ -4031,6 +4037,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
>   	 * Set ADDITIONAL_LENGTH
>   	 */
>   	put_unaligned_be32(add_len, &buf[4]);
> +	target_set_cmd_data_length(cmd, 8 + add_len);
>   
>   	transport_kunmap_data_sg(cmd);
>   
> 


Looks ok to me.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
