Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA93125AC
	for <linux-scsi@vger.kernel.org>; Wed, 20 Mar 2024 04:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710910484; cv=none; b=lIQ2Kno9J4H+vkGQHNkmUpQzAEuh/kZUGs+TdcXgpUgcIburwbMHfrCYYVXDcQJL9jvtIQ1IqqHhBG9aZIp4U+yW4r5/iBpKSauarvCjjG+sDB2WpTJBS8GT6JcYtXVABUG9ukFIFaNj/cR2GCyYBFzG/HTDlYAwbkmyjaiRKFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710910484; c=relaxed/simple;
	bh=8eaJqHyNmP/fYoH7aMyIqf9NsyTSID+Bm+ZrmaGX8W4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZGbhV8LC0AQfPsjEFhCYhvDbujY702OYmLrDhWp3RAJYyEsssIn0oc9w4LZeeRLwiZ1G5Z6oe20BLPFFb7iP3wWpwkcyFeBM2qhzMt7qFeCBiaadKarWzgHUF6QD6LXUtPlt2GT2vXNAZzjBmouqsymzrbZVLzNl/aWyMcSJIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JMsj5r7b; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JMsj5r7b"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d46c2e8dd7so77775241fa.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Mar 2024 21:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1710910480; x=1711515280; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o+ayy+Sd8A6OZ6yKIPNb1/KCDizTUo8OQCn2nH2ngBk=;
        b=JMsj5r7bNVZdPdSKikJ2JEeYUwMNj/JOVzVgov0LFPo55gBBNXFo9mrdcCsaFkxPIh
         WFWvoos/VNq3H76ESVkU38v7ZzUvebYTX6TJkzZq6zJmvZqdpqfjZiL/d3YdGcrmS73L
         7uLlGXNH9MUtwyAG3BgR0AnUmLCeJpNFRi/aQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710910480; x=1711515280;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o+ayy+Sd8A6OZ6yKIPNb1/KCDizTUo8OQCn2nH2ngBk=;
        b=xHtjNmizIf9lqm8wuofrKndWNKwb3vBdChjmTO3VuUJnj/ctQMk0+MtTKfAyOjXFin
         M8nFodia1+RF89v81T5lx6JjO65SYFsBCteU/zQ0ciazOzVSQBJ5cSwGHHifyvAx+Lr+
         U06nOS2EjfJPRiXuUKKyhA+6B2zfz83W+L/zsFYy5mdY70E1En7UwGdg6ruszIVoScUv
         sXcIGUW0W/pgu3HZ2ie9UZxbapHe8jrBThfH57Lkpjya5W6CTd9M3rh82ydiPWaL5/+L
         dABcwJDbmV4mvQlit3OLZNQzLWRUTkhUTb/+vIOWif9J4dGMFt5dtboZTAfjs5GNLvD3
         zL7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXH40ulRTOEuMWn1M//pcbX4//bRCEgkVFPyKc4b5lFMklswKpiqrMUzGfYqv+0ZxQmPhP1/bzecvOJt6sQIyA9/4bqihOI9iDoSg==
X-Gm-Message-State: AOJu0YwILZm7ZLA1dDXzjlhndZQm1TN7M9z8UovcEB7iVqsRmkTayIYJ
	IpojsRYGZc6q55XkgfmhXScQ/rgOMXWikmVt5S0gu+E1ySJGKxYl6tnHEY2/fi/wXZ1C7aib4wv
	Ki2n7Tj34yLmpAuR+fLbAFuyyaJPfUt98voQ=
X-Google-Smtp-Source: AGHT+IGKuhYRdUTAga2YjyeZTbWHEgSnz2vuEjd1StHfvZ4TSMjhEPWmo/JvKIGeOtcprn7fuSZq6PiKR68JTPWFGEg=
X-Received: by 2002:a2e:9c96:0:b0:2d4:6d12:71f7 with SMTP id
 x22-20020a2e9c96000000b002d46d1271f7mr595319lji.15.1710910480519; Tue, 19 Mar
 2024 21:54:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307042645.2827201-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240307042645.2827201-1-shinichiro.kawasaki@wdc.com>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Tue, 19 Mar 2024 22:54:24 -0600
Message-ID: <CAFdVvOzU0L6OERfnVqGE0yY1HUUMOXrZ=60RPcCx54s6H5mrVg@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000075a039061410631f"

