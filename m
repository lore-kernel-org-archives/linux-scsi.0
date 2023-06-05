Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0E5C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjFEJrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjFEJrO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:47:14 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC9FEA;
        Mon,  5 Jun 2023 02:47:09 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so5698302e87.3;
        Mon, 05 Jun 2023 02:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685958428; x=1688550428;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rBNwkYQzKR8/jV4Jvz1JLisxXlpfDmjj/f7H7v7PDqI=;
        b=ahfnds9DZZJYcGGPGtFF1VSPjuAVSwhUEdl+GKrQq1dv+0ca8TJMIto9aGzvFRlynX
         /fUt2EkUa1OtQyBKncOaK14Z+iBvHSrPZbZMMLCvzjwmp21MhetJdBYSlPatoS8IzCJc
         tTQY4C6RGr0EsdZ+7dVXxBh/z1oYTgq54KFazaMSCX37lqdCq7/kuCQp0hoMUIV4yez4
         VN0OxEkEX0r5GMUQ22QW/L+1KflI7UkwGIPIxYEOQAH+izzAzq+Uw4WHUpt9+6/yZmkX
         vbaNjc8DlIRN1jZO4qp8CnOn5SgNDUoe0R9w9k+n3EvI0ZjFyB+qfsY4Gjldz5VeZVgO
         imQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685958428; x=1688550428;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rBNwkYQzKR8/jV4Jvz1JLisxXlpfDmjj/f7H7v7PDqI=;
        b=hyB4Vx53KUHG9zGfd+qERVE1ey/nkpB8oobrRRI010bBZkjCyD0cNdCfvSTQ1WoWRw
         qYmYiiUwQPgoiDJW3J3tPsSGiZsUndR9rIRriU/bCmTywJ+OLH2Yx1EzbGu56xod4eDt
         bv6Uw82fqyupBt5tM8X5GTLRxWMy9Wn4BD7mAQrSEQCm88GlMAlONPbF5DQ4OVpT2v+o
         gsSfuLPWP/89FUkDE/c3GLrHULQgUwrC2G+HPQEEH4Xm5mPW8acTeRF9GEUujVtUz0cH
         cm5tF+IceGUxlRNBBRVfDG8wK7bm1Np5xMJB1mESsHcTrdg0m3TrN1rz5ubW4w6+D32Z
         vxNw==
X-Gm-Message-State: AC+VfDxiT581TVRUwZZcpjsjlHRxZ0NXZDw9++HexwTYpPsySM3oBcNk
        vmIVwvURqKsh/XqAOIVZSRI=
X-Google-Smtp-Source: ACHHUZ73H1zVfeYhxBSMYLEFuxX9cqkyCoyPHhgiS74Z65/DwXLCTbuAJe6BrI98J9vPbRlwWB70DQ==
X-Received: by 2002:ac2:4a9d:0:b0:4f4:ca64:3c9d with SMTP id l29-20020ac24a9d000000b004f4ca643c9dmr5220158lfp.54.1685958427497;
        Mon, 05 Jun 2023 02:47:07 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.85.227])
        by smtp.gmail.com with ESMTPSA id r10-20020a19ac4a000000b004f3b4a9a616sm1063852lfc.177.2023.06.05.02.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:47:06 -0700 (PDT)
Subject: Re: [PATCH 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-4-dlemoal@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <7ccf4d9e-783a-1cec-ea94-81981a6976d1@gmail.com>
Date:   Mon, 5 Jun 2023 12:47:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20230605013212.573489-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 4:32 AM, Damien Le Moal wrote:

> In ata_scsi_dev_config(), instead of hardconing the test to check if

   Again, hardcoding?

> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
> ata_ncq_supported().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[...]

MBR, Sergey
