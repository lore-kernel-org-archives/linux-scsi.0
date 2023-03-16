Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5A7C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 00:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjCPACK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 20:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjCPACJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 20:02:09 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC8F1E1E0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 17:02:01 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id q14so157272pff.10
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2023 17:02:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924921;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iD+ln/YKzQPh0fxY/kRP9KyDCE6OgZXQw7AxbwcAvRQ=;
        b=QgcPU0XuCNhL2RUCNh5VRqSNqLaUWV6tGT3du5cPx/KI1mIVjtAY4PeSVm6sJYWUpx
         i9WIh4MOKqGLTRl0GeoX4LM3i5AHh21gZtRyMYs0FpYU4Dj3r0QsNT2ZJhUMHAO9oZ1p
         /XUsgdqpr5JJfPz7cJ+yIRAPsdtKYEv1Ee6KD4QDDWTbYfurrR6iqfgI6nrm3ptHjrv+
         KEaHENhI1an7ErD0DvyM53dulidIZAtbCUv32AM/9g6C0WOo3A4rGbwA7rYmnkcUdqtp
         b/COpdl7zvyofYcBrlh68eDVn5Wq5M8CamLFjSNwalM+8AG0nFbfDZmhSmMDJ9qMZJqo
         C0IQ==
X-Gm-Message-State: AO0yUKUhviRiebza5cKKKGQ7v/+mq4TVWRohwDMvHbddaCkW4Da8tqwU
        zj+o0S419JyL4RvT4h3ZexA=
X-Google-Smtp-Source: AK7set+piNSzsDcLvkNmLIXGJ55cG2VaFvU/KJsoKKgbe7y/rluTKfI0l+dehHDC41sQbAOWKoM7RQ==
X-Received: by 2002:a62:1856:0:b0:624:7fb:1c5b with SMTP id 83-20020a621856000000b0062407fb1c5bmr1256547pfy.1.1678924920778;
        Wed, 15 Mar 2023 17:02:00 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id k17-20020aa792d1000000b005a84ef49c63sm3998550pfa.214.2023.03.15.17.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:02:00 -0700 (PDT)
Message-ID: <993866eb-fead-5c97-1194-0b29ba43c597@acm.org>
Date:   Wed, 15 Mar 2023 17:01:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] scsi: ufs: core: Disable the reset settle delay
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
References: <20230314205822.313447-1-bvanassche@acm.org>
 <DM6PR04MB6575689FC234B87CD997F474FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <09ed808a-b697-37fc-8bec-c4da6be1382c@acm.org>
 <DM6PR04MB6575D6BA280BA7B4396D39F7FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575D6BA280BA7B4396D39F7FCBF9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 15:13, Avri Altman wrote:
> But aren’t we calling now scsi_report_bus_reset too soon?

Hi Avri,

I think that calling scsi_report_bus_reset() immediately after a host 
reset has finished is fine. My understanding is that the purpose of the 
reset settle delay is to prevent that commands get submitted to a SCSI 
device while it is not responsive. I'm not aware of a need to wait after 
a host reset has been submitted to a UFS device?

Thanks,

Bart.

