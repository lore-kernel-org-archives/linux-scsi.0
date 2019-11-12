Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F018C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55BBE20818
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SbmHXZN/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKLScl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:32:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26184 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbfKLSck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 13:32:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573583559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T37uMfb11Vm2Z+tIw2JnYl/U06oZA8r7nuixmJI/izs=;
        b=SbmHXZN/KIzSROQ+fkw3PYQ3dzmbzskqMqp+54x5Ca0qDFgEcCiRtJXAoPrpVmt+Sfbv0v
        hC2AyCsWxHlzENnwhBroaMXN/F/xo+7BqaTD+CcwaXsZI08P8sm6axcKzjvS3GHiS1eB1f
        o3dahLJ5C5uDApQEiJLP6sgkuTqHEHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-enopd-hDPhOZsgFJCoOogA-1; Tue, 12 Nov 2019 13:32:38 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C30E19A3B7;
        Tue, 12 Nov 2019 18:32:37 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 512B91B477;
        Tue, 12 Nov 2019 18:32:37 +0000 (UTC)
Message-ID: <36d2fa998e37b69cd744b88e71b3f6cc06880c25.camel@redhat.com>
Subject: Re: [PATCH 4/6] lpfc: Initialize cpu_map for not present cpus
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
Date:   Tue, 12 Nov 2019 13:32:36 -0500
In-Reply-To: <20191111230401.12958-5-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
         <20191111230401.12958-5-jsmart2021@gmail.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: enopd-hDPhOZsgFJCoOogA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-11-11 at 15:03 -0800, James Smart wrote:
> Currently, cpu_map[cpu#]->hdwq is left to equal
> LPFC_VECTOR_MAP_EMPTY for not present CPUs.  If a CPU
> is dynamically hot-added, it is possible we may crash due to
> not assigning an allocated hdwq.
>=20
> Correct by assigning a hdwq at initialization for all
> not-present cpu's.
>=20
> Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD archite=
ctures")
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
> Issue applies as of the 12.2.0.0 patch kit, but this fix requires
> the above patch set for resolution. Referenced patch is in the
> 5.5/scsi-queue branch
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index 480d5a28c4f5..2b0e1097f727 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11004,7 +11004,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, in=
t vectors)
>  =09=09=09=09cpu, cpup->phys_id, cpup->core_id,
>  =09=09=09=09cpup->hdwq, cpup->eq, cpup->flag);
>  =09}
> -=09/* Finally we need to associate a hdwq with each cpu_map entry
> +=09/* Associate a hdwq with each cpu_map entry
>  =09 * This will be 1 to 1 - hdwq to cpu, unless there are less
>  =09 * hardware queues then CPUs. For that case we will just round-robin
>  =09 * the available hardware queues as they get assigned to CPUs.
> @@ -11083,6 +11083,23 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, i=
nt vectors)
>  =09=09=09=09cpup->hdwq, cpup->eq, cpup->flag);
>  =09}
> =20
> +=09/*
> +=09 * Initialize the cpu_map slots for not-present cpus in case
> +=09 * a cpu is hot-added. Perform a simple hdwq round robin assignment.
> +=09 */
> +=09idx =3D 0;
> +=09for_each_possible_cpu(cpu) {
> +=09=09cpup =3D &phba->sli4_hba.cpu_map[cpu];
> +=09=09if (cpup->hdwq !=3D LPFC_VECTOR_MAP_EMPTY)
> +=09=09=09continue;
> +
> +=09=09cpup->hdwq =3D idx++ % phba->cfg_hdw_queue;
> +=09=09lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
> +=09=09=09=09"3340 Set Affinity: not present "
> +=09=09=09=09"CPU %d hdwq %d\n",
> +=09=09=09=09cpu, cpup->hdwq);
> +=09}
> +
>  =09/* The cpu_map array will be used later during initialization
>  =09 * when EQ / CQ / WQs are allocated and configured.
>  =09 */

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

