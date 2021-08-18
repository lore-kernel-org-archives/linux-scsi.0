Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02403C432BE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC53C60FDA
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 09:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhHRJKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 05:10:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37044 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhHRJJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 05:09:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A136722035;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629277711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iCuRTAJuCnJmxJ2CmYiNmjgFiivUSPgIfbx8V0CS6Kw=;
        b=ZBQ+iCsw7nyb0o3sU7tiIISt0t4P65WsPD6Zs1TUGHFIgpfqbIcA19C6Nyjm88EugK8ln+
        JjYkpxyVz6Kvk1nxdRLNhq4C+b5sv6wsCB//Ng3u8m0VIvyF42HprkmK1MqLZ+O3H8Pts7
        VDaig4gWGOjBFKUSTlQJYZcV1ENpugc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629277711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iCuRTAJuCnJmxJ2CmYiNmjgFiivUSPgIfbx8V0CS6Kw=;
        b=iXPAaI0Edzlo/8lqAvY2z0EU322Q6FRuxhSSeKiBCzbhT5vjcLuIbxl4bsBZ+pqutyHIP7
        RtQQ3DZvrO8fPvBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 94C7CA3B96;
        Wed, 18 Aug 2021 09:08:31 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 81436518CF54; Wed, 18 Aug 2021 11:08:31 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] lpfc: fixes for SCSI EH rework
Date:   Wed, 18 Aug 2021 11:08:22 +0200
Message-Id: <20210818090827.134342-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

with the SCSI EH rework the scsi_cmnd argument for the SCSI EH callbacks
is going away, so we need to fixup the drivers to work without it.

This patchset modifies the lpfc driver to not rely on a specific command
for the EH callbacks.

As usual, comments and reviews are welcome.


Hannes Reinecke (5):
  lpfc: kill lpfc_bus_reset_handler
  lpfc: drop lpfc_no_handler()
  lpfc: use fc_block_rport()
  lpfc: use rport as argument for lpfc_send_taskmgmt()
  lpfc: use rport as argument for lpfc_chk_tgt_mapped()

 drivers/scsi/lpfc/lpfc_scsi.c | 138 +++++-----------------------------
 1 file changed, 20 insertions(+), 118 deletions(-)

-- 
2.29.2

