Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F225EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 13:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjF2Npj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jun 2023 09:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjF2Npi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2023 09:45:38 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA261FE7
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2023 06:45:37 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b7fb1a82c4so4553135ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2023 06:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688046337; x=1690638337;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVCVuuF6cTxfDRrgBY+4rg0HQf71yVKvVaewu7cREDM=;
        b=B47NLIBSdQxixbGRm0TJOgroAy7CNEcoq17pUvSeE0F+ZX7+AcayhhCNUyC/a9m86+
         2fCWDzOyp2TgmX7btPE417bPkW6TWip+EfESy1moqD3DeRH6cFv+dl3/+l+ONEqpkZTw
         Jcs0oA2Bf0L0IYWNathbvN8Xb3DiJ3K4ecg4m1eA+p/VHGI+pgQ1jTbwMEY8CsDetgIi
         XLrH04fyG0Lxlj1Rve/Ge68XSgosfIa6/9qyRzQd1gw6aZGhpwt2Bam2F63KbYEOFzaa
         VukLG9x69eNYFOuARYcRMpFSY26fXkBc6fTzsugt+4WL58axh6UyEgQgSHN1xXskOXFs
         VhVA==
X-Gm-Message-State: AC+VfDzGYdw2qQBfBMJkxo8PYR4ufMZv36ALizwL175kWUQpbRyMWLy2
        jdvYZuPN/AEb1l5A6/rZasHedno26Lo=
X-Google-Smtp-Source: ACHHUZ4gXJiTAfS2PqsnsmDzkawCaeLOVb9tneqm+3VD7oQIl0oP2r0MOkuYL+g/grhozC+hOMSjNQ==
X-Received: by 2002:a17:903:11ce:b0:1a6:74f6:fa92 with SMTP id q14-20020a17090311ce00b001a674f6fa92mr14841716plh.19.1688046336529;
        Thu, 29 Jun 2023 06:45:36 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id ep11-20020a17090ae64b00b0025bcf8aca8csm9318037pjb.26.2023.06.29.06.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 06:45:35 -0700 (PDT)
Message-ID: <b303cb23-efe9-004b-a054-02124d876620@acm.org>
Date:   Thu, 29 Jun 2023 06:45:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC] Support for Write-and-Verify only drives
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>,
        linux-scsi@vger.kernel.org
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
 <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
 <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/23 16:40, Daniel Rozsnyó wrote:
> (IRONY ON) If your approach is so "simple" - could you just "simply" ban 
> from Linux a complete lineup of 2 major hard drive vendors (Seagate, 
> HGST), until they do fix my particular firmware? Sure we do not want to 
> support these incompetent drive makers that ship drives with a 
> potentially "broken" fw. (IRONY OFF)

If a technology is considered too crazy, support is not added in the 
Linux kernel.

How common are hard disks that accept the WRITE AND VERIFY command but 
not the WRITE command? And how are these sold to users? Which arguments 
do drive vendors use to convince users to buy drives that are not 
supported by the Linux kernel?

Thanks,

Bart.
