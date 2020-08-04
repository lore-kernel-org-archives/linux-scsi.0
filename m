Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C29C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00DF622B40
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BtYnWEZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbgHDJHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729985AbgHDJHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:04 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD72C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:04 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id t23so27218864qto.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bTdvrExZaKC0j2udF1+3J/5he8xgyaRLwD31+bm6mBU=;
        b=BtYnWEZvV5QydwmBf4vShTH4BVIhpUq0Y5OfmB8V9HV4RMN8zPhlJ7JjZ3NoN9dHLm
         WcLmpRYtRpcC8a2mUSOUB1QO/FodjFDDTHX7pv6VLpDOJeJm0psvkbNvrhdXP2IaQTn4
         tmx2zRLbREgNZT27RwG6ThCPv9CxLc/DTRwiI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bTdvrExZaKC0j2udF1+3J/5he8xgyaRLwD31+bm6mBU=;
        b=lmJpOxp9LDdppko1qB117Dlte661TBEQgHtjyrksNwxB9ARq43w42WDrmTP+iSkYsV
         UXe7a9SMseiXHAyiAqonSMfvFwQNU7JtRoNclvq0apNSJ837Yw2+w6THTC74smLxsan2
         vmgGWNyJVWVTjvZpgsyIrQ73GmYXZXYNdl/A/i6rRTq+ny0TWIZXRL9RyA98IiG/PqGp
         bKnrZ/jypFB12IAk2MASCSDb3FjF4j1bqtvUu+Hw0cJFejINCdzAcuG4+R4DkzZhwd0i
         7W2XKx6BO5Vnzl9l6Gr3fvcT5wK/R0Ofuxtm60KTPASeh4YQzJsyZBCD/aNBIWJ7GySA
         JaCg==
X-Gm-Message-State: AOAM533Iud6SYdbdtX8496PqAGpWriVcZfpF6EfGM+/oQZhWE0KgncAu
        5jHWbAa7F0NJ2LvWMJy/q6L9sA==
X-Google-Smtp-Source: ABdhPJwo2uH9VpJCRm6pE7ZNfdhwgQ5tK4MKfwp0Z6PsaOaPQVY1Ke+PjNulKHLbrKoK46IEXBVeSg==
X-Received: by 2002:ac8:e89:: with SMTP id v9mr20938810qti.100.1596532023161;
        Tue, 04 Aug 2020 02:07:03 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:02 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 00/16] Application specific identification support
Date:   Tue,  4 Aug 2020 07:43:00 +0530
Message-Id: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Various virtualization technologies used in Fibre Channel
SAN deployments have created the opportunity to identify
and associate traffic with specific virtualized applications.
 
The concepts behind the T11 Application Services standard is
to provide the general mechanisms needed to identify
virtualized services.
 
This patch set enables the Fabric and the storage targets to
identify, monitor, and handle FC traffic
based on VMID .
 
It added a new knob app_identifier in blkio controller
and also provides a mechanism for inserting UUID info.
 
 
It also provides a mechanism
for inserting application specific identification into the FC frame.
 
The HBA driver(lpfc) retrieves the UUID when the first IO is initiated
and registers it with the Fabric.
The Fabric assigns an VMID which is unique within the fabric. The
resulting VMID is stored against the UUID/per-port. The VMID is inserted
in all the subsequent FC frames that are originating from the UUID, and
egressing the specific port through which the fabric is connected.
HBA maintains mapping of fabric associated IDs (VMID) to compute associated IDs (UUID).

The HBA changes currently supports only for scsi.
For VM this patch currently supports for
virtio device(device type:Disk Device and BUS type :VIRTIO)


Tests done:
We have tested this patch by attaching the device to
a KVM as a virtio device and added UUID to blkio cgroup as shown below.
 
echo "UUID" >
/sys/fs/cgroup/blkio/machine.slice/machine-qemu\\x2d<ID>\\
x2d<VMNAME>.scope/blkio.app_identifier
 
Then from the guest we run couple of io tests and checked
the VMID are passed to the fabric to identify,monitor the fc frames.

The patches were cut against  5.9/scsi-queue tree


Gaurav Srivastava (15):
  lpfc: vmid: Add the datastructure for supporting VMID in lpfc
  lpfc: vmid: API to check if VMID is enabled.
  lpfc: vmid: Supplementary data structures for vmid
  lpfc: vmid: Forward declarations for APIs
  lpfc: vmid: Add support for vmid in mailbox command
  lpfc: vmid: VMID params initialization
  lpfc: vmid: vmid resource allocation
  lpfc: vmid: cleanup vmid resources
  lpfc: vmid: Implements ELS commands for appid patch
  lpfc: vmid: Functions to manage vmids
  lpfc: vmid: Implements CT commands for appid.
  lpfc: vmid: Appends the vmid in the wqe before sending request
  lpfc: vmid: Timeout implementation for vmid
  lpfc: vmid: Adding qfpa and vmid timeout check in worker thread
  lpfc: vmid: Introducing vmid in io path.

Muneendra (1):
  blkcg:Introduce blkio.app_identifier knob to blkio controller

 block/blk-cgroup.c               |  32 +++
 drivers/scsi/lpfc/lpfc.h         | 122 +++++++++++
 drivers/scsi/lpfc/lpfc_attr.c    |  47 ++++
 drivers/scsi/lpfc/lpfc_crtn.h    |  11 +
 drivers/scsi/lpfc/lpfc_ct.c      | 256 +++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_disc.h    |   1 +
 drivers/scsi/lpfc/lpfc_els.c     | 356 ++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 151 +++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h      | 124 ++++++++++-
 drivers/scsi/lpfc/lpfc_hw4.h     |  12 ++
 drivers/scsi/lpfc/lpfc_init.c    | 108 ++++++++++
 drivers/scsi/lpfc/lpfc_mbox.c    |   6 +
 drivers/scsi/lpfc/lpfc_scsi.c    | 323 ++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.c     |  65 +++++-
 drivers/scsi/lpfc/lpfc_sli.h     |   8 +
 include/linux/blk-cgroup.h       |  19 ++
 16 files changed, 1618 insertions(+), 23 deletions(-)

-- 
2.18.2

