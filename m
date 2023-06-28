Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476CEEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 22:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjF1WyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 18:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjF1WyJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 18:54:09 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD6C13D
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 15:54:07 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-668704a5b5bso86607b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 15:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687992847; x=1690584847;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BTk6uHJsXbO0KxSQAvx3j8Bics1KsDk9lTJCSirmYls=;
        b=YB0XOykqRX/8z1dkRD0EG6ePRPtTM8xpkQ+e4c5Qm0hV/tb4JVB7y/IbbPHO/WLorh
         xRYonr6dIySco0bGmkaVG5WjdyGVzvOLsIc8congg/saaO8rXEbPGzNbckEfWiq9Nh6k
         SV/EowUlLZEscU8bobtz6dXfZ9Gzs2IG0s7fxFWWoAe2V075krr98jvnNVmwTZJVh0pE
         5B55iDotrrX3niz4zyQ0E88CKtQR4ruqoNrtfzQjB+wkglklZl3b3vpXhAmNvATVh75v
         221ZMu4eE8DyJ4OTXc/kTf6wdnaeWypJz149Zt17A4VCKF6o8trKJSKDIzejYqXXxHWc
         Kkaw==
X-Gm-Message-State: AC+VfDyTpnHcZkR+YRyEhoL95eANtMNoSa40vQsbRQ2OsM7IrBZyEReO
        U8Pxc00pSMwJdk0D+8Q1+6nIoUXAwek=
X-Google-Smtp-Source: ACHHUZ64WPKOQ1pLX8hiB9s5XZKIwW4MEd2zJ8QSl9Kkr9y89sqRpR8xW9SwRZsb/iHxsrc/wFhmAQ==
X-Received: by 2002:a05:6a00:1a13:b0:679:fc52:1eae with SMTP id g19-20020a056a001a1300b00679fc521eaemr10410100pfv.19.1687992847070;
        Wed, 28 Jun 2023 15:54:07 -0700 (PDT)
Received: from [192.168.50.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id x16-20020a056a00271000b0067459e92801sm6042264pfv.64.2023.06.28.15.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 15:54:06 -0700 (PDT)
Message-ID: <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
Date:   Wed, 28 Jun 2023 15:54:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC] Support for Write-and-Verify only drives
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_Rozsny=c3=b3?= <daniel@rozsnyo.com>,
        linux-scsi@vger.kernel.org
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/26/23 13:35, Daniel Rozsnyó wrote:
>     There are some drives, or more precisely - normal drives with a 
> custom firmware, that simply reject a regular Write - likely as not 
> being good enough for the intended high-rel application - which I can 
> understand, but even after reformatting the drive to no-PI and going to 
> "poor" 512B sector size, they still refuse to do an easy Write 
> operation. I had verified that by using the sg_write_verify (that uses 
> an ioctl) I can really write data to these drives. The reading path is 
> working okay and both dd and hdparm works at expected speeds.

To me the above sounds like the drive firmware is broken. Please fix the 
drive firmware and make sure that WRITE commands are accepted.

Thanks,

Bart.

