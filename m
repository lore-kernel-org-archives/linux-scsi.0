Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408CDC001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 00:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjGTAod (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 20:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGTAoc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 20:44:32 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9870E1BF7;
        Wed, 19 Jul 2023 17:44:30 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so314367e87.2;
        Wed, 19 Jul 2023 17:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689813869; x=1690418669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:dkim-signature:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wUeRFAaIbh6Rf2J31fu1QB7kQOTkCJrp2QTeKpBkSTQ=;
        b=cDA73Iz6Ap1RECD/QzuqZmW/CjatPKqgvnErsudczx5mllE9ygigVrPJkEZG5dD5VT
         bqoLntMHyB/eLQ1PUWu1ibbyCM0QRfGN1phix16eIDweUs1QTZH4lz7CnFXsVa01Aykj
         MYHS63f71cIh6Nx3f9CXqok2yI13E3YqseHeUr14bnbD2hQjJWzZCAdufRri+736Df0F
         NYMlU3TNPw/NpDEb5Dwx93EEdHUd3f/oiXc2AkPwT/QdRgkfBgpRkQZsDPFOZGdM4cl9
         OcJbQxGZTpjbD+7OMw0I40D9FkVbIxo8USMBt8awgS785AUv/OSmlHUWHzMCZ4JlTX4/
         5XRQ==
X-Gm-Message-State: ABy/qLbeifBwtMe8gd1msCDtCRiBM2a7AYbIcrWM19s3aGriOvxzCBCm
        b3Q3JPdq6jOr55RGWpj9ej5yefXVYlNxm8zM
X-Google-Smtp-Source: APBJJlFAwhgqv3NU15ukCtuEJhb71nC/HFTFLmrY3KMrWnlNylAYkVywnJoNHmjEZxfkkEQwjaopoQ==
X-Received: by 2002:a05:6512:b29:b0:4f7:604f:f4c8 with SMTP id w41-20020a0565120b2900b004f7604ff4c8mr1136532lfu.18.1689813868863;
        Wed, 19 Jul 2023 17:44:28 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id ep25-20020a056512485900b004efae490c51sm1175891lfb.240.2023.07.19.17.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 17:44:28 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 772033F12; Thu, 20 Jul 2023 02:44:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813867; bh=HB/obDH8IIPUi2im/fMggUWNUbBNLm3iHNuHkuuMxg8=;
        h=From:To:Cc:Subject:Date:From;
        b=Tahbn56MafbS5tYHohY1jeu1MNcnCOzqYFLUqAIj0uO2HxpWm1nztSATFOjWTCqrJ
         8KyWJzo+FHga4/jNDPLt8QcU2Nm7J5cqacqhbhGRX36QEJNBjMlolvgsf/ZfTpxYW7
         N04nqDee6QkTBTym76IL6hv3g4GpHk/65gk0fcfk=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 485B635D8;
        Thu, 20 Jul 2023 02:43:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689813840; bh=HB/obDH8IIPUi2im/fMggUWNUbBNLm3iHNuHkuuMxg8=;
        h=From:To:Cc:Subject:Date:From;
        b=fCUrbxqrPgHHqfYuLtlmWy9VZGJ3q6BrUqP1/yYqbn1FbhAiwhV59phb/gGQUJq76
         nxtH41C52jT33guq3UVjRnxRV9IyLPV8vkAjjPHNfafOF1FiizZ37ZGPVZoiSOItec
         QzckfY6Nx2bhhjJiHojFfvgAWA/v57GubAqfhWZ4=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 0/8] libata: remove references to 'old' error handler
Date:   Thu, 20 Jul 2023 02:42:41 +0200
Message-ID: <20230720004257.307031-1-nks@flawful.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hi all,

now that the ipr driver has been modified to not hook into libata
all drivers now use the 'new' error handler, so we can remove any
references to it. And do a general cleanup to remove callbacks
which are no longer needed.


Changes since v1:
-Rebased against Damien's libata for-next branch. (Fixed conflicts in
 ata_qc_complete().)
-Fixed comments from Damien.
-Fixed comments from myself.
-Do not dump all QCs unconditionally (which should make the performance
 regression reported by the test robot go away.)
-Since ata_dump_status() was only called for drivers without .error_handler
 callback, this function is now unused and unreachable, so it was removed.
-Since atapi_qc_complete() can no longer reach the "old EH" failure paths
 (code will now always take the top branch on error), they are removed.
-Since atapi_eh_request_sense() can no longer be called, it is now removed.
 (The atapi_eh_request_sense() version called by EH is still there.)
-Patch 7/8 and 8/8 are new in V2.


Hannes Reinecke (6):
  ata: remove reference to non-existing error_handler()
  ata,scsi: remove ata_sas_port_{start,stop} callbacks
  ata,scsi: remove ata_sas_port_destroy()
  ata: remove ata_sas_sync_probe()
  ata: inline ata_port_probe()
  ata,scsi: cleanup ata_port_probe()

Niklas Cassel (2):
  ata: sata_sx4: drop already completed TODO
  ata: remove ata_bus_probe()

 drivers/ata/libata-core.c          | 355 +++++++----------------------
 drivers/ata/libata-eh.c            | 150 +++++-------
 drivers/ata/libata-sata.c          |  77 -------
 drivers/ata/libata-scsi.c          | 142 +-----------
 drivers/ata/libata-sff.c           |  30 +--
 drivers/ata/libata.h               |   3 -
 drivers/ata/sata_sx4.c             |   1 -
 drivers/scsi/libsas/sas_ata.c      |   6 +-
 drivers/scsi/libsas/sas_discover.c |   2 +-
 include/linux/libata.h             |   6 +-
 10 files changed, 170 insertions(+), 602 deletions(-)

-- 
2.41.0

