From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/3] megaraid: use dev_printk() when possible
Date: Tue, 28 Apr 2015 18:13:57 -0500
Message-ID: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The current megaraid driver messages are somewhat inconsistent, e.g.,

  megasas: 06.803.01.00-rc1 Mon. Mar. 10 17:00:00 PDT 2014
  megasas: 0x1000:0x005b:0x15d9:0x0690: bus 1:slot 0:func 0
  megasas: FW now in Ready state
  megaraid_sas 0000:01:00.0: enabling device (0000 -> 0002)
  megasas: Waiting for FW to come to ready state
  megasas: FW in FAULT state!!
  megaraid_sas 0000:01:00.0: megasas: FW restarted successfully from megasas_init_fw!
  megasas: Waiting for FW to come to ready state
  megasas: FW in FAULT state!!

These patches use dev_printk() to include the driver name and device
address in the conventional format.

---

Bjorn Helgaas (3):
      megaraid: use dev_printk when possible
      megaraid_sas: use dev_printk when possible
      megaraid_sas: use dev_printk when possible


 drivers/scsi/megaraid.c                     |   92 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c   |  281 +++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   96 +++++----
 3 files changed, 230 insertions(+), 239 deletions(-)
