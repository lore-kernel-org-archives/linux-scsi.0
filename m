Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BF1C17440
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA658206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 18:31:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBLZC+Jz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfKLSbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:31:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725997AbfKLSbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 13:31:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573583501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qb5CTQyhC9XmdTDDdA4lMvKR8hPvbqR2VOWuxiT9754=;
        b=LBLZC+Jz9ByIEqNmKwN6SwS79MSqrVgUiLuNhoTo/lqiH01u5h0XqctOtsFwYgUb7/fyiN
        HgoVH/K0o/lsYKGzti0cXlmBLJFBUvCeJOjRgGM8EiD1JalXRQe0m7ANyRTs8NjiFm2Qol
        EtYbmaFxYV5dYuEw0N9Q7711R+5ToUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-e-25N233P5aecyjPa1o2PA-1; Tue, 12 Nov 2019 13:31:38 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D39DA3A94;
        Tue, 12 Nov 2019 18:31:37 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F80319C69;
        Tue, 12 Nov 2019 18:31:36 +0000 (UTC)
Message-ID: <b0940758df08680e34edf9ce4b435e3f073002f8.camel@redhat.com>
Subject: Re: [PATCH 3/6] lpfc: fix inlining of lpfc_sli4_cleanup_poll_list()
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>
Date:   Tue, 12 Nov 2019 13:31:36 -0500
In-Reply-To: <20191111230401.12958-4-jsmart2021@gmail.com>
References: <20191111230401.12958-1-jsmart2021@gmail.com>
         <20191111230401.12958-4-jsmart2021@gmail.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: e-25N233P5aecyjPa1o2PA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-11-11 at 15:03 -0800, James Smart wrote:
> Compilation can fail due to having an inline function
> reference where the function body is not present.
>=20
> Fix by removing the inline tag.
>=20
> Fixes: 93a4d6f40198 ("scsi: lpfc: Add registration for CPU Offline/Online=
 events")
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
> patch is in the 12.6.0.1 set which is in 5.5/scsi-queue
> ---
>  drivers/scsi/lpfc/lpfc_crtn.h | 2 +-
>  drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.=
h
> index d91aa5330306..ee353c84a097 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -215,7 +215,7 @@ irqreturn_t lpfc_sli_fp_intr_handler(int, void *);
>  irqreturn_t lpfc_sli4_intr_handler(int, void *);
>  irqreturn_t lpfc_sli4_hba_intr_handler(int, void *);
> =20
> -inline void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba);
> +void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba);
>  int lpfc_sli4_poll_eq(struct lpfc_queue *q, uint8_t path);
>  void lpfc_sli4_poll_hbtimer(struct timer_list *t);
>  void lpfc_sli4_start_polling(struct lpfc_queue *q);
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index fad890cea21a..6d82ad9380db 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -14466,7 +14466,7 @@ static inline void lpfc_sli4_remove_from_poll_lis=
t(struct lpfc_queue *eq)
>  =09=09del_timer_sync(&phba->cpuhp_poll_timer);
>  }
> =20
> -inline void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba)
> +void lpfc_sli4_cleanup_poll_list(struct lpfc_hba *phba)
>  {
>  =09struct lpfc_queue *eq, *next;
> =20

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

