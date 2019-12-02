Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600DCC432C0
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 16:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D56A20722
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 16:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfLBQkV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 11:40:21 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46892 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbfLBQkV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Dec 2019 11:40:21 -0500
Received: by mail-pf1-f194.google.com with SMTP id y10so2804323pfm.13
        for <linux-scsi@vger.kernel.org>; Mon, 02 Dec 2019 08:40:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jOokgaHgNJdP0RFw/VCxJO7+KI6ztoXvjZjFxc+/eb8=;
        b=kkgVIdKr23G24mWXMRb2ijsJ/IUOwCfkz5DR0pxh70KbgqJavT6gXk8BaLwqdF8oFi
         9bmlH050ZKIem1Gn3HJ8pD5hNcAAk4SUhHV+yLbcmWLwKA/yxTieDuwO3DEmIGOpZ6qi
         iB987ujuT85S4rvXxdFr63goFAODyeaXGjOa7FnNuzlffrM3rDX5c390b6+WOv92GgRt
         F4ydb+dYMf1aGAEDAiDxLmNCiIr0bwguJEN7GclgpNLpNtNnqywIWkFfTXXKk0lHivSb
         o71Ci+I4p0/ff5iHn3GVvswihpsSdnN6WeHDGvheFqlAbfcXGNG4I/MKCDNiEX4iyPnH
         tMsg==
X-Gm-Message-State: APjAAAVgdLBZf33qy8XyYOD670FWwI3NT1cFAWNCYZE46XwBZ8jl6/gL
        9TyyF7I0t0urhNsctzERNDU=
X-Google-Smtp-Source: APXvYqzH2vOQ1mxti1OeJK289CESCdMMa47dW1KmjgnPNWt7BPnkxwFpCxLjD50wJBCHmM0rY5UCJA==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr52118254pfq.20.1575304820568;
        Mon, 02 Dec 2019 08:40:20 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 9sm26097885pfx.177.2019.12.02.08.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 08:40:18 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
Message-ID: <af903206-ce02-ef50-567f-d647efe0476a@acm.org>
Date:   Mon, 2 Dec 2019 08:40:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/19 3:28 AM, Roman Bolshakov wrote:
> On Fri, Nov 08, 2019 at 08:21:35PM -0800, Bart Van Assche wrote:
>> The commit mentioned in the subject breaks point-to-point mode for at least
>> the QLE2562 HBA. Restore point-to-point support by reverting that commit.
>>
>> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
>> Cc: Quinn Tran <qutran@marvell.com>
>> Cc: Himanshu Madhani <hmadhani@marvell.com>
>> Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value") > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/qla2xxx/qla_iocb.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
>> index b25f87ff8cde..cfd686fab1b1 100644
>> --- a/drivers/scsi/qla2xxx/qla_iocb.c
>> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
>> @@ -2656,10 +2656,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>>   	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
>>   	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
>>   	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
>> -	/* For SID the byte order is different than DID */
>> -	els_iocb->s_id[1] = vha->d_id.b.al_pa;
>> -	els_iocb->s_id[2] = vha->d_id.b.area;
>> -	els_iocb->s_id[0] = vha->d_id.b.domain;
>> +	els_iocb->s_id[0] = vha->d_id.b.al_pa;
>> +	els_iocb->s_id[1] = vha->d_id.b.area;
>> +	els_iocb->s_id[2] = vha->d_id.b.domain;
>>   
>>   	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
>>   		els_iocb->control_flags = 0;
> 
> The original commit definitely fixes P2P mode for QLE2700, the lowest
> byte is domain, followed by AL_PA, followed by area. However the
> fields are reserved in ELS IOCB for QLE2500, according to FW spec.
> 
> Perhaps we should have a switch here for 2500 and the other one for
> 2600/2700? Or, we should only set the fields only for QLE2700, to comply
> with both specs.

Hi Roman,

How about the patch below? Leaving out the els_iocb->s_id[] initialization
is not sufficient on 2500 series adapters to restore point-to-point mode.
The patch below works fine on my setup.

Thanks,

Bart.

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b25f87ff8cde..e2e91b3f2e65 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2656,10 +2656,16 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
  	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
  	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
  	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
-	/* For SID the byte order is different than DID */
-	els_iocb->s_id[1] = vha->d_id.b.al_pa;
-	els_iocb->s_id[2] = vha->d_id.b.area;
-	els_iocb->s_id[0] = vha->d_id.b.domain;
+	if (IS_QLA23XX(vha->hw) || IS_QLA24XX(vha->hw) || IS_QLA25XX(vha->hw)) {
+		els_iocb->s_id[0] = vha->d_id.b.al_pa;
+		els_iocb->s_id[1] = vha->d_id.b.area;
+		els_iocb->s_id[2] = vha->d_id.b.domain;
+	} else {
+		/* For SID the byte order is different than DID */
+		els_iocb->s_id[1] = vha->d_id.b.al_pa;
+		els_iocb->s_id[2] = vha->d_id.b.area;
+		els_iocb->s_id[0] = vha->d_id.b.domain;
+	}

  	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
  		els_iocb->control_flags = 0;
