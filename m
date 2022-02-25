Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B249EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbiBYCXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232653AbiBYCXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:23:49 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE54C1C664D
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s1so3525442plg.12
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wtzy2wQF1GXEbk3QiEBW75ykaSjDDSfTJP8VORvM7rw=;
        b=jWHJGbv/Ny5dZ1D47QWERuw3ACK7Dog2vNH5+tWC9obiBIm6z0F2WLLbw6ijDw2GsO
         ZsmdL90Vzh7zz+ZkIi3omHnWmez0PKHNZIKJSw6ntoWwlfNiJn7MNJmaodlGD9gKMeXr
         qZ9io+X1kX8qoDknU8Pweul7N4Nv3by4mrh63HZciRXDBmDE/o6hIYieXJXzWuaDIfkZ
         8Rpn38yd7Vj2Z4NhkLtQudLpzadANAHzZ21CjOnrSuhSSQcS4KyGuFnClQlCUj97tsw/
         a3CSl3bGO8oSQt1dG5tDzBVBeJEfgVVQzzET0QtOgBJ4jXRwZwPpsPb1QR+okj53CedB
         d6mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wtzy2wQF1GXEbk3QiEBW75ykaSjDDSfTJP8VORvM7rw=;
        b=MNx7lTaaVL6ps8eYPXbQWreJVTV9Ut1WQgem4/gPp/nQh+c7uJ/bFAcmNIWAlXiGts
         nX/Sgz3POg02ZRa0l71u5kdaGhE7Jmf0CTlUTgVQbk8ouE+PJeCX2Une0p0Dv4R61XBC
         GJTz8Kz18WNjCUOKjVoJzEb13bBmrFPf9GyejPGoLq5eU1AD/YL4+Dck7J/ZuBKwKMlg
         KNPr2/mE3K7tNlSwZE2NEMcmsYI2Gpy5/TEvZnS9nB8a+Fmw4t236RPynFziEWJpEpno
         1yn1Yk8TXqyv6oQRxV99d3kuMrHhgYICKS2DoVS+1raX4+/DIS4aiKM9aHiq9aGH4KPS
         ArTA==
X-Gm-Message-State: AOAM530yUhOWQJ1THM6js9wpOjsls3Bu5lLAeid2n9BoNN7O0kGwADyD
        p78bM3RYS8nvPN8VrgXrhepVH3DTzyE=
X-Google-Smtp-Source: ABdhPJyn7GSOFk9AmhSEYpWEQsP9rVmofeflKsOffnnZmMl6+SWrEMvb0slfhmvBy7yd5QZiA26s5g==
X-Received: by 2002:a17:90a:8595:b0:1bb:fbfd:bfbf with SMTP id m21-20020a17090a859500b001bbfbfdbfbfmr971266pjn.125.1645755797333;
        Thu, 24 Feb 2022 18:23:17 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:17 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/17] lpfc: Update lpfc to revision 14.2.0.0
Date:   Thu, 24 Feb 2022 18:22:51 -0800
Message-Id: <20220225022308.16486-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.0

This patch set is a refactoring of the lpfc driver.

The lpfc driver was first implemented for sli-3 then had sli-4 added
to it. The addition of sli-4 was done in a manner where the sli-3 paths
were left in place with sli-3 structures converted to sli-4 when written
to the adapter. Similar behavior for responses. Over time we've been hit
with subtle sli3 vs sli4 structure formats issues, bits defined on sli3
that aren't on sli4 or vice versa, that the driver wasn't careful about.
The subtleties caused bogus settings to be passed when the eventually
overlapped, or expected values that never we set by the hw.

Given that all sli-3 hardware is now end of life (last sli3 adapter is 
~10 yrs old) we'd like to move the implementation of the driver such that
it uses sli-4 as its native path and kills the "translation" layer. Sli-3
is still supported, but we're trying to move away from the sli-3 data
structures that dominated the implementation and instead move to a more
generic structure, and hopefully do so without huge amounts of code change
for what in some respects would be naming deltas.

This patch refactors the driver to make the fast and slow paths now work
on native sli-4 datastructures. Common areas or items change their names
to make it clear they aren't sli-3 centric. Generic access functions to
get/set common fields were created abstract the structure deltas. The
different code paths were then reworked to use the generic names/routines
and where rev-specific data was to be set, add explicit sections to set
the items based on the revision. In this way, no translation occurs and
any rev-spec delta is very clear.  In performing this, some of the
checking or case logic varied a little, and some code cleanups were
performed.

The patches were cut against Martin's 5.17/scsi-fixes tree


James Smart (17):
  lpfc: SLI path split: refactor lpfc_iocbq
  lpfc: SLI path split: refactor fast and slow paths to native sli4
  lpfc: SLI path split: introduce lpfc_prep_wqe
  lpfc: SLI path split: refactor base els paths and the FLOGI path
  lpfc: SLI path split: refactor PLOGI/PRLI/ADISC/LOGO paths
  lpfc: SLI path split: refactor the RSCN/SCR/RDF/EDC/FARPR paths
  lpfc: SLI path split: refactor LS_ACC paths
  lpfc: SLI path split: refactor LS_RJT paths
  lpfc: SLI path split: refactor FDISC paths
  lpfc: SLI path split: refactor VMID paths
  lpfc: SLI path split: refactor misc ELS paths
  lpfc: SLI path split: refactor CT paths
  lpfc: SLI path split: refactor SCSI paths
  lpfc: SLI path split: refactor Abort paths
  lpfc: SLI path split: refactor BSG paths
  lpfc: Update lpfc version to 14.2.0.0
  lpfc: Copyright updates for 14.2.0.0 patches

 drivers/scsi/lpfc/lpfc.h           |   98 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |  349 ++--
 drivers/scsi/lpfc/lpfc_crtn.h      |   22 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  346 ++--
 drivers/scsi/lpfc/lpfc_els.c       | 1513 +++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   46 +-
 drivers/scsi/lpfc/lpfc_hw.h        |   16 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |   38 +-
 drivers/scsi/lpfc/lpfc_init.c      |   13 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  104 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |   41 +-
 drivers/scsi/lpfc/lpfc_nvme.h      |    8 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |   85 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  457 ++---
 drivers/scsi/lpfc/lpfc_sli.c       | 2831 +++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.h       |   31 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |    2 +-
 drivers/scsi/lpfc/lpfc_version.h   |    6 +-
 18 files changed, 3146 insertions(+), 2860 deletions(-)

-- 
2.26.2

