Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3A3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 07:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiBOHie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 02:38:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiBOHid (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 02:38:33 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D451D119870
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 23:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644910704; x=1676446704;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mOGFBW7aguOed/dN3nAvwpwLuVIGedkjSKb7cLhQ7fU=;
  b=DT3QDoF9POcBZEIOMhXAC9o8rwWBckPd/veAiMkPswfb8KkVf/Iudx0Q
   ETgW0PXESJ+aQ5kEUy4ArmwySrGlQAW3wJsfwc7ajtG8oX3VvtIFvjtgf
   LcpJbhmpzHgbqCbOSJ8CCpKEp+Bo7EzbWt4mFcPWT6bab/xwpU7CQiaT4
   TxzWT27dOtGgGBf0AxzS6osSSDBKjIRTVhOwMGTxOqcBaEbX85e07LgfV
   bxGUurMXzooq/mjwAaNWX0dhRbSWYztFKRVK2RXX8lnTTCD8XsPXdS3ah
   MMKsHUl7HVpWd7tPDMDkQR6XHTkbY6h8cs7QV15kQSLuvkwiRAZmuP6Rh
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,370,1635177600"; 
   d="scan'208";a="193959917"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2022 15:38:23 +0800
IronPort-SDR: 1q0O/qcizW2DpQ3OFNRtZgWVlJhYvdzaRMHB8hpN8o0sHXpFYIBrA1l96ZvDxnSprlXpB1emxu
 L2UCjehmV4WEd5XRXkI5rfT9lPUQc6aQc9Un9bb/QSXnoAu0vh3fjyYnKhCgzXfwo6/ITKWztU
 yuh/KGopNl4HQ64cKJbvYSfnBbugCS+WceX5cmgR6Qt7hynuOXwdSExGirHjI7EsJm37ZUL80Q
 rFYY1l3G8ki/ldAe5UJMtmnRo8rM6MHSgPw0F8320msigSYpnDzyVaACVUhEzr8VstBVMd0KwE
 duca0B7+TFkjCXIfFeb9HCj3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 23:10:04 -0800
IronPort-SDR: eglbDkhCZ6r/aZ+GRZjq9bBCb/jWSynX5264f/kqMtLPZYUSOBlgHn1xjPll4jGvO5Mi8yJpc/
 UU1LMj4ltaJ14leaffkjxm7c17AIIGO6U1emvb97dM0yu1jTkZUDmGakZVnGGsRmDCQy90WZlw
 MjUpHEXJg3lEcDUAA7O8WG6erqzMod/09YWHVp66aqf7h3qvAF28zOTGMFGYNeu6M5gfPrhrNW
 xMfemZoMCR8YUM1GvdMUa0kCR8IYe+dB5fLB3YjwsStPmF6pkFmR1m4EWRrfDyYWj1mlkBVE78
 s9Y=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 23:38:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JyXy64w9tz1SVp1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 23:38:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644910702; x=1647502703; bh=mOGFBW7aguOed/dN3nAvwpwLuVIGedkjSKb
        7cLhQ7fU=; b=RngAnXjuQp71d/WtLNsOT0kyC8P18u8kvYfWyTX4+h4EANomyRN
        plalWjKckt/kUR61KHI3oxRpSAzDFY2FRPaYgMw8X/BL1K5Zjqh5YYOAVUeaNuEQ
        c/IZfjZlpYxEQGI2h5DEVB+Uw68VspLCgKpyIVJFJj+BKwZ8LGUMDP9EMIHwmEcQ
        n0nG4HR368K8v9ZkZXxqto2yIidDKV5Da4HdnodjHD3+VRGOY4JVNfvqSloGccp1
        /BoloEPvQCRhX4/DIkSnn7clD1s1DTyf5ySBfL55ZPgNdlQYXfvN/TQZxmo3NshG
        bV0rJTnrgQiqyp9zz6sHClbrt1Oa65YjjYg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UMAmPeQ8d3PD for <linux-scsi@vger.kernel.org>;
        Mon, 14 Feb 2022 23:38:22 -0800 (PST)
Received: from [10.225.163.73] (unknown [10.225.163.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JyXy52P75z1Rwrw;
        Mon, 14 Feb 2022 23:38:21 -0800 (PST)
Message-ID: <95d50cb3-bea3-2288-5fb1-0ac10314ac1f@opensource.wdc.com>
Date:   Tue, 15 Feb 2022 16:38:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/31] libsas and pm8001 fixes
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <f14056ab-56a3-0d44-fd51-5a6386c60e03@opensource.wdc.com>
 <yq1ee44n7ni.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1ee44n7ni.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/22 12:18, Martin K. Petersen wrote:
> 
> Hi Damien!
> 
>> Note that there is a conflict between 5.18/scsi-staging and 5.17-rc3/4
>> in the pm8001 driver. And I need to touch rc3/rc4 code too. Could you
>> rebase scsi-staging ?
> 
> I pulled in 5.17/scsi-fixes and fixed up the conflicts.

Thanks !

> I suggest you merge your -rc of choice when testing. That's what I do if
> the baseline kernel has problems on my lab systems.

That is what I normally do, but for some reason, this time, I kept
ending up with a non working kernel...
I must have done something very wrong :)



-- 
Damien Le Moal
Western Digital Research
