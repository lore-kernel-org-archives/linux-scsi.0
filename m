Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25239C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEB492072E
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 23:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="S7xbLXfU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFYXmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgFYXmU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2020 19:42:20 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC33C08C5C1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:42:20 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id z5so4102007pgb.6
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 16:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=wFGbPV7kbz54dfKkl1t7LePnDXNy9twV34+98CeS1D4=;
        b=S7xbLXfUmYP51fd1Sdp3LUuSiM5c3oH7/d4IL//sjOauUVpjmGpxwkGJqPrH6XY/rs
         AlhbhggkBSUC+Ztq+e4F/yaVL0UM5JD0r0gFdTPjLYozR+laREAsmqxmrGY6XBx0FY7x
         E7uuiwRbmyPL3X4lLeBgds/dJAUaYjZF1t9GQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wFGbPV7kbz54dfKkl1t7LePnDXNy9twV34+98CeS1D4=;
        b=cxsAb1Bx4orytGnoOsyy8YniivjO/ZUs7w77oHlW7Fw0sXvZXPIDgiD9bkP3fK/DoY
         FDCcdcGzRV6WZMImxUzKjnWZBOYid3FAfstI32Ln/AYu7419rUELBpYFnf/y2HEUtd2j
         B8zUSQDU483wrJsIM6yZue6kazL6U46KcGQz/Bo05L6vlp6lVTVRn9DPodDdHVFr+xsZ
         0M0s+PHD1CqouSsDSzJFfFmtYQahnWm/ycLWW+PMxAzRJ1xMaoISwIdfim32vVR0yM/s
         HQwRIwrmT2tZZg+TiOlo+gV4KzeFInTW6LTr7/SEz/EqiTWg81XadaymN/9V//SEU5O0
         hBHw==
X-Gm-Message-State: AOAM53088PM6sVFN0YpZMO6RATGgM2AZA9RnUXzYPH3EP/FRJnyU7FxL
        BBIdEdPbN30Y17OG334WdeR53UD4zBk=
X-Google-Smtp-Source: ABdhPJy2gqJdQeulGccbPTn7D5Gbqi4sWbdHe21+SlOtCF9RjBT0akSDHVZu7JWN93oCzxRN0wFcFQ==
X-Received: by 2002:a63:757:: with SMTP id 84mr273313pgh.275.1593128539550;
        Thu, 25 Jun 2020 16:42:19 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a12sm9376067pjw.35.2020.06.25.16.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 16:42:18 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] qla2xxx: SAN congestion management(SCM)
 implementation.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200610141509.10616-1-njavali@marvell.com>
 <20200610141509.10616-3-njavali@marvell.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <e67a451f-06df-22c9-d82c-2e7b62261902@broadcom.com>
Date:   Thu, 25 Jun 2020 16:42:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610141509.10616-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 6/10/2020 7:15 AM, Nilesh Javali wrote:
> From: Shyam Sundar <ssundar@marvell.com>
>
> * Firmware Initialization with SCM enabled based on NVRAM setting and
>    firmware support (About Firmware).
> * Enable PUREX and add support for fabric performance impact
>    notification(FPIN) handling.
> * Allocate a default purex item for each vha, to handle memory
>    allocation failures in ISR.
>
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
>

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

