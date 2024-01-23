Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F88462
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 07:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705993486; cv=none; b=D6YHhNoSTtx/GeOU4ZsUl/4XcWah3yq5up9bgUTumm6bJW8MmYPTUiyrSx8LROPqpsLh1JKgtvxnSF9TAyxQI3rU+cfwlVFrdPhUWz4svTAA++kDLCabp/gyVFq/DRUw9TM7/XVulphbZOZ+r/2m2ZFSMC/ie5DXpqhC3ltTq30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705993486; c=relaxed/simple;
	bh=qLUOmoAQjORLXT256do7FonTAmpgOQ5bkpteqbkx2/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CsQQ7xhKkM3t0X/s2ng/3EzN8Y9c7V0Fz4yp+l7DC0ysqt83hZWSXgxeKixQoM3apWAewbB7JZmDe7iX4cGVGCPGR0uQBIAb9usYjhbeCPovunVrkGiJ3ICH4kMWytwCvQk1Zdt6MUoRCay59tpjo/gLDYuxrZs9osTLJYHVW4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=EMZNeMHs; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="EMZNeMHs"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2cddb0ee311so41214881fa.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 23:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1705993482; x=1706598282; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C78J8cjwJK6xbpPoRU/Z21jBQJ9VOcflSyvupBkK99w=;
        b=EMZNeMHsCMnGxEka1P9suzYuWwM+WcoIXhXg8UPK1OMh3M/dWrstL49BE6HCoPPGoC
         z6fxkhoGUkV4YwW6P8MUUUFeaiCZ0ZWJ/KpKDIVkeltCu3i7X+FwHr0kws6mrOCSo4FT
         cLp2WAMwkCH2445DzeCkbj8mZ1pwT4UsmvpOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705993482; x=1706598282;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C78J8cjwJK6xbpPoRU/Z21jBQJ9VOcflSyvupBkK99w=;
        b=UdpB438ZFwWO65Cl9v2i/H9v2TTgU1Nqb2YlqNd/gtSlYH7kdKSVo7sTI++8zcFbJm
         nU6K5cw+ltU5hicM9SSQJYefQmXnLQs915DcLhukhwp4FBzpKMRrzSJ3BjS3tsRzVFQ+
         wnGx9deq9s93No9U1bfmCt55PDsMDQnU8zo6VyggeuukKmkuDR+5/W6eAGa/21ZRnW1G
         dMTCh3vNWu3T69HgABW4BjnDpZyGTnmbzd/+1pIFtxktglbCD4qx4N7HnoN2p2sopl4r
         8gliIeDbxwk6kG7nUR0h0670BUwFFmL9Ql548av+h2jypst5HP4VM37Uq+3ocIBrprbW
         NRSw==
X-Gm-Message-State: AOJu0YwSaiZH/uD/3Sv/JuI15se7jsTrcVn4DpheuDutrIj+BAlgELFs
	wGDdCxQ8j0UW+F4TC8pWXT7IEwOL+WuX5/gaA96027eEr6XO4i4HaGKZY07N4VvMx8DtxWPTSUg
	+TW+TfnDzrcMOTu2lByeo9h5U/bJ28NofJNw=
X-Google-Smtp-Source: AGHT+IEZFpFOAEKONXRWIW06cN2pI4+1PFsjMkQysa//lm/xLz3rRSDaAdqhoXzy0Uhbu+j4Wy2tZbBrhO5p25KJ1QU=
X-Received: by 2002:a2e:9112:0:b0:2cd:20dd:568a with SMTP id
 m18-20020a2e9112000000b002cd20dd568amr1229485ljg.34.1705993482419; Mon, 22
 Jan 2024 23:04:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240112070000.4161982-1-ming.lei@redhat.com> <ccbc1e9b-ca63-415c-9b83-225d4108021a@suse.de>
 <ZaEz066MVkijH68c@fedora> <CAGtn9r=Qko22+9Zxg8BnaAMtfEH_WYpkE7mDBmKWSdcm98Ui1Q@mail.gmail.com>
 <ZaHubv1sH2I14z20@fedora>
In-Reply-To: <ZaHubv1sH2I14z20@fedora>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Tue, 23 Jan 2024 00:04:25 -0700
Message-ID: <CAFdVvOzOs-BnieaaadDCU-Lt0EGGDKrSz4hZUJKm7Jp7y6_jrg@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock for
 waking up EH handler
To: Ming Lei <ming.lei@redhat.com>
Cc: Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000088588f060f978f35"

