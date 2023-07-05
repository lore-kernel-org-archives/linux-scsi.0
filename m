Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1658C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jul 2023 14:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjGEOfx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 10:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjGEOfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 10:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE0210D5
        for <linux-scsi@vger.kernel.org>; Wed,  5 Jul 2023 07:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688567711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EPFecaivr54rVjCWMqN8jp7NqN4gyR5hEtTh6S4C2F0=;
        b=Eo1TQ0thZJVsjl5o+HDYCI8sSLJoltubT4Vn7CtGF9MhI35qD98NNptn3CqIdtCXBWWnzY
        /trxraMMKQn/3URd3XVcfL8faIxuonFacfChAoczhVjvWSMn9lQe03LblbKUIH+3l9zV8v
        QocU+DQjs5Ja3bnxR+zXlx5mFWgeyuc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-LryW92PzOe6phc2Vz26Vpg-1; Wed, 05 Jul 2023 10:35:11 -0400
X-MC-Unique: LryW92PzOe6phc2Vz26Vpg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-635e6c83d77so47969386d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2023 07:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688567709; x=1691159709;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EPFecaivr54rVjCWMqN8jp7NqN4gyR5hEtTh6S4C2F0=;
        b=bsvrqhguU3doILBT/gA+VYaiiZmFRswOMoV8mNbl87pGpXmSM3jcSc5RyB7NcEYiuY
         Pu8y6XjJZ8BUWBEuSKXc8JQ3vXOfiSZ9fPqvewiBVD58J9+RY4/JAqSEdgBVSIsL1naE
         84kXbyVVzwVY5HgwV8N3d+JGsK+BB02rvHpXe1wpYLnKvnXXIzwLPDORETdm4XUar5b+
         nBg51LwOttrBNJ6uzCBJFJjc7TLST7HdztOoU2qp7/nYgASRiocliCvp7Oov7TKy5ZTy
         2q9ZmYxUDR0xEIMUyHtO8HfnJXbpBDY5QmAfbkz4O/V/k2pl2g2yqnricVc0i42oqb3Q
         MjBQ==
X-Gm-Message-State: ABy/qLZzluNpoJuiASJLkJcX40gCE2wrPHff8vXebOZHbDsLNkW/iofs
        wYRn3cU89lr3iTI57Gue2OyXUWG0l2KfT5gh41Gwx/jZdN7Ez14soWWiyXbYjV3KlWtGHpPloaM
        TWiJ156xHc6BwFgYz7PxP2g==
X-Received: by 2002:ad4:5765:0:b0:630:44b:180d with SMTP id r5-20020ad45765000000b00630044b180dmr18862426qvx.25.1688567709466;
        Wed, 05 Jul 2023 07:35:09 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHFyXlkEh+mHD4R3+SJyx2btDLMuQniRGZbkM0WraI/J70rRiNQccu387F7tHzH+jcR7nwgGA==
X-Received: by 2002:ad4:5765:0:b0:630:44b:180d with SMTP id r5-20020ad45765000000b00630044b180dmr18862413qvx.25.1688567709187;
        Wed, 05 Jul 2023 07:35:09 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id mz14-20020a0562142d0e00b006300e1db3ecsm13454637qvb.141.2023.07.05.07.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 07:35:08 -0700 (PDT)
Message-ID: <6105b8bf9d35ca2906094a0f9a58b5351bc741da.camel@redhat.com>
Subject: Re: [PATCH] scsi: lpfc: Fix a possible data race in
 lpfc_unregister_fcf_rescan()
From:   Laurence Oberman <loberman@redhat.com>
To:     Tuo Li <islituo@gmail.com>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@outlook.com, BassCheck <bass@buaa.edu.cn>
Date:   Wed, 05 Jul 2023 10:35:08 -0400
In-Reply-To: <20230630024748.1035993-1-islituo@gmail.com>
References: <20230630024748.1035993-1-islituo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2023-06-30 at 10:47 +0800, Tuo Li wrote:
> The variable phba->fcf.fcf_flag is often protected by the lock=20
> phba->hbalock() when is accessed. Here is an example in=20
> lpfc_unregister_fcf_rescan():
>=20
> =C2=A0 spin_lock_irq(&phba->hbalock);
> =C2=A0 phba->fcf.fcf_flag |=3D FCF_INIT_DISC;
> =C2=A0 spin_unlock_irq(&phba->hbalock);
>=20
> However, in the same function, phba->fcf.fcf_flag is assigned with 0=20
> without holding the lock, and thus can cause a data race:
>=20
> =C2=A0 phba->fcf.fcf_flag =3D 0;
>=20
> To fix this possible data race, a lock and unlock pair is added when=20
> accessing the variable phba->fcf.fcf_flag.
>=20
> Reported-by: BassCheck <bass@buaa.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
> =C2=A0drivers/scsi/lpfc/lpfc_hbadisc.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c
> b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 5ba3a9ad9501..9d2feb69cae7 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -6961,7 +6961,9 @@ lpfc_unregister_fcf_rescan(struct lpfc_hba
> *phba)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (rc)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Reset HBA FCF states a=
fter successful unregister FCF */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irq(&phba->hbalock);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0phba->fcf.fcf_flag =3D 0;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock_irq(&phba->hbalock=
);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0phba->fcf.current_rec.fla=
g =3D 0;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*

This makes sense and looks good to me
Reviewed-by: Laurence Oberman <loberman@redhat.com>

