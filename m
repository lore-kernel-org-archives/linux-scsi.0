Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51889349CC1
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727997; cv=pass; b=L0zRzkYKBy9id7oBGYs6ZBZrRRX8XcgkzRR7U9hLmBAr5qNFBvqWIcTbJe1maxIjpfbJn6reKUPhvxUHRIi5iZ6FjPhju6Fgldi2LzyXJX5g/b/ag/ehGrr7bNgPfk+o2ovdumw2Dn5v6WjAz+Rk28KO+zBeJuiIJaXzwzoJOEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727997; c=relaxed/simple;
	bh=vFylazToLpUeeuw8wb7AToA3xRp6hCLzjPYUROZeTP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XzDWJXVcnL2ILSWVrwQSIpTFnPusb8UPkG0iAI0ZIqkhj3Dgn04sX9Ag6VTDcYrTCuYTqY5bW5304WYWvtowwEQepQs09X+mhJr1m4hGvYRRfdw5mY+kW+YbZCX7cqyDijn464tEvZDLiLh2zSdiumCDIlvqdl7T2n8I7m6eFho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=G+g+BM4e; arc=pass smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="G+g+BM4e"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39c8e65e3f5so106330081fa.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 06:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784727992; cv=none;
        d=google.com; s=arc-20260327;
        b=am9MdqfqGNnxI9SckLrXoQ9VGTgopvYxxpQc4X0sU9/My0F2M+i17rOyVUvKtDfZYn
         GqXnbyDtdBJ3x0IaD+v7cT477ZEU/37g5nAfS+Ppadv0Cz9MgpMG+JjN+5B80m17H9/v
         9yo/DFMfLSAONLPyIbvUHCikm8sYqsE1UXLhLMKXHSdSTefPaJBS+7b978VhFzGqCidX
         KhXif5gYwRyQdmEiLNwP5u468RbJsB/DA+XlSQKPyP+c/vBCoJvf+kfen7ZGx7HroNZa
         lPzux5ZTAnIP1A7yeSg/ogbPl6GD7woDXoVm0GlILA/U9LgU0kbEUoKdRwmoPwh5syL8
         +4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GG7S7atzjbH2DdWvERNY1S614BAIBnyKfHId2SZCk5k=;
        fh=OOk0FVSYP11iJou4bGtKgOvv/Ae0YSERxa2P75emQA0=;
        b=HFlo+D/5cuagbEJDByomUjOe1Mn0o9kmdGLtFBk7+6927E/ofgVqU2WsQYXTLUeoiZ
         v4AOa1KV/ea32mw5JK0l0nxpVV3NRnZd9W6uT/F8c3f9oJu5FD1Cl7uJ4biQSRfpF9rm
         AenQgpzF8HnZ19y60Js0q5iRJwpbLPVHG/xlewIBgsFGL1mSFrZe5pTaBUYYTROllFQg
         Cxfz90mSCaNfFoDlb6JU5IefLJezsGGd/dl4TjXCTUATrQoMy52T0B1MGqCQv9SKoS2+
         OetGMZ12fptX1LpXTk1tE0I2FniKY8Yd0Fgo+Y8qVlQdlWy6Nb+BIf9MteRXk7kiK7t9
         N9zA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1784727992; x=1785332792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GG7S7atzjbH2DdWvERNY1S614BAIBnyKfHId2SZCk5k=;
        b=G+g+BM4eMcKItPrKikicvtWIMHTMgk+KNXN2BqeIRch+LXsQANjS+EjtzNYThENx+d
         SnWTrYDoavBYjru+aCewIoGBzIg6T6vjKF7iru0dFCOqF3iuFpXhoyNs9E/gtX9zPuBS
         od7Io5kPqYjlD/93e5s8RZS6B3q/3SlAvPWM9pIe+2n12yvT6dPyW9SkGtwiBTLhXFxz
         VQ//puWkAiMNyp7VcJkJfoxumz/5/7KA721Ey6yluBi3Z2RpzUWipilh+zqCR2BGvfiH
         lELrBOVEL8IGgDnzyUag3BWVNm0ylNnVAUgBkyHysMzwJmnCp4Vob/rlv22AVxlX9ayi
         5N+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784727992; x=1785332792;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GG7S7atzjbH2DdWvERNY1S614BAIBnyKfHId2SZCk5k=;
        b=XolQoU7ZgKXnlkU/KJX+6zFPY7lP9zazBR4Q1Xrrnt93G/gfiRkb2BtJUQVG4h77sp
         gzTN4fUndR/6XLUhixK/KWeBHmreZL2G4gM2WvMIz2G+e0E7eWGrxl4WzIwc/9U6m+tK
         utSoHzrWHoA/8qVfHcEjHnlltpLmhxq/+4RKhXzpXfmqBAz+dtClr/Vz0bV2bjSTINki
         UM46gXDj6TXvd8fWl1HAuDQQp30jon7Djau3LC5BhMTKIY7ks+FeADPtrF4v5UXVyzoj
         lNfEp5zCcPxYbgdB85AzBgj5X3DlCfR187NMiPCWr1Odm9Zn1czSTCOEejCggvhCxAIH
         afLA==
