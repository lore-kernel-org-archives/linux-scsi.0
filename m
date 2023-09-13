Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7EFEE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbjIMBoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:44:14 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A72210DD;
        Tue, 12 Sep 2023 18:44:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-68fe2470d81so1675214b3a.1;
        Tue, 12 Sep 2023 18:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569450; x=1695174250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Biml60wvjlVh6OenDKpLcpVUh2nGkd2XswuKKgmpqQ=;
        b=fmxzsoR5RFcQIbO2eW2SREf8FXRRT89a1yhlpamvmeYrEAGk2f7bRqCsksDtZL+Y4J
         Wo6GV56Ua4EaXuzVUMqCYJvGehZXgRczkC7+XpSBSgV6mcCZoMTFnDeNKi85T22PLXqs
         jgLm9pkbvznZp7/MsPy6mknMgBg7mFv+4VCIyaDgqFoPh9puJ7fmHG31ttxOBknM2aDz
         ikNP4tF+a8zPOnL7etU2Y8nvEuqYM4roYURmw3LhGfoGOTWATb9iCH7+rLKf8lufMbVy
         av0T/XMwX54SDB1FdMzbEzzIF27jaH+5XLslNXtqEsXOKEJHEE27PYLEGSd0n3i2H/Co
         N1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569450; x=1695174250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Biml60wvjlVh6OenDKpLcpVUh2nGkd2XswuKKgmpqQ=;
        b=xQaEWy9f9rYZRshAyczaT4o/8WHYmIKAbVtnEN1WkwZ1HwqRPKRmVnwRX16mvsDG+A
         3t++14b3ZSqpUdhSghS4rTqfzDSIbFaYISMpikNVQUce9RPU5v8AS+114+8VaUvywu9g
         0Yi2C0tqsgvb4WNESlmN5dH172akzgr0i45YfhsBYamjElApzKJHTeBXlkO6q0Sh1l4x
         AYDAu5QmEFn1dKcxyJ+8M3VW3fITEsDFirGl4RL8S/+lt53NGRBBwFZc620TBuw6cVFz
         QbTwmRztwwutO2Xy5uejM41vnTs0GKbBGFmdlzL3/Tx/mgW0Reus18vi+Zz1+7sW1pOs
         vTtA==
X-Gm-Message-State: AOJu0Ywo5mIQxm6tx3S4rGERzuotsbMkoeDhrrYMOjU1845Fc7cx9JIT
        vTEDo8kSstTvM9KKBm2Sw1c=
X-Google-Smtp-Source: AGHT+IF3aRBI0R1T2u/H0e3QUkJHNbSgLY5NF+g1wmUlXi/R2iH/vnoYRbVVfxx8bwq97vAlxFaImQ==
X-Received: by 2002:a05:6a21:32a9:b0:153:6ce7:294d with SMTP id yt41-20020a056a2132a900b001536ce7294dmr1313587pzb.12.1694569449740;
        Tue, 12 Sep 2023 18:44:09 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a004800b002682392506bsm270644pjb.50.2023.09.12.18.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:44:09 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:44:05 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 04/19] ata: libata-scsi: Disable scsi device
 manage_start_stop
Message-ID: <ZQET5QfRHaIewdKT@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-5-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-5-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:02PM +0900, Damien Le Moal wrote:
> The introduction of a device link to create a consumer/supplier
> relationship between the scsi device of an ATA device and the ATA port
> of the ATA device fixed the ordering of the suspend and resume
> operations. For suspend, the scsi device is suspended first and the ata
> port after it. This is fine as this allows the synchronize cache and
> START STOP UNIT commands issued by the scsi disk driver to be executed
> before the ata port is disabled.
> 
> For resume operations, the ata port is resumed first, followed
> by the scsi device. This allows having the request queue of the scsi
> device to be unfrozen after the ata port restart is scheduled in EH,
> thus avoiding to see new requests issued to the ATA device prematurely.
> However, since libata sets manage_start_stop to 1, the scsi disk resume
> operation also results in issuing a START STOP UNIT command to wakeup
> the device. This is too late and that must be done before libata EH
> resume handling starts revalidating the drive with IDENTIFY etc
> commands. Commit 0a8589055936 ("ata,scsi: do not issue START STOP UNIT
> on resume") disabled issuing the START STOP UNIT command to avoid
> issues with it. However, this is incorrect as transitioning a device to
> the active power mode from the standby power mode set on suspend
> requires a media access command. The device link reset and subsequent
> SET FEATURES, IDENTIFY and READ LOG commands executed in libata EH
> context triggered by the ata port resume operation may thus fail.
> 
> Fix this by handling a device power mode transitions for suspend and
> resume in libata EH context without relying on the scsi disk management
> triggered with the manage_start_stop flag.
> 
> To do this, the following libata helper functions are introduced:
> 
> 1) ata_dev_power_set_standby():
> 
> This function issues a STANDBY IMMEDIATE command to transitiom a device
> to the standby power mode. For HDDs, this spins down the disks. This
> function applies only to ATA and ZAC devices and does nothing otherwise.
> This function also does nothing for devices that have the
> ATA_FLAG_NO_POWEROFF_SPINDOWN or ATA_FLAG_NO_HIBERNATE_SPINDOWN flag
> set.
> 
> For suspend, call ata_dev_power_set_standby() in
> ata_eh_handle_port_suspend() before the port is disabled and frozen.
> ata_eh_unload() is also modified to transition all enabled devices to
> the standby power mode when the system is shutdown or devices removed.
> 
> 2) ata_dev_power_set_active() and
> 
> This function applies to ATA or ZAC devices and issues a VERIFY command
> for 1 sector at LBA 0 to transition the device to the active power mode.
> For HDDs, since this function will complete only once the disk spin up.
> Its execution uses the same timeouts as for reset, to give the drive
> enough time to complete spinup without triggering a command timeout.
> 
> For resume, call ata_dev_power_set_active() in
> ata_eh_revalidate_and_attach() after the port has been enabled and
> before any other command is issued to the device.
> 
> With these changes, the manage_start_stop flag does not need to be set
> in ata_scsi_dev_config().
> 
> Fixes: 0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume")
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
