Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404FA173;
	Thu,  9 Jan 2025 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429655; cv=none; b=RzrfKpIG5lJ+FDwneiLxqAMIogyft/YQyfMxIdIj3S91rJnU8TGaaEk0NnTYOJkn6saa486bMb1rabk6F50gpiyIgzqlpYdXTG2X2yP94avlhh9+m9ozhaWC/Y7WLS8XxDPkowciExoTG9j37gJPl2I9lKrhLoCtzeqo8axlu5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429655; c=relaxed/simple;
	bh=xxksU+xs3cu/kZ/FTLBqcNXXpTB/kcYOniBoY58rG3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJN3lOeMiMfGVjZdvPjAigKXC3Pd5Pjz2HBRID6FVhmH52/vjd5oL6RofJ/UxhgpPk7BmUQ2pMi2OA7RK8ULWmPEyGlSJMnc5KlwZtyfD1u0tzQV31Vu0iXRDELGUdvaWHb7FprqDLJTCflwp+nhYuRal+p5TvoQ/5hG8OWtOzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fotUD5MN; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fotUD5MN"
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-5d3bdccba49so1355249a12.1;
        Thu, 09 Jan 2025 05:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736429648; x=1737034448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xxksU+xs3cu/kZ/FTLBqcNXXpTB/kcYOniBoY58rG3k=;
        b=fotUD5MNy3QE/EoG6GqVtzzg5f6Rm+qX9pzbh3ylbKSJ9dimZBO6c2OlueRd4Sj+RE
         LVB6NRoozHmMtsSe7YVTNeMBV0yT0V+PcMCEyJMCZjZNiVdb9I184HWGvRnk2xZZBXgV
         AXn+bW9aNmZrhjOg9DWYvac1bFKjS0tf66kZ3qxMZlRwW1E31COMkogPtdj37BqmsZJ3
         qUYke+sDXwKa3ZNJkAKlD6dGIGfYZb+GjSB2ZLCB91ZnrVeKJqAxq49cgNmV6cJzEv7+
         Z5kIMr06Res4uKt+37jQA1pPqWwishdt3ptkXXZndBhkdCnepJTrkIfjAjD+nvDf4Cxw
         LhtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736429648; x=1737034448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xxksU+xs3cu/kZ/FTLBqcNXXpTB/kcYOniBoY58rG3k=;
        b=UZt7EiIOErA1IGT5O+emV5L9t2uF0YEMVJ07jumsg0RDqEHL3Aj3XdMsYYQPL4oR1v
         vR/gIAun4qAzGmXsVxgl71WxK+1W9brtxHPQ8bOLDjHsY1sqsUipmteqN/a4FUhkLGa1
         am+1MVKVszK7QHHsK42f0iSc/zBPK+b9tlTZXMsbMDMqecRZPxWOmVdGHI52Pm4aoNfS
         pTUCUmWDVpw0zsumgnEGmlprHZiUz7WyeRVMXF7o5NYMMf+FYUCNoO5lPcyuDB6nnUEi
         tI4pLsF1gZVqigOAKAHwBv81hlDpD7iOOshDpNYsm3iZwvyDogxChHlhbGNdcdIbHkN1
         Xpcw==
X-Forwarded-Encrypted: i=1; AJvYcCUWxHTP+16g/vOZPpBLIYxvwhVbshnjX8/dmy9E16AaMRxwS2DuGXn0h5qwvMbI/0m7HZI9vm7I/uPjbgE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl37zx3CMJzbvINrUuuIikEO0akUtqHKkC7N+Qo2ZCGY8aSNSz
	Rkv/SQeKOfzGVVqnqHa5ToeFKHUHQqiF/OYCh584fbKw87y+Mj9n/tsBi6yIhIiLkXWkEbyr6hh
	ahbI4zDZPy9p9Hwv7/Qt8LiRESd4=
X-Gm-Gg: ASbGncsbujpA04dtFuFxtNbR2RbABaG2q65L9YAJKWkfKbrLSg1Vxkg4A039KM+n/vk
	Nb6LiZOPBaWDyf50N6TO3y5KgML3zL6dctXN1sQ==
