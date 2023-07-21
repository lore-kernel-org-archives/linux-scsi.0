Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A62C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjGUQeq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjGUQed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:34:33 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B834F3AB6;
        Fri, 21 Jul 2023 09:33:54 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b743161832so31314741fa.1;
        Fri, 21 Jul 2023 09:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689957205; x=1690562005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:dkim-signature:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+5Ukit2FxcxgjHkUY+QbDH5w+IxYlIfRyHm82V8uec=;
        b=Q39l2eKbnb4bKRrccYeIw8M5cruOCW1qmp6yBeSDcOB4+bp8OYHg0ZVoT48SbZrqMQ
         yzooZ9qqTYt/rw7QLtkUe4m+kOjff89cst6XrkBOmSwRLX0YH/bh/ERlik3W2cVhs0wa
         7+89mNnuahwT6GiMIF7toVqXxsdE7QP7YMnPKWdnayHrFE/PDN1NWYtTpD9Ack8VBdQj
         lWFX3Q8wvHaJm9NkeOyxWj80SaZ3y2+zlOH7947qIU/TFxmG91saDUkPatEtCz1PnG8Q
         FkOimJ3Ns65T03DcSagCMZt034dHRTjQ4FXImwwUbT5rQZMBqFvxB2imV4MaFxhPPyTg
         2LCw==
X-Gm-Message-State: ABy/qLY14Z8av5xpls1F0lddBcYmYaqTu5ni4A0IcPbfGGleduUglzZz
        Y31n9ia8496nXpYoyxafXfnnS3cyb0kPUA==
X-Google-Smtp-Source: APBJJlHf1l1ZLxwEZmRg7cHHrXpQOpf6fwl/G+MJb0ZISOlLpWVSJav3MsD1ue9mJ9hNFMug1ADu1Q==
X-Received: by 2002:a2e:b008:0:b0:2b6:ce35:2e9e with SMTP id y8-20020a2eb008000000b002b6ce352e9emr1969589ljk.44.1689957204835;
        Fri, 21 Jul 2023 09:33:24 -0700 (PDT)
Received: from flawful.org (c-f5f0e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.240.245])
        by smtp.gmail.com with ESMTPSA id e7-20020a2e8ec7000000b002b6ece2456csm1009196ljl.121.2023.07.21.09.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:33:24 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 789C33F57; Fri, 21 Jul 2023 18:33:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957203; bh=IcQXzCMZzGegOEzqm5XLHIAK+6jYi9nCTuu4TpnQApE=;
        h=From:To:Cc:Subject:Date:From;
        b=dhVhW3AlonK3565XUJ1UAq7HPVWRzknJYcaJd65hmG9jUft/4lZBR0qphqhlXz6Ke
         bOjcHdln+gwtChgvTSxUVR2VOZZLEsXYL9fV2nXlCWjRynPzBgExTVbigCtooJ1/wM
         6K25MWd2+ZITY+r+Ji28mrvP/qTN8h+En3i0F/qw=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 18E683F16;
        Fri, 21 Jul 2023 18:32:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1689957169; bh=IcQXzCMZzGegOEzqm5XLHIAK+6jYi9nCTuu4TpnQApE=;
        h=From:To:Cc:Subject:Date:From;
        b=qmzNXZjH1eP/dm9bcXvNimEeJDtL2439cA0ftKI5uEOiOC71CMZmV2YieTW1Bu5qK
         ovyZforzqsK3241/3la2fMuftrtvxK3hg517+8x8qvMNjofO/2lqfHGOkfW59SXKM4
         NTnLEv6QDH0LjIGMHU2yHVJJkZbTJXEfs4aB/AUE=
From:   Niklas Cassel <nks@flawful.org>
To:     Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 0/9] libata: remove references to 'old' error handler
Date:   Fri, 21 Jul 2023 18:32:11 +0200
Message-ID: <20230721163229.399676-1-nks@flawful.org>
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


Changes since v2:
-Fixed comments from John, thank you John!
-Fixed comments from Jason, thank you Jason!
-Patch 9/9 which actually removed the old eh callbacks from
 struct ata_port_operations is new in V3.
-Updated the documentation to remove references to functions
 that do no longer exist.
-Updated documentation to be in line with the current libata
 EH code.


Hannes Reinecke (6):
  ata: remove reference to non-existing error_handler()
  ata,scsi: remove ata_sas_port_{start,stop} callbacks
  ata,scsi: remove ata_sas_port_destroy()
  ata: remove ata_sas_sync_probe()
  ata: inline ata_port_probe()
  ata,scsi: cleanup __ata_port_probe()

Niklas Cassel (3):
  ata: sata_sx4: drop already completed TODO
  ata: remove ata_bus_probe()
  ata: remove deprecated EH callbacks

 Documentation/driver-api/libata.rst |  38 +--
 drivers/ata/libata-core.c           | 355 +++++++---------------------
 drivers/ata/libata-eh.c             | 152 +++++-------
 drivers/ata/libata-sata.c           |  77 ------
 drivers/ata/libata-scsi.c           | 161 +------------
 drivers/ata/libata-sff.c            |  30 +--
 drivers/ata/libata.h                |   3 -
 drivers/ata/pata_sl82c105.c         |   3 +-
 drivers/ata/sata_sx4.c              |   1 -
 drivers/scsi/libsas/sas_ata.c       |   6 +-
 drivers/scsi/libsas/sas_discover.c  |   2 +-
 include/linux/libata.h              |  15 +-
 12 files changed, 181 insertions(+), 662 deletions(-)

-- 
2.41.0

