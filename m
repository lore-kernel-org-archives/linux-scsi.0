Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1C1C433F4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5B0420792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FQQg+rLZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgGUQnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730781AbgGUQmt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD99C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f18so21905787wrs.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H9LDHmcVxxsBv9ZykmDpwTd3mHwVX3vTQiVhZFHoSgs=;
        b=FQQg+rLZdBeOGeQcQA/SYlbeIaOvOlMIe9hfxI9Q4ysmtl/4DFAqzMwLSjQ5C1jNJ7
         YJOgqpToD9Dtkw80Paxrn2fJ6WarZOAGfvPxQ8oNCEtBkqT8xajvabB7Jy8duaNtLXwF
         b0FhBOrwcMkw1S6cJJ7xeuZyxI9ST0XSkhxUZKh7jfY9tPaQLIgYzRhRLiKSr/tRutw6
         RUZAWQqrutIwuheQCHeWUwz5EApXiRmBXcRRNuiEoD/JPJQxVaC0vc59fHbE/nNHO6AB
         SfHwcXZ/zC8wikIZj7fo0EWP6tvktwKBWSEo536Zc7+N+SbdU0LokyNxcIGrORs/Ev/M
         ccPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H9LDHmcVxxsBv9ZykmDpwTd3mHwVX3vTQiVhZFHoSgs=;
        b=npj+F2lW9glf5QFwOCpN2bRwUYRCGSV12XwaVTTl6DBLQUA3DKWQaZxnKGpbqXZzKB
         PNAyilyu18V67jFXMhz+n7HlFgObkwl/P2loRhTlqBncE+g0xPtJdMFOcyhWcX6vy2vK
         FDP9Bl9Ty2qcGHGYf0LVt8DXXr5gNY9E25OfTqAEL7DkyS6NAUfC9/yX2ZLPLP0XLFW9
         IvzfmVlySP0kLgz8606Ez+iBpT0BuNk/H5IxDstGgt5Ohfe1mQf8Nzg5yWelFY68yE6Q
         mGiyzkOUhXOpq40tMa5B/CYBQqs4V9JuEXv1qui26avLKc/vy9mZtp5JWTfVAaUCyWUt
         H79g==
X-Gm-Message-State: AOAM53365KElAre1sXqo6dx5/LYQKASqhrjmng3Yv9rz1CXEVYzSQDoG
        6CI8c8hPaFyu3vcbXsPu1UD9SSPehUg=
X-Google-Smtp-Source: ABdhPJyDaOO0jPNdSnU52jCfwtEY8r5HTi4PsvGk2oHYyC/IESDG7ITMyAqRoYXXjGYQ3oD7VCNbQw==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr25737356wrx.50.1595349766689;
        Tue, 21 Jul 2020 09:42:46 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:46 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 35/40] scsi: bfa: bfad_bsg: Staticify all local functions
