Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FE5E7D0AC
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 19:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjIUTFS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbjIUTE4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 15:04:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEB67C710;
        Thu, 21 Sep 2023 10:36:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACC8C433C8;
        Thu, 21 Sep 2023 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695317471;
        bh=KdlhnRMy4NCtw2GSjbw/OHbLqgjhrzK8JvzZD2l0+hk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=e3iF32bJE6RxMXZRBASgg9UumSfxq4ax5n0mazBPat/R32WKF97AOcs2QETz0ZKVQ
         5aTBiUoBFLecLptfzWrVFxMO+ZoccJQny3/YrXxWG4aYmNRFHPxuCmTe/LQrtzlYuK
         Y9CY5OQTVPP+CVD5mScVIYELQJ1X0ytlRdc+cxjubbu+IuSCaUH2mdzS/0l6xUbyZM
         hc1GeurH7xC77lWMA4deiFoXieqXYscZTrlwtTVQcEaqXbUKVJiGx5WLYM/zJ+nQZN
         vbKOrDRJkJGAoCuZaySzc/tFNT0skRJMjbi/b397wtW25bjOf/IvuFwu1479LUvMBg
         7w9yadVFFu7qw==
Message-ID: <274c4526-49b0-b8a3-81ca-67889a403901@kernel.org>
Date:   Thu, 21 Sep 2023 10:31:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4 19/23] ata: libata-core: Do not resume runtime
 suspended ports
Content-Language: en-US
To:     Sergey Shtylyov <s.shtylyov@omp.ru>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-20-dlemoal@kernel.org>
 <cb714cbb-0fba-6774-f525-726b829af02e@omp.ru>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cb714cbb-0fba-6774-f525-726b829af02e@omp.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/21 0:32, Sergey Shtylyov wrote:
> On 9/20/23 4:54 PM, Damien Le Moal wrote:
> 
>> The scsi disk driver does not resume disks that have been runtime
>> suspended by the user. To be consistent with this behavior, do the same
>> for ata ports and skip the PM request in ata_port_pm_resume() if the
>> port was already runtime suspended. With this change, it is no longer
>> necessary to for the PM state of the port to ACTIVE as the PM core code
>             ^^^^^^
>    Can't parse this. :-)

s/for/force

Will fix that.

> 
>> will take care of that when handling runtime resume.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
> [...]
> 
> MBR, Sergey

-- 
Damien Le Moal
Western Digital Research

