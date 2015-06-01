From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 0/3] megaraid: use dev_printk() when possible
Date: Mon, 01 Jun 2015 10:39:56 -0500
Message-ID: <20150601153240.23309.73917.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33851 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbFAPj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2015 11:39:58 -0400
Received: by igbhj9 with SMTP id hj9so64462717igb.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jun 2015 08:39:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The current megaraid driver messages are somewhat inconsistent, with
different combinations of driver name and device address:

  megasas: 0x1000:0x005b:0x15d9:0x0690: bus 1:slot 0:func 0
  megaraid_sas 0000:01:00.0: megasas: FW restarted successfully from megasas_init_fw!
  megasas: Waiting for FW to come to ready state

These patches use dev_printk() to include the driver name and device
address in the conventional format.

Changes between v1 and v2:
  - Rebase to next-20150601
  - Squash megaraid_sas_base.c and megaraid_sas_fusion.c changes into one patch
  - Split megasas_dump_pending_frames() run-on printks into one line each
  - Add patch to fix whitespace errors in megasas_dump_pending_frames()

---

Bjorn Helgaas (3):
      megaraid : use dev_printk when possible
      megaraid_sas : use dev_printk when possible
      megaraid_sas : fix whitespace errors


 drivers/scsi/megaraid.c                     |   92 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c   |  287 +++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   92 ++++-----
 3 files changed, 231 insertions(+), 240 deletions(-)
