Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41D3C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8AE8206DA
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 22:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czkZ0HmM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKUWLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 17:11:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55144 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbfKUWLI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 17:11:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574374267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7MkfNJx9/hhZw9H16C+fuOJ+aoE1z057cKicSME1zs=;
        b=czkZ0HmMcfUN7uaTdVNu0zByrS2H3mzxg7b9tqRXdcKmY9TT/omA4exXXu6t/OWRv3U3W/
        fwNt6qjnN41b+MEMKqZ7A4kZRLEScA+RQhAytMB/dOa5G8ojlaRf/1xDWkB6Tke70IuKLn
        0XFNn54Vrmz+0hgiOgmkkHFj8IEgcac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-GGznGNIVNTyVw49FEzU9oQ-1; Thu, 21 Nov 2019 17:11:03 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B70E4800054;
        Thu, 21 Nov 2019 22:11:02 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B70E5EE1A;
        Thu, 21 Nov 2019 22:11:02 +0000 (UTC)
Message-ID: <d7e46473766b16bb21290180d333216175aba4d7.camel@redhat.com>
Subject: Re: [PATCH] lpfc: size cpu map by last cpu id set
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
Date:   Thu, 21 Nov 2019 17:11:01 -0500
In-Reply-To: <20191121175556.18953-1-jsmart2021@gmail.com>
References: <20191121175556.18953-1-jsmart2021@gmail.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: GGznGNIVNTyVw49FEzU9oQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-11-21 at 09:55 -0800, James Smart wrote:
> Currently the lpfc driver sizes its cpu_map array based on
> num_possible_cpus(). However, that can be a value that is less
> than the highest cpu id bit that is set. As such, if a thread
> runs on a cpu with a larger cpu id, or for_each_possible_cpu()
> is used, the driver could index off the end of the array and
> return garbage or GPF.
>=20
> The driver maintains it's own internal copy of the "num_possible"
> cpu value and sizes arrays by it.
>=20
> Fix by setting the driver's value to the value of the last cpu id
> bit set in the possible_mask - plus 1. Thus cpu_map will be sized
> to allow access by any cpu id possible.
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.=
c
> index e9323889f199..cd83617354a1 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -6460,7 +6460,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *ph=
ba)
>  =09u32 if_fam;
> =20
>  =09phba->sli4_hba.num_present_cpu =3D lpfc_present_cpu;
> -=09phba->sli4_hba.num_possible_cpu =3D num_possible_cpus();
> +=09phba->sli4_hba.num_possible_cpu =3D cpumask_last(cpu_possible_mask) +=
 1;
>  =09phba->sli4_hba.curr_disp_cpu =3D 0;
>  =09lpfc_cpumask_of_node_init(phba);
> =20

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