X-Google-Smtp-Source: AGHT+IHR1kM+p+Z6ESB7epJPMROCzm0ZIxClESMPvYDZvNV67rWkKHMpdulXjuK+THpgW36TdkuE40ImAJsHgX5XvkA=
X-Received: by 2002:a05:6402:4407:b0:5d3:d733:7ad4 with SMTP id
 4fb4d7f45d1cf-5d972dfe6abmr6733890a12.3.1736429647944; Thu, 09 Jan 2025
 05:34:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241230065041.67315-1-haoqinhuang7@gmail.com>
In-Reply-To: <20241230065041.67315-1-haoqinhuang7@gmail.com>
From: haoqin huang <haoqinhuang7@gmail.com>
Date: Thu, 9 Jan 2025 21:33:55 +0800
X-Gm-Features: AbW1kvZppX8xqNnELoNp4Vocqxhlh2dJBn5H3cVH30L3AWP2RwxyiXXyMyhBHPc
Message-ID: <CAEjiKSkAPzL6+A2Z6OqjgK6MWP--5YEDokZMv=SdvEcESXxDTw@mail.gmail.com>
Subject: Fwd: [PATCH] scsi: qla2xxx: Remove duplicate fcport release in error handler
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com, 
	"James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, martin.petersen@oracle.com, 
	himanshu.madhani@oracle.com, skashyap@marvell.com, szuberi@marvell.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	haoqinhuang <haoqinhuang@tencent.com>, Haisu Wang <haisuwang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello, it's been quite some time since I submitted my patch, and I'm
yet to receive any response. Could you kindly provide me with an
update on the current status of this patch?


=E4=B8=8B=E9=9D=A2=E6=98=AF=E8=A2=AB=E8=BD=AC=E5=8F=91=E7=9A=84=E9=82=AE=E4=
=BB=B6=EF=BC=9A

=E5=8F=91=E4=BB=B6=E4=BA=BA: haoqinhuang <haoqinhuang7@gmail.com>
=E4=B8=BB=E9=A2=98: [PATCH] scsi: qla2xxx: Remove duplicate fcport release =
in error handler
=E6=97=A5=E6=9C=9F: 2024=E5=B9=B412=E6=9C=8830=E6=97=A5 GMT+8 14:50:41
=E6=94=B6=E4=BB=B6=E4=BA=BA: njavali@marvell.com, GR-QLogic-Storage-Upstrea=
m@marvell.com,
James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
himanshu.madhani@oracle.com, skashyap@marvell.com
=E6=8A=84=E9=80=81: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.or=
g,
haoqinhuang <haoqinhuang@tencent.com>, Haisu Wang
<haisuwang@tencent.com>

From: haoqinhuang <haoqinhuang@tencent.com>

After calling function qla2x00_sp_release(), the system automatically
executes the function qla2x00_free_fcport(sp->fcport).

A closer inspection of qla2x00_sp_release() reveals that it triggers a
call to sp->free(sp), where sp->free points to qla2x00_els_dcmd_sp_free.
In function qla2x00_els_dcmd_sp_free(), if sp->fcport exists,
qla2x00_free_fcport(sp->fcport) is triggered.

Given this sequence of events, calling qla2x00_free_fcport(sp->fcport)
again during qla2x00_sp_release() is duplicate. This redundant call
should be eliminated.

Fixes: 82f522ae0d97 ("scsi: qla2xxx: Fix double free of fcport")
Signed-off-by: Haisu Wang <haisuwang@tencent.com>
Signed-off-by: haoqinhuang <haoqinhuang@tencent.com>
---
drivers/scsi/qla2xxx/qla_iocb.c | 2 --
1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_ioc=
b.c
index 0b41e8a06602..faec66bd1951 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2751,7 +2751,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int
els_opcode,
if (!elsio->u.els_logo.els_logo_pyld) {
/* ref: INIT */
kref_put(&sp->cmd_kref, qla2x00_sp_release);
- qla2x00_free_fcport(fcport);
return QLA_FUNCTION_FAILED;
}

@@ -2776,7 +2775,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int
els_opcode,
if (rval !=3D QLA_SUCCESS) {
/* ref: INIT */
kref_put(&sp->cmd_kref, qla2x00_sp_release);
- qla2x00_free_fcport(fcport);
return QLA_FUNCTION_FAILED;
}

--=20
2.43.5
