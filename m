Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50C4C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 03:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A334060FD7
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 03:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhJIEAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 00:00:19 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:35832 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJIEAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2021 00:00:17 -0400
Received: by mail-pg1-f172.google.com with SMTP id e7so4988342pgk.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 Oct 2021 20:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JPjs3hNx0aAYhyrZ44XQ6X2sIlbXEJ3ybRlP0rOxS6I=;
        b=1loN5d4bC0fbo2z9sHX3czziu6nP6BbjztXtncSQUNnIvDZI6ra+CDrYUI8L+WObhJ
         5qbOVgPXUzub42n6eljmMsS3hnA4SgusOiRZfVas98AEOsaEWDL9hGefgJGLxbgf4f9u
         tINK02zsasNkJKj78Y2Kjju+bJei4s9KRTg9EvU9qInJGxO/1j6rnijovqj3G9pWAjbq
         8m7Ju4yDvcx9JMo8FbCplFVFIg1F/NcMnytNE8rRha7jnBh7CKFAyOOg2ZX1/vH94y5P
         wR5THucSytsxWErkix78GIuILPvuMNS+QIvskS0FclWVgOeOOX7PFnRyo++7D56rUPCg
         trAg==
X-Gm-Message-State: AOAM533QlJ6SE2RjSOz6Z4GCJTXVZi+SDeMqYqAS5j1clUbs4Ow6Gc/L
        yD/m9/dqhs1WgMIWBepY5wR5UZQXdka/TA==
X-Google-Smtp-Source: ABdhPJx5QxLoMaFXhlZ0r1ZrA+kWHHwx8p8HVEPOyS4m/4iQ0JUhMT4oJq3tP8IIwYL6ljkdcReUDQ==
X-Received: by 2002:a63:4d56:: with SMTP id n22mr7970579pgl.414.1633751900433;
        Fri, 08 Oct 2021 20:58:20 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:8688:1df5:6f09:f79c? ([2601:647:4000:d7:8688:1df5:6f09:f79c])
        by smtp.gmail.com with ESMTPSA id n66sm683576pfn.142.2021.10.08.20.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 20:58:19 -0700 (PDT)
Message-ID: <526271c5-a745-7666-6b18-9eb61898f1db@acm.org>
Date:   Fri, 8 Oct 2021 20:58:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Content-Language: en-US
To:     Yanling Song <songyl@ramaxel.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20210930034752.248781-1-songyl@ramaxel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210930034752.248781-1-songyl@ramaxel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/21 20:47, Yanling Song wrote:
> +#define dev_log_dbg(dev, fmt, ...)	do { \
> +	if (unlikely(log_debug_switch))	\
> +		dev_info(dev, "[%s] [%d] " fmt,	\
> +			__func__, __LINE__, ##__VA_ARGS__);	\
> +} while (0)

Please use pr_debug() instead of introducing dev_log_dbg().

> +static inline
> +struct spraid_admin_request *spraid_admin_req(struct request *req)
> +{
> +	return blk_mq_rq_to_pdu(req);
> +}

Please read the section with the title "The inline disease" in 
Documentation/process/coding-style.rst.

