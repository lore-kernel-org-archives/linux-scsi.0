Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89435C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 04:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54BCE22202
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 04:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbhAAEqI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Dec 2020 23:46:08 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43472 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbhAAEqH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Dec 2020 23:46:07 -0500
Received: by mail-pf1-f176.google.com with SMTP id c12so12066354pfo.10;
        Thu, 31 Dec 2020 20:45:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cLh/wvoUGF9NsKGsYRBg++GRTONNYVlDU9PdKF5jRao=;
        b=t0TzzWYUBRw04m3Zdixn3QQV+EXLnB+Hji1gVy6hc13SUgj3JOSB+bO9PmE3J3dOp2
         1Hy2Ysr0AD/GYvQxBiiv8vOe3vHHr/pAuF5TGqdyUpobRRmgXzZJoKRz0vgDCaNrQM+a
         iI0vJqr8PA8rIG4Dhhs5Yd5AnbV/I/K0XcJdL2IzCe0mATd4Q7YJWEHNkaWW3f+j7tNl
         qSRsSwrot8Ci8RWienNVYdUuxieJH/KHQybBYfzOjm/dvEOq7ZpyAWAR/twc6JwMwqOr
         yF/DvU62YNVO3Z+HICHt287ZU0NqHXx7EMpdIOQ0jP20Wqb1crNpKYJAVNBVaam4cKfZ
         tjNQ==
X-Gm-Message-State: AOAM533jUVZ7WhQGk/wIOF5nwc6dSCpPYMqxfJk+gXwpiRYNY8KO21V1
        xv9MEELGR0zjuiqu1OV7rpm1vGQ1xjE=
X-Google-Smtp-Source: ABdhPJyXp0vekbbMGmEnEBWmsSFRpj4wDqHLVndmexdkUbWu6UbDPYjyb8tYJsjz/2C6mdfzAGGQfA==
X-Received: by 2002:a63:da58:: with SMTP id l24mr58586526pgj.178.1609476326776;
        Thu, 31 Dec 2020 20:45:26 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i184sm48369500pfe.126.2020.12.31.20.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Dec 2020 20:45:25 -0800 (PST)
Subject: Re: [PATCH 3/7] tcm qlaxx: move sess cmd list/lock to driver
To:     Mike Christie <michael.christie@oracle.com>,
        himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
 <1603666998-8086-4-git-send-email-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8d94c626-78e4-ed8c-d077-4add314f789c@acm.org>
Date:   Thu, 31 Dec 2020 20:45:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1603666998-8086-4-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/20 4:03 PM, Mike Christie wrote:
> @@ -617,25 +629,20 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
>  static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
>      uint64_t tag)
>  {
> -	struct qla_tgt_cmd *cmd = NULL;
> -	struct se_cmd *secmd;
> +	struct qla_tgt_cmd *cmd;
>  	unsigned long flags;
>  
>  	if (!sess->se_sess)
>  		return NULL;
>  
> -	spin_lock_irqsave(&sess->se_sess->sess_cmd_lock, flags);
> -	list_for_each_entry(secmd, &sess->se_sess->sess_cmd_list, se_cmd_list) {
> -		/* skip task management functions, including tmr->task_cmd */
> -		if (secmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
> -			continue;
> -
> -		if (secmd->tag == tag) {
> -			cmd = container_of(secmd, struct qla_tgt_cmd, se_cmd);
> -			break;
> -		}
> +	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
> +	list_for_each_entry(cmd, &sess->sess_cmd_list, sess_cmd_list) {
> +		if (cmd->se_cmd.tag == tag)
> +			goto done;
>  	}
> -	spin_unlock_irqrestore(&sess->se_sess->sess_cmd_lock, flags);
> +	cmd = NULL;
> +done:
> +	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
>  
>  	return cmd;
>  }

Hi Mike,

Although this behavior has not been introduced by your patch: what prevents
that the command found by tcm_qla2xxx_find_cmd_by_tag() disappears after
sess_cmd_lock has been unlocked and before the caller uses the qla_tgt_cmd
pointer? As you may know the corresponding code in SCST increments the SCSI
command reference count before unlocking the lock that protects the command
list. See also the __scst_find_cmd_by_tag() call in scst_mgmt_cmd_init().

Thanks,

Bart.
