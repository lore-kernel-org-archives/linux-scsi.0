Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2DECA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4E720679
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rJll4yvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405976AbfJWV4K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:10 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:53916 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405936AbfJWV4J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:09 -0400
Received: by mail-wm1-f46.google.com with SMTP id i13so515387wmd.3
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2reZ1oPdWCPytpJRKhUeiiRyT6O/ALezpDPrLcQPFhA=;
        b=rJll4yvhEOpCwu8hrHwdIEEJb0yeIBxnXre7ORwXR3dLVC6LNoh8USTXYBwZWu0MDR
         MR+bWwNDg5aL84hcLmglMdCGCcQlhwt99E+u2+A7d8SLgRfQZgXMj48jY5i+oyW3AxxI
         VOLYSTN6lKfCWerif6UQe5e4km8C6U3+brLpFtWDb+yuWKGFgcU8NwC4OI7/FC4jikwH
         OSvSP76QHkr5G0p1H1ybaUr5Qs/eBdz9jWqRDQm/+ZOU5n1UMZTr0Cuj2W2Ad4KpAbPH
         CjrdLaBUAsUtTjpNsccxzrZcdZ5VWSmoZ3rw9gOHI4AEvJr5AB7NCXRS9U7UEp61G30T
         TLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2reZ1oPdWCPytpJRKhUeiiRyT6O/ALezpDPrLcQPFhA=;
        b=pMatVO0UOz3V6p6vH34CcNqQ27ra71Ao23BKtwvUDlpGn1n8BgClhVqAjXv80re46D
         EA5UOhvrswcOFAyB/T5AzmfT25F6b2j+Pa4Zapuot41krTtqsUsm/kV2527DiUmYQkfM
         96wHXV9LJvSEQm/b2M7derQCV0uP3pQa9Jw9WtqXtxvvmymRzUBznlZXOxl7QKNXrbHB
         MRZVKFnKK05LaAxpuVFwvZFN/PpRdOI3j9pzUlMDtPp6Kue/uLnzgxPOZmT+oic3fnJX
         lQydeaGalqEcvZCdxYIxSGw7nzSblWwWwzE0J7/yW+ot4t6s8x9U67i6ApUK7jlbR73a
         NQAg==
X-Gm-Message-State: APjAAAUjbhBdFW4b1jY7VYvA6ifUOYJGG3Y2HfjXkya/aKG1r6Pt7H2D
        b+t+S1zW3eHL8mk/IveeOOcviiyn
X-Google-Smtp-Source: APXvYqzjwLmypQ3AVGp0PVD8WwMAypHHegBjnxSyzowrTS4uiObA+wDcBXZolf4PEdlt5AdUuE7qKQ==
X-Received: by 2002:a1c:a657:: with SMTP id p84mr1674926wme.35.1571867767003;
        Wed, 23 Oct 2019 14:56:07 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:06 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/32] [NEW] efct: Broadcom (Emulex) FC Target driver
Date:   Wed, 23 Oct 2019 14:55:25 -0700
Message-Id: <20191023215557.12581-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set is a request to incorporate the new Broadcom
(Emulex) FC target driver, efct, into the kernel source tree.

The driver source has been Announced a couple of times, the last
version on 12/18/2018. The driver has been hosted on gitlab for
review has had contributions from the community.
  gitlab (git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)

The driver integrates into the source tree at the (new) drivers/scsi/elx
subdirectory.

The driver consists of the following components:
- A libefc_sli subdirectory: This subdirectory contains a library that
  encapsulates common definitions and routines for an Emulex SLI-4
  adapter.
- A libefc subdirectory: This subdirectory contains a library of
  common routines. Of major import is a number of routines that
  implement a FC Discovery engine for target mode.
- An efct subdirectory: This subdirectory contains the efct target
  mode device driver. The driver utilizes the above librarys and
  plugs into the SCSI LIO interfaces. The driver is SCSI only at
  this time.

The patches populate the libraries and device driver and can only
be compiled as a complete set.

This driver is completely independent from the lpfc device driver
and there is no overlap on PCI ID's.

The patches have been cut against the 5.5/scsi-queue branch.

Thank you to those that have contributed to the driver in the past.

Review comments welcome!

-- james


