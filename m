Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30022C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 03:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091F620815
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 03:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lnq7IvwP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfKYDy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Nov 2019 22:54:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727007AbfKYDy6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Nov 2019 22:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574654098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CPOHOcFtU4rdB9Bxe7jxRbzwI9Lm1XbZyUIUwlUdhY=;
        b=Lnq7IvwPBma6ZsX6jFZkefNCNyRkv4+G8MDE1ySZc+B32+S31q9bXFAkOdhoANpmAkf28s
        8IpmKVMk8mvdCAZcTVHMXQRQr7xcqTadjSpuTAlEC6Qc196DS+sVKcbGVpRaWgNDDQJeEY
        XXA1bkVqZmCzhN73c5HR3AZg+mI2lTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-ozaAnZOCOr6nsvFH9H5FQw-1; Sun, 24 Nov 2019 22:54:54 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AA5B801E63;
        Mon, 25 Nov 2019 03:54:52 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B29F60C18;
        Mon, 25 Nov 2019 03:54:42 +0000 (UTC)
Date:   Mon, 25 Nov 2019 11:54:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Andrea Vai <andrea.vai@unipv.it>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
Message-ID: <20191125035437.GA3806@ming.t460p>
References: <Pine.LNX.4.44L0.1911061044070.1694-100000@iolanthe.rowland.org>
 <BYAPR04MB5816640CEF40CB52430BBD3AE7790@BYAPR04MB5816.namprd04.prod.outlook.com>
 <b22c1dd95e6a262cf2667bee3913b412c1436746.camel@unipv.it>
 <BYAPR04MB58167B95AF6B7CDB39D24C52E7780@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CAOsYWL3NkDw6iK3q81=5L-02w=VgPF_+tYvfgnTihgCcwKgA+g@mail.gmail.com>
 <20191109222828.GA30568@ming.t460p>
 <fa3b0cf1f88e42e1200101bccbc797e4e7778d58.camel@unipv.it>
 <20191123072726.GC25356@ming.t460p>
 <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
MIME-Version: 1.0
In-Reply-To: <a9ffcca93657cbbb56819fd883c474a702423b41.camel@unipv.it>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ozaAnZOCOr6nsvFH9H5FQw-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2019 at 04:44:55PM +0100, Andrea Vai wrote:
> Il giorno sab, 23/11/2019 alle 15.28 +0800, Ming Lei ha scritto:
> >=20
> > Please post the log of 'lsusb -v', and I will try to make a patch
> > for
> > addressing the issue.
>=20
> attached,

Please apply the attached patch, and re-build & install & reboot kernel.

This time, please don't switch io scheduler.

Thanks,
Ming

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="usb.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5c9adcaa27ac..eecb46020bfb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1436,7 +1436,13 @@ static void __blk_mq_delay_run_hw_queue(struct blk_m=
q_hw_ctx *hctx, bool async,
 =09if (unlikely(blk_mq_hctx_stopped(hctx)))
 =09=09return;
=20
-=09if (!async && !(hctx->flags & BLK_MQ_F_BLOCKING)) {
+=09/*
+=09 * Some single-queue devices may need to dispatch IO in order
+=09 * which was guaranteed for the legacy queue via the big queue
+=09 * lock. Now we reply on single hctx->run_work for that.
+=09 */
+=09if (!async && !(hctx->flags & (BLK_MQ_F_BLOCKING |
+=09=09=09=09=09BLK_MQ_F_STRICT_DISPATCH_ORDER))) {
 =09=09int cpu =3D get_cpu();
 =09=09if (cpumask_test_cpu(cpu, hctx->cpumask)) {
 =09=09=09__blk_mq_run_hw_queue(hctx);
@@ -3042,6 +3048,10 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
 =09if (!set->ops->get_budget ^ !set->ops->put_budget)
 =09=09return -EINVAL;
=20
+=09if (set->queue_depth > 1 && (set->flags &
+=09=09=09=09BLK_MQ_F_STRICT_DISPATCH_ORDER))
+=09=09return -EINVAL;
+
 =09if (set->queue_depth > BLK_MQ_MAX_DEPTH) {
 =09=09pr_info("blk-mq: reduced tag depth to %u\n",
 =09=09=09BLK_MQ_MAX_DEPTH);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d3d237a09a78..563188844143 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1939,6 +1939,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 =09shost->tag_set.flags =3D BLK_MQ_F_SHOULD_MERGE;
 =09shost->tag_set.flags |=3D
 =09=09BLK_ALLOC_POLICY_TO_MQ_FLAG(shost->hostt->tag_alloc_policy);
+=09if (shost->hostt->strict_dispatch_order)
+=09=09shost->tag_set.flags |=3D BLK_MQ_F_STRICT_DISPATCH_ORDER;
+
 =09shost->tag_set.driver_data =3D shost;
=20
 =09return blk_mq_alloc_tag_set(&shost->tag_set);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.=
c
index 6737fab94959..77795edad8e8 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -661,6 +661,18 @@ static const struct scsi_host_template usb_stor_host_t=
emplate =3D {
 =09/* we do our own delay after a device or bus reset */
 =09.skip_settle_delay =3D=09=091,
=20
+
+=09/*
+=09 * Some USB storage, such as Kingston Technology DataTraveler 100
+=09 * G3/G4/SE9 G2(ID 0951:1666), requires IO dispatched in the
+=09 * sequential order, otherwise IO performance may drop drastically.
+=09 *
+=09 * can_queue is always 1, so we set .strict_dispatch_order for
+=09 * USB mass storage HBA. Another reason is that there can be such
+=09 * kind of devices too.
+=09 */
+=09.strict_dispatch_order =3D=091,
+
 =09/* sysfs device attributes */
 =09.sdev_attrs =3D=09=09=09sysfs_device_attr_list,
=20
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index dc03e059fdff..844539690a27 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -388,6 +388,7 @@ struct blk_mq_ops {
 enum {
 =09BLK_MQ_F_SHOULD_MERGE=09=3D 1 << 0,
 =09BLK_MQ_F_TAG_SHARED=09=3D 1 << 1,
+=09BLK_MQ_F_STRICT_DISPATCH_ORDER=09=3D 1 << 2,
 =09BLK_MQ_F_BLOCKING=09=3D 1 << 5,
 =09BLK_MQ_F_NO_SCHED=09=3D 1 << 6,
 =09BLK_MQ_F_ALLOC_POLICY_START_BIT =3D 8,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d4452d0ea3c7..f932d6fa1a4c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -442,6 +442,13 @@ struct scsi_host_template {
 =09/* True if the low-level driver supports blk-mq only */
 =09unsigned force_blk_mq:1;
=20
+=09/*
+=09 * True if the low-level driver needs IO to be dispatched in
+=09 * the order provided by legacy IO path. The flag is only
+=09 * valid for single queue device.
+=09 */
+=09unsigned strict_dispatch_order:1;
+
 =09/*
 =09 * Countdown for host blocking with no commands outstanding.
 =09 */

--45Z9DzgjV8m4Oswq--

