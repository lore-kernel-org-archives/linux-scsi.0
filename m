Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCD3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiCAOkz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiCAOkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:40:45 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EA726DB
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:40:04 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E76861F440;
        Tue,  1 Mar 2022 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=piYrIQmNscs5s/kT3iC+a4RIvDMLFq2fFH4L2utrB58=;
        b=whMHFQ4IVG9CNYq/juE7ex+I1JsgGbpW6onguk/bPEPM5mZqXC5jazSoB3GXJHdSjOy9X4
        PQKT44xMM3rIQTnNxCDJHkWwX6hBCRl5PeKAkOPP+h0xxTPQ1PjrvtUiQTMsXwNXcT9saw
        guCn1THqAnVNxVdoRzCLq/ivYYNvwYM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145602;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=piYrIQmNscs5s/kT3iC+a4RIvDMLFq2fFH4L2utrB58=;
        b=XhhSWZLogJaHzFeFO2pyWBostawd9+92GRvW9RkdEXZ/DSGcKerO8F6yUzjrOFfrHv6nUx
        8AmH0K8+x4lw+EAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DC8C1A3B8A;
        Tue,  1 Mar 2022 14:40:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C919151933D2; Tue,  1 Mar 2022 15:40:02 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] aic7xxx/aic79xx: fixes for SCSI EH rework
Date:   Tue,  1 Mar 2022 15:39:53 +0100
Message-Id: <20220301143957.40998-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

here's a set of patches for the aic7xxx/aic79xx driver to make the
conversion for the SCSI EH rework easier.

As usual, comments and reviews welcome.

Hannes Reinecke (4):
  aic7xxx: use scsi device as argument for BUILD_SCSIID()
  aic79xx: use scsi device as argument for BUILD_SCSIID()
  aic7xxx: do not reference scsi command when resetting device
  aic79xx: do not reference scsi command when resetting device

 drivers/scsi/aic7xxx/aic79xx_osm.c |  29 +++++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 112 +++++++++++++++--------------
 2 files changed, 78 insertions(+), 63 deletions(-)

-- 
2.29.2

