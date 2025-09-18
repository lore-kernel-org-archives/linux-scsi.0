Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C1F286D70
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 23:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237886; cv=none; b=bKx9iptY/QaMh5XulS5qYptlXcI77i57LfBchRPv/e7EndmdkxIFiuLK0+wh+Sn2eqcxc4HpSpXp169gUk+2mbmljRWa1MVTeGL0VY4FuRVRyf2BRgmtfp6QFMrBfou8IM3tsDNU8CGCYht1iUTTmysJUvTGvD3bb/Gli45meCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237886; c=relaxed/simple;
	bh=KJ6eDJFZIq1v7BWaE8E+JtTKTM/ntkeLT86o6EjF27g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JnisWfFKvu6/QpWr9mu4QG9Nx4D8mxtCjfd7ZumoObV4vT6gl63ci6SwKqh8JoIYglsOt1g8AmUmDVHPvZnz4bj0ToKqJ1fODKGj6BH7MV4/qgzyFGkEf+GbYDpupOdr5BSn7qozbs0Szrwa9KcYKB2+YVkQnLrycwTFG0RlXCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZT4tzB/b; arc=none smtp.client-ip=74.125.224.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZT4tzB/b"
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-632e9c6b411so912207d50.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 16:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758237884; x=1758842684; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CvsGel4kr99TW5YyyaaFZ7yb3mg4vfy3/AwN3gMDYlU=;
        b=ZT4tzB/b0FXWbXbc4V5XpQR9izM6DXvrc5SrRLsUUX818wRaNDjqnk8kUUbIyKl7TB
         JYxug4LTXl1GfvSE/b4kDPN+zeVsxWq4FcLcBhQHE7YZ34L3zrNeAy7qFxPcTHMP3LzE
         8fEt9EhTUQOgk1iaRMeVq2ELT3lfxYDP0KZ/gL6lNxdETlTccUtZkbVkQ668a0ySxqJo
         JCWcc1LLJH+IZuXvmGDK6uB4vn9iH8mVM2JWtJJLPf0+wBRdErOfpASUR5W9/8/8KS/9
         9byX8FSKxsWamtC4RgI07jw8S0kjxV4CsVSCi4lhx3PDVvXMgmTV7K+SQhkvlrk+PruG
         iLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758237884; x=1758842684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvsGel4kr99TW5YyyaaFZ7yb3mg4vfy3/AwN3gMDYlU=;
        b=T4MM/HjTyvWou+YoGL/XRquWiCKgkj78SePrfNV2q33W6vbuUctpzupZjy7+fmYV3S
         l9dSMrZXRajBdvID8ntWvRHYvFed1Lrs7xdgkTQaGVR1joC0IUDOgcJ4XBoO/KFZX0L5
         UkScTpGYIyp2TcubZ7q7uXua/no4P22HHRUYJUcrWlgBeC73s83E0Fb7Wy6nRDYXo1Ig
         66izU6zzeCUY6DRSLY5i7GdUqNjcTMErcIF9/NhHxF5+GtE1C7OJo/aXtkWFUFrY7rrq
         YfwqmRfeywWbF+5NKyC82MwBPbHaxNBJLkpI52eE3ETbMSJy0jjKV60nhFkYhOgmPJVd
         78SQ==
X-Forwarded-Encrypted: i=1; AJvYcCUY57g6TnrECQ8yA9q919CSCdn6dZvZO7xqTPXfLjafa3zrB2pbLkiAIVe3CjbFfIyvNja/Ia4s461o@vger.kernel.org
X-Gm-Message-State: AOJu0YyiPpOAaZFzOyGVQZNX1PHLzGWK0ganW1C9OnhvL/4gEjFp0mqS
	WpVi1r68u5Uf2gDenkX2uioMWhIEZTGwbe4YHZd6w7OzlvdAUkVwuoGCHdXvimQtJ7OIHIIRfeS
	HF7bz9JDy7xYbOdYX1YEXY4uIg0BVY+M=
X-Gm-Gg: ASbGncsYp0/r7tw9iVe1sBRVcz95UZoQRiDdj+JnKyVHEcFS/ZlHTNXC1lObxfhq6Dp
	Qyfg8aSlWR3ox9r2VCmx0rshNBY68IJ8otJf7Wt4HBi6vPVCESiz7U3dRB+Favt9/DLY9T5vrQU
	Mk4rYF5LkOJ4Y+txUwvbPyWG4afkUw18CFuGOVGRTCcft/GRn9Qhjkc2a1Xid1NYwTuxUipMym6
	QAenUr0iyrJQFy65+4wfgSDs80=
X-Google-Smtp-Source: AGHT+IGnlRT51Rt/EmIV+6PuLeofyi5CG17OdD1HpDWJozqBX1ywLiIjRWssfaPB3W3r+0+fH94losGcIjmTdT9C9/U=
X-Received: by 2002:a05:690e:d50:b0:62e:35c:f4dd with SMTP id
 956f58d0204a3-6347f5a2ce8mr1145514d50.28.1758237883961; Thu, 18 Sep 2025
 16:24:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917141806.661826-1-yury.norov@gmail.com>
In-Reply-To: <20250917141806.661826-1-yury.norov@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 18 Sep 2025 16:24:30 -0700
X-Gm-Features: AS18NWCx6-1PZIfOInuho6Ua4GZ5_d0gdGjoTSTVK59NruqS-sIn5SQORAc7xug
Message-ID: <CABPRKS9mmUCig30yz4DE1JgAkS+NejeZwr74rd80F5actbS6_Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
To: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Cc: James Smart <james.smart@broadcom.com>, Justin Tee <justin.tee@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Yury,

> +                       if (phba->fcf.fcf_pri[next].fcf_rec.flag & LPFC_FCF_FLOGI_FAILED == 0) {

May we change this to?
if (!(phba->fcf.fcf_pri[next].fcf_rec.flag & LPFC_FCF_FLOGI_FAILED)) {

Thank you for noticing and implementing the rework.

Regards,
Justin Tee