X-Forwarded-Encrypted: i=1; AHgh+RqcG9cM+QtYyQGK+iQBPPhfAK2ucCj5yu/T60JReH6W8BVUfG6+pjyHAsyBlp8Fv6WYEW1WNNwpYQJ3@vger.kernel.org
X-Gm-Message-State: AOJu0YzQP9+8Rn22J+QqLMC7U2OS2Iegh44M4nz9bh5WVfsqaiuMEDA2
	fucLYfrtd7qKrAKDmCZGNMrG0o5yqyxKzrgv1q1iQxpw4ibX0RTEjW5F4n1Yo+0MoZvS2ZECYQW
	TPNBmyewzcDFchrZ+poWsPNWHzG1ow4Ev+f1WaGXF7RolsKsEZbzQ1Xk=
X-Gm-Gg: AR+sD13D7rJePri1Oggo9UCQM6UdhvHilQIRJToB9TtoBUszxS5mUG8MQ8VNfv96Ddb
	3o6laZfavIm5spIECHAqPA7y/XPPqquyDZXDxWNLMqMxcV2J5ECSqLehUtCZ+g28DJaxq6RYalR
	yTtimh0K1qxx5ACDQXXLf7Mn4HVRRU9/0ZZkhKUoq+a77ZlnC1aQkKezs/Rcov7UTg2bt93sGwI
	Y8ZZCLD1/Qhz5TAabkp1PmdQVmZ3gxTu58hgpOkMZ18JlPrtQrOpPZknzsCwG/hDB9dsHm7q+R+
	ku/rHzNFdmokJlk2vy7WEJWGFPbbIGxIwLyLIvuHyxs08M4=
X-Received: by 2002:a2e:300f:0:b0:39c:71f9:26c1 with SMTP id
 38308e7fff4ca-39eb28f4b17mr28719991fa.37.1784727992300; Wed, 22 Jul 2026
 06:46:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715135642.456578-1-haris.iqbal@ionos.com>
In-Reply-To: <20260715135642.456578-1-haris.iqbal@ionos.com>
From: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Date: Wed, 22 Jul 2026 15:46:20 +0200
X-Gm-Features: AUfX_mxL3P9kLA42hO69T2duZgwaDiydpA0n3HBPt0mGEI6CpxRaqTD-cTH6Wjw
Message-ID: <CAJpMwyjQc_mimuBjUugbBJsZio2vZQCD-Ay966o2jWtpTt2MEg@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: don't post task management replies to
 io_uring poll queues
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 15, 2026 at 3:56=E2=80=AFPM Md Haris Iqbal <haris.iqbal@ionos.c=
om> wrote:
>
> mpt3sas_scsih_issue_tm() posts a task management (TM) request to the
> reply queue given by @msix_task. For ABORT_TASK and the broadcast
> primitive QUERY_TASK/ABORT_TASK paths, @msix_task is the msix_io of the
> command being managed; for an io_uring polled (RWF_HIPRI) command that is
> an io_uring poll reply queue (index >=3D ioc->iopoll_q_start_index).
>
> io_uring poll queues have no MSI-X interrupt registered and are drained
> only by mpt3sas_blk_mq_poll(), which the block layer calls to complete
> polled block I/O. A task management request is not a block layer request,
> so nothing polls on its behalf: the reply is posted to a queue that is
> never serviced during the wait, tm_cmds.done is never completed, and the
> TM times out even though the controller is healthy. The abort then
> escalates to a controller reset that was not needed.
>
> Post TM replies to reply queue 0 whenever the selected reply queue is an
> io_uring poll queue; reply queue 0 is always interrupt-serviced. When
> poll queues are disabled, iopoll_q_start_index equals reply_queue_count,
> so the check is a no-op and behaviour is unchanged.
>
> Reachable only when the driver is loaded with poll_queues > 0 and an
> io_uring polled workload issues I/O that later times out and is aborted.
>
> Fixes: 432bc7caef4e ("scsi: mpt3sas: Add io_uring iopoll support")
> Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> ---
> Found by code inspection while auditing the task-management reply path.
> Posting for review of the analysis.

Gentle ping.

>
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 12caffeed3a0..572ec1787e10 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3186,6 +3186,16 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc=
, u16 handle, uint channel,
>         int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
>         mpt3sas_scsih_set_tm_flag(ioc, handle);
>         init_completion(&ioc->tm_cmds.done);
> +       /*
> +        * A task management reply must be posted to an interrupt-service=
d
> +        * reply queue. If the associated command was submitted on an io_=
uring
> +        * poll queue, that queue has no MSI-X interrupt and is drained o=
nly by
> +        * mpt3sas_blk_mq_poll(); a task management request is not a bloc=
k layer
> +        * request, so nothing would process its reply and the command wo=
uld
> +        * time out. Fall back to reply queue 0 in that case.
> +        */
> +       if (msix_task >=3D ioc->iopoll_q_start_index)
> +               msix_task =3D 0;
>         ioc->put_smid_hi_priority(ioc, smid, msix_task);
>         wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
>         if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
> --
> 2.43.0
>


--=20

Regards
-Haris
