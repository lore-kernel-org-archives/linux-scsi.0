Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117D3EE3F0E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbjIKUvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbjIKKPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 06:15:05 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078DCE5F;
        Mon, 11 Sep 2023 03:15:01 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-502a4f33440so3805175e87.1;
        Mon, 11 Sep 2023 03:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694427299; x=1695032099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UHCnoccZNiz4HQ8Bo9b1jZ414TiCPpgUdOpHpw/rPXw=;
        b=c1Sq9ZgjSYTJXSXnjb/fXBWFdtviDwrR/xxzraHb5Qe3mkeVZ4y6gqiugdFn2DmrfK
         3hXeC4A0Gv9jVyIh1AVqFhQ5LPLvTbQ940omt9msE7CXyJx9gRXS7vyBqWA6UbnbDl0N
         rLHZ/J+TpzIBUs5IAfVML3N4SI2YdcdFHUeZboEJ2Cu0POOzV7HgweiitgZ9DzX8J/5m
         0izqa9YWkHL8rCBz7/KY1ZKvDJFdO14deqziDGdJmxPoAhLU+lwOJNe7DEsFWXgR+Opn
         jeMNblwWtYVdAn+7dblPH1O789ul+ZXSw+9gPjUDD8Cja5V9vbQyFpsO2LV22oPhitLa
         GQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694427299; x=1695032099;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UHCnoccZNiz4HQ8Bo9b1jZ414TiCPpgUdOpHpw/rPXw=;
        b=TfWn3VyQVF6fuL61Fp6w4HBL0+FDuBwYSroTIAzLXSD/1OBlXrzJKnA/Do41MY9YQD
         T2fXJ0B7bcxjdX+pFOwZwphFdoxIGzvssDGo9T6OywZSDoHB1Yc6tTYitr8AEIjt5sky
         SOkAvzrxa9wXJ4hmHYqH02YERjduGxW0oD3F1KhwIWckHqaaheTTljxqN5/LN7LPngrc
         Kjv9GkAg6HmK9HAF3sNLbG+sBRUpgGm/H/FGqRDL2qAh6Je8nQKE9Z70SyZPaXMJ+GcE
         Cg+FEnWhF73y+tfOmcXKVKIaERwy83AGsxbqEiqvhCyO7h3qU+ZFBFlvSOiUvRJYCE01
         pndA==
X-Gm-Message-State: AOJu0YxmSl+MIaRlQdJAcL7Ul+7oIXs7e/bQTxGCmQIXRrnggq5Geff3
        9IZ9ITrfcCO5JsjA5MDfaE0=
X-Google-Smtp-Source: AGHT+IEBzImGafYSjy+sKGHiF/inpe78xQ3N0eED9tvnQyipiObNqw+8hKQHd3OOq3uiMbbz8quuUQ==
X-Received: by 2002:a19:ca18:0:b0:4f8:62a6:8b2 with SMTP id a24-20020a19ca18000000b004f862a608b2mr6380933lfg.46.1694427298875;
        Mon, 11 Sep 2023 03:14:58 -0700 (PDT)
Received: from [192.168.1.103] ([178.176.75.0])
        by smtp.gmail.com with ESMTPSA id q1-20020a19a401000000b005009c4ba3f0sm1291041lfc.72.2023.09.11.03.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 03:14:58 -0700 (PDT)
Subject: Re: [PATCH 18/19] ata: libata-eh: Reduce "disable device" message
 verbosity
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-19-dlemoal@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <3df11a20-bd80-304b-0a78-9875fa1a9e9b@gmail.com>
Date:   Mon, 11 Sep 2023 13:14:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20230911040217.253905-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 9/11/23 7:02 AM, Damien Le Moal wrote:

> There is no point in warning about a device being diabled when we expect

   Disabled. :-)

> it to be, that is, on suspend, shutdown or when detaching a device.
> Suppress this message for these cases by introducing the EH static
> function ata_eh_dev_disable() and by using it in ata_eh_unload() and
> ata_eh_detach_dev(). ata_dev_disable() code is modified to call this new
> function after printing the "disable device" message.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[...]

MBR, Sergey
