Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB56CA9EBD
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 08:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA1D20873
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 08:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U5SVYSfU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfJ0ITh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 04:19:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725977AbfJ0ITh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 27 Oct 2019 04:19:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572164375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1YcqTDnLloIb+ZLB9uujC7vc9mZnFxIJiCufzMLN3cU=;
        b=U5SVYSfUXDgP0BvnwGNu5ddIwdpG5lp/OaxRQPeRp0N5/sLTv3hKljtdBXMyRhmFf36Rko
        6EDxE8wdQw3vSt2VidkpVgMPeyBkOZ8wk1kPsUfochLfwe9nSuE168vWVojpemAXTrCAxo
        q41j4S8N+u19xp8cRcg1ElJRDLKW08Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-p0Jgi6WLOn2-vmJW0PVX0g-1; Sun, 27 Oct 2019 04:19:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA96A107AD28;
        Sun, 27 Oct 2019 08:19:27 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F23D5D9E2;
        Sun, 27 Oct 2019 08:19:17 +0000 (UTC)
Date:   Sun, 27 Oct 2019 16:19:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org, hare@suse.com
Subject: Re: [PATCH 6/6] scsi: hisi_sas: Expose multiple hw queues for v3 as
 experimental
Message-ID: <20191027081910.GB16704@ming.t460p>
References: <1571926881-75524-1-git-send-email-john.garry@huawei.com>
 <1571926881-75524-7-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
