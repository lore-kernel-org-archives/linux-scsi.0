Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55FFC3F2D1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 10:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8986920705
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 10:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cOf9ecOE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387396AbgCDKgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 05:36:20 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38818 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgCDKgU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 05:36:20 -0500
Received: by mail-qv1-f68.google.com with SMTP id g16so543259qvz.5
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2020 02:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SqpaJf/BMWttA8K7zEORpG3yAqd77PxtNtS4Qu4RSvM=;
        b=cOf9ecOEP8nBsdRZywS2nq15H5F8XGB3QljfN5D9WaTITGSU0YToSxznArzvX3rLfL
         UZM0FXFOk8r6bSVgWwIyd0csug/KzqqL78sALqiIXiYJ8nPIA0cJgeVUAQCRST6PZ+ST
         LetySVyi11ZMIAd/VeePDp8Wz0bwJ8had+awU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=SqpaJf/BMWttA8K7zEORpG3yAqd77PxtNtS4Qu4RSvM=;
        b=bGesO2QCET7uMnz281O0jQ3ra9qroBE4zac5SRdZaxeZfTOVsutZAw5BTxen1Zz2jA
         kjwHtryyXPJEz/S09KPNReE332psovAQlaGlPy9citVY21zyWprF+UEDN2NBgsp7lmYb
         aZeOjd9OHH1Lw7ff3/ugqa+18t6I0X58CXAwNOcjYGwsoWvIrkWXnM2EzDZ51NyReAOr
         O9CBsDtWw6sbH1n33idQKHL9C2FKOmev/LRgkrrsaCNGunpxLxKnDDiVCaytEED88jWO
         ikrOc5zkSaRGAS3GTZeAuUtEBAQ+7M958UKF/fr78kRPACNN3HF4Fx4wAcRcSxGRjhVw
         8Acg==
X-Gm-Message-State: ANhLgQ0a3qvH1oMPNgNg0/ae/bnItf/haJLOqf6zyI4gnz2Y+p43M45g
        HXJtbOL+1eFY6vYU4eiO3ofMZhHDROsD5O6Y2X5LwhoH
X-Google-Smtp-Source: ADFU+vtNt7zJfZrDE0YsrUGGRY8u/bh2BdICxi1IkncZhOxfnCCW5Zyh7gUVXycPGvD1z6Ubvi/kuAok7KI3xsMnytE=
X-Received: by 2002:a05:6214:118d:: with SMTP id t13mr1440488qvv.192.1583318178446;
 Wed, 04 Mar 2020 02:36:18 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1581940533-13795-1-git-send-email-kashyap.desai@broadcom.com> <4c89034d-d56e-567a-2f84-e3aca41c3f6b@suse.de>
In-Reply-To: <4c89034d-d56e-567a-2f84-e3aca41c3f6b@suse.de>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIz7HzIU6vx7Bue1PmMV2dYshfgsgHl/ZfUp20T+JA=
Date:   Wed, 4 Mar 2020 16:06:13 +0530
Message-ID: <9d67b7929b7c95bd7b4aff35e89cec94@mail.gmail.com>
Subject: RE: [RFC PATCH] megaraid_sas : threaded irq hybrid polling
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        linux-nvme@lists.infradead.org, ming.lei@redhat.com,
        kbusch@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> I actually would like to have something more generic; threaded irq pollin=
g
> looks like something where most high-performance drivers would benefit
> from.
> So I think it might be worthwhile posting a topic for LSF/MM to have a
> broader discussion.

This requirement is generic for many Storage controller so having common
interface would help through LSF forum.

