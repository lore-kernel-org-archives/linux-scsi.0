Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D7ACD37B0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Sep 2023 02:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjIPCdm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 22:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbjIPCdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 22:33:31 -0400
X-Greylist: delayed 513 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Sep 2023 19:33:26 PDT
Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4513F7
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 19:33:26 -0700 (PDT)
Received: by sphereful.davidgow.net (Postfix, from userid 119)
        id 2F1C11D5836; Sat, 16 Sep 2023 10:24:49 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
        s=201606; t=1694831089;
        bh=jBpVTCxi4sGh7+c3O2f5gZuyUZzB9wdHYZRzW/WXyAU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OpphjgZzhzHyr3Crj6khajzLxN+TiXabNevBXe7vSofNYvm4xPXegrtFt5B7yHavH
         jUnFhFNZv8VD1AwFXYiaGnscbwLoJWemZoPOvOVieYJjDyOTw2UitTlfiVXnaAnnFi
         iuh0GgnrqXM/up3r2DOwtVgvSE3W1mNHiNjv7titPTeobri2OT4o2Ud0PcJiSYDxch
         PJ9QmyAFXBJDyXbHxMNKM3K95dD3TKLzA+0tE1NFbuFe/rcvTVvuEgVFPOp27r+uhh
         G9LFuBLMOGll6urdG/FMSMjNkiYdJZ6YTVZIHDrfsWrN0nKiqmKOVjh1hYFQTMESiC
         zcEDBXWJ3WUpM9rd9BX9Lz5FjJjhsqKfOjhNqhogOYnsNm1ZKW0I9bqmGpHstdg9bN
         ZxndE8WvaujI66Y2RLHkPpGhM5Ev0IcpmPBpq0pY2adW2SL/RWZTjx9uaTpIL6HeOI
         WjYhvMesBIo3d8chYBwYA7AC9MtSIT3uv3lF/EWQxr6MQaoyeT1JJu2TWasP8Y104G
         UbLrwdmwC3YPQBdW8n0QFezSEdIfDsIPySCIaFQRBqqBODejKM3XQJ+azH2/Wo4g/G
         lk3YXDY+iqccyUBscwuN6maJzvJ+kvvPVR+7TmUbQ7lsiJVVZn0J6UccsrC2Eg4Sb/
         C2fw7holStSgvYAPzpmgk+SE=
Received: from [IPV6:2001:8003:8824:9e00::bec] (unknown [IPv6:2001:8003:8824:9e00::bec])
        by sphereful.davidgow.net (Postfix) with ESMTPSA id 191D41D580B;
        Sat, 16 Sep 2023 10:24:48 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
        s=201606; t=1694831088;
        bh=jBpVTCxi4sGh7+c3O2f5gZuyUZzB9wdHYZRzW/WXyAU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sXstOT1J99zKLsG934V4UP+cvHIHY/WK54b2w+pZQ+2wpgfCzzZKTwtZ0jWdVRQbn
         Y/lclgR8cA8I4vVPlohvFMUel/T6vOeqB5LSM91dOKB5ApPGhep1JJCdkIiu5huSHg
         Uon1Qbgg2ChAkg6kDe6vrFAuiYvzGCsH7/55ttZ/Q7Yzq1OjkzsLSYmlWcr69iAnWo
         IO8NIC7O+qExTlb5Xmje0We5F41GANKizo+hsKnyrGAsrGQEYdB5fGEUwgVwZ8I4w5
         qjc7NcDo/cqLFWpgbO+FjTwy3YUQjkhyDo0dCa3m9oV+LESzig+4kgXp+r6ydlQHBk
         iV+xkrOf+R1iXwZZYghD7Ro+Rk5O+oSVrzlzueyEUu7qgAOiCLpMgsAKU+1gSyy90R
         HDdxgbOpGuj/GAgGvaJDLeAFcsk99Mq4597SyKuk6CJscRjl9cSppGvXsNn3Xbxvd7
         82ALJTKpLX1CRnIhNS76Bg1AW8WeUShjY1Znd95IqIGr4aXjef7+IykNaHb5H+Ofph
         QGjEJB6ltRooa2Pr5K8OLgbD77V2rcxp7dc1MV/z9c3Ioxql2RzXEnD+hOmcbCAl8Z
         zhjngmj4BeKIerfF6bZ86aOI04seKdlT9nayxWnWZGZwjxxvYvtFQwzEZhTpSW0uqZ
         5eEZmZnlaedbXL0JNg+VrJwI=
Message-ID: <50423b13-9814-47eb-b3ee-a4ef074c3e9a@davidgow.net>
Date:   Sat, 16 Sep 2023 10:24:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Do no try to probe for CDL on old drives
Content-Language: fr
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>
References: <20230915022034.678121-1-dlemoal@kernel.org>
From:   David Gow <david@davidgow.net>
In-Reply-To: <20230915022034.678121-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 2023/09/15 à 10:20, Damien Le Moal a écrit :
> Some old drives (e.g. an Ultra320 SCSI disk as reported by John) do not
> seem to execute MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
> commands correctly and hang when a non-zero service action is specified
> (one command format with service action case in scsi_report_opcode()).
> 
> Currently, CDL probing with scsi_cdl_check_cmd() is the only caller
> using a non zero service action for scsi_report_opcode(). To avoid
> issues with these old drives, do not attempt CDL probe if the device
> reports support for an SPC version lower than 5 (CDL was introduced in
> SPC-5). To keep things working with ATA devices which probe for the CDL
> T2A and T2B pages introduced with SPC-6, modify ata_scsiop_inq_std() to
> claim SPC-6 version compatibility for ATA drives supporting CDL.
> 
> SPC-6 standard version number is defined as Dh (= 13) in SPC-6 r09. Fix
> scsi_probe_lun() to correctly capture this value by changing the bit
> mask for the second byte of the INQUIRY response from 0x7 to 0xf.
> include/scsi/scsi.h is modified to add the definition SCSI_SPC_6 with
> the value 14 (Dh + 1). The missing definitions for the SCSI_SPC_4 and
> SCSI_SPC_5 versions are also added.
> 
> Reported-by: John David Anglin <dave.anglin@bell.net>
> Fixes: 624885209f31 ("scsi: core: Detect support for command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

This fixes the log spam I was seeing on a Marvell 88SE9230, which had 
looked like this:
[    1.744094] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.744368] ata14.00: configured for UDMA/66

It now just gets configured the once at boot, as it did before the CDL 
patch.

Tested-by: David Gow <david@davidgow.net>

Thanks a lot,
-- David

