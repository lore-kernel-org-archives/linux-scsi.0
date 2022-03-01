Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA58AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 14:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiCAOiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 09:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiCAOiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 09:38:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339F026DB
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 06:37:32 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E32562198B;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646145450; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tsCg8/M76Lvg4C53MRCAIcx08qnwP7LQoVfF8oXjyqk=;
        b=WEHMgQHRGQRLUs6XGBPqEHvBARrRpCrx0KCZiuu8RVclb+JRxmK8xXz5Anv3dBUSc+2MVL
        L20WB0mZ2bhyehhFdZ6uzNI4e7PpCUGoXW+ZcnoL7yegfc6tIDCem1rMy96oesnBYtPULg
        ku9ib/uDkPy5ZBet559F4gDWT516XfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646145450;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=tsCg8/M76Lvg4C53MRCAIcx08qnwP7LQoVfF8oXjyqk=;
        b=/47gqzKcxjrY9erQGbiQUoyBXPF6nsDtat0pILioRhbFSUd1IE1chHHhDTExWg/UPDu6Fq
        wU4ahiOHsxbQyIDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C7C7BA3B95;
        Tue,  1 Mar 2022 14:37:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9586251933C6; Tue,  1 Mar 2022 15:37:30 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] lpfc: fixes for EH rework
Date:   Tue,  1 Mar 2022 15:37:13 +0100
Message-Id: <20220301143718.40913-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

in preparation to the SCSI EH rework here's a bunch of patches to
the lpfc driver to make the conversion easier.

As usual, comments and reviews are welcome.

Hannes Reinecke (5):
  lpfc: kill lpfc_bus_reset_handler
  lpfc: drop lpfc_no_handler()
  lpfc: use fc_block_rport()
  lpfc: use rport as argument for lpfc_send_taskmgmt()
  lpfc: use rport as argument for lpfc_chk_tgt_mapped()

 drivers/scsi/lpfc/lpfc_scsi.c | 141 ++++++----------------------------
 1 file changed, 22 insertions(+), 119 deletions(-)

-- 
2.29.2