>
> Thing is, I wonder if it wouldn't be more efficient for high-performance
> devices
> to first try for completions in-line, ie start with polling _first_, then
> enable
> interrupt handler, and then shift to polling for more completions.
> But this will involve timeouts which probably would be need to be tweaked
> per hardware/driver; one could even look into disable individual
> functionality
> completely (if you disable the first and the last part you're back to the
> original
> implementation, if you disable the first it's the algorithm you proposed)=
.

Is it worth to export blk_mq_poll_nsecs OR provide avg latency return by
blk_mq_poll_nsecs in SCSI command so that low level driver can use it ?

Problem for HBA which connect different types of drives having range of
latency  =E2=80=93

We need poll delay per reply queue (not per sdev). Block layer=E2=80=99s po=
ll delay
is per sdev. For Native NVMe, it is fine because they will have consistent
latency on each block size.
For MR/IT HBA it is a problem -  It is possible that we have IO in reply
queue with different latency 10usec, 100 usec, 50 usec, 5 usec etc. I canno=
t
pick last and also I cannot pick average of all.

What we need is < poll delay> =3D least among all pending IO. To handle thi=
s I
did some changes in next RFC version.

In submission path, driver will set poll_delay which is smallest of the all
IO.
In completion path, driver will read poll_delay in thread. Once it read tha=
t
value, it will reset poll_delay to ZERO. This is an indication in submissio=
n
path that they can forget all previous data and restart.
Also, I skipped IO which has more than 1msec latency so that we do not
create unwanted latency. 1msec latency is only possible for HDD random
profile.

Some of the stats indicates that using blk_mq_poll_nsecs, I can get best
result.  Highest IOPS, Low latency and Low CPU utilization.

<24 SSD, QD =3D 32, RandRead>

usleep delay		IOPs	Latency		CPU utilization
blk_mq_poll_nsecs	3.3M	189.47usec	18%
5 usec			3.3M	189.47usec	52%
20 usec			3.3M	189.61usec	29%
40 usec			3.3M	189.61usec	22%
80 usec			3.2M	194.34usec	18%

<24 HDD, QD =3D 32, Sequential Read>
usleep delay		IOPs	Latency		CPU utilization
blk_mq_poll_nsecs	1.24M	545.81usec	8%
5 usec			1.24M	545.81usec	16%
20 usec			1.24M	545.81usec	13%
40 usec			1.24M	545.81usec	12%
80 usec			1.24M	545.81usec	15%
200 usec		1.24M	545.81usec	8%

I exported " blk_mq_poll_nsecs " function so that driver can use it. Here i=
s
RFC V2 -

diff --git a/drivers/scsi/megaraid/megaraid_sas.h
b/drivers/scsi/megaraid/megaraid_sas.h
index 83d8c4c..4d6dcd0 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2212,6 +2212,10 @@ struct megasas_irq_context {
 	struct irq_poll irqpoll;
 	bool irq_poll_scheduled;
 	bool irq_line_enable;
+	bool attempt_irq_poll;
+	unsigned int poll_usec;
+	atomic_t   in_used;
+	atomic_t   pending_cmds;
 };

 struct MR_DRV_SYSTEM_INFO {
@@ -2709,4 +2713,6 @@ int megasas_adp_reset_wait_for_ready(struct
megasas_instance *instance,
 				     int ocr_context);
 int megasas_irqpoll(struct irq_poll *irqpoll, int budget);
 void megasas_dump_fusion_io(struct scsi_cmnd *scmd);
+irqreturn_t megasas_irq_check_fusion(int irq, void *devp);
+irqreturn_t megasas_irq_fusion_thread(int irq, void *devp);
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c
index fd4b5ac..4dc8d1c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5536,6 +5536,8 @@ void megasas_setup_irq_poll(struct megasas_instance
*instance)
 		irq_ctx =3D &instance->irq_context[i];
 		irq_ctx->os_irq =3D pci_irq_vector(instance->pdev, i);
 		irq_ctx->irq_poll_scheduled =3D false;
+		atomic_set(&irq_ctx->in_used, 0);
+		atomic_set(&irq_ctx->pending_cmds, 0);
 		irq_poll_init(&irq_ctx->irqpoll,
 			      instance->threshold_reply_count,
 			      megasas_irqpoll);
@@ -5585,7 +5587,7 @@ megasas_setup_irqs_ioapic(struct megasas_instance
*instance)
 static int
 megasas_setup_irqs_msix(struct megasas_instance *instance, u8 is_probe)
 {
-	int i, j;
+	int i, j, ret;
 	struct pci_dev *pdev;

 	pdev =3D instance->pdev;
@@ -5596,9 +5598,12 @@ megasas_setup_irqs_msix(struct megasas_instance
*instance, u8 is_probe)
 		instance->irq_context[i].MSIxIndex =3D i;
 		snprintf(instance->irq_context[i].name, MEGASAS_MSIX_NAME_LEN,
"%s%u-msix%u",
 			"megasas", instance->host->host_no, i);
-		if (request_irq(pci_irq_vector(pdev, i),
-			instance->instancet->service_isr, 0, instance->irq_context[i].name,
-			&instance->irq_context[i])) {
+		ret =3D request_threaded_irq(pci_irq_vector(pdev, i),
+				megasas_irq_check_fusion,
+				megasas_irq_fusion_thread, IRQF_ONESHOT,
+				instance->irq_context[i].name,
+				&instance->irq_context[i]);
+		if (ret) {
 			dev_err(&instance->pdev->dev,
 				"Failed to register IRQ for vector %d.\n", i);
 			for (j =3D 0; j < i; j++)
@@ -7799,6 +7804,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 {
 	int i;
 	struct Scsi_Host *host;
+	struct scsi_device *sdev;
 	struct megasas_instance *instance;
 	struct fusion_context *fusion;
 	u32 pd_seq_map_sz;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
b/drivers/scsi/megaraid/megaraid_sas_fusion.c
old mode 100644
new mode 100755
index f3b36fd..c07841e
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -44,9 +44,13 @@
 #include <scsi/scsi_dbg.h>
 #include <linux/dmi.h>

+
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"

+extern unsigned long blk_mq_poll_nsecs(struct request_queue *q,
+				struct blk_mq_hw_ctx *hctx,
+				struct request *rq);

 extern void megasas_free_cmds(struct megasas_instance *instance);
 extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
@@ -371,13 +375,17 @@ megasas_get_msix_index(struct megasas_instance
*instance,
 		       struct megasas_cmd_fusion *cmd,
 		       u8 data_arms)
 {
+	struct megasas_irq_context *irq_ctx;
 	int sdev_busy;
+	unsigned int poll_nsec =3D 0;

 	/* nr_hw_queue =3D 1 for MegaRAID */
 	struct blk_mq_hw_ctx *hctx =3D
 		scmd->device->request_queue->queue_hw_ctx[0];

 	sdev_busy =3D atomic_read(&hctx->nr_active);
+	poll_nsec =3D blk_mq_poll_nsecs(scmd->device->request_queue,
+			hctx, scmd->request);

 	if (instance->perf_mode =3D=3D MR_BALANCED_PERF_MODE &&
 	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
@@ -391,6 +399,19 @@ megasas_get_msix_index(struct megasas_instance
*instance,
 	else
 		cmd->request_desc->SCSIIO.MSIxIndex =3D
 			instance->reply_map[raw_smp_processor_id()];
+
+	irq_ctx =3D &instance->irq_context[cmd->request_desc->SCSIIO.MSIxIndex];
+
+	/* Execute Polling for faster device. latency < 1msec.
+	 * Potential candidate is SAS, SATA, NVME SSDs.
+	 * Sequential workload on HDDs.
+	 */
+	if (atomic_inc_return(&irq_ctx->pending_cmds) >
+		MR_DEVICE_HIGH_IOPS_DEPTH && (poll_nsec < 1000000)) {
+		irq_ctx->poll_usec =3D min_not_zero(irq_ctx->poll_usec,
+					poll_nsec) / 1000;
+		irq_ctx->attempt_irq_poll =3D true;
+	}
 }

 /**
@@ -2754,6 +2775,7 @@ megasas_build_ldio_fusion(struct megasas_instance
*instance,
 	u16 ld;
 	u32 start_lba_lo, start_lba_hi, device_id, datalength =3D 0;
 	u32 scsi_buff_len;
+	struct megasas_irq_context *irq_ctx;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
 	struct IO_REQUEST_INFO io_info;
 	struct fusion_context *fusion;
@@ -3101,6 +3123,7 @@ megasas_build_syspd_fusion(struct megasas_instance
*instance,
 	u16 pd_index =3D 0;
 	u16 os_timeout_value;
 	u16 timeout_limit;
+	struct megasas_irq_context *irq_ctx;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct RAID_CONTEXT	*pRAID_Context;
 	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
@@ -3540,6 +3563,7 @@ complete_cmd_fusion(struct megasas_instance *instance=
,
u32 MSIxIndex,

 	fusion =3D instance->ctrl_context;

+
 	if (atomic_read(&instance->adprecovery) =3D=3D MEGASAS_HW_CRITICAL_ERROR)
 		return IRQ_HANDLED;

@@ -3556,6 +3580,9 @@ complete_cmd_fusion(struct megasas_instance *instance=
,
u32 MSIxIndex,
 	if (reply_descript_type =3D=3D MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 		return IRQ_NONE;

+	if (!atomic_add_unless(&irq_context->in_used, 1, 1))
+		return 0;
+
 	num_completed =3D 0;

 	while (d_val.u.low !=3D cpu_to_le32(UINT_MAX) &&
@@ -3596,6 +3623,7 @@ complete_cmd_fusion(struct megasas_instance *instance=
,
u32 MSIxIndex,
 			/* Fall through - and complete IO */
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
 			atomic_dec(&instance->fw_outstanding);
+			atomic_dec(&irq_context->pending_cmds);
 			if (cmd_fusion->r1_alt_dev_handle =3D=3D MR_DEVHANDLE_INVALID) {
 				map_cmd_status(fusion, scmd_local, status,
 					       extStatus, le32_to_cpu(data_length),
@@ -3669,6 +3697,7 @@ complete_cmd_fusion(struct megasas_instance *instance=
,
u32 MSIxIndex,
 					irq_context->irq_line_enable =3D true;
 					irq_poll_sched(&irq_context->irqpoll);
 				}
+				atomic_dec(&irq_context->in_used);
 				return num_completed;
 			}
 		}
@@ -3686,6 +3715,8 @@ complete_cmd_fusion(struct megasas_instance *instance=
,
u32 MSIxIndex,
 				instance->reply_post_host_index_addr[0]);
 		megasas_check_and_restore_queue_depth(instance);
 	}
+
+	atomic_dec(&irq_context->in_used);
 	return num_completed;
 }

@@ -3817,6 +3848,75 @@ static irqreturn_t megasas_isr_fusion(int irq, void
*devp)
 			? IRQ_HANDLED : IRQ_NONE;
 }

+/*
+ * megasas_irq_fusion_thread:
+ */
+irqreturn_t megasas_irq_fusion_thread(int irq, void *devp)
+{
+	int num_completed =3D 0;
+	struct megasas_irq_context *irq_context =3D devp;
+	struct megasas_instance *instance =3D irq_context->instance;
+	unsigned int curr_poll_usec;
+
+	num_completed +=3D complete_cmd_fusion(instance,
+					irq_context->MSIxIndex, irq_context);
+
+	/* If there are still pending completion, let's wait for some time
+	 * and retry since enable/disable irq is expensive operation.
+	 */
+	do {
+		if (atomic_read(&irq_context->pending_cmds)) {
+			curr_poll_usec =3D irq_context->poll_usec ?
+				irq_context->poll_usec : 4;
+			irq_context->poll_usec =3D 0;
+			usleep_range(curr_poll_usec/2, curr_poll_usec);
+			num_completed +=3D complete_cmd_fusion(instance,
+						irq_context->MSIxIndex,
+						irq_context);
+		}
+
+	} while (atomic_read(&irq_context->pending_cmds) &&
+			(num_completed < instance->cur_can_queue));
+
+	irq_context->attempt_irq_poll =3D false;
+	enable_irq(irq_context->os_irq);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * megasas_irq_check_fusion:
+ *
+ * For threaded interrupts, this handler will be called and its job is to
+ * complete command in first attempt before it calls threaded isr handler.
+ *
+ * Threaded ISR handler will be called if there is a prediction of more
+ * completion pending.
+ */
+irqreturn_t megasas_irq_check_fusion(int irq, void *devp)
+{
+	irqreturn_t ret;
+	struct megasas_irq_context *irq_context =3D devp;
+	struct megasas_instance *instance =3D irq_context->instance;
+
+	if (instance->mask_interrupts)
+		return IRQ_NONE;
+
+	/* First attempt from primary handler */
+	ret =3D megasas_isr_fusion(irq, devp);
+
+	/* Primary handler predict more IO in completion queue,
+	 * so let's use threaded irq poll.
+	 */
+	if (!irq_context->attempt_irq_poll ||
+			(atomic_read(&irq_context->pending_cmds) =3D=3D 0))
+		return IRQ_HANDLED;
+
+	disable_irq_nosync(irq_context->os_irq);
+	return IRQ_WAKE_THREAD;
+}
+
+
 /**
  * build_mpt_mfi_pass_thru - builds a cmd fo MFI Pass thru
  * @instance:			Adapter soft state

>
> But as I said, that probably warrants a wider discussion.

Agree.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		           Kernel Storage Architect
> hare@suse.de			                  +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg =
HRB
> 36809 (AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
