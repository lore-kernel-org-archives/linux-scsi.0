Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FA2EE57DF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbjIMBnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBnK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:43:10 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4DF115;
        Tue, 12 Sep 2023 18:43:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68fc292de9dso345829b3a.0;
        Tue, 12 Sep 2023 18:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569386; x=1695174186; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=stQy8kqciEO3ukYVfjCIxPN/rm7nEGBK6N1teU6wSA0=;
        b=OTkhkwckVkjFfTvas4KRgi8FC2LY4+lFnt3vsfX8ACyX8QDnDKpDf1HxRzWXD4G1f+
         67+uIIv7zXHoK4daam44Hppzwcr+Zsme+pOnQplKfaFtG1iYGKmByz9p/SIdQBjWezLL
         zZR8QKZg3YCifCM4oZn07mGipZTrlieyTmZyf6utQptShwOJAkri4q6XSEObNE+oTm9z
         wQZMMCho0mIcZ3UoX+a3U1fnZetad5EaOHr7X98er2un9WaEa7ZcJFmnSA2wnmzChAub
         Tx00vlM8YElECc6CBM/f6rTk8+K6lnpv/wqPzrJC5zO6erUEoRO6VdALMN5xBM5CPjzH
         aw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569386; x=1695174186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=stQy8kqciEO3ukYVfjCIxPN/rm7nEGBK6N1teU6wSA0=;
        b=i70CITBFJGLOAscJNQilLD/UY/pLn81rI1iRhfyd4NTFojnWO4RyoF6u3Mx3mGnCTr
         cZY8Rl8RszUvB9dybLfvWyU+ZnqAJ5i+CyEkHr9I/uEIGSiCk49JsYos+s7KjX97RtnC
         45MWz8yfxV/AApLS0tUiFj0UTwLjrPElGMq8a9rI1KuXBLXSUKlLYdyDgtOGikZ3gwBn
         UH52KeaWhCtoXcj4KeQoEu2lpWxPBXfAjLkV+YVCo1ZWLpPk6PMITIj7y1LcKdBem3ct
         EOwHRZVQAhAGkOh1ItbadnLtoLll9L3ogIB0rTVvxdTEVyzqiX3EErGleU3romlmoJvd
         HJ9A==
X-Gm-Message-State: AOJu0YyUBiTyAOJDnBXOFZZeb20/HMe6x/UXH2UoRG380TT5obv1DU48
        n61ZRdm6cHLRdwe7OLqFmXA=
X-Google-Smtp-Source: AGHT+IF/cW3QPxSPcmSYWJJ31gSnw+R0ZizrDpYT4YRoqK4PC6697pcoOOtujz0asAcA4bwIi2a3Eg==
X-Received: by 2002:a05:6a00:b85:b0:68f:bb16:d16a with SMTP id g5-20020a056a000b8500b0068fbb16d16amr1749250pfj.5.1694569386008;
        Tue, 12 Sep 2023 18:43:06 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79103000000b0064fd4a6b306sm7954406pfh.76.2023.09.12.18.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:43:05 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:43:01 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 02/19] ata: libata-core: Fix port and device removal
Message-ID: <ZQETpdC3S9Ruiqyg@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-3-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-3-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:00PM +0900, Damien Le Moal wrote:
> Whenever an ATA adapter driver is removed (e.g. rmmod),
> ata_port_detach() is called repeatedly for all the adapter ports to
> remove (unload) the devices attached to the port and delete the port
> device itself. Removing of devices is done using libata EH with the
> ATA_PFLAG_UNLOADING port flag set. This causes libata EH to execute
> ata_eh_unload() which disables all devices attached to the port.
> 
> ata_port_detach() finishes by calling scsi_remove_host() to remove the
> scsi host associated with the port. This function will trigger the
> removal of all scsi devices attached to the host and in the case of
> disks, calls to sd_shutdown() which will flush the device write cache
> and stop the device. However, given that the devices were already
> disabled by ata_eh_unload(), the synchronize write cache command and
> start stop unit commands fail. E.g. running "rmmod ahci" with first
> removing sd_mod results in error messages like:
> 
> ata13.00: disable device
> sd 0:0:0:0: [sda] Synchronizing SCSI cache
> sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:0:0:0: [sda] Stopping disk
> sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> 
> Fix this by removing all scsi devices of the ata devices connected to
> the port before scheduling libata EH to disable the ATA devices.
> 
> Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