--00000000000075a039061410631f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 9:26=E2=80=AFPM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> When the "storcli2 show" command is executed for eHBA-9600, mpi3mr
> driver prints this WARNING:
>
>   memcpy: detected field-spanning write (size 128) of single field "bsg_r=
eply_buf->reply_buf" at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 (size 1)
>   WARNING: CPU: 0 PID: 12760 at drivers/scsi/mpi3mr/mpi3mr_app.c:1658 mpi=
3mr_bsg_request+0x6b12/0x7f10 [mpi3mr]
>
> This is caused by the 128 bytes memcpy to the 1 byte size struct field
> replay_buf in the struct mpi3mr_bsg_in_reply_buf. The field is intended
> to be a variable length buffer, then the WARN is a false positive.
>
> One approach to suppress the WARN is to remove the constant '1' from the
> replay_buf array declaration to clarify the array size is variable.
> However, the array is defined in include/uapi/scsi/scsi_bsg_mpi3mr.h and
> the change will break UAPI compatibility. As another approach, divide
> the memcpy call into two memcpy calls: one call for the 1 byte size of
> the array declaration, and the other call for the left over. While at
> it, replace the magic number 1 with sizeof(bsg_reply_buf->reply_buf);
>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_app.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 0380996b5ad2..7fa0710c7574 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1233,6 +1233,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
>         u8 *din_buf =3D NULL, *dout_buf =3D NULL;
>         u8 *sgl_iter =3D NULL, *sgl_din_iter =3D NULL, *sgl_dout_iter =3D=
 NULL;
>         u16 rmc_size  =3D 0, desc_count =3D 0;
> +       int declared_size;
>
>         bsg_req =3D job->request;
>         karg =3D (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
> @@ -1643,9 +1644,11 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg=
_job *job)
>
>         if ((mpirep_offset !=3D 0xFF) &&
>             drv_bufs[mpirep_offset].bsg_buf_len) {
> +               declared_size =3D sizeof(bsg_reply_buf->reply_buf);
>                 drv_buf_iter =3D &drv_bufs[mpirep_offset];
> -               drv_buf_iter->kern_buf_len =3D (sizeof(*bsg_reply_buf) - =
1 +
> -                                          mrioc->reply_sz);
> +               drv_buf_iter->kern_buf_len =3D (sizeof(*bsg_reply_buf)
> +                                             - declared_size
> +                                             + mrioc->reply_sz);
>                 bsg_reply_buf =3D kzalloc(drv_buf_iter->kern_buf_len, GFP=
_KERNEL);
>
>                 if (!bsg_reply_buf) {
> @@ -1655,8 +1658,13 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg=
_job *job)
>                 if (mrioc->bsg_cmds.state & MPI3MR_CMD_REPLY_VALID) {
>                         bsg_reply_buf->mpi_reply_type =3D
>                                 MPI3MR_BSG_MPI_REPLY_BUFTYPE_ADDRESS;
> +                       /* Divide memcpy to avoid field-spanning write WA=
RN */
>                         memcpy(bsg_reply_buf->reply_buf,
> -                           mrioc->bsg_cmds.reply, mrioc->reply_sz);
> +                              mrioc->bsg_cmds.reply,
> +                              declared_size);
> +                       memcpy(bsg_reply_buf->reply_buf + declared_size,
> +                              (u8 *)mrioc->bsg_cmds.reply + declared_siz=
e,
> +                              mrioc->reply_sz - declared_size);
>                 } else {
>                         bsg_reply_buf->mpi_reply_type =3D
>                                 MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS;
> --
> 2.43.0
>
The changes look good, however, The uapi structures are not used by
any broadcom applications so far and those use their internal files
and AFAIK there is no third party developed applications using uapi
headers, so can we declare this as a flexible length array to be more
clean?

--00000000000075a039061410631f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJgcV+AF
Uw4/UcXe02K3DSN5CsWdzQCgQogAQlSBGLaQMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MDMyMDA0NTQ0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA5cY9/QeXimSPj5Di6l97QFtme
kiUf+Fq6y4Fk/5j47/YIMJQVwZbhbZ8JwRaL/Ky6UN/yUOEtBeMutS5tKVhcZ0osQwLPl7JV2711
dn5b7WM6i3FVJgAmh7kXGU1vUMW3rddPhS23EWIyuWN9EHsfgV58HbPchpQ3kzGKv8qvZfHc8tsg
PGOTFqhcipNdjN/c3GupXvnE4v6aac2iz7KOpyHwqzNRnGzfbACKuPwrJdMCjTghqOkZMp4/QO82
5ZMlft4o0SuQ/deNgeE8MWAFx+7hpz1HdAyLhpelmck6Z5A6E9c5I9j1RQhfVNCq0j+QY052eqlZ
pPNywxdRF8mI
--00000000000075a039061410631f--
