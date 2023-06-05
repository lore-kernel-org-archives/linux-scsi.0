Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66211C7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjFEJsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjFEJsP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:48:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073E3DB;
        Mon,  5 Jun 2023 02:48:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C9561016;
        Mon,  5 Jun 2023 09:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2ECC433D2;
        Mon,  5 Jun 2023 09:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685958494;
        bh=bNtcEiOleZJYiqqAAKyzALyxBpljt67BJSNngawBfXc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Du3S44I+pAve46CR9aAgzPnVbLpcNjFWQXrk7gbVVJ5XlSnPWne+GfAKMHqq8Hed6
         LCbUNPA8DdVFnDc47KYktGjp/T7oHWWY/xU9uJKgdNS36+x5WKZjwjQR9C1urXBFf7
         +UknA9r+YFS9Ne9ll5XZASrUjj1udqVnJOdQpbxPbXoMEQmFwgP9goArwC0UU8h5eg
         TRLo75KO++JU0M0xK7psKjs9MgU8zxlspp8RpoLSUSB+B1Y1zqTbBONN2g/6VNzu2p
         v+uEWJKCuzg29ksv4VL1FBq89XrPUdRuePN1of+ZQG791Iv8mSGtNJI9woTQb4hhfp
         Fuzlcuyr4W4fg==
Message-ID: <52b11e92-0550-d6c7-6674-6d84a3622d40@kernel.org>
Date:   Mon, 5 Jun 2023 18:48:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
Content-Language: en-US
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-4-dlemoal@kernel.org>
 <7ccf4d9e-783a-1cec-ea94-81981a6976d1@gmail.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7ccf4d9e-783a-1cec-ea94-81981a6976d1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 18:47, Sergei Shtylyov wrote:
> On 6/5/23 4:32 AM, Damien Le Moal wrote:
> 
>> In ata_scsi_dev_config(), instead of hardconing the test to check if
> 
>    Again, hardcoding?

Yes... Square fingers today :)

> 
>> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
>> ata_ncq_supported().
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> [...]
> 
> MBR, Sergey

-- 
Damien Le Moal
Western Digital Research

