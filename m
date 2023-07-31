Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A901C04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 19:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjGaTn4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 15:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjGaTnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 15:43:55 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333971B2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 12:43:54 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-55ae2075990so3069211a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2023 12:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soe.ucsc.edu; s=soe-google-2018; t=1690832633; x=1691437433;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=2srF+VwsfZK2mGTSZ1/Lzy6JxU0qS8lMwLV+lKLY4gk=;
        b=KNrPgz59EKXF/Cdi8VB+MqUgLmWvFCd6rarGZ1xw8oblswwKFiFfdzqnrAx986D6G8
         9w0qN93ko6rlHDKeGSQwrvCCITCfv5GNQcsqd+3Cs5Ul3UnWJkm0y11UFqoYbZY3VdYP
         iPtKz5KMpW319YBzaF+LNP7PxRGKF/OX7TPiRyVPJ1Low21ZPP5RiwLgt6fh98m9Skxz
         LCvCyroPQTP92S66ctbcg/BMXU2bTOHLXBSpbEiqFZUYHBSmNkCNdT1kYFCQNq3a2saj
         F+hgE1kp9CoK24xq50ISNYRW1PuiCqihCNZpQhxaeDrZFol/PK03QQKKCgXpV7+09Hl+
         qGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690832633; x=1691437433;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2srF+VwsfZK2mGTSZ1/Lzy6JxU0qS8lMwLV+lKLY4gk=;
        b=Oqs+BkuApVyU4xa+5Q2z3/9iMUWA9UelrOOeoYfSR3ir3YLOePylJe9VIBcFpWqi3q
         JzDBXh7ICd0uW8Pfh7d5UiU3ZSgAdgrmyJc3MqsJnAC4A99b/qR3dXOzPGgAAIfYKdDZ
         tzT2Hnp7AQmxsCLlCXeIgXKydD2H5jcDSJNHYeM4FKBr8NGYqv/xMJHiRuFbfwPGxFwU
         /NSB8TUva9kGLqnPRaqVYJb7UbUgBUMwuldRtCcGbqO5aE+ZebeSkf6GOEagTpmspl8d
         zBIv0SRrs7gU02F+XsTWJdqCb8kMkmjYYpKiWiug1dmkBHsCL52KdqZI4OWoevKIU4r9
         U4gg==
X-Gm-Message-State: ABy/qLZXBpqMHwAeM+57Q8CxiJ5cmKpDopbRnqlUFfZk5VjhVaEmtAAE
        wEBDlD1BE9qB39eTScvkP6eQRQ==
X-Google-Smtp-Source: APBJJlH1fVcQ97yyq8Zt7838/qVW3ws0AdnOmmS0wxBtL/mM82/pvD3MXZ7hdqU8RKAFXjjF4TkV2A==
X-Received: by 2002:a17:90b:1003:b0:25e:d727:6fb4 with SMTP id gm3-20020a17090b100300b0025ed7276fb4mr9340515pjb.2.1690832633462;
        Mon, 31 Jul 2023 12:43:53 -0700 (PDT)
Received: from [192.168.1.50] (99-189-239-182.lightspeed.sntcca.sbcglobal.net. [99.189.239.182])
        by smtp.gmail.com with ESMTPSA id p21-20020a17090adf9500b00263d3448141sm6574393pjv.8.2023.07.31.12.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 12:43:52 -0700 (PDT)
From:   Paul Ausbeck <paula@soe.ucsc.edu>
X-Google-Original-From: Paul Ausbeck <paula@alumni.cse.ucsc.edu>
Message-ID: <a8d35a0e-fe01-e889-615a-2f2e104e2492@alumni.cse.ucsc.edu>
Date:   Mon, 31 Jul 2023 12:43:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
In-Reply-To: <20230731003956.572414-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/30/23 17:39, Damien Le Moal wrote:
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
>     been reenabled at the beginning of the EH execution. This is visible
>     with error messages like:
> 
> ata10.00: device reported invalid CHS sector 0
> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
> sd 9:0:0:0: PM: failed to resume async: error -5
> 
> 2) The START STOP UNIT command is received while the EH process is
>     on-going, which mean that it is stopped and must wait for its
>     completion, at which point the command is rather useless as the drive
>     is already fully spun up already. This case results also in a
>     significant delay in sd_resume() which is observable by users as
>     the entire system resume completion is delayed.
> 
> Given that ATA devices will be woken up by libata activity on resume,
> sd_resume() has no need to issue a START STOP UNIT command, which solves
> the above mentioned problems. Do not issue this command by introducing
> the new scsi_device flag no_start_on_resume and setting this flag to 1
> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
> UNIT command only if this flag is not set.
> 
> Reported-by: Paul Ausbeck<paula@soe.ucsc.edu>
> Closes:https://bugzilla.kernel.org/show_bug.cgi?id=215880
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Tested-by: Paul Ausbeck <paula@soe.ucsc.edu>
