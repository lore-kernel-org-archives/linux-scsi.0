Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8B4C43141
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBC4120885
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHh2PD3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfKRKbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:31:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23797 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbfKRKbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 05:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574073102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBUQpEvhUSGPyW0TNCDWONDd8thoA0ntji5C32j1HOM=;
        b=NHh2PD3CxryF93hocFfzs/VRO6KJRMJTq5aGqD5tbK7iRfuiheI7fJLiirZqjZgHLyfoja
        OBsP97Hfp/MhCZdnB5vNSKOTrbQlwQJ77ITxF41NWgJBtxLe6hu7nILCQ3EtVFaMgsihGa
        oO4cprw0jKegIdB/12K/5hjLIDT24Hs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-R0u2oME6PaG-zSQCmkh7eQ-1; Mon, 18 Nov 2019 05:31:39 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C7AD1802CE0;
        Mon, 18 Nov 2019 10:31:36 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 013D4600CD;
        Mon, 18 Nov 2019 10:31:32 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/4] scsi: megaraid_sas: use private counter for tracking inflight per-LUN commands
Date:   Mon, 18 Nov 2019 18:31:14 +0800
Message-Id: <20191118103117.978-2-ming.lei@redhat.com>
In-Reply-To: <20191118103117.978-1-ming.lei@redhat.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: R0u2oME6PaG-zSQCmkh7eQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for bypassing sdev->device_busy for improving performance on
fast SCSI storage device, so sdev->device_busy can't be relied
any more.

megaraid_sas may need one such counter for balancing load among LUNs in
some specific setting, so add one private counter for this purpose.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 15 +++++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 13 +++++++++----
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/m=
egaraid_sas.h
index a6e788c02ff4..f9562c02705b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2025,6 +2025,7 @@ struct MR_PRIV_DEVICE {
 =09u8 interface_type;
 =09u8 task_abort_tmo;
 =09u8 target_reset_tmo;
+=09atomic_t active_cmds;
 };
 struct megasas_cmd;
=20
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index 42cf38c1ea99..3afead3bc96e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1759,6 +1759,7 @@ megasas_queue_command(struct Scsi_Host *shost, struct=
 scsi_cmnd *scmd)
 {
 =09struct megasas_instance *instance;
 =09struct MR_PRIV_DEVICE *mr_device_priv_data;
+=09int ret;
=20
 =09instance =3D (struct megasas_instance *)
 =09    scmd->device->host->hostdata;
@@ -1821,7 +1822,11 @@ megasas_queue_command(struct Scsi_Host *shost, struc=
t scsi_cmnd *scmd)
 =09=09goto out_done;
 =09}
=20
-=09return instance->instancet->build_and_issue_cmd(instance, scmd);
+=09atomic_inc(&mr_device_priv_data->active_cmds);
+=09ret =3D instance->instancet->build_and_issue_cmd(instance, scmd);
+=09if (ret)
+=09=09atomic_dec(&mr_device_priv_data->active_cmds);
+=09return ret;
=20
  out_done:
 =09scmd->scsi_done(scmd);
@@ -2100,6 +2105,7 @@ static int megasas_slave_alloc(struct scsi_device *sd=
ev)
=20
 =09atomic_set(&mr_device_priv_data->r1_ldio_hint,
 =09=09   instance->r1_ldio_hint_default);
+=09atomic_set(&mr_device_priv_data->active_cmds, 0);
 =09return 0;
 }
