From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/4] scsi: megaraid_sas - Zero pad_0 in mfi structure
Date: Sun, 6 Dec 2009 08:24:21 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B7EAC2C7@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933843AbZLFPYa@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Add the pad_0 in mfi frame structure to 0 to fix the context value larger than 32bit value issue.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2009-12-04 05:25:19.000000000 -0500
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2009-12-04 05:29:57.000000000 -0500
@@ -843,6 +843,7 @@ megasas_build_dcdb(struct megasas_instan
 	pthru->lun = scp->device->lun;
 	pthru->cdb_len = scp->cmd_len;
 	pthru->timeout = 0;
+	pthru->pad_0 = 0;
 	pthru->flags = flags;
 	pthru->data_xfer_len = scsi_bufflen(scp);
 
@@ -2250,6 +2251,7 @@ megasas_get_pd_list(struct megasas_insta
 	dcmd->sge_count = 1;
 	dcmd->flags = MFI_FRAME_DIR_READ;
 	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
 	dcmd->data_xfer_len = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);
 	dcmd->opcode = MR_DCMD_PD_LIST_QUERY;
 	dcmd->sgl.sge32[0].phys_addr = ci_h;
@@ -2339,6 +2341,7 @@ megasas_get_ctrl_info(struct megasas_ins
 	dcmd->sge_count = 1;
 	dcmd->flags = MFI_FRAME_DIR_READ;
 	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
 	dcmd->data_xfer_len = sizeof(struct megasas_ctrl_info);
 	dcmd->opcode = MR_DCMD_CTRL_GET_INFO;
 	dcmd->sgl.sge32[0].phys_addr = ci_h;
@@ -2710,6 +2713,7 @@ megasas_get_seq_num(struct megasas_insta
 	dcmd->sge_count = 1;
 	dcmd->flags = MFI_FRAME_DIR_READ;
 	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
 	dcmd->data_xfer_len = sizeof(struct megasas_evt_log_info);
 	dcmd->opcode = MR_DCMD_CTRL_EVENT_GET_INFO;
 	dcmd->sgl.sge32[0].phys_addr = el_info_h;
@@ -2824,6 +2828,7 @@ megasas_register_aen(struct megasas_inst
 	dcmd->sge_count = 1;
 	dcmd->flags = MFI_FRAME_DIR_READ;
 	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
 	dcmd->data_xfer_len = sizeof(struct megasas_evt_detail);
 	dcmd->opcode = MR_DCMD_CTRL_EVENT_WAIT;
 	dcmd->mbox.w[0] = seq_num;
@@ -3162,6 +3167,7 @@ static void megasas_flush_cache(struct m
 	dcmd->sge_count = 0;
 	dcmd->flags = MFI_FRAME_DIR_NONE;
 	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
 	dcmd->data_xfer_len = 0;
 	dcmd->opcode = MR_DCMD_CTRL_CACHE_FLUSH;
 	dcmd->mbox.b[0] = MR_FLUSH_CTRL_CACHE | MR_FLUSH_DISK_CACHE;
@@ -3201,6 +3207,7 @@ static void megasas_shutdown_controller(
 	dcmd->sge_count = 0;
 	dcmd->flags = MFI_FRAME_DIR_NONE;
 	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
 	dcmd->data_xfer_len = 0;
 	dcmd->opcode = opcode;
