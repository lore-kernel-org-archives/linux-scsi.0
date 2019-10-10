Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF76C10F14
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 17:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D4112067B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 17:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfJJRDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Oct 2019 13:03:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44662 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJJRDc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2019 13:03:32 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so4274914pfn.11
        for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2019 10:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lbhz+CSR8apwS1DMP4BRjeSjwIkigapxZ4Vqn99GTj0=;
        b=nHBBQfnKyRpRd/99CNx9lPx49TSjJZLrvijSCcmYeQq0DmmvZXWfe9FmWfssiWwgBw
         SmnMctSlRIstCbcLS4HxUWHcpP7BlwTKbvTLAxMqFA2/s/F2MMOWMbb9qJK+rJO8dhXd
         HgjsLimTAPaCeCGOVaZHs5i7jEVCw75Qmn42HKLglkMaUCwMX3NGKE5CNavhn5gmB+3W
         IlRnL9M6AjLVZu/o4uzberpgUl9tzOy2kfZ1HVAtU+zdd9e7j3Ga6pVxLt9ZleJ49IOl
         6befOVQmO8vVAQpPlHXNtpxKHiRYoIeITn05DfF1Yo3WOiVZCa9kzWVXeK0FhMmPH9JD
         Mpkg==
X-Gm-Message-State: APjAAAXMampjI62Olb1gpPaDFrVhsyNp000F8DqseAyNDpAwCdxmqo2h
        Wk0oUqjkQBx+hkpfbU8fC8g=
X-Google-Smtp-Source: APXvYqzDxugGZ7OLCvFjbM9/g5Uxm9Q9sRn3JrGcmBui7gpMHbUv9m2QFJPZJycjhG3QtkwfOyVSAQ==
X-Received: by 2002:a17:90a:fa0d:: with SMTP id cm13mr12770370pjb.114.1570727011759;
        Thu, 10 Oct 2019 10:03:31 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l6sm5918710pje.28.2019.10.10.10.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2019 10:03:30 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: fix uninit-value access of variable sshdr
To:     zhengbin <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <1570709143-147364-1-git-send-email-zhengbin13@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fe58cc1c-f15a-2b05-24b7-24d9ef6f4f34@acm.org>
Date:   Thu, 10 Oct 2019 10:03:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1570709143-147364-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/19 5:05 AM, zhengbin wrote:
> kmsan report a warning in 5.1-rc4:
> 
> BUG: KMSAN: uninit-value in sr_get_events drivers/scsi/sr.c:207 [inline]
> BUG: KMSAN: uninit-value in sr_check_events+0x2cf/0x1090 drivers/scsi/sr.c:243
> CPU: 1 PID: 13858 Comm: syz-executor.0 Tainted: G    B             5.1.0-rc4+ #8
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x173/0x1d0 lib/dump_stack.c:113
>   kmsan_report+0x131/0x2a0 mm/kmsan/kmsan.c:619
>   __msan_warning+0x7a/0xf0 mm/kmsan/kmsan_instr.c:310
>   sr_get_events drivers/scsi/sr.c:207 [inline]
>   sr_check_events+0x2cf/0x1090 drivers/scsi/sr.c:243
> 
> The reason is as follows:
> sr_get_events
>    struct scsi_sense_hdr sshdr;  -->uninit
>    scsi_execute_req              -->If fail, will not set sshdr
>    scsi_sense_valid(&sshdr)      -->access sshdr
> 
> We can init sshdr in sr_get_events, but there have many callers of
> scsi_execute, scsi_execute_req, we have to troubleshoot all callers,
> the simpler way is init sshdr in __scsi_execute.
> 
> BTW: we can't just init sshdr->response_code, sr_do_ioctl use
> sshdr->sense_key(Need to troubleshoot all callers)
> 
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5447738..037fb2a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -255,6 +255,12 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   	struct scsi_request *rq;
>   	int ret = DRIVER_ERROR << 24;
> 
> +	/*
> +	 * need to initial sshdr to avoid uninit-value access
> +	 */
> +	if (sshdr)
> +		memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
> +
>   	req = blk_get_request(sdev->request_queue,
>   			data_direction == DMA_TO_DEVICE ?
>   			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);

 From SAM-5: "Sense data shall be made available by the logical unit if 
a command terminates with CHECK CONDITION status or other conditions 
(e.g., the processing of a REQUEST SENSE command). The format, content, 
and conditions under which sense data shall be prepared by the logical 
unit are as defined in this standard, SPC-4, the applicable command 
standard, and the applicable SCSI transport protocol standard."

Apparently sr_check_events() submits a GET EVENT STATUS NOTIFICATION 
command and it even evaluates the sense data if that command succeeded. 
I'm not aware of other scsi_execute() callers that do this. So I'm not 
sure that modifying __scsi_execute() is the best approach. I'm wondering 
whether the sr driver should be fixed instead of modifying __scsi_execute().

Thanks,

Bart.
