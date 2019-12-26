Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0104EC2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C26012075E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EyQtu7qn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfLZLNt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:13:49 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:36751 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZLNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 06:13:49 -0500
Received: by mail-wm1-f44.google.com with SMTP id p17so5860145wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 03:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/3JfgW9qnSRBC+UeM5G+ajSObgoQhYIjUGm6MCb8PYM=;
        b=EyQtu7qnhw9BXOTR+lH5i1QpbQJTEOSwlDQWWQQiqnrmpvjPlfRmWwvIRdQUfFtNRM
         4qxThxdMlFOJWXE4pcP4qS3KsHrOLNYb4KhbzGUUZlZeTLIyuUTG46f4EGgCLQehJoLN
         LQ+XNPCwFaWNjqMvtsB7Fxdy4PA4q5RKN/VTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/3JfgW9qnSRBC+UeM5G+ajSObgoQhYIjUGm6MCb8PYM=;
        b=RbdZh6It/TOqLtXzKHLwr9R8ManGHK/fbkzBwaEPYR5HJ6f6CDwen+7FIkJGNU2MZf
         szOa8AMzCuU4wDTU/AqHoxQC3xm1l2N4quzPmlljsDnsyPE2qEIbmU6Mo7o2Yx6HjSHH
         LWzlPSbwxpk2IyJr3eN7XnTFDz2z/0Dwr6jcuD+nLB85MjWOh0MY1s1hL1f9FfRuGf16
         7VRfebvqedok/iIK11lDxAy8d0xYeJV++yGOrq5fg29nCZwFMOdJXwgbxsXrtQx0BdZr
         +DGXx+2vUMuVk6bGSo1KwLaf97j1MhC/XlBl4y3oq2hiVUeMavTYN/SAhWXO2EOSd+ji
         vHoQ==
X-Gm-Message-State: APjAAAVTsE6kOkMIjO8L9iz2iStGNx6lL1oMqQeXRgDYCra57jRCnOBk
        WrbaejZ6AcwbrPOfa/9XqWKg1TPfi9YW2voNfsLT32ieR59xjyA2QNPleLti5YJfkuiqg4OHumO
        0KM5AUYfjBsPSCFmT1fco8nxeyP0G55Fs7Mn1X0juOf1UZPK/ULsFi/mff/ay/Rjiv+CU7mum6r
        unOBZiz0Ap
X-Google-Smtp-Source: APXvYqyTs64Mbqp3ANIAboUE7e40EuARmBruHQO99MVAn9y2LxybogYIhLUaOPEsgx+AiqBHJmgxAA==
X-Received: by 2002:a7b:c936:: with SMTP id h22mr13057062wml.115.1577358826569;
        Thu, 26 Dec 2019 03:13:46 -0800 (PST)
Received: from dhcp-10-123-20-125.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id u8sm7957966wmm.15.2019.12.26.03.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 03:13:45 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH v1 00/10] mpt3sas: Enhancements of phase14
Date:   Thu, 26 Dec 2019 06:13:23 -0500
Message-Id: <20191226111333.26131-1-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.18.2
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Below are the main features are added in this patch set.

* Add support for NVMe shutdown operation. Where driver
issues IO Unit Control Shutdown message to Firmware during
system shutdown to inform that shutdown operation has
initiated. SO that Firmware issue NVMe shutdown command
to NVMe drives attached to it.

* Add support for new IOC state named 'CoreDump'. Once
driver detects this new state then driver has stop sending
any new requests and has wait for firmware to change the
IOC state from CoreDump to Fault State. In CoreDump state
Firmware will copy its logs to CoreDump flash region.

* Optimize the driver logging so that most of the important
information will be captured in the first instance of failure
logs itself with default logging level.

v1 change set:
 Update patch2 by initializing the update_latency to zero in
  _scsih_pcie_device_remove() function.


Suganath Prabu S (10):
  mpt3sas: Update MPI Headers to v02.00.57
  mpt3sas: Add support for NVMe shutdown.
  mpt3sas: renamed _base_after_reset_handler function
  mpt3sas: Add support IOCs new state named COREDUMP
  mpt3sas: Handle CoreDump state from watchdog thread
  mpt3sas: print in which path firmware fault occurred
  mpt3sas: Optimize mpt3sas driver logging.
  mpt3sas: Print function name in which cmd timed out
  mpt3sas: Remove usage of device_busy counter
  mpt3sas: Update drive version to 33.100.00.00

 drivers/scsi/mpt3sas/mpi/mpi2.h          |   6 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  19 +-
 drivers/scsi/mpt3sas/mpi/mpi2_image.h    |   7 +
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 340 ++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  45 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  39 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  46 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 222 +++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  11 +-
 10 files changed, 594 insertions(+), 149 deletions(-)

-- 
2.18.1

