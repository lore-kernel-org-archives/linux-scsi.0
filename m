Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA68ECA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F28721D81
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2qeWKYp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfJYWr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 18:47:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38307 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfJYWr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 18:47:27 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so3421027wms.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 15:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HHXZ/2SKuT1BhU/znDVYmT7Hu5JQN4gFzkw2ue0Y6t0=;
        b=l2qeWKYp9lcWx9NQgRbDys5P/h/kQL+tQK2jwc87eEquV9ZKoXnfY1JirxmxD4uT/T
         w3arEj3jkJGPouHOOf+U2zJee1mn4LwTt01IK6Ld5BtnDaOceZuhNpwyOS5WMbS/XbW3
         Gp0sUkb9AdW/zO6HV3uLS08ELtX35+7p3yPKZ/q0Us8Ozy8agAcQ3UWUK4RYYezmHfBo
         X0N1WzAK9T9XWGHg7xwpbjBx+FVyOSrcPIIs1eAChhXvPPJtiIIziblwkazU53Dxm5nE
         i0ngK5KsXOipcSP/hldKt8IPrpvnj0n3xfkCgtWVJ0wfDaSmiufsC+F2HfTcyxL2pKzU
         65YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HHXZ/2SKuT1BhU/znDVYmT7Hu5JQN4gFzkw2ue0Y6t0=;
        b=Eo7KzZeeWSwT/x/znVUfLjpBz33KDY1EOS+YwChapxZLU/3svjZsKutLcAt1vegPxd
         Ss5LHnngnVh2KZEzGUM2fM9hoa/QZ3LigsByQ0kYplZufXKEeLBFxR5DZwoe+sPBWzW+
         bhCgik5H8K8H/tPh+EwzX3WELmT2YD2vMXtVaDFiYfU6VHvRKHbz8BVcRKXXUnbqREs/
         gSYp15izJRG+P+ROMkdssEGSCP1nJBHlhU5h/xXJImYH4rj7DduMfTzGLp5RJxQwrosW
         m4+/kw6YVboXjEY41VV6cevXrQ3klSKYBGZ7ZInycqqvXQt+ZAvmDpbCfZGGUDA1sIAe
         A7kg==
X-Gm-Message-State: APjAAAUltF4DUjuO+CAgih4EFLrj5E14WnWXjCLi8WqNwepqMrDdm39/
        nrsswlbeS6njTO4HuNDwSSo=
X-Google-Smtp-Source: APXvYqzd4WZ0/YBNW144TmHKJjbadiaWgwcBDaZtRDxEY/JKfhkMwjFn7BOJ6yhC17hkaYQm2+iRHw==
X-Received: by 2002:a7b:c302:: with SMTP id k2mr5629218wmj.81.1572043645563;
        Fri, 25 Oct 2019 15:47:25 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q11sm3135198wmq.21.2019.10.25.15.47.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 15:47:25 -0700 (PDT)
Subject: Re: [PATCH 31/32] elx: efct: Add Makefile and Kconfig for efct driver
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-32-jsmart2021@gmail.com>
 <20191025155529.xglrsp3tmctvvguw@beryllium.lan>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <b9fbb131-9574-b9cf-27e7-82ce5202ed1b@gmail.com>
Date:   Fri, 25 Oct 2019 15:47:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025155529.xglrsp3tmctvvguw@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/2019 8:55 AM, Daniel Wagner wrote:
>> diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
>> new file mode 100644
>> index 000000000000..3d25d8463c48
>> --- /dev/null
>> +++ b/drivers/scsi/elx/Kconfig
>> @@ -0,0 +1,8 @@
>> +config SCSI_EFCT
>> +	tristate "Emulex Fibre Channel Target"
>> +	depends on PCI && SCSI
>> +	depends on SCSI_FC_ATTRS
> 
> Is TARGET_ISCSI missing?


I think we missed 'TARGET_CORE', will fix that in the next version.

-- James and Ram
