Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64B1C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC0864F1E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbhCDM2e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:28:34 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:40444 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240478AbhCDM2D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 07:28:03 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2021 07:28:02 EST
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 9B48422565;
        Thu,  4 Mar 2021 04:19:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9B48422565
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1614860395;
        bh=cNp3e06wPZ7e8aq644Ukouz3uEU6eR5XZ/CCS2oSZx4=;
        h=From:To:Cc:Subject:Date:From;
        b=iVi2YjhAV+UzmhqrXh1nwmPJkl27Ovx8ugmjrozF/tBG1YYKY3gPFWsLM7jAGq6g0
         pXopgOiDJ2xqQOxDOJ7gRovsKOANC4/hRKtHoXfakvoMs61TRx7j4HFTj5HV1SRyY5
         BOOWEFB4ET4PmxN30nqpgQ4UDICYi7FwWowUyPRM=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [PATCH v8 00/16] blkcg:Support to track FC storage blk io traffic
Date:   Thu,  4 Mar 2021 10:57:10 +0530
Message-Id: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This Patch added a unique application identifier i.e
app_id  knob to  blkcg which allows identification of traffic
sources at an individual cgroup based Applications
(ex:virtual machine (VM))level in both host and
fabric infrastructure.

Added a new sysfs attribute appid_store to set the application identfier
in  the blkcg associted with cgroup id under
/sys/class/fc/fc_udev_device/*

With this new interface the user can set the application identfier
in  the blkcg associted with cgroup id.

This capability can be utilized by multiple block transport infrastructure
like fc,iscsi,roce.

Existing FC fabric will use this feature and the description of
the use case is below.

Various virtualization technologies used in Fibre Channel
SAN deployments have created the opportunity to identify
and associate traffic with specific virtualized applications.
The concepts behind the T11 Application Services standard is
to provide the general mechanisms needed to identify
virtualized services.
It enables the Fabric and the storage targets to
identify, monitor, and handle FC traffic
based on vm tags by inserting application specific identification
into the FC frame.

The patches were cut against  5.12/scsi-queue tree

v8:
Modified the structure member,log messages and function declarations
Added proper error codes and return values

v7:
Modified the Kconfig comments

v6:
Addressed the issues reported by kernel test robot
Modified the Kconfig files as per standard

v5:
Renamed the function cgroup_get_from_kernfs_id to
cgroup_get_from_id.

Moved the input validation at the beginning of the function in 
Renamed the arguments appropriatley.

Changed Return code to non-numeric/SymbolChanged Return code
to non-numeric/Symbol

Modified the comments.

v4:
Addressed the error reported by  kernel test robot

v3:
removed RFC.

Renamed the functions and app_id to more specific
Addressed the reference leaks in blkcg_set_app_identifier
Added a new config BLK_CGROUP_FC_APPID and made changes to 
select the same under SCSI_FC_ATTRS

V2:
renamed app_identifier to app_id.
removed the  sysfs interface blkio.app_identifie under
/sys/fs/cgroup/blkio
Ported the patch on top of 5.10/scsi-queue.
Removed redundant code due to changes since last submit.
Added a fix for issuing QFPA command.



Gaurav Srivastava (12):
  lpfc: vmid: Add the datastructure for supporting VMID in lpfc
  lpfc: vmid: Supplementary data structures for vmid and APIs
  lpfc: vmid: Forward declarations for APIs
  lpfc: vmid: VMID params initialization
  lpfc: vmid: Add support for vmid in mailbox command, does vmid
    resource allocation and vmid cleanup
  lpfc: vmid: Implements ELS commands for appid patch
  lpfc: vmid: Functions to manage vmids
  lpfc: vmid: Implements CT commands for appid.
  lpfc: vmid: Appends the vmid in the wqe before sending
  lpfc: vmid: Timeout implementation for vmid
  lpfc: vmid: Adding qfpa and vmid timeout check in worker thread
  lpfc: vmid: Introducing vmid in io path.

Muneendra (4):
  cgroup: Added cgroup_get_from_id
  blkcg: Added a app identifier support for blkcg
  nvme: Added a newsysfs attribute appid_store
  scsi: Made changes in Kconfig to select BLK_CGROUP_FC_APPID

 block/Kconfig                    |   9 +
 drivers/nvme/host/fc.c           |  73 ++++++-
 drivers/scsi/Kconfig             |  13 ++
 drivers/scsi/lpfc/lpfc.h         | 121 ++++++++++
 drivers/scsi/lpfc/lpfc_attr.c    |  47 ++++
 drivers/scsi/lpfc/lpfc_crtn.h    |  11 +
 drivers/scsi/lpfc/lpfc_ct.c      | 249 ++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_disc.h    |   1 +
 drivers/scsi/lpfc/lpfc_els.c     | 364 ++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 153 +++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h      | 124 ++++++++++-
 drivers/scsi/lpfc/lpfc_hw4.h     |  12 +
 drivers/scsi/lpfc/lpfc_init.c    | 106 +++++++++
 drivers/scsi/lpfc/lpfc_mbox.c    |   6 +
 drivers/scsi/lpfc/lpfc_scsi.c    | 337 ++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c     |  63 ++++++
 drivers/scsi/lpfc/lpfc_sli.h     |   8 +
 include/linux/blk-cgroup.h       |  56 +++++
 include/linux/cgroup.h           |   6 +
 kernel/cgroup/cgroup.c           |  26 +++
 20 files changed, 1775 insertions(+), 10 deletions(-)

-- 
2.26.2