=20
@@ -3475,12 +3481,15 @@ megasas_complete_cmd(struct megasas_instance *insta=
nce, struct megasas_cmd *cmd,
 =09unsigned long flags;
 =09struct fusion_context *fusion =3D instance->ctrl_context;
 =09u32 opcode, status;
+=09struct MR_PRIV_DEVICE *mr_device_priv_data =3D NULL;
=20
 =09/* flag for the retry reset */
 =09cmd->retry_for_fw_reset =3D 0;
=20
-=09if (cmd->scmd)
+=09if (cmd->scmd) {
 =09=09cmd->scmd->SCp.ptr =3D NULL;
+=09=09mr_device_priv_data =3D cmd->scmd->device->hostdata;
+=09}
=20
 =09switch (hdr->cmd) {
 =09case MFI_CMD_INVALID:
@@ -3519,6 +3528,7 @@ megasas_complete_cmd(struct megasas_instance *instanc=
e, struct megasas_cmd *cmd,
 =09=09if (exception) {
=20
 =09=09=09atomic_dec(&instance->fw_outstanding);
+=09=09=09atomic_dec(&mr_device_priv_data->active_cmds);
=20
 =09=09=09scsi_dma_unmap(cmd->scmd);
 =09=09=09cmd->scmd->scsi_done(cmd->scmd);
@@ -3567,6 +3577,7 @@ megasas_complete_cmd(struct megasas_instance *instanc=
e, struct megasas_cmd *cmd,
 =09=09}
=20
 =09=09atomic_dec(&instance->fw_outstanding);
+=09=09atomic_dec(&mr_device_priv_data->active_cmds);
=20
 =09=09scsi_dma_unmap(cmd->scmd);
 =09=09cmd->scmd->scsi_done(cmd->scmd);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/meg=
araid/megaraid_sas_fusion.c
index e301458bcbae..10ed3bc3b643 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2728,7 +2728,7 @@ megasas_build_ldio_fusion(struct megasas_instance *in=
stance,
 =09u8 *raidLUN;
 =09unsigned long spinlock_flags;
 =09struct MR_LD_RAID *raid =3D NULL;
-=09struct MR_PRIV_DEVICE *mrdev_priv;
+=09struct MR_PRIV_DEVICE *mrdev_priv =3D scp->device->hostdata;
 =09struct RAID_CONTEXT *rctx;
 =09struct RAID_CONTEXT_G35 *rctx_g35;
=20
@@ -2826,7 +2826,7 @@ megasas_build_ldio_fusion(struct megasas_instance *in=
stance,
 =09}
=20
 =09if ((instance->perf_mode =3D=3D MR_BALANCED_PERF_MODE) &&
-=09=09atomic_read(&scp->device->device_busy) >
+=09=09atomic_read(&mrdev_priv->active_cmds) >
 =09=09(io_info.data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
 =09=09cmd->request_desc->SCSIIO.MSIxIndex =3D
 =09=09=09mega_mod64((atomic64_add_return(1, &instance->high_iops_outstandi=
ng) /
@@ -2849,7 +2849,6 @@ megasas_build_ldio_fusion(struct megasas_instance *in=
stance,
 =09=09 * with the SLD bit asserted.
 =09=09 */
 =09=09if (io_info.r1_alt_dev_handle !=3D MR_DEVHANDLE_INVALID) {
-=09=09=09mrdev_priv =3D scp->device->hostdata;
=20
 =09=09=09if (atomic_inc_return(&instance->fw_outstanding) >
 =09=09=09=09(instance->host->can_queue)) {
@@ -3159,7 +3158,7 @@ megasas_build_syspd_fusion(struct megasas_instance *i=
nstance,
 =09cmd->request_desc->SCSIIO.DevHandle =3D io_request->DevHandle;
=20
 =09if ((instance->perf_mode =3D=3D MR_BALANCED_PERF_MODE) &&
-=09=09atomic_read(&scmd->device->device_busy) > MR_DEVICE_HIGH_IOPS_DEPTH)
+=09=09atomic_read(&mr_device_priv_data->active_cmds) > MR_DEVICE_HIGH_IOPS=
_DEPTH)
 =09=09cmd->request_desc->SCSIIO.MSIxIndex =3D
 =09=09=09mega_mod64((atomic64_add_return(1, &instance->high_iops_outstandi=
ng) /
 =09=09=09=09MR_HIGH_IOPS_BATCH_COUNT), instance->low_latency_index_start);
@@ -3550,6 +3549,7 @@ complete_cmd_fusion(struct megasas_instance *instance=
, u32 MSIxIndex,
=20
 =09while (d_val.u.low !=3D cpu_to_le32(UINT_MAX) &&
 =09       d_val.u.high !=3D cpu_to_le32(UINT_MAX)) {
+=09=09struct MR_PRIV_DEVICE *mr_device_priv_data =3D NULL;
=20
 =09=09smid =3D le16_to_cpu(reply_desc->SMID);
 =09=09cmd_fusion =3D fusion->cmd_list[smid - 1];
@@ -3585,6 +3585,8 @@ complete_cmd_fusion(struct megasas_instance *instance=
, u32 MSIxIndex,
 =09=09=09}
 =09=09=09/* Fall through - and complete IO */
 =09=09case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
+=09=09=09mr_device_priv_data =3D scmd_local->device->hostdata;
+=09=09=09atomic_dec(&mr_device_priv_data->active_cmds);
 =09=09=09atomic_dec(&instance->fw_outstanding);
 =09=09=09if (cmd_fusion->r1_alt_dev_handle =3D=3D MR_DEVHANDLE_INVALID) {
 =09=09=09=09map_cmd_status(fusion, scmd_local, status,
@@ -4865,6 +4867,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int=
 reason)
=20
 =09=09/* Now return commands back to the OS */
 =09=09for (i =3D 0 ; i < instance->max_scsi_cmds; i++) {
+=09=09=09struct MR_PRIV_DEVICE *mr_device_priv_data =3D NULL;
 =09=09=09cmd_fusion =3D fusion->cmd_list[i];
 =09=09=09/*check for extra commands issued by driver*/
 =09=09=09if (instance->adapter_type >=3D VENTURA_SERIES) {
@@ -4893,6 +4896,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int=
 reason)
 =09=09=09=09megasas_return_cmd_fusion(instance, cmd_fusion);
 =09=09=09=09scsi_dma_unmap(scmd_local);
 =09=09=09=09scmd_local->scsi_done(scmd_local);
+=09=09=09=09mr_device_priv_data =3D scmd_local->device->hostdata;
+=09=09=09=09atomic_dec(&mr_device_priv_data->active_cmds);
 =09=09=09}
 =09=09}
=20
--=20
2.20.1