James Smart (32):
  elx: libefc_sli: SLI-4 register offsets and field definitions
  elx: libefc_sli: SLI Descriptors and Queue entries
  elx: libefc_sli: Data structures and defines for mbox commands
  elx: libefc_sli: queue create/destroy/parse routines
  elx: libefc_sli: Populate and post different WQEs
  elx: libefc_sli: bmbx routines and SLI config commands
  elx: libefc_sli: APIs to setup SLI library
  elx: libefc: Generic state machine framework
  elx: libefc: Emulex FC discovery library APIs and definitions
  elx: libefc: FC Domain state machine interfaces
  elx: libefc: SLI and FC PORT state machine interfaces
  elx: libefc: Remote node state machine interfaces
  elx: libefc: Fabric node state machine interfaces
  elx: libefc: FC node ELS and state handling
  elx: efct: Data structures and defines for hw operations
  elx: efct: Driver initialization routines
  elx: efct: Hardware queues creation and deletion
  elx: efct: RQ buffer, memory pool allocation and deallocation APIs
  elx: efct: Hardware IO and SGL initialization
  elx: efct: Hardware queues processing
  elx: efct: Unsolicited FC frame processing routines
  elx: efct: Extended link Service IO handling
  elx: efct: SCSI IO handling routines
  elx: efct: LIO backend interface routines
  elx: efct: Hardware IO submission routines
  elx: efct: link statistics and SFP data
  elx: efct: xport and hardware teardown routines
  elx: efct: IO timeout handling routines
  elx: efct: Firmware update, async link processing
  elx: efct: scsi_transport_fc host interface support
  elx: efct: Add Makefile and Kconfig for efct driver
  elx: efct: Tie into kernel Kconfig and build process

 MAINTAINERS                            |    8 +
 drivers/scsi/Kconfig                   |    2 +
 drivers/scsi/Makefile                  |    1 +
 drivers/scsi/elx/Kconfig               |    8 +
 drivers/scsi/elx/Makefile              |   30 +
 drivers/scsi/elx/efct/efct_driver.c    | 1243 +++++
 drivers/scsi/elx/efct/efct_driver.h    |  154 +
 drivers/scsi/elx/efct/efct_els.c       | 2676 +++++++++++
 drivers/scsi/elx/efct/efct_els.h       |  139 +
 drivers/scsi/elx/efct/efct_hw.c        | 7866 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h        | 1275 ++++++
 drivers/scsi/elx/efct/efct_hw_queues.c | 1964 ++++++++
 drivers/scsi/elx/efct/efct_hw_queues.h |   66 +
 drivers/scsi/elx/efct/efct_io.c        |  288 ++
 drivers/scsi/elx/efct/efct_io.h        |  219 +
 drivers/scsi/elx/efct/efct_lio.c       | 2643 +++++++++++
 drivers/scsi/elx/efct/efct_lio.h       |  371 ++
 drivers/scsi/elx/efct/efct_scsi.c      | 1970 ++++++++
 drivers/scsi/elx/efct/efct_scsi.h      |  401 ++
 drivers/scsi/elx/efct/efct_unsol.c     | 1156 +++++
 drivers/scsi/elx/efct/efct_unsol.h     |   49 +
 drivers/scsi/elx/efct/efct_utils.c     |  662 +++
 drivers/scsi/elx/efct/efct_utils.h     |  113 +
 drivers/scsi/elx/efct/efct_xport.c     | 1728 +++++++
 drivers/scsi/elx/efct/efct_xport.h     |  216 +
 drivers/scsi/elx/include/efc_common.h  |   44 +
 drivers/scsi/elx/libefc/efc.h          |  188 +
 drivers/scsi/elx/libefc/efc_device.c   | 1977 ++++++++
 drivers/scsi/elx/libefc/efc_device.h   |   72 +
 drivers/scsi/elx/libefc/efc_domain.c   | 1393 ++++++
 drivers/scsi/elx/libefc/efc_domain.h   |   57 +
 drivers/scsi/elx/libefc/efc_fabric.c   | 2252 +++++++++
 drivers/scsi/elx/libefc/efc_fabric.h   |  116 +
 drivers/scsi/elx/libefc/efc_lib.c      |  263 ++
 drivers/scsi/elx/libefc/efc_node.c     | 1878 ++++++++
 drivers/scsi/elx/libefc/efc_node.h     |  196 +
 drivers/scsi/elx/libefc/efc_sm.c       |  275 ++
 drivers/scsi/elx/libefc/efc_sm.h       |  171 +
 drivers/scsi/elx/libefc/efc_sport.c    | 1157 +++++
 drivers/scsi/elx/libefc/efc_sport.h    |   52 +
 drivers/scsi/elx/libefc/efclib.h       |  796 ++++
 drivers/scsi/elx/libefc_sli/sli4.c     | 7522 ++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h     | 4845 ++++++++++++++++++++
 43 files changed, 48502 insertions(+)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
 create mode 100644 drivers/scsi/elx/efct/efct_els.c
 create mode 100644 drivers/scsi/elx/efct/efct_els.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.h
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h
 create mode 100644 drivers/scsi/elx/efct/efct_lio.c
 create mode 100644 drivers/scsi/elx/efct/efct_lio.h
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.h
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h
 create mode 100644 drivers/scsi/elx/efct/efct_utils.c
 create mode 100644 drivers/scsi/elx/efct/efct_utils.h
 create mode 100644 drivers/scsi/elx/efct/efct_xport.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.h
 create mode 100644 drivers/scsi/elx/include/efc_common.h
 create mode 100644 drivers/scsi/elx/libefc/efc.h
 create mode 100644 drivers/scsi/elx/libefc/efc_device.c
 create mode 100644 drivers/scsi/elx/libefc/efc_device.h
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.h
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.c
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.h
 create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sport.h
 create mode 100644 drivers/scsi/elx/libefc/efclib.h
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h

-- 
2.13.7

