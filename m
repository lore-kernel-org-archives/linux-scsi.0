Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC8ECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F65320867
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:16:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaSR5sYe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505255AbfJYQQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:16:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55811 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390348AbfJYQQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 12:16:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id g24so2750937wmh.5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 09:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xEzoTshWx9LHG7n1pf+ZKj4XQNDPSyPSzUdAg8EzOuM=;
        b=VaSR5sYeQbzO2y7/VMe7w4rbNf4cihbM2NOXrpOXqNKHHwjkxHvVoMbGnfb3V9kSsI
         WhCyDQyh0K+s3j67791K56pC02EuQyC0M9x+K1ilakVMsurw7WQijyKixX7F87389aPB
         CENji9C9G5IM7JLQAi7nE0dVMZEezCX5IGQCxFBvVzDtHddI3OSYCtQ5PLs5jwxRyLKN
         7YDRT0MzXf490GuUd5kBOVjUveYRiCGp3/40AZDs0PmNqkXA80ULHhzAMGw6KymLcQUz
         dsYy92+Apwf8WWDVyZFg1bjQxtJhZaPD5ESCmxt0x3yOVDt+/AfG68dhfSqs/n1Chulm
         m0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xEzoTshWx9LHG7n1pf+ZKj4XQNDPSyPSzUdAg8EzOuM=;
        b=ZoJ8IoeFZnbJwWdvPYsI0Gfhfo85U59d8wmMhk0f79CWSDItcwIvfZ2tU7LoU9m1qY
         yfarVGNKFF/t5nwLCWizBCBbzPbq8gNUMbAPFeVPrO887ZPq0TjE8mYmV+fCKrlGguUE
         NmFyUT4bJyVIqUSiCVIaf21hLy5vPVOOuSHa/6iTRhmdLmk3gEIMggPUuRsMjeWQcF95
         HUEvrEh5jdRBTdS5iCYe3s/qnXMzgekY/JwShXGffNorLRMueoXxPju7nBIVoSHBdwuu
         6G1ui7bfTicqiaMO/kRkfkwGFynOdE1g2hgFQopfwOJW3k3JaSrLwjiw7yOWpC0g6rSl
         o+qQ==
X-Gm-Message-State: APjAAAUkD8SHRekJsDNSeubwhDO4g8NavGL8UD89OTWKVG3fMJpj1S/L
        G4dbOx43eirwHxX5WjidddU=
X-Google-Smtp-Source: APXvYqwRs29cTCDJX/Qj9b0zPr+sP6RUc/kFQZGbYqCKoahmZeaIEZNHdKd7IeDX5YMFaCGTb9q4yw==
X-Received: by 2002:a1c:3dc6:: with SMTP id k189mr4100932wma.145.1572020160358;
        Fri, 25 Oct 2019 09:16:00 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o70sm2825834wme.29.2019.10.25.09.15.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 09:15:59 -0700 (PDT)
Subject: Re: [PATCH 02/16] lpfc: Fix reporting of read-only fw error errors
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
 <20191018211832.7917-3-jsmart2021@gmail.com> <yq136fhd4ar.fsf@oracle.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1d3700c8-f020-b2e1-8caa-5c5694baafc0@gmail.com>
Date:   Fri, 25 Oct 2019 09:15:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <yq136fhd4ar.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/2019 6:03 PM, Martin K. Petersen wrote:
> 
> James,
> 
>>   	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
>>   	     magic_number != MAGIC_NUMER_G6) ||
>>   	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC &&
>> -	     magic_number != MAGIC_NUMER_G7))
>> +	     magic_number != MAGIC_NUMER_G7)) {
> 
> These magic numers[sic] caught my eye.
> 

I'll send a patch to fix the spelling errors

-- james

