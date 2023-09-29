Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23208E728D2
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Sep 2023 17:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbjI2Rpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Sep 2023 13:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjI2Rpt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2023 13:45:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84145195
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 10:45:47 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1c3f97f2239so129798195ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2023 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696009546; x=1696614346; darn=vger.kernel.org;
        h=content-language:content-transfer-encoding:mime-version:user-agent
         :date:message-id:subject:to:from:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7q/Ocr/LuKL/ulDcDi15T1xKwBX0O06v5b0Uc8oaurk=;
        b=nMUlIomJEUM9ckK1u/Wod46oX2tGGNcA0PqHA62LLTuM9wW90Z7viJEzaZ1+v9FO6D
         iFDcwAYEX2RTLK1nBuT38xbPuDlJALVITYwbno1MURgE4eNfD4APoiOCdnlg19xm3Rof
         aikOQDC/FJ/9yI/PEC+W6H2ERYd+8tg/WuudbNl88MY9Mj1xkECPW0mD+ODWdr1uppaS
         /P0YyXCKYXOVAOd0Qt/B2KnMO8oNaNhMq75yuRPDLxBgyAzcGCOUBApgkW9uZDdZjFmG
         rIBy0adF5QKWlTaCfn73wsUeKxHUu1sxFR3iwHujsHmJmZ8PLzMrOepiRfz35OHtCSW/
         hgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696009546; x=1696614346;
        h=content-language:content-transfer-encoding:mime-version:user-agent
         :date:message-id:subject:to:from:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7q/Ocr/LuKL/ulDcDi15T1xKwBX0O06v5b0Uc8oaurk=;
        b=kHQLrv8bgFZSL5luBazDH9GTv4xwI0MGbWDxfy+tzS4AcFe2iH2uj4PHZt8OivitEJ
         NYVp+GpLC9o/TSTNk3VvPuuTPI+gWfPSnQL4tUp3vc9TjS7j87rWrT/6dS9UmIVQ/2Wn
         ILGhh6ToYEPHdWjy7uOKdR31ag3Hw1qZOROfpPGieYw+/irCGCb/yLEnuxnUtqYOFuPZ
         JaC7ji0YX1OBuCCCt5lAN6lkXCWItn5TNKNv83GfiZJYQrZVpc/g05bnpqxe8b17sTyJ
         9DcHFLypbYK/BeH17A/dPT45IyV/EGBLCNiGY4b/j+k1fymQaBq087BtE794m01G45tY
         hMmw==
X-Gm-Message-State: AOJu0YyIL06TLl1KX6M+YKRq06cvmrY+fEgFS2o1H+JScLxK71J6FA60
        NVcRn7EgTERS64rbBC4AhnjA1nE7xhGvdQ==
X-Google-Smtp-Source: AGHT+IHgLll+vnOohZuDIdElwi+ehvRx5KZ72AiwRTn7Z1W5Y2u/Nj2QbAxL0ggxr9mCoIbXf6MASw==
X-Received: by 2002:a17:90a:68ce:b0:25e:a8ab:9157 with SMTP id q14-20020a17090a68ce00b0025ea8ab9157mr4442210pjj.22.1696009546672;
        Fri, 29 Sep 2023 10:45:46 -0700 (PDT)
Received: from [192.168.43.79] ([47.15.3.9])
        by smtp.gmail.com with ESMTPSA id 6-20020a17090a1a0600b00263dfe9b972sm1944359pjk.0.2023.09.29.10.45.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Sep 2023 10:45:46 -0700 (PDT)
Reply-To: businesssolutionsrocks23@gmail.com
From:   Noor Bano <noorbano3685@gmail.com>
To:     linux-scsi@vger.kernel.org
Subject: RE: Meeting request
Message-ID: <6bdcceba-ef72-39a5-b744-7ca085a0f0d6@gmail.com>
Date:   Fri, 29 Sep 2023 23:15:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Circling back on my previous email if you have a requirement for Mobile 
App OR Web App Development service.

Can we schedule a quick call for Tuesday (3rd october) or Wednesday (4th 
October)?

Please suggest a suitable time based on your availability. Please share 
your contact information to connect.

Best Regards,
Noor Bano

On Tuesday 22 August 2023 5:43 PM, Noor Bano wrote:


Hi

We are a Software development company creating solutions for many 
industries across all over the world.

We follow the latest development approaches and technologies to build 
web applications that meet your requirements.

Our development teams only use modern and scalable technologies to 
deliver a mobile or web application the way you mean it.

Can we have a quick call to discuss if we can be of some assistance to 
you? Please share your phone number to reach you.

Thanks & Regards,
Noor Bano
