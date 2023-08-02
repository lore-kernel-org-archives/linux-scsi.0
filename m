Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76240C41513
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 08:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjHBIFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjHBIFJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 04:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DCBAC;
        Wed,  2 Aug 2023 01:05:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1257161853;
        Wed,  2 Aug 2023 08:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B159C433CC;
        Wed,  2 Aug 2023 08:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690963507;
        bh=td07XKWidoomSVZRaOJmmQqKf2QT5CJ94O/GYzC2Udw=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=JZXNMDmtJL5nILNMkGKoj/PsxNOxvf7djJBiI/6nLij4T6udUZfgZJj7jhaS8C3mZ
         hJtZYJdnsmwA896yXzLpVvK/FMJ1p+15G+qbxmGLpQjbmXcfRSD+V+mwxAW55Bzk45
         CLWHkaSU7rt1yJyjSfxMg3Q8JzJ+YySmHLXEqcDb8dykGVH9exs0X37nDAwMj5CBtr
         YWTHIyi2/Y9emvWytorzySeQuYMrOYvKQL9OJsLkRkIHvSzDKb9e0WouiBAyNwpZm0
         SFm2iKtwVelxkcw9mY3WacvYjUOrypNdQReLkgV0jIUJFVAVioNr8lBqFR6MDhbphV
         hdi4O3XiZWkWw==
Message-ID: <b7431ae0-e6a1-a9b3-9941-bfe84801b324@kernel.org>
Date:   Wed, 2 Aug 2023 17:05:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/31/23 09:39, Damien Le Moal wrote:
> During system resume, ata_port_pm_resume() triggers ata EH to
> 1) Resume the controller
> 2) Reset and rescan the ports
> 3) Revalidate devices
> This EH execution is started asynchronously from ata_port_pm_resume(),
> which means that when sd_resume() is executed, none or only part of the
> above processing may have been executed. However, sd_resume() issues a
> START STOP UNIT to wake up the drive from sleep mode. This command is
> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
> device. However, depending on the state of execution of the EH process
> and revalidation triggerred by ata_port_pm_resume(), two things may
> happen:
> 1) The START STOP UNIT fails if it is received before the controller has
>    been reenabled at the beginning of the EH execution. This is visible
>    with error messages like:
> 
> ata10.00: device reported invalid CHS sector 0
> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
> sd 9:0:0:0: PM: failed to resume async: error -5
> 
> 2) The START STOP UNIT command is received while the EH process is
>    on-going, which mean that it is stopped and must wait for its
>    completion, at which point the command is rather useless as the drive
>    is already fully spun up already. This case results also in a
>    significant delay in sd_resume() which is observable by users as
>    the entire system resume completion is delayed.
> 
> Given that ATA devices will be woken up by libata activity on resume,
> sd_resume() has no need to issue a START STOP UNIT command, which solves
> the above mentioned problems. Do not issue this command by introducing
> the new scsi_device flag no_start_on_resume and setting this flag to 1
> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> UNIT command only if this flag is not set.

Martin,

Are you OK with this patch ? Can I get your Acked-by please ?


-- 
Damien Le Moal
Western Digital Research

