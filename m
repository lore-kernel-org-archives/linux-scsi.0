Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954D836A358
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345156; cv=pass; b=rju7t+oygyyrzjTtS0PVXgC4ze4x4x8YAXmGaJ0tFfcsDFo1Snvgvo9YD1nnA26Etak3ZrYYC2O1ywSI1R2IFi/BF8OCiyIIWP2WM8fNhAPDj4okgNnejmCeO6b6gks0fdqr4o9E/P9nrnIpqiI5InaMLN2zr+oXUyawMYZw0aI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345156; c=relaxed/simple;
	bh=eix+jDc1eLMOO495uTBf7ZGaaENlrIzMHe/FDtyYGyw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZQvWqAzU1e8w3vi3riciume1GTY6swk3mI3vuoo2b+NUvJU8lCUYKRiCzFClXJ/lYE2YT4cNvhg/u7S6IeY1CQqxjqQzj7QLC/BAHlSXjke6O44z2ILlO8cxdIt7Dq0fel5k6gJiWfQKknsDLrL7qFXe5wp83owTsdAHrXGikGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/JTcWEx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cNOj3cFW; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/JTcWEx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cNOj3cFW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790345153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kUPsp0+j6N99PN5TDquxRGX7XdHybJ0Jd9WQ5AMfVHg=;
	b=D/JTcWEx/3ISK1d6dO1HGtTJsifD4m2lbN+YkNJocP0B6pT7O6ZjjvWlw2RhWfCMFXrOVc
	vGX+wvwb+r1k42DMPSjwhtayOqFQmr6H+IkHWCzr7YvLcMk/jPHqyptG+zuf3f1Y0DW9TX
	rlfikwj0t7PFQ4oMJDOt6IOuX8WYJK8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-3J2mpodtOgO4K8AzBufsbA-1; Fri, 25 Sep 2026 10:05:52 -0400
X-MC-Unique: 3J2mpodtOgO4K8AzBufsbA-1
X-Mimecast-MFC-AGG-ID: 3J2mpodtOgO4K8AzBufsbA_1790345151
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4843227cfcfso1430657f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:05:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790345151; cv=none;
        d=google.com; s=arc-20260327;
        b=JmmFnUeSHeocUrG1DoEfzvRiAlBBf+WWkqbcqQGgIvwZkq504EieWO/L0mkDo/BKM1
         ksSO0P5c4N4tUfdtD+qT60Nh1d/czVw9Bm3wDi1nOZWSxqzUuM7wAJyawBx+Vaw93BGa
         WNc79wJ8kFSHT3kuKMQbrTxg7mMQs7/Ou5+iIliSthD0Cf98NlRhzHjOQviZRR9uSM1T
         fHNWbX41784a1JzMf3UzwHFuZ3+ddR8U6cSMM2k8GlmZVGG+o8vCNAc7bg2OmGgOauq/
         m7kV0/YhCWP0gu45FOvWOOYOoJ1Jql42b12hJBn/w0oVnU49OFZE088v9lEUjMK9PYKA
         XdRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kUPsp0+j6N99PN5TDquxRGX7XdHybJ0Jd9WQ5AMfVHg=;
        fh=pd/CxikVt1vfssH3pfO6g6NT4xx+3mDBKkQOLYFaDFY=;
        b=MpMe0d1jQoRQD9bUYQGgXA5K3mbR6xC/+qJhNRH9iJUWf3r2og+wMmN8UlH4Wdgf/2
         cNQ5ttCck1smde9m3mq6UDg/BN42fN5vBNJ1aSWtrB4FKvxvSSTo6FsA70Ew5IgiYYzQ
         K+4h5uJunOsZjz1IjkQ2tF7MvexP97A50mCWjYiIm4/RAlmdhB1ERUf4ONab2vdJ8dKE
         45/2LxWVZ38VGrRVuDiyAHgEvrjK7jpDkcPJHYxIuzdt30oVQu/M2bOEBJDAvirhxTSH
         z5xrkbhSyTyhe2ZfH/2OvFnNBTCOCk4ZIqQH3NGt2EPVoA8TMWOZ0D9BEIxHkOS+VSg5
         JcKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790345151; x=1790949951; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kUPsp0+j6N99PN5TDquxRGX7XdHybJ0Jd9WQ5AMfVHg=;
        b=cNOj3cFW7z8kCoZMSS1YNjfup8F+zV2BS6a7bW83oGQw4wbNJe+NBF7tBOzbsNw3yA
         xZ5wpb9QSxcB7ksCMHfdBrZ037ZBdISmkvx+SwpnYqYw21zG9ULo3muz4FJ8k25cBsiT
         sJuwvhkpG4FHPU19ma+tJWo3cGKgbxUcU08vgB/shoYD/gvhGbyI2qZxwdXnUzZlVSBm
         Jhka7wVMeOCOY9bR4RGvFhwxROBiUbcshaiG2I0LfgYeBB6YqSzHOJdqYq6B1fCDj7xN
         0XlSX0I0YToY5QHG0TNcmYDGj2LlQ9PMfhrBmw0ROPOV80+JZX0I6u5WueSI9LJJ3LpT
         B3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790345151; x=1790949951;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kUPsp0+j6N99PN5TDquxRGX7XdHybJ0Jd9WQ5AMfVHg=;
        b=ZlSma4BAm/hQOvRj3LGKb4vO/+3DWZmzourLrkNzXUxQQGpAhsnb+/xnLjvylqUOXH
         +k4xSK8zcDuak7fP1n3kLvYtQpjcd2l0jk4MyBc/o/owAxe7INln6pBwwjmj3Gmz3tTt
         AD1aD753ue2Gl+Cnugoce4q3EbcJSBXd4jKbeAtMdDztiDYldz7aqY/Fc4PEVtshvWw/
         hSO8J2HDtygbVHIKZYApp1baBVr5bfO1+LeXah56LNmfYzL1Wh4WRNDCOgM/WVzrIAfB
         uzUDlM/LCyV9a6amkKrtb9ZUSZJIFv2r+a4rojWuplbuLlFLI/vWtRIpddfe7R5FzR7A
         PqFw==
