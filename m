Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC76DC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5EFE20855
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 10:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XhdwF3Mv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfKRKbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:31:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50122 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbfKRKbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 05:31:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574073110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQGaSPSMYZf0wTy4mSjYgqZcEjcQZsd+fMlyCkP8oTA=;
        b=XhdwF3MvMaOJZcLcwwnWUCulR72OjbamI5440PD0DBqrCk09d1CB3gIFwlgBxpwYg6t6Y6
        lBUeo3q/IVJQ8SYBAWI8huCWhQhpv9ltsApY4yD2wKRlWp2BifVMhKCyg3lW6hBdd1SNL9
        ylsWmUV3Bueh90BtALcxsyFatCdLFCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-YV0MO35nMzaGbPBoC5Cesw-1; Mon, 18 Nov 2019 05:31:46 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CF5F801FD2;
        Mon, 18 Nov 2019 10:31:42 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F37A519C6A;
        Mon, 18 Nov 2019 10:31:38 +0000 (UTC)
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
Subject: [PATCH 2/4] scsi: mpt3sas: use private counter for tracking inflight per-LUN commands
Date:   Mon, 18 Nov 2019 18:31:15 +0800
Message-Id: <20191118103117.978-3-ming.lei@redhat.com>
In-Reply-To: <20191118103117.978-1-ming.lei@redhat.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: YV0MO35nMzaGbPBoC5Cesw-1
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

mpt3sas may need one such counter for balancing load among LUNs in
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
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  3 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++++++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt=
3sas_base.c
index fea3cb6a090b..9c2d374b3157 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3480,12 +3480,13 @@ static inline u8
 _base_get_high_iops_msix_index(struct MPT3SAS_ADAPTER *ioc,
 =09struct scsi_cmnd *scmd)
 {
+=09struct MPT3SAS_DEVICE *sas_device_priv_data =3D scmd->device->hostdata;
 =09/**
 =09 * Round robin the IO interrupts among the high iops
 =09 * reply queues in terms of batch count 16 when outstanding
 =09 * IOs on the target device is >=3D8.
 =09 */
-=09if (atomic_read(&scmd->device->device_busy) >
+=09if (atomic_read(&sas_device_priv_data->active_cmds) >
 =09    MPT3SAS_DEVICE_HIGH_IOPS_DEPTH)
 =09=09return base_mod64((
 =09=09    atomic64_add_return(1, &ioc->high_iops_outstanding) /
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt=
3sas_base.h
index faca0a5e71f8..9e9f319bb636 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -467,6 +467,7 @@ struct MPT3SAS_DEVICE {
 =09 * thing while a SATL command is pending.
 =09 */
 =09unsigned long ata_command_pending;
+=09atomic_t active_cmds;
=20
 };
=20
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mp=
t3sas_scsih.c
index c8e512ba6d39..194960dae1d6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1770,6 +1770,7 @@ scsih_slave_alloc(struct scsi_device *sdev)
=20
 =09sas_device_priv_data->lun =3D sdev->lun;
 =09sas_device_priv_data->flags =3D MPT_DEVICE_FLAGS_INIT;
+=09atomic_set(&sas_device_priv_data->active_cmds, 0);
=20
 =09starget =3D scsi_target(sdev);
 =09sas_target_priv_data =3D starget->hostdata;
@@ -2884,6 +2885,7 @@ scsih_abort(struct scsi_cmnd *scmd)
 =09    ioc->remove_host) {
 =09=09sdev_printk(KERN_INFO, scmd->device,
 =09=09=09"device been deleted! scmd(%p)\n", scmd);
+=09=09atomic_dec(&sas_device_priv_data->active_cmds);
 =09=09scmd->result =3D DID_NO_CONNECT << 16;
 =09=09scmd->scsi_done(scmd);
 =09=09r =3D SUCCESS;
@@ -2993,7 +2995,7 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 =09=09MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 =09=09tr_timeout, tr_method);
 =09/* Check for busy commands after reset */
-=09if (r =3D=3D SUCCESS && atomic_read(&scmd->device->device_busy))
+=09if (r =3D=3D SUCCESS && atomic_read(&sas_device_priv_data->active_cmds)=
)
 =09=09r =3D FAILED;
  out:
 =09sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
@@ -4517,9 +4519,12 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *io=
c)
 =09int count =3D 0;
=20
 =09for (smid =3D 1; smid <=3D ioc->scsiio_depth; smid++) {
+=09=09struct MPT3SAS_DEVICE *sas_device_priv_data;
+
 =09=09scmd =3D mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 =09=09if (!scmd)
 =09=09=09continue;
+=09=09sas_device_priv_data =3D scmd->device->hostdata;
 =09=09count++;
 =09=09_scsih_set_satl_pending(scmd, false);
 =09=09st =3D scsi_cmd_priv(scmd);
@@ -4529,6 +4534,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc=
)
 =09=09=09scmd->result =3D DID_NO_CONNECT << 16;
 =09=09else
 =09=09=09scmd->result =3D DID_RESET << 16;
+=09=09atomic_dec(&sas_device_priv_data->active_cmds);
 =09=09scmd->scsi_done(scmd);
 =09}
 =09dtmprintk(ioc, ioc_info(ioc, "completing %d cmds\n", count));
@@ -4756,11 +4762,14 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmn=
d *scmd)
 =09    mpi_request->LUN);
 =09memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
=20
+=09atomic_inc(&sas_device_priv_data->active_cmds);
+
 =09if (mpi_request->DataLength) {
 =09=09pcie_device =3D sas_target_priv_data->pcie_dev;
 =09=09if (ioc->build_sg_scmd(ioc, scmd, smid, pcie_device)) {
 =09=09=09mpt3sas_base_free_smid(ioc, smid);
 =09=09=09_scsih_set_satl_pending(scmd, false);
+=09=09=09atomic_dec(&sas_device_priv_data->active_cmds);
 =09=09=09goto out;
 =09=09}
 =09} else
@@ -5207,6 +5216,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *=
ioc, u16 handle)
 static u8
 _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 r=
eply)
 {
+=09struct MPT3SAS_DEVICE *sas_device_priv_data;
 =09Mpi25SCSIIORequest_t *mpi_request;
 =09Mpi2SCSIIOReply_t *mpi_reply;
 =09struct scsi_cmnd *scmd;
@@ -5216,7 +5226,6 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid,=
 u8 msix_index, u32 reply)
 =09u8 scsi_state;
 =09u8 scsi_status;
 =09u32 log_info;
-=09struct MPT3SAS_DEVICE *sas_device_priv_data;
 =09u32 response_code =3D 0;
=20
 =09mpi_reply =3D mpt3sas_base_get_reply_virt_addr(ioc, reply);
@@ -5225,6 +5234,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid,=
 u8 msix_index, u32 reply)
 =09if (scmd =3D=3D NULL)
 =09=09return 1;
=20
+=09sas_device_priv_data =3D scmd->device->hostdata;
 =09_scsih_set_satl_pending(scmd, false);
=20
 =09mpi_request =3D mpt3sas_base_get_msg_frame(ioc, smid);
@@ -5431,6 +5441,7 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid,=
 u8 msix_index, u32 reply)
=20
 =09scsi_dma_unmap(scmd);
 =09mpt3sas_base_free_smid(ioc, smid);
+=09atomic_dec(&sas_device_priv_data->active_cmds);
 =09scmd->scsi_done(scmd);
 =09return 0;
 }
--=20
2.20.1

