Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF81AC33CB8
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B611B2087E
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 07:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YeN/z+VY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgASHPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 02:15:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58042 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726396AbgASHPa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jan 2020 02:15:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579418128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pn4SA7nmTt+ix5HXMB4kLh+eSavv2+gG8CXaUSteEw4=;
        b=YeN/z+VYAEz14OESAlwDSpwVRE9c9vHq/g71JoCVhK69fVcKLPyG5Rhvh0qWPx6NVp6WLm
        dBQ6kDb8LPxpT43IyG2WVcjY/+mQSTw9NrPTdN+IaZ9b5aoqvONWXrmc7nv3JKM0zjaIjT
        R0UzZvkjKS1Loc98cvtN1YUkeEQp9bo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-1Q2T7_OJMieiKD9k-A8Svg-1; Sun, 19 Jan 2020 02:15:25 -0500
X-MC-Unique: 1Q2T7_OJMieiKD9k-A8Svg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8845D800D41;
        Sun, 19 Jan 2020 07:15:23 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B25684BC8;
        Sun, 19 Jan 2020 07:15:20 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ming Lei <ming.lei@redhat.com>,
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
Subject: [PATCH 6/6] scsi: megaraid: set flag of no_device_queue_for_ssd
Date:   Sun, 19 Jan 2020 15:14:32 +0800
Message-Id: <20200119071432.18558-7-ming.lei@redhat.com>
In-Reply-To: <20200119071432.18558-1-ming.lei@redhat.com>
References: <20200119071432.18558-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

megraraid sas is one high end HBA, and the IOPS may reach million level.
As discussed before, megaraid sas performance can be improved on SSD
when the device busy check is bypassed.

So set the flag of no_device_queue_for_ssd for megaraid sas.

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
 drivers/scsi/megaraid/megaraid_sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index 43cbc749f66c..8f3770af7382 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3424,6 +3424,7 @@ static struct scsi_host_template megasas_template =3D=
 {
 	.bios_param =3D megasas_bios_param,
 	.change_queue_depth =3D scsi_change_queue_depth,
 	.max_segment_size =3D 0xffffffff,
+	.no_device_queue_for_ssd =3D 1,
 };
=20
 /**
--=20
2.20.1

