Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590C3C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 17:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31FC520674
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 17:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cfbV5byo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfKYRGz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Nov 2019 12:06:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41025 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbfKYRGz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2019 12:06:55 -0500
Received: by mail-wr1-f65.google.com with SMTP id b18so19049431wrj.8
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2019 09:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RNvRQxee4dtfLcLBqplgGvU50XDLRTEsDB0Z2dLOzKs=;
        b=cfbV5byoqJMs1HLdxO2jZNB+eA77SX8qqZXWvqLcgobEEsP5i9sQ4+/xyOdA1om2Ai
         niYRTz2HZzkIzCW8zuyC3WMVaMUjf+JWADR188fsFF2Tm3HqON1L4smw5s20LMNwDxti
         XU8adf35/akimCM6sR7PCLhbXBolUTRAGzjIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RNvRQxee4dtfLcLBqplgGvU50XDLRTEsDB0Z2dLOzKs=;
        b=mz4S/f0Qrc0emkKg9J7BbYS5UeUK81We2DS9U0HjimruYRHfdhsUEbP4c6vrmbkljl
         ef0T9rpoaUw9aIR17NEEO403InTQZLhfOl2yYkUqjwRiaQYXN41RW3I/dCHHdsPlTSAx
         mLGKp2KsHIBsSifRDszqiuosjSV/TR3h+B9tdASV8gSq/qdoBtqzfleWyMi9ImKgf2Ca
         tMwkKUHA/oCElc34roEQXGSOmSVm6XZpEpzaMjsYGWSMSPx81XL6q19UkGILSAP26k6N
         HJSfsGaEjsVGcneO//BXU+N3ibN8kfQ+KZpkET7UvzfJg2gwCyzRL6m3cjMNNHfwpIzV
         zBXQ==
X-Gm-Message-State: APjAAAV1T5pjVZ1+J5YFET6kgKDWUsiGGZJGct8Di7wATINIC1QAJHQm
        KGR2c11oNXUGRMz2J+UPZ/lggg0FwAgStfwqp1rtSvWXeyVADzBBniAcvNHLul9B4wLw/sxPJtE
        FpK8rydsP5n5w6otO94WzjqwBOOxy5t4OeKsSTcXcxYpCqa/vGn4gHZ7v9Vyy1QNx8c+NNaEFN6
        va
X-Google-Smtp-Source: APXvYqzOCZM/dkAIhSThx5eaZEqoGEI1Xa6vyBOF3r2XGf3PcS2rIgFUZesdYcmljsb6KAX8mRI9RQ==
X-Received: by 2002:adf:e707:: with SMTP id c7mr10290651wrm.218.1574701613354;
        Mon, 25 Nov 2019 09:06:53 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w7sm10756262wru.62.2019.11.25.09.06.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Nov 2019 09:06:52 -0800 (PST)
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org
References: <20191105080855.16881-1-dwagner@suse.de>
 <yq1h838pivf.fsf@oracle.com> <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
 <4a1fedc9-03f1-7312-fd50-a041a78c0294@broadcom.com>
 <20191119181435.taxa56wbf4zd4f2f@beryllium.lan>
 <44cc15adc190fb1f6f89cbb8478aadda35f6b1e2.camel@redhat.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <d9c8974a-ba64-afb7-983c-f344d6981e9d@broadcom.com>
Date:   Mon, 25 Nov 2019 09:06:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <44cc15adc190fb1f6f89cbb8478aadda35f6b1e2.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/2019 8:40 AM, Ewan D. Milne wrote:
> [ removed linux-kernel from cc: ]
>
> We may have hit the same issue in testing, we're looking at it.
>
> -Ewan
>

Make sure you have this patch in your testing (from 12.6.0.0 patch set):

scsi: lpfc: Fix bad ndlp ptr in xri aborted handling
commit 324e1c402069e8d277d2a2b18ce40bde1265b96a

-- james

