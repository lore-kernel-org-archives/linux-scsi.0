From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v3 0/3] megaraid: use dev_printk() when possible
Date: Tue, 07 Jul 2015 15:52:14 -0500
Message-ID: <20150707204916.6218.37871.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

The current megaraid driver messages are somewhat inconsistent, with
different combinations of driver name and device address:

  megasas: 0x1000:0x005b:0x15d9:0x0690: bus 1:slot 0:func 0
  megaraid_sas 0000:01:00.0: megasas: FW restarted successfully from megasas_init_fw!
  megasas: Waiting for FW to come to ready state

These patches use dev_printk() to include the driver name and device
address in the conventional format.

Changes between v2 and v3:
  - Rebase to v4.2-rc1
  - Fix more whitespace issues (but not all) in megaraid_sas_base.c

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


 drivers/scsi/megaraid.c                     |  140 +++----
 drivers/scsi/megaraid/megaraid_sas_base.c   |  544 +++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   95 ++---
 3 files changed, 378 insertions(+), 401 deletions(-)