> +static inline bool spraid_is_rw_scmd(struct scsi_cmnd *scmd)
> +{
> +	switch (scmd->cmnd[0]) {
> +	case READ_6:
> +	case READ_10:
> +	case READ_12:
> +	case READ_16:
> +	case READ_32:
> +	case WRITE_6:
> +	case WRITE_10:
> +	case WRITE_12:
> +	case WRITE_16:
> +	case WRITE_32:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}

Please use op_is_write() instead of reimplementing it.

> +	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
> +		rw->opcode = SPRAID_CMD_WRITE;
> +	} else if (scmd->sc_data_direction == DMA_FROM_DEVICE) {
> +		rw->opcode = SPRAID_CMD_READ;
> +	} else {
> +		dev_err(hdev->dev, "Invalid IO for unsupported data direction: %d\n",
> +			scmd->sc_data_direction);
> +		WARN_ON(1);
> +	}
> +
> +	/* 6-byte READ(0x08) or WRITE(0x0A) cdb */
> +	if (scmd->cmd_len == 6) {
> +		datalength = (u32)(scmd->cmnd[4] == 0 ?
> +				IO_6_DEFAULT_TX_LEN : scmd->cmnd[4]);
> +		start_lba_lo = ((u32)scmd->cmnd[1] << 16) |
> +				((u32)scmd->cmnd[2] << 8) | (u32)scmd->cmnd[3];
> +
> +		start_lba_lo &= 0x1FFFFF;
> +	}
> +
> +	/* 10-byte READ(0x28) or WRITE(0x2A) cdb */
> +	else if (scmd->cmd_len == 10) {
> +		datalength = (u32)scmd->cmnd[8] | ((u32)scmd->cmnd[7] << 8);
> +		start_lba_lo = ((u32)scmd->cmnd[2] << 24) |
> +				((u32)scmd->cmnd[3] << 16) |
> +				((u32)scmd->cmnd[4] << 8) | (u32)scmd->cmnd[5];
> +
> +		if (scmd->cmnd[1] & FUA_MASK)
> +			control |= SPRAID_RW_FUA;
> +	}
> +
> +	/* 12-byte READ(0xA8) or WRITE(0xAA) cdb */
> +	else if (scmd->cmd_len == 12) {
> +		datalength = ((u32)scmd->cmnd[6] << 24) |
> +				((u32)scmd->cmnd[7] << 16) |
> +				((u32)scmd->cmnd[8] << 8) | (u32)scmd->cmnd[9];
> +		start_lba_lo = ((u32)scmd->cmnd[2] << 24) |
> +				((u32)scmd->cmnd[3] << 16) |
> +				((u32)scmd->cmnd[4] << 8) | (u32)scmd->cmnd[5];
> +
> +		if (scmd->cmnd[1] & FUA_MASK)
> +			control |= SPRAID_RW_FUA;
> +	}
> +	/* 16-byte READ(0x88) or WRITE(0x8A) cdb */
> +	else if (scmd->cmd_len == 16) {
> +		datalength = ((u32)scmd->cmnd[10] << 24) |
> +			((u32)scmd->cmnd[11] << 16) |
> +			((u32)scmd->cmnd[12] << 8) | (u32)scmd->cmnd[13];
> +		start_lba_lo = ((u32)scmd->cmnd[6] << 24) |
> +			((u32)scmd->cmnd[7] << 16) |
> +			((u32)scmd->cmnd[8] << 8) | (u32)scmd->cmnd[9];
> +		start_lba_hi = ((u32)scmd->cmnd[2] << 24) |
> +			((u32)scmd->cmnd[3] << 16) |
> +			((u32)scmd->cmnd[4] << 8) | (u32)scmd->cmnd[5];
> +
> +		if (scmd->cmnd[1] & FUA_MASK)
> +			control |= SPRAID_RW_FUA;
> +	}
> +	/* 32-byte READ(0x88) or WRITE(0x8A) cdb */
> +	else if (scmd->cmd_len == 32) {
> +		datalength = ((u32)scmd->cmnd[28] << 24) |
> +			((u32)scmd->cmnd[29] << 16) |
> +			((u32)scmd->cmnd[30] << 8) | (u32)scmd->cmnd[31];
> +		start_lba_lo = ((u32)scmd->cmnd[16] << 24) |
> +			((u32)scmd->cmnd[17] << 16) |
> +			((u32)scmd->cmnd[18] << 8) | (u32)scmd->cmnd[19];
> +		start_lba_hi = ((u32)scmd->cmnd[12] << 24) |
> +			((u32)scmd->cmnd[13] << 16) |
> +			((u32)scmd->cmnd[14] << 8) | (u32)scmd->cmnd[15];
> +
> +		if (scmd->cmnd[10] & FUA_MASK)
> +			control |= SPRAID_RW_FUA;
> +	}

Please remove all of the above code and use blk_rq_pos(), 
blk_rq_sectors() and rq->cmd_flags & REQ_FUA instead.

> +	spraid_wq = alloc_workqueue("spraid-wq", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
> +	if (!spraid_wq)
> +		return -ENOMEM;

Why does this driver create a workqueue? Why is system_wq not good enough?

Thanks,

Bart.