--00000000000088588f060f978f35
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 12, 2024 at 6:59=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Fri, Jan 12, 2024 at 02:34:52PM -0500, Ewan Milne wrote:
> > On Fri, Jan 12, 2024 at 7:43=E2=80=AFAM Ming Lei <ming.lei@redhat.com> =
wrote:
> > >
> > > On Fri, Jan 12, 2024 at 12:12:57PM +0100, Hannes Reinecke wrote:
> > > > On 1/12/24 08:00, Ming Lei wrote:
> > > > > Inside scsi_eh_wakeup(), scsi_host_busy() is called & checked wit=
h host lock
> > > > > every time for deciding if error handler kthread needs to be wake=
n up.
> > > > >
> > > > > This way can be too heavy in case of recovery, such as:
> > > > >
> > > > > - N hardware queues
> > > > > - queue depth is M for each hardware queue
> > > > > - each scsi_host_busy() iterates over (N * M) tag/requests
> > > > >
> > > > > If recovery is triggered in case that all requests are in-flight,=
 each
> > > > > scsi_eh_wakeup() is strictly serialized, when scsi_eh_wakeup() is=
 called
> > > > > for the last in-flight request, scsi_host_busy() has been run for=
 (N * M - 1)
> > > > > times, and request has been iterated for (N*M - 1) * (N * M) time=
s.
> > > > >
> > > > > If both N and M are big enough, hard lockup can be triggered on a=
cquiring
> > > > > host lock, and it is observed on mpi3mr(128 hw queues, queue dept=
h 8169).
> > > > >
> > > > > Fix the issue by calling scsi_host_busy() outside host lock, and =
we
> > > > > don't need host lock for getting busy count because host lock nev=
er
> > > > > covers that.
> > > > >
> > > > Can you share details for the hard lockup?
> > > > I do agree that scsi_host_busy() is an expensive operation, so it
> > > > might not be ideal to call it under a spin lock.
> > > > But I wonder where the lockup comes in here.
> > > > Care to explain?
> > >
> > > Recovery happens when there is N * M inflight requests, then scsi_dec=
_host_busy()
> > > can be called for each inflight request/scmnd from irq context.
> > >
> > > host lock serializes every scsi_eh_wakeup().
> > >
> > > Given each hardware queue has its own irq handler, so there could be =
one
> > > request, scsi_dec_host_busy() is called and the host lock is spinned =
until
> > > it is released from scsi_dec_host_busy() for all requests from all ot=
her
> > > hardware queues.
> > >
> > > The spin time can be long enough to trigger the hard lockup if N and =
M
> > > is big enough, and the total wait time can be:
> > >
> > >         (N - 1) * M * time_taken_in_scsi_host_busy().
> > >
> > > Meantime the same story happens on scsi_eh_inc_host_failed() which is
> > > called from softirq context, so host lock spin can be much more worse=
.
> > >
> > > It is observed on mpi3mr with 128(N) hw queues and 8169(M) queue dept=
h.
> > >
> > > >
> > > > And if it leads to a lockup, aren't other instances calling scsi_ho=
st_busy()
> > > > under a spinlock affected, as well?
> > >
> > > It is only possible when it is called in per-command situation.
> > >
> > >
> > > Thanks,
> > > Ming
> > >
> >
> > I can't see why this wouldn't work, or cause a problem with a lost wake=
up,
> > but the cost of iterating to obtain the host_busy value is still being =
paid,
> > just outside the host_lock.  If this has triggered a hard lockup, shoul=
d
> > we revisit the algorithm, e.g. are we still delaying EH wakeup for a no=
ticeable
> > amount of time?
>
> SCSI EH is designed to start handling until all in-flight commands are
> failed, so it waits until all requests are failed first.
>
> > O(n^2) algorithms in the kernel don't seem like the best idea.
>
> It is actually O(n) because each hardware queue handles request
> in parallel.
>
> It is degraded to O(n^2) or O(n * m) just because of shared host lock.
>
> Single or N scsi_host_busy() won't take too long without host lock, what
> matters is actually the per-host lock spin time which can be accumulated
> as too big.
>
> >
> > In any case...
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>
> Thanks for the review!
>
>
> --
> Ming
>
>
Reviewed-by: Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>
Tested-by:  Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>

--00000000000088588f060f978f35
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
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDGfP8pU
ZTrmd9lxHz0h/ePoeBILKWE276uShk31ncR8MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MDEyMzA3MDQ0MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCADdHfkl8JR3ayNLVdzSgAv894
zxUGt2CeYXn+FDcejsjInnHESItDCha7yO28jDYv3mQvCUhZghWzO0W4wnTp4OytlOJdIkT78ov8
ms+9PGcp9myCQGOwNIm1kRmp+JXd6sqyx+etP4vcSY1kpYINHSeLKKIhc+SkHC7vo6BM9lJs2oXp
UyCqhNRv8mM+N9JivDstf7KTAnuHLF57lmdJdUiv0Oev2jR955MUzXHYqaMNZ7OQN7Chdv0HJS2j
CkL2to+5s3lw26+SFH8SBN/PjuVZpxVz8hOoGciW99Uea6WdU0ep23wUS59haqdMdy7a4tGPjFyx
C09Lnwz8+IZn
--00000000000088588f060f978f35--