In-Reply-To: <1571926881-75524-7-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: p0Jgi6WLOn2-vmJW0PVX0g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 24, 2019 at 10:21:21PM +0800, John Garry wrote:
> Since we're not ready to expose mutliple queues to the upper layer always
> due to CPU hotplug issue, add a new interim experimental command line
> option to support it.
>=20
> We still need to keep supporting auto_affine_msi_experimental, since
> people are now replying the performance it provides, even though it is
> unsafe.
>=20
> If auto_affine_msi_experimental and expose_mq_experimental are both set,
> then auto_affine_msi_experimental takes preference.
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h       |  2 +
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 55 ++++++++++++++++----------
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 51 +++++++++++++++++++++---
>  3 files changed, 83 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/his=
i_sas.h
> index 4eb8f1c53f78..884f2426d753 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -8,6 +8,8 @@
>  #define _HISI_SAS_H_
> =20
>  #include <linux/acpi.h>
> +#include <linux/blk-mq.h>
> +#include <linux/blk-mq-pci.h>
>  #include <linux/clk.h>
>  #include <linux/debugfs.h>
>  #include <linux/dmapool.h>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
> index 53802c1cc1d0..c8c96a46acfd 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -389,9 +389,11 @@ static int hisi_sas_task_prep(struct sas_task *task,
>  =09struct hisi_sas_slot *slot;
>  =09struct hisi_sas_cmd_hdr=09*cmd_hdr_base;
>  =09struct asd_sas_port *sas_port =3D device->port;
> +=09struct Scsi_Host *shost =3D hisi_hba->shost;
>  =09struct device *dev =3D hisi_hba->dev;
>  =09int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
>  =09int n_elem =3D 0, n_elem_dif =3D 0, n_elem_req =3D 0;
> +=09struct scsi_cmnd *scmd =3D NULL;
>  =09struct hisi_sas_dq *dq;
>  =09unsigned long flags;
>  =09int wr_q_index;
> @@ -407,13 +409,38 @@ static int hisi_sas_task_prep(struct sas_task *task=
,
>  =09=09return -ECOMM;
>  =09}
> =20
> -=09if (hisi_hba->reply_map) {
> -=09=09int cpu =3D raw_smp_processor_id();
> -=09=09unsigned int dq_index =3D hisi_hba->reply_map[cpu];
> +=09if (task->uldd_task) {
> +=09=09struct ata_queued_cmd *qc;
> =20
> -=09=09*dq_pointer =3D dq =3D &hisi_hba->dq[dq_index];
> -=09} else {
> +=09=09if (dev_is_sata(device)) {
> +=09=09=09qc =3D task->uldd_task;
> +=09=09=09scmd =3D qc->scsicmd;
> +=09=09} else {
> +=09=09=09scmd =3D task->uldd_task;
> +=09=09}
> +=09}
> +
> +=09/* We have to move to just a single mode: expose multiple queues */
> +=09if (!hisi_hba->reply_map && !shost->nr_hw_queues) {
>  =09=09*dq_pointer =3D dq =3D sas_dev->dq;
> +=09} else {
> +=09=09if (hisi_hba->reply_map) {
> +=09=09=09int cpu =3D raw_smp_processor_id();
> +=09=09=09unsigned int dq_index =3D hisi_hba->reply_map[cpu];
> +
> +=09=09=09*dq_pointer =3D dq =3D &hisi_hba->dq[dq_index];
> +=09=09} else {
> +=09=09=09if (scmd) {
> +=09=09=09=09unsigned int dq_index;
> +=09=09=09=09u32 blk_tag;
> +
> +=09=09=09=09blk_tag =3D blk_mq_unique_tag(scmd->request);
> +=09=09=09=09dq_index =3D blk_mq_unique_tag_to_hwq(blk_tag);
> +=09=09=09=09*dq_pointer =3D dq =3D &hisi_hba->dq[dq_index];
> +=09=09=09} else {
> +=09=09=09=09*dq_pointer =3D dq =3D sas_dev->dq;
> +=09=09=09}
> +=09=09}
>  =09}
> =20
>  =09port =3D to_hisi_sas_port(sas_port);
> @@ -438,22 +465,10 @@ static int hisi_sas_task_prep(struct sas_task *task=
,
>  =09}
> =20
>  =09if (hisi_hba->hw->slot_index_alloc)
> -=09=09rc =3D hisi_hba->hw->slot_index_alloc(hisi_hba, device, NULL);
> -=09else {
> -=09=09struct scsi_cmnd *scsi_cmnd =3D NULL;
> -
> -=09=09if (task->uldd_task) {
> -=09=09=09struct ata_queued_cmd *qc;
> +=09=09rc =3D hisi_hba->hw->slot_index_alloc(hisi_hba, device, scmd);
> +=09else
> +=09=09rc =3D hisi_sas_slot_index_alloc(hisi_hba, scmd);
> =20
> -=09=09=09if (dev_is_sata(device)) {
> -=09=09=09=09qc =3D task->uldd_task;
> -=09=09=09=09scsi_cmnd =3D qc->scsicmd;
> -=09=09=09} else {
> -=09=09=09=09scsi_cmnd =3D task->uldd_task;
> -=09=09=09}
> -=09=09}
> -=09=09rc =3D hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
> -=09}
>  =09if (rc < 0)
>  =09=09goto err_out_dif_dma_unmap;
> =20
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> index 29119d0b27a7..03ba0416f910 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -512,6 +512,11 @@ module_param(auto_affine_msi_experimental, bool, 044=
4);
>  MODULE_PARM_DESC(auto_affine_msi_experimental, "Enable auto-affinity of =
MSI IRQs as experimental:\n"
>  =09=09 "default is off");
> =20
> +static bool expose_mq_experimental;
> +module_param(expose_mq_experimental, bool, 0444);
> +MODULE_PARM_DESC(expose_mq_experimental, "Expose multiple hw queues to u=
pper layer as experimental:\n"
> +=09=09 "default is off");
> +
>  static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
>  {
>  =09void __iomem *regs =3D hisi_hba->regs + off;
> @@ -558,6 +563,11 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi=
_hba,
> =20
>  static int bitmaps_alloc_v3_hw(struct hisi_hba *hisi_hba)
>  {
> +=09if (expose_mq_experimental)
> +=09=09return sbitmap_init_node(&hisi_hba->slot_index_tags,
> +=09=09=09=09=09 HISI_SAS_MAX_COMMANDS, -1,
> +=09=09=09=09=09 GFP_KERNEL,
> +=09=09=09=09=09 dev_to_node(hisi_hba->dev));
>  =09return sbitmap_init_node(&hisi_hba->slot_index_tags,
>  =09=09=09=09 HISI_SAS_UNRESERVED_IPTT, -1,
>  =09=09=09=09 GFP_KERNEL, dev_to_node(hisi_hba->dev));
> @@ -570,6 +580,10 @@ static int slot_index_alloc_v3_hw(struct hisi_hba *h=
isi_hba,
>  =09struct sbitmap *slot_index_tags =3D &hisi_hba->slot_index_tags;
>  =09int index;
> =20
> +=09if (expose_mq_experimental)
> +=09=09return sbitmap_get(slot_index_tags,
> +=09=09=09=09   hisi_hba->sbitmap_alloc_hint, false);
> +
>  =09if (scmd)
>  =09=09return scmd->request->tag;
> =20
> @@ -583,7 +597,10 @@ static void slot_index_free_v3_hw(struct hisi_hba *h=
isi_hba, int slot_idx)
>  {
>  =09struct sbitmap *slot_index_tags =3D &hisi_hba->slot_index_tags;
> =20
> -=09if (slot_idx >=3D HISI_SAS_UNRESERVED_IPTT)
> +=09if (expose_mq_experimental) {
> +=09=09sbitmap_clear_bit(slot_index_tags, slot_idx);
> +=09=09hisi_hba->sbitmap_alloc_hint =3D slot_idx;
> +=09} else if (slot_idx >=3D HISI_SAS_UNRESERVED_IPTT)
>  =09=09sbitmap_clear_bit(slot_index_tags,
>  =09=09=09=09  slot_idx - HISI_SAS_UNRESERVED_IPTT);
>  }
> @@ -2414,8 +2431,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba =
*hisi_hba)
>  =09struct device *dev =3D hisi_hba->dev;
>  =09int vectors;
>  =09int max_msi =3D HISI_SAS_MSI_COUNT_V3_HW, min_msi;
> +=09struct Scsi_Host *shost =3D hisi_hba->shost;
> =20
> -=09if (auto_affine_msi_experimental) {
> +=09if (auto_affine_msi_experimental || expose_mq_experimental) {
>  =09=09struct irq_affinity desc =3D {
>  =09=09=09.pre_vectors =3D BASE_VECTORS_V3_HW,
>  =09=09};
> @@ -2434,7 +2452,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba =
*hisi_hba)
>  =09=09=09=09=09=09=09 &desc);
>  =09=09if (vectors < 0)
>  =09=09=09return -ENOENT;
> -=09=09setup_reply_map_v3_hw(hisi_hba, vectors - BASE_VECTORS_V3_HW);
> +=09=09if (auto_affine_msi_experimental)
> +=09=09=09setup_reply_map_v3_hw(hisi_hba,
> +=09=09=09=09=09      vectors - BASE_VECTORS_V3_HW);
>  =09} else {
>  =09=09min_msi =3D max_msi;
>  =09=09vectors =3D pci_alloc_irq_vectors(hisi_hba->pci_dev, min_msi,
> @@ -2444,6 +2464,9 @@ static int interrupt_preinit_v3_hw(struct hisi_hba =
*hisi_hba)
>  =09}
> =20
>  =09hisi_hba->cq_nvecs =3D vectors - BASE_VECTORS_V3_HW;
> +=09if (expose_mq_experimental)
> +=09=09shost->nr_hw_queues =3D hisi_hba->cq_nvecs;
> +
>  =09return 0;
>  }
> =20
> @@ -3096,6 +3119,17 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba =
*hisi_hba, bool enable)
>  =09return 0;
>  }
> =20
> +static int hisi_sas_map_queues(struct Scsi_Host *shost)
> +{
> +=09struct hisi_hba *hisi_hba =3D shost_priv(shost);
> +=09struct blk_mq_queue_map *qmap =3D &shost->tag_set.map[HCTX_TYPE_DEFAU=
LT];
> +
> +=09if (expose_mq_experimental)
> +=09=09return blk_mq_pci_map_queues(qmap, hisi_hba->pci_dev,
> +=09=09=09=09=09     BASE_VECTORS_V3_HW);
> +=09return blk_mq_map_queues(qmap);
> +}
> +
>  static struct scsi_host_template sht_v3_hw =3D {
>  =09.name=09=09=09=3D DRV_NAME,
>  =09.module=09=09=09=3D THIS_MODULE,
> @@ -3104,6 +3138,7 @@ static struct scsi_host_template sht_v3_hw =3D {
>  =09.slave_configure=09=3D hisi_sas_slave_configure,
>  =09.scan_finished=09=09=3D hisi_sas_scan_finished,
>  =09.scan_start=09=09=3D hisi_sas_scan_start,
> +=09.map_queues=09=09=3D hisi_sas_map_queues,
>  =09.change_queue_depth=09=3D sas_change_queue_depth,
>  =09.bios_param=09=09=3D sas_bios_param,
>  =09.this_id=09=09=3D -1,
> @@ -3265,8 +3300,14 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
>  =09shost->max_lun =3D ~0;
>  =09shost->max_channel =3D 1;
>  =09shost->max_cmd_len =3D 16;
> -=09shost->can_queue =3D HISI_SAS_UNRESERVED_IPTT;
> -=09shost->cmd_per_lun =3D HISI_SAS_UNRESERVED_IPTT;
> +
> +=09if (expose_mq_experimental) {
> +=09=09shost->can_queue =3D HISI_SAS_MAX_COMMANDS;
> +=09=09shost->cmd_per_lun =3D HISI_SAS_MAX_COMMANDS;

The above is contradictory with current 'nr_hw_queues''s meaning,
see commit on Scsi_Host.nr_hw_queues.


        /*
         * In scsi-mq mode, the number of hardware queues supported by the =
LLD.
         *
         * Note: it is assumed that each hardware queue has a queue depth o=
f
         * can_queue. In other words, the total queue depth per host
         * is nr_hw_queues * can_queue.
         */

Also this implementation wastes memory too much.


thanks,
Ming

