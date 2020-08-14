Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7147DC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 16:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13BC2207DA
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 16:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="iI8H0DkK";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="sCwH9e6a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHNQjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 12:39:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54860 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgHNQji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Aug 2020 12:39:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 24EE18EE1F3;
        Fri, 14 Aug 2020 09:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597423178;
        bh=1GeTo5+kI1ZRhYo/3Dw/Az7CcWr7NSXW8xvPXgcpISU=;
        h=Subject:From:To:Cc:Date:From;
        b=iI8H0DkK++J37msJ9f6ACFP7e1R+IODPSjhA8pUglwnGcp7EoF2M9319bJgwM/Ite
         I28WzqEZnaXza1FcndALl9dOzinw2uIH1Ij4URNyeoloejjaW2pIiTt8HyZroWUWUL
         R9W8mEB2NSminaRLx4C8rWueOa/k5SQanSfl4kQ8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nngdI4FgmOnG; Fri, 14 Aug 2020 09:39:38 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 9F5588EE0E4;
        Fri, 14 Aug 2020 09:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597423177;
        bh=1GeTo5+kI1ZRhYo/3Dw/Az7CcWr7NSXW8xvPXgcpISU=;
        h=Subject:From:To:Cc:Date:From;
        b=sCwH9e6aAh50PKxfabdr/J/CWbC/3CWTHrBKiSRKmNFfte003LOMJu95qtA0D683w
         puVfzTz+s31X6NW8prOQbWHEIsHEXwB47xrt6Wcf1dPCBakOfX6fgY4qwXAvQiXASk
         621a1HPxLMu8MDW4eH0eazQ7fF7fLdsWzumZKqiM=
Message-ID: <1597423176.3916.19.camel@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 5.8+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 14 Aug 2020 09:39:36 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the set of patches which arrived too late to stabilise in -next
for the first pull.  It's really just an lpfc driver update and an
assortment of minor fixes, all in drivers.  The only core update is to
the zone block device driver, which isn't the one most people use.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Damien Le Moal (1):
      scsi: sd_zbc: Improve zone revalidation

Dick Kennedy (8):
      scsi: lpfc: Update lpfc version to 12.8.0.3
      scsi: lpfc: Fix LUN loss after cable pull
      scsi: lpfc: Fix validation of bsg reply lengths
      scsi: lpfc: Fix retry of PRLI when status indicates its unsupported
      scsi: lpfc: Fix oops when unloading driver while running mds diags
      scsi: lpfc: Fix RSCN timeout due to incorrect gidft counter
      scsi: lpfc: Fix no message shown for lpfc_hdw_queue out of range value
      scsi: lpfc: Fix FCoE speed reporting

Ewan D. Milne (1):
      scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport

Javed Hasan (2):
      scsi: libfc: Free skb in fc_disc_gpn_id_resp() for valid cases
      scsi: fcoe: Memory leak fix in fcoe_sysfs_fcf_del()

Jing Xiangfeng (1):
      scsi: lpfc: Add missing misc_deregister() for lpfc_init()

Max Gurtovoy (1):
      scsi: target: Make iscsit_register_transport() return void

Xiang Chen (1):
      scsi: scsi_transport_sas: Add spaces around binary operator "|"

And the diffstat:

 drivers/scsi/fcoe/fcoe_ctlr.c                 |  2 +-
 drivers/scsi/libfc/fc_disc.c                  | 12 +++-
 drivers/scsi/lpfc/lpfc_attr.c                 | 26 +++++++-
 drivers/scsi/lpfc/lpfc_bsg.c                  | 21 +++---
 drivers/scsi/lpfc/lpfc_ct.c                   | 22 +++++--
 drivers/scsi/lpfc/lpfc_els.c                  | 10 ++-
 drivers/scsi/lpfc/lpfc_init.c                 | 25 +++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c            |  8 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c                |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c                  | 11 +++-
 drivers/scsi/lpfc/lpfc_version.h              |  2 +-
 drivers/scsi/scsi_transport_sas.c             |  2 +-
 drivers/scsi/sd.c                             | 10 ++-
 drivers/scsi/sd.h                             | 11 +++-
 drivers/scsi/sd_zbc.c                         | 93 +++++++++++++--------------
 drivers/target/iscsi/iscsi_target_transport.c |  4 +-
 include/target/iscsi/iscsi_transport.h        |  2 +-
 17 files changed, 165 insertions(+), 98 deletions(-)

James