Date:   Tue, 21 Jul 2020 17:41:43 +0100
Message-Id: <20200721164148.2617584-36-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfad_bsg.c:19:1: warning: no previous prototype for ‘bfad_iocmd_ioc_enable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:42:1: warning: no previous prototype for ‘bfad_iocmd_ioc_disable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:150:1: warning: no previous prototype for ‘bfad_iocmd_ioc_get_fwstats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:180:1: warning: no previous prototype for ‘bfad_iocmd_ioc_reset_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:198:1: warning: no previous prototype for ‘bfad_iocmd_ioc_set_name’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:212:1: warning: no previous prototype for ‘bfad_iocmd_iocfc_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:223:1: warning: no previous prototype for ‘bfad_iocmd_ioc_fw_sig_inv’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:235:1: warning: no previous prototype for ‘bfad_iocmd_iocfc_set_intr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:248:1: warning: no previous prototype for ‘bfad_iocmd_port_enable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:269:1: warning: no previous prototype for ‘bfad_iocmd_port_disable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:319:1: warning: no previous prototype for ‘bfad_iocmd_port_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:353:1: warning: no previous prototype for ‘bfad_iocmd_port_reset_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:374:1: warning: no previous prototype for ‘bfad_iocmd_set_port_cfg’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:394:1: warning: no previous prototype for ‘bfad_iocmd_port_cfg_maxfrsize’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:408:1: warning: no previous prototype for ‘bfad_iocmd_port_cfg_bbcr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:431:1: warning: no previous prototype for ‘bfad_iocmd_port_get_bbcr_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:469:1: warning: no previous prototype for ‘bfad_iocmd_lport_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:493:1: warning: no previous prototype for ‘bfad_iocmd_lport_reset_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:527:1: warning: no previous prototype for ‘bfad_iocmd_lport_get_iostats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:552:1: warning: no previous prototype for ‘bfad_iocmd_lport_get_rports’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:594:1: warning: no previous prototype for ‘bfad_iocmd_rport_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:680:1: warning: no previous prototype for ‘bfad_iocmd_rport_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:721:1: warning: no previous prototype for ‘bfad_iocmd_rport_clr_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:757:1: warning: no previous prototype for ‘bfad_iocmd_rport_set_speed’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:793:1: warning: no previous prototype for ‘bfad_iocmd_vport_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:816:1: warning: no previous prototype for ‘bfad_iocmd_vport_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:844:1: warning: no previous prototype for ‘bfad_iocmd_vport_clr_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:911:1: warning: no previous prototype for ‘bfad_iocmd_qos_set_bw’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:924:1: warning: no previous prototype for ‘bfad_iocmd_ratelim’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:953:1: warning: no previous prototype for ‘bfad_iocmd_ratelim_speed’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:982:1: warning: no previous prototype for ‘bfad_iocmd_cfg_fcpim’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:995:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_get_modstats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1017:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_clr_modstats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1039:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_get_del_itn_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1164:1: warning: no previous prototype for ‘bfad_iocmd_fcport_enable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1177:1: warning: no previous prototype for ‘bfad_iocmd_fcport_disable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1190:1: warning: no previous prototype for ‘bfad_iocmd_ioc_get_pcifn_cfg’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1212:1: warning: no previous prototype for ‘bfad_iocmd_pcifn_create’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1235:1: warning: no previous prototype for ‘bfad_iocmd_pcifn_delete’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1257:1: warning: no previous prototype for ‘bfad_iocmd_pcifn_bw’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1281:1: warning: no previous prototype for ‘bfad_iocmd_adapter_cfg_mode’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1304:1: warning: no previous prototype for ‘bfad_iocmd_port_cfg_mode’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1328:1: warning: no previous prototype for ‘bfad_iocmd_ablk_optrom’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1354:1: warning: no previous prototype for ‘bfad_iocmd_faa_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1377:1: warning: no previous prototype for ‘bfad_iocmd_cee_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1413:1: warning: no previous prototype for ‘bfad_iocmd_cee_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1450:1: warning: no previous prototype for ‘bfad_iocmd_cee_reset_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1464:1: warning: no previous prototype for ‘bfad_iocmd_sfp_media’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1486:1: warning: no previous prototype for ‘bfad_iocmd_sfp_speed’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1507:1: warning: no previous prototype for ‘bfad_iocmd_flash_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1528:1: warning: no previous prototype for ‘bfad_iocmd_flash_erase_part’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1548:1: warning: no previous prototype for ‘bfad_iocmd_flash_update_part’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1580:1: warning: no previous prototype for ‘bfad_iocmd_flash_read_part’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1612:1: warning: no previous prototype for ‘bfad_iocmd_diag_temp’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1634:1: warning: no previous prototype for ‘bfad_iocmd_diag_memtest’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1657:1: warning: no previous prototype for ‘bfad_iocmd_diag_loopback’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1680:1: warning: no previous prototype for ‘bfad_iocmd_diag_fwping’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1704:1: warning: no previous prototype for ‘bfad_iocmd_diag_queuetest’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1725:1: warning: no previous prototype for ‘bfad_iocmd_diag_sfp’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1748:1: warning: no previous prototype for ‘bfad_iocmd_diag_led’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1761:1: warning: no previous prototype for ‘bfad_iocmd_diag_beacon_lport’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1776:1: warning: no previous prototype for ‘bfad_iocmd_diag_lb_stat’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1791:1: warning: no previous prototype for ‘bfad_iocmd_diag_dport_enable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1813:1: warning: no previous prototype for ‘bfad_iocmd_diag_dport_disable’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1833:1: warning: no previous prototype for ‘bfad_iocmd_diag_dport_start’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1858:1: warning: no previous prototype for ‘bfad_iocmd_diag_dport_show’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1873:1: warning: no previous prototype for ‘bfad_iocmd_phy_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1894:1: warning: no previous prototype for ‘bfad_iocmd_phy_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1915:1: warning: no previous prototype for ‘bfad_iocmd_phy_read’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1947:1: warning: no previous prototype for ‘bfad_iocmd_vhba_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1966:1: warning: no previous prototype for ‘bfad_iocmd_phy_update’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:1996:1: warning: no previous prototype for ‘bfad_iocmd_porglog_get’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2016:1: warning: no previous prototype for ‘bfad_iocmd_debug_fw_core’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2050:1: warning: no previous prototype for ‘bfad_iocmd_debug_ctl’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2071:1: warning: no previous prototype for ‘bfad_iocmd_porglog_ctl’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2085:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_cfg_profile’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2129:1: warning: no previous prototype for ‘bfad_iocmd_fcport_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2154:1: warning: no previous prototype for ‘bfad_iocmd_fcport_reset_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2178:1: warning: no previous prototype for ‘bfad_iocmd_boot_cfg’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2200:1: warning: no previous prototype for ‘bfad_iocmd_boot_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2222:1: warning: no previous prototype for ‘bfad_iocmd_preboot_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2241:1: warning: no previous prototype for ‘bfad_iocmd_ethboot_cfg’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2264:1: warning: no previous prototype for ‘bfad_iocmd_ethboot_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2287:1: warning: no previous prototype for ‘bfad_iocmd_cfg_trunk’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2327:1: warning: no previous prototype for ‘bfad_iocmd_trunk_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2350:1: warning: no previous prototype for ‘bfad_iocmd_qos’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2378:1: warning: no previous prototype for ‘bfad_iocmd_qos_get_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2404:1: warning: no previous prototype for ‘bfad_iocmd_qos_get_vc_attr’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2436:1: warning: no previous prototype for ‘bfad_iocmd_qos_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2468:1: warning: no previous prototype for ‘bfad_iocmd_qos_reset_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2499:1: warning: no previous prototype for ‘bfad_iocmd_vf_get_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2522:1: warning: no previous prototype for ‘bfad_iocmd_vf_clr_stats’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2559:1: warning: no previous prototype for ‘bfad_iocmd_lunmask’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2582:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_lunmask_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2596:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_cfg_lunmask’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2615:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_throttle_query’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2630:1: warning: no previous prototype for ‘bfad_iocmd_fcpim_throttle_set’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2645:1: warning: no previous prototype for ‘bfad_iocmd_tfru_read’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2667:1: warning: no previous prototype for ‘bfad_iocmd_tfru_write’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2689:1: warning: no previous prototype for ‘bfad_iocmd_fruvpd_read’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2711:1: warning: no previous prototype for ‘bfad_iocmd_fruvpd_update’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:2733:1: warning: no previous prototype for ‘bfad_iocmd_fruvpd_get_max_size’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3181:1: warning: no previous prototype for ‘bfad_fcxp_get_req_sgaddr_cb’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3193:1: warning: no previous prototype for ‘bfad_fcxp_get_req_sglen_cb’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3203:1: warning: no previous prototype for ‘bfad_fcxp_get_rsp_sgaddr_cb’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3215:1: warning: no previous prototype for ‘bfad_fcxp_get_rsp_sglen_cb’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3225:1: warning: no previous prototype for ‘bfad_send_fcpt_cb’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3240:1: warning: no previous prototype for ‘bfad_fcxp_map_sg’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3284:1: warning: no previous prototype for ‘bfad_fcxp_free_mem’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3302:1: warning: no previous prototype for ‘bfad_fcxp_bsg_send’ [-Wmissing-prototypes]
 drivers/scsi/bfa/bfad_bsg.c:3342:1: warning: no previous prototype for ‘bfad_im_bsg_els_ct_request’ [-Wmissing-prototypes]

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 222 ++++++++++++++++++------------------
 1 file changed, 111 insertions(+), 111 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 412dbe125e10c..fc515424ca88d 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -15,7 +15,7 @@
 
 BFA_TRC_FILE(LDRV, BSG);
 
