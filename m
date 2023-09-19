Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8C9CE79AA
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 21:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjISVFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 17:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbjISVFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 17:05:41 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDDBBD
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 14:05:35 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-68fe2470d81so5656767b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 14:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695157533; x=1695762333;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgBB05n36btIzETYigi7p7iBwjqISBa5M+RNZqYO8nk=;
        b=fj0ZtpylpGhIkhxIq4G7VE9SykswJ2VBilCg5eIbRFGjdbscYEIBmZYuEoYqG/66HO
         xPLBgYj8mKOJtpeXZuBbKu9on/kft4SJ+MJexrSLbf4FSTZ3lUdZpYmC2DUJNe+2CeL+
         lUldUegfG99QyEMeNayrWpE5GPNzUfEsdGhPL0xzBvDfriw3nY7YQ9df4s2AvbY8sBZq
         2+0wNuLSdNLg54Du0losSe2B8iefRQvBLQW+GXffL1A09OqWcECsKrL5saAODGyyxBqV
         VuQFN/jiP9iXvLcGzoQBesj0y2ETopAYQwvZ31KG9EjfOEdHkr5RHcuUfTXteLJHblWh
         laOQ==
X-Gm-Message-State: AOJu0YyPtz5mEiWvFqJIWVNztaEieox1OddFm20ysJ51gmbQDis7nFGA
        ZgpGSfqg8pIRXjCPQwVnjZ8=
X-Google-Smtp-Source: AGHT+IHBY9jiYMKMIY750z5fRmPmYLPEzqGgp5qk1FtISQBrg3YBuzBrgwinVPTNoSQWRep+xYoLwQ==
X-Received: by 2002:a05:6a20:4414:b0:149:122b:6330 with SMTP id ce20-20020a056a20441400b00149122b6330mr830075pzb.10.1695157532756;
        Tue, 19 Sep 2023 14:05:32 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dc54:7e62:ea3c:d7a8? ([2620:15c:211:201:dc54:7e62:ea3c:d7a8])
        by smtp.gmail.com with ESMTPSA id u12-20020aa7848c000000b00689f1ce7dacsm1121020pfn.23.2023.09.19.14.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 14:05:32 -0700 (PDT)
Message-ID: <f5b226ac-71ad-4826-8191-862f9a6e90ee@acm.org>
Date:   Tue, 19 Sep 2023 14:05:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: Set the Command Priority (CP) flag for RT
 requests
Content-Language: en-US
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230918162058.1562033-1-bvanassche@acm.org>
 <20230918162058.1562033-5-bvanassche@acm.org>
 <DM6PR04MB6575255764CC491B595F86BCFCFAA@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575255764CC491B595F86BCFCFAA@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/23 11:37, Avri Altman wrote:
> Bart Van Assche wrote:
>> Make the UFS device execute realtime (RT) requests before other
>> requests. This will be used in Android to reduce the I/O latency of
>> the foreground app.
>
> Maybe one more sentence, explaining that ufs CP is agnostic to scsi
> CDL, And can be implemented regardless.

Hmm ... is it really necessary to add a reference to CDL in the patch
description? I'm not aware of any UFS devices that support CDL.
Additionally, if CDL will ever be supported then I think that
ufshcd_comp_scsi_upiu() should be modified such that it selects a 
duration limit instead of setting the CP bit.

Thanks,

Bart.
