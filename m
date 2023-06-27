Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470D9EB64D9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjF0ITL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjF0ITJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:19:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC74C1BC0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687853896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYcUtRkjKABtT5PU3mxAKBDSxEwKFf/d8voooDnS1zM=;
        b=hxwQS5RxJr5+JaEimQ+XKvC1J//W7dbVG32kQq8Dr1l2G4HXkAM7Cia/xumVsSY0wnlcIN
        1/K/tiBegN/9xCWrdL5GBlvC20ZgHnFTa0tsileTmVGXcAN/Y9VNgU6/kMsSYFRk2m0OZz
        0Ug6VJTJwL8wEaGvS+kcAH9Vdyaf9y4=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-FLaHN_eTMHSm8y9PXEn_kQ-1; Tue, 27 Jun 2023 04:18:14 -0400
X-MC-Unique: FLaHN_eTMHSm8y9PXEn_kQ-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-471ae16a13eso755544e0c.0
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687853893; x=1690445893;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYcUtRkjKABtT5PU3mxAKBDSxEwKFf/d8voooDnS1zM=;
        b=QC5uEhg4Va1nbsSdyaUPpHJlzqRRfwyCfl2Q+OL+9TjPqSI+HDLpDxBKrYiFFHJtCN
         Bv+r40jn/GUD37ch0xiQ7K/VT9+0muwz2rhHtfxnI8NW7uHL976qluSXAdNoLxBzBaIO
         M3Uk3jtjS9ab978l0tB2eOHdObeqVCh05XfUaFTTffVC6f73CdKBmpEgHlmdPS9HdI8U
         dt8YxMQ2Zec7mWgLZtMkgQyMMOLi3LUmsDuY1z1Hli7ZtVxmzPFKtqVRLyrPsOda1AWs
         ExFBcCoXu2GiCCSJuEQD3UzAE6vZbQOc36yc3Rse7jZ8NkFqRb6LkUFr2h+nO2/Q9uxQ
         B7OA==
X-Gm-Message-State: AC+VfDwJG5LJZztucLBHz8VucUcC5xKYi93nvp6P5d2hWMG/z5ZzYJWc
        42Y4/AGxFcS/qw6r/W0eHvt6KA7xQQLBT3CPta+X7jj6h7mqCBNaN4UzYS3+Kua1b9PZ3aox07l
        x+G/2b9QQZaG/j7SLsNeg6Kyce2hfrgXKXu0r4/zjB7Q9lw==
X-Received: by 2002:a1f:c843:0:b0:463:12f:d38e with SMTP id y64-20020a1fc843000000b00463012fd38emr14945014vkf.1.1687853892998;
        Tue, 27 Jun 2023 01:18:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5JCsXkFdXsohKWGcYGlMRJ3lWcD9SmwA2HTltke5r0xofEExL2YsUM8RfwnV6/24CiTUfaR1a/bRIRt89283s=
X-Received: by 2002:a1f:c843:0:b0:463:12f:d38e with SMTP id
 y64-20020a1fc843000000b00463012fd38emr14945008vkf.1.1687853892742; Tue, 27
 Jun 2023 01:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230623161136.6270-1-michael.christie@oracle.com>
In-Reply-To: <20230623161136.6270-1-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 27 Jun 2023 10:18:00 +0200
Message-ID: <CAFL455mj8f_D_uv1fcwuDRMX-HwBhagwe9kpvJS1fdQhR2cM0w@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: target: Quiet bool conversion warning with
 pr_preempt use
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

p=C3=A1 23. 6. 2023 v 18:13 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> We want to pass in true for pr_preempt's argument if we are doing a
> PRO_PREEMPT_AND_ABORT, so just test sa against PRO_PREEMPT_AND_ABORT, and
> pass the result directly to pr_preempt.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306221655.Kwtqi1gI-lkp@i=
ntel.com/
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_iblock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_=
core_iblock.c
> index a3c5f3558a33..3d1b511ea284 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -888,7 +888,7 @@ static sense_reason_t iblock_execute_pr_out(struct se=
_cmd *cmd, u8 sa, u64 key,
>
>                 ret =3D ops->pr_preempt(bdev, key, sa_key,
>                                       scsi_pr_type_to_block(type),
> -                                     sa =3D=3D PRO_PREEMPT ? false : tru=
e);
> +                                     sa =3D=3D PRO_PREEMPT_AND_ABORT);
>                 break;
>         case PRO_RELEASE:
>                 if (!ops->pr_clear) {
> --
> 2.25.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