X-Forwarded-Encrypted: i=1; AKwUvBzMWkA8WXV6QNOv+V1anx01VV1/skSS7l1u8EIqDDf+kCE89rOglQU8Rb3xOICCe5UxKYhkTTL1EEVC@vger.kernel.org
X-Gm-Message-State: AFuF++lRXF+Bb4z52xcXjLyYjRd5+TvnT60hgw9vvvDYCFYgVIh1jjAg
	Y2vS+nOgq7LfZTWdqywBGrLd9Ev5A36o9umv6CQYSLMdgyDHzkZNfpimhXiMvxnkvBJwS+JFyE1
	6LHw0Rs1XYyueME43nqM/6+S9DnZ04NXeOMAFcCISKpkO23kGs6anYAbWChukTh/uGHNCypsnBB
	tVvQh3CnF7Wc6I3kk3FNeSNKIrz71PfymC6qVz/GZ5G6EI5RdS
X-Gm-Gg: AYBFou04A1UeXcfWrLvMNGYsV+NFQXe3Op+EQaUHzjL6tJvkE4DGzGadsBxgmnLJ1W7
	6D09mXtR7jrz4LM27dPQJtiQdl6dP537FqrjoYefuEKa6uzhSh/9LVPeoM+zLqx7eTcwfEimdiF
	QhnL0mrUi7HvlESH6ZhHl2EVfHfch9QY0XeVO80OfmCHmb5mU3dRuNR9IAOX0scgxJYE4KiqfDp
	1+L74x0lKLnxRrK6A==
X-Received: by 2002:a05:600c:248:b0:49c:e0e8:bd94 with SMTP id 5b1f17b1804b1-49fe66c84f8mr83073185e9.1.1790345151099;
        Fri, 25 Sep 2026 07:05:51 -0700 (PDT)
X-Received: by 2002:a05:600c:248:b0:49c:e0e8:bd94 with SMTP id
 5b1f17b1804b1-49fe66c84f8mr83072805e9.1.1790345150772; Fri, 25 Sep 2026
 07:05:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528063606.22324-1-nprabudo@redhat.com>
In-Reply-To: <20260528063606.22324-1-nprabudo@redhat.com>
From: Jesse Taube <jtaubepe@redhat.com>
Date: Fri, 25 Sep 2026 10:05:39 -0400
X-Gm-Features: AclHuK8o7hlp5oYBe8-lcGVVwUb4JmFoQSrhFR-ASlwbAvyr7VWhPqeY2b11B6o
Message-ID: <CADRr4bfgL70JEHx9wYb3KTVfq=ui03fFPMWc1H=Bn05RAu5xyQ@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: qedf: drop invalid skb_transport_header check to
 prevent panic
To: Nimal Prabudoss I <nprabudo@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, jmeneghi@redhat.com, nilesh.javali@marvell.com, 
	Saurav Kashyap <skashyap@marvell.com>, aved Hasan <jhasan@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, "Martin K. Petersen" <mkp@kernel.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2026 at 2:36=E2=80=AFAM Nimal Prabudoss I <nprabudo@redhat.=
com> wrote:
>
> During intensive FCOE Tier 1 CTC boot tests, the qedf driver triggers a
> warning assertion in include/linux/skbuff.h. This happens because the
> driver attempts to access an uninitialized transport header offset via
> skb_transport_header() under a CONFIG_DEBUG_NET environment.
>
> Remove the invalid helper call within qedf_recv_frame() to eliminate the
> warning assertion and prevent the subsequent system panic.
>
> Co-developed-by: Jesse T <jtaubepe@redhat.com>
> Signed-off-by: Nimal Prabudoss I <nprabudo@redhat.com>
> Signed-off-by: Jesse T <jtaubepe@redhat.com>

BUMP.
The order of signoffs acording to checkpatch should be
Co-developed-by: Jesse T <jtaubepe@redhat.com>
Signed-off-by: Jesse T <jtaubepe@redhat.com>
Signed-off-by: Nimal Prabudoss I <nprabudo@redhat.com>


Thanks,
Jesse Taube

> ---
>  drivers/scsi/qedf/qedf_main.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index da429b3a4283..f2bc0ac684e0 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2496,7 +2496,6 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
>
>         /* Pull the header */
>         hp =3D (struct fcoe_hdr *)skb->data;
> -       fh =3D (struct fc_frame_header *) skb_transport_header(skb);
>         skb_pull(skb, sizeof(struct fcoe_hdr));
>         fr_len =3D skb->len - sizeof(struct fcoe_crc_eof);
>
> --
> 2.54.0
>

