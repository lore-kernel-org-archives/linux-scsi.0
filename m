Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0659CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B778D2084B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfJUQhw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:37:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34973 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfJUQhw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 12:37:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id c8so3318994pgb.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2019 09:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gOutXIxd6gu3qApLn7/xvZyJ82D/0dOXSVxtFVuHrsI=;
        b=Ykjyi1FCVhB18LuoYmxT7MmplXQ5Ma3ABqo3G3cv6adf9gp04LvpofnuOcb7+3oDu1
         2KDd813ginEoEDguryxhVoophHSWNO2h4sAMjviJ3/aQBkJTmNXheB8QpH1qU+5nPpf/
         AiCDZeRGEHWm87LbPUyZMb5Tqkme2huQhz3gpWnmmyA0rX7ME3hjEF5mz79bHlhqJGz6
         IPm2Ov7jZx8ftXSs8Is2jDm5BW2Y6oYZekIa1I1okTBAomBtyTUIi1TaMWoiMbcs3wZb
         fXvl8N1nSKSqJ0pJk0NEOHTSscIwM7hnNl6YS/FyamGTrHAtL5ri5lhzUD8DPdnpoQBS
         JLeA==
X-Gm-Message-State: APjAAAXtczqWfbloiu/gIEtIYcn0ApFcGeMfpfk9iatdzN8qd0Yonfkc
        mmijj4GwBaejsGiS36JgM6nTVS/p/0I=
X-Google-Smtp-Source: APXvYqyR0NCz9jD3Rci3BuKIjQG+YP/ypU6W8xmAACE43eWk4YRCwVrMFQKm6M2EEhmUKUdo4WKriA==
X-Received: by 2002:a63:5b1d:: with SMTP id p29mr11525932pgb.209.1571675870936;
        Mon, 21 Oct 2019 09:37:50 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p9sm15964727pfn.115.2019.10.21.09.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 09:37:50 -0700 (PDT)
Subject: Re: [PATCH 11/24] advansys: kill driver_defined status byte accessors
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-12-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6e710e3c-1812-4a4d-f9d5-671161db261a@acm.org>
Date:   Mon, 21 Oct 2019 09:37:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021095322.137969-12-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/19 2:53 AM, Hannes Reinecke wrote:
> @@ -6021,43 +6015,28 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
>   				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
>   				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
>   						  SCSI_SENSE_BUFFERSIZE);
> -				/*
> -				 * Note: The 'status_byte()' macro used by
> -				 * target drivers defined in scsi.h shifts the
> -				 * status byte returned by host drivers right
> -				 * by 1 bit.  This is why target drivers also
> -				 * use right shifted status byte definitions.
> -				 * For instance target drivers use
> -				 * CHECK_CONDITION, defined to 0x1, instead of
> -				 * the SCSI defined check condition value of
> -				 * 0x2. Host drivers are supposed to return
> -				 * the status byte as it is defined by SCSI.
> -				 */
> -				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
> -				    STATUS_BYTE(scsiqp->scsi_status);
> -			} else {
> -				scp->result = STATUS_BYTE(scsiqp->scsi_status);
>   			}
> +			scp->result = status_byte(scsiqp->scsi_status);
>   			break;

Did you really want to delete the code that sets DRIVER_SENSE?

> @@ -6789,47 +6768,30 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
>   				ASC_DBG(2, "SAM_STAT_CHECK_CONDITION\n");
>   				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
>   						  SCSI_SENSE_BUFFERSIZE);
> -				/*
> -				 * Note: The 'status_byte()' macro used by
> -				 * target drivers defined in scsi.h shifts the
> -				 * status byte returned by host drivers right
> -				 * by 1 bit.  This is why target drivers also
> -				 * use right shifted status byte definitions.
> -				 * For instance target drivers use
> -				 * CHECK_CONDITION, defined to 0x1, instead of
> -				 * the SCSI defined check condition value of
> -				 * 0x2. Host drivers are supposed to return
> -				 * the status byte as it is defined by SCSI.
> -				 */
> -				scp->result = DRIVER_BYTE(DRIVER_SENSE) |
> -				    STATUS_BYTE(qdonep->d3.scsi_stat);
> -			} else {
> -				scp->result = STATUS_BYTE(qdonep->d3.scsi_stat);
>   			}
> +			scp->result = status_byte(qdonep->d3.scsi_stat);
>   			break;

Same comment here: did you really want to delete the code that sets DRIVER_SENSE?

Thanks,

Bart.