-int
+static int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -38,7 +38,7 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -146,7 +146,7 @@ bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_fwstats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -176,7 +176,7 @@ bfad_iocmd_ioc_get_fwstats(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -194,7 +194,7 @@ bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_ioc_name_s *iocmd = (struct bfa_bsg_ioc_name_s *) cmd;
@@ -208,7 +208,7 @@ bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_attr_s *iocmd = (struct bfa_bsg_iocfc_attr_s *)cmd;
@@ -219,7 +219,7 @@ bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -231,7 +231,7 @@ bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_intr_s *iocmd = (struct bfa_bsg_iocfc_intr_s *)cmd;
@@ -244,7 +244,7 @@ bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -265,7 +265,7 @@ bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -315,7 +315,7 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -349,7 +349,7 @@ bfad_iocmd_port_get_stats(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -370,7 +370,7 @@ bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_port_cfg_s *cmd = (struct bfa_bsg_port_cfg_s *)iocmd;
@@ -390,7 +390,7 @@ bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_maxfrsize_s *iocmd =
@@ -404,7 +404,7 @@ bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_bbcr_enable_s *iocmd =
@@ -427,7 +427,7 @@ bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_get_bbcr_attr(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_bbcr_attr_s *iocmd = (struct bfa_bsg_bbcr_attr_s *) pcmd;
@@ -465,7 +465,7 @@ bfad_iocmd_lport_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -489,7 +489,7 @@ bfad_iocmd_lport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -523,7 +523,7 @@ bfad_iocmd_lport_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_iostats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -548,7 +548,7 @@ bfad_iocmd_lport_get_iostats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -590,7 +590,7 @@ bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_attr_s *iocmd = (struct bfa_bsg_rport_attr_s *)cmd;
@@ -676,7 +676,7 @@ bfad_iocmd_rport_get_addr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_stats_s *iocmd =
@@ -717,7 +717,7 @@ bfad_iocmd_rport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_reset_stats_s *iocmd =
@@ -753,7 +753,7 @@ bfad_iocmd_rport_clr_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_rport_set_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_set_speed_s *iocmd =
@@ -789,7 +789,7 @@ bfad_iocmd_rport_set_speed(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -812,7 +812,7 @@ bfad_iocmd_vport_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -840,7 +840,7 @@ bfad_iocmd_vport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -907,7 +907,7 @@ bfad_iocmd_fabric_get_lports(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_qos_bw_s *iocmd = (struct bfa_bsg_qos_bw_s *)pcmd;
@@ -920,7 +920,7 @@ bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -949,7 +949,7 @@ bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_trl_speed_s *iocmd = (struct bfa_bsg_trl_speed_s *)pcmd;
@@ -978,7 +978,7 @@ bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_s *iocmd = (struct bfa_bsg_fcpim_s *)cmd;
@@ -991,7 +991,7 @@ bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstats_s *iocmd =
@@ -1013,7 +1013,7 @@ bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstatsclr_s *iocmd =
@@ -1035,7 +1035,7 @@ bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_get_del_itn_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_del_itn_stats_s *iocmd =
@@ -1160,7 +1160,7 @@ bfad_iocmd_itnim_get_itnstats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1173,7 +1173,7 @@ bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1186,7 +1186,7 @@ bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_cfg_s *iocmd = (struct bfa_bsg_pcifn_cfg_s *)cmd;
@@ -1208,7 +1208,7 @@ bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_create(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1231,7 +1231,7 @@ bfad_iocmd_pcifn_create(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_delete(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1253,7 +1253,7 @@ bfad_iocmd_pcifn_delete(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_pcifn_bw(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd = (struct bfa_bsg_pcifn_s *)cmd;
@@ -1277,7 +1277,7 @@ bfad_iocmd_pcifn_bw(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_adapter_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_adapter_cfg_mode_s *iocmd =
@@ -1300,7 +1300,7 @@ bfad_iocmd_adapter_cfg_mode(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_port_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_mode_s *iocmd =
@@ -1324,7 +1324,7 @@ bfad_iocmd_port_cfg_mode(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ablk_optrom(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -1350,7 +1350,7 @@ bfad_iocmd_ablk_optrom(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_faa_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_faa_attr_s *iocmd = (struct bfa_bsg_faa_attr_s *)cmd;
@@ -1373,7 +1373,7 @@ bfad_iocmd_faa_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_attr(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_cee_attr_s *iocmd =
@@ -1409,7 +1409,7 @@ bfad_iocmd_cee_attr(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1446,7 +1446,7 @@ bfad_iocmd_cee_get_stats(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -1460,7 +1460,7 @@ bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_sfp_media(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_media_s *iocmd = (struct bfa_bsg_sfp_media_s *)cmd;
@@ -1482,7 +1482,7 @@ bfad_iocmd_sfp_media(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_sfp_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_speed_s *iocmd = (struct bfa_bsg_sfp_speed_s *)cmd;
@@ -1503,7 +1503,7 @@ bfad_iocmd_sfp_speed(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_attr_s *iocmd =
@@ -1524,7 +1524,7 @@ bfad_iocmd_flash_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_erase_part(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_s *iocmd = (struct bfa_bsg_flash_s *)cmd;
@@ -1544,7 +1544,7 @@ bfad_iocmd_flash_erase_part(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_update_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1576,7 +1576,7 @@ bfad_iocmd_flash_update_part(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_flash_read_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1608,7 +1608,7 @@ bfad_iocmd_flash_read_part(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_temp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_get_temp_s *iocmd =
@@ -1630,7 +1630,7 @@ bfad_iocmd_diag_temp(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_memtest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_memtest_s *iocmd =
@@ -1653,7 +1653,7 @@ bfad_iocmd_diag_memtest(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_loopback(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_loopback_s *iocmd =
@@ -1676,7 +1676,7 @@ bfad_iocmd_diag_loopback(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_fwping(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_fwping_s *iocmd =
@@ -1700,7 +1700,7 @@ bfad_iocmd_diag_fwping(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_queuetest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_qtest_s *iocmd = (struct bfa_bsg_diag_qtest_s *)cmd;
@@ -1721,7 +1721,7 @@ bfad_iocmd_diag_queuetest(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_sfp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_show_s *iocmd =
@@ -1744,7 +1744,7 @@ bfad_iocmd_diag_sfp(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_led_s *iocmd = (struct bfa_bsg_diag_led_s *)cmd;
@@ -1757,7 +1757,7 @@ bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_beacon_s *iocmd =
@@ -1772,7 +1772,7 @@ bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_lb_stat_s *iocmd =
@@ -1787,7 +1787,7 @@ bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =
@@ -1809,7 +1809,7 @@ bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -1829,7 +1829,7 @@ bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =
@@ -1854,7 +1854,7 @@ bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_diag_dport_show_s *iocmd =
@@ -1869,7 +1869,7 @@ bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 }
 
 
-int
+static int
 bfad_iocmd_phy_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_attr_s *iocmd =
@@ -1890,7 +1890,7 @@ bfad_iocmd_phy_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_stats_s *iocmd =
@@ -1911,7 +1911,7 @@ bfad_iocmd_phy_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_read(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_phy_s *iocmd = (struct bfa_bsg_phy_s *)cmd;
@@ -1943,7 +1943,7 @@ bfad_iocmd_phy_read(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vhba_attr_s *iocmd =
@@ -1962,7 +1962,7 @@ bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_phy_update(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 {
 	struct bfa_bsg_phy_s *iocmd = (struct bfa_bsg_phy_s *)cmd;
@@ -1992,7 +1992,7 @@ bfad_iocmd_phy_update(struct bfad_s *bfad, void *cmd, unsigned int payload_len)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_porglog_get(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_debug_s *iocmd = (struct bfa_bsg_debug_s *)cmd;
@@ -2012,7 +2012,7 @@ bfad_iocmd_porglog_get(struct bfad_s *bfad, void *cmd)
 }
 
 #define BFA_DEBUG_FW_CORE_CHUNK_SZ	0x4000U /* 16K chunks for FW dump */
-int
+static int
 bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -2046,7 +2046,7 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2067,7 +2067,7 @@ bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_portlogctl_s *iocmd = (struct bfa_bsg_portlogctl_s *)cmd;
@@ -2081,7 +2081,7 @@ bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_cfg_profile(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_profile_s *iocmd =
@@ -2125,7 +2125,7 @@ bfad_iocmd_itnim_get_ioprofile(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =
@@ -2150,7 +2150,7 @@ bfad_iocmd_fcport_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2174,7 +2174,7 @@ bfad_iocmd_fcport_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
@@ -2196,7 +2196,7 @@ bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
@@ -2218,7 +2218,7 @@ bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_preboot_s *iocmd = (struct bfa_bsg_preboot_s *)cmd;
@@ -2237,7 +2237,7 @@ bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
@@ -2260,7 +2260,7 @@ bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
@@ -2283,7 +2283,7 @@ bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2323,7 +2323,7 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_trunk_attr_s *iocmd = (struct bfa_bsg_trunk_attr_s *)cmd;
@@ -2346,7 +2346,7 @@ bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2374,7 +2374,7 @@ bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_attr_s *iocmd = (struct bfa_bsg_qos_attr_s *)cmd;
@@ -2400,7 +2400,7 @@ bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_vc_attr_s *iocmd =
@@ -2432,7 +2432,7 @@ bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =
@@ -2464,7 +2464,7 @@ bfad_iocmd_qos_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_qos_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
@@ -2495,7 +2495,7 @@ bfad_iocmd_qos_reset_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_stats_s *iocmd =
@@ -2518,7 +2518,7 @@ bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_reset_stats_s *iocmd =
@@ -2555,7 +2555,7 @@ bfad_iocmd_lunmask_reset_lunscan_mode(struct bfad_s *bfad, int lunmask_cfg)
 		bfad_reset_sdev_bflags(vport->drv_port.im_port, lunmask_cfg);
 }
 
-int
+static int
 bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)pcmd;
@@ -2578,7 +2578,7 @@ bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_query_s *iocmd =
@@ -2592,7 +2592,7 @@ bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_s *iocmd =
@@ -2611,7 +2611,7 @@ bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =
@@ -2626,7 +2626,7 @@ bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =
@@ -2641,7 +2641,7 @@ bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =
@@ -2663,7 +2663,7 @@ bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =
@@ -2685,7 +2685,7 @@ bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =
@@ -2707,7 +2707,7 @@ bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =
@@ -2729,7 +2729,7 @@ bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_fruvpd_get_max_size(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_max_size_s *iocmd =
@@ -3177,7 +3177,7 @@ bfad_im_bsg_vendor_request(struct bsg_job *job)
 }
 
 /* FC passthru call backs */
-u64
+static u64
 bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3189,7 +3189,7 @@ bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 	return addr;
 }
 
-u32
+static u32
 bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3199,7 +3199,7 @@ bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 	return sge->sg_len;
 }
 
-u64
+static u64
 bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3211,7 +3211,7 @@ bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 	return addr;
 }
 
-u32
+static u32
 bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp = bfad_fcxp;
@@ -3221,7 +3221,7 @@ bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 	return sge->sg_len;
 }
 
-void
+static void
 bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 		bfa_status_t req_status, u32 rsp_len, u32 resid_len,
 		struct fchs_s *rsp_fchs)
@@ -3236,7 +3236,7 @@ bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbarg,
 	complete(&drv_fcxp->comp);
 }
 
-struct bfad_buf_info *
+static struct bfad_buf_info *
 bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 		 uint32_t payload_len, uint32_t *num_sgles)
 {
@@ -3280,7 +3280,7 @@ bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 	return NULL;
 }
 
-void
+static void
 bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 		   uint32_t num_sgles)
 {
@@ -3298,7 +3298,7 @@ bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base,
 	}
 }
 
-int
+static int
 bfad_fcxp_bsg_send(struct bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
@@ -3338,7 +3338,7 @@ bfad_fcxp_bsg_send(struct bsg_job *job, struct bfad_fcxp *drv_fcxp,
 	return BFA_STATUS_OK;
 }
 
-int
+static int
 bfad_im_bsg_els_ct_request(struct bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
-- 
2.25.1

