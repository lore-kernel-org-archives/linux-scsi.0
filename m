Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D7EC61DA4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Feb 2023 15:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbjBCPfA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Feb 2023 10:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbjBCPez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2023 10:34:55 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88DC6CC87
        for <linux-scsi@vger.kernel.org>; Fri,  3 Feb 2023 07:34:52 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id k8-20020a05600c1c8800b003dc57ea0dfeso6299548wms.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Feb 2023 07:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O+uNCL6ZUju9IqY/nPsC1hroJXk9iy9d8UOj3Tlrt3o=;
        b=Le5YTKmNlOAiGW8xsrJPi3ImQA4MjM0towWwAODKVaI4Xo81to1Askk2dR2azYM75x
         +91N1maI3gouD1k086QU+UUSsgD/buNd6yMbRqW8ji3EcPih8r7skr5dvnSP/NhK9JE5
         meH6QL1wfVm56GrzZMvOsAJiDcneH7nz3zosZYmMCOF5+1kLobcjOTvxuDJe1vrmHnyK
         2V6RmkF6rgAo648Xhb8FpvjUIOUoH22sOVfisZw7jZmj55AAu7b0i4sle7x0i1x56bzL
         OWEJbW41nu0hpbsUApgg28L9O1I5lHRZVnFqSLIQBlGHbnwp3QUdC2JnPrd2tIuiXOR/
         GR7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O+uNCL6ZUju9IqY/nPsC1hroJXk9iy9d8UOj3Tlrt3o=;
        b=y3wFu5mI3AbEnhz7KbNjPGYUscn6yOVxEH2ZmvDC6HGY8Pvw9F9woKcMvogr5oreN3
         chTx69KXDBree2x5pZnnioMwKnA/ZkypijU0DR8WMi99BGKfd07H1f7HJia1wK1CiNbd
         STh0TTaD9/Z0OkuTcdwoEDdfFMo46kvsejsDi2Ow9bYFi11YijSwaZMA261WSnszy5r0
         8ecRnyx7N5l/bFr2jbNkS9fWqJUWziIMCcf19QbOqBB3ISoOzQvw2U7yZ1hPePgRaWfb
         MfQW4cHPV1akwsEpkIREx8oy0qS0LVqdM0xZNnqga410Gc6SCdEjswjyasUpp82JYLCC
         XATg==
X-Gm-Message-State: AO0yUKXG6UE4uYPq9h9263Y9QMlRpht/TF1RMty2QVw/JhxJhAvtQckp
        zZJmB7g0Y2BSiaJqJ2j5iTc=
X-Google-Smtp-Source: AK7set/AYYbQGEcW0HnsaX2N9nOWwT6gIN27J9q7yo6nj9H/FxF/05P5Ty3WfGblqDzUe7RNX4lt9Q==
X-Received: by 2002:a1c:f413:0:b0:3dd:b0b3:811b with SMTP id z19-20020a1cf413000000b003ddb0b3811bmr9891705wma.31.1675438491260;
        Fri, 03 Feb 2023 07:34:51 -0800 (PST)
Received: from ?IPV6:2003:c5:8709:6a68:dcfc:3ca1:303e:b509? (p200300c587096a68dcfc3ca1303eb509.dip0.t-ipconnect.de. [2003:c5:8709:6a68:dcfc:3ca1:303e:b509])
        by smtp.gmail.com with ESMTPSA id bh1-20020a05600005c100b002bff7caa1c2sm2358072wrb.0.2023.02.03.07.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 07:34:50 -0800 (PST)
Message-ID: <6c8d1ba0-2f51-34e0-62bd-6c7b04734a6c@gmail.com>
Date:   Fri, 3 Feb 2023 16:34:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS
 devices
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
References: <20230202220041.560919-1-bvanassche@acm.org>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230202220041.560919-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

To this series patch:


Reviewed-by: Bean Huo <beanhuo@micron.com>


Thanks,

Bean

