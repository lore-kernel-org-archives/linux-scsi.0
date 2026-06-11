Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA2E3D0919
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781174669; cv=none; b=L9s4mqA29tyH/i0+tVXyP8YC/Zoi7RA/It2aNpp4A9aqXgbpwe4Tzj7P1zzqgoor2bQ8ZQQUMquO3gSzaXuQ6fKoj7BNIAvadX+48b7PQu9RHshNLbmuwRWVBroCNMf8gk36B1IbZncG98oi9ZQT4VqxI+SHJvK3drlPLQ5qFNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781174669; c=relaxed/simple;
	bh=IijzkghcgYB9vbUIw0Rk8y2meYmPet8ll5Ozfmr8HfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i5xY0+wWD0jbLsLFtpJePJi2Zt0VfWk95ShYrcsbgLoUewMXrkrxSldgr9p350ABlNcshWYv/RPLU0XX7AFj1gijLXoIJAtLTMD1tQ4Yp06nSTlPwro8nkMO4zDvTUx9JQ7FH8wBMvWnfKIgCl7Fbp7ySTMFyAJb9TXopMIugbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NP5XmrRP; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NP5XmrRP"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2c0b9328c4aso55243825ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 03:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781174668; x=1781779468;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IijzkghcgYB9vbUIw0Rk8y2meYmPet8ll5Ozfmr8HfE=;
        b=e+AzzD5i6yCu1Y+cS3yLw4t1p/VodnEEGIgit2SGOohFUI/7rhcYtaK+6Trb3ZMYXN
         jKaMEYCDvLrEC+jI2O/AU+e+9h237bBqdPYyPlTga9ptJB7rzyeqWGfWYoV2TxhlA6dU
         Ix6VFIzpDHjhxtCD9z0HbpRBCsLWGcc0E+/MfTdnUycpbJvi96ureJHvSe5dmHEkdlKY
         dp6DlZno4LOTETNspZolbmkPhrEC7DH+IufsQFqPDXDrDBDpzjofsr8wLRPGdbNn5HqR
         yA62D8zCur7yKSkxFaj92wmGDtKZeR5Sb3Oixi4IHyCba7MPVcx1eJ/in6FUicAV4aX3
         DqPw==
X-Forwarded-Encrypted: i=1; AFNElJ8utSIzRgXUWjBohckVTBLkxC20OvwmMPMWaoFMhRbdrNmTU15CDYC8+TCnQfuXUyZP/dbdd+mIk+WV@vger.kernel.org
X-Gm-Message-State: AOJu0YwwcoyeM1TJ9U7W294pKb2Vg3rOLaC812T0PtSa70xEAq6oIXJ6
	thhstPijzxP+myn3vge9VmWIFa/E1hTDXlgFSanKDccOTnovQLTNDHRC1fEQPj/1GhTTDbyOMBg
	5xAQgt9O3xVUco1sry2NqqN7E5oUtODqdFtfEU7dA13yBEaAOncnzxnUso2AoEiA47nypavciYU
	KZNOQrx1DUOY8GYqLW/aimrf4rWllse/OJT8aw1O6VyR0uvQeRy51kY4uMpNmJJ4ww3+MMiWhIr
	z6afy6tsCpdy80Q
X-Gm-Gg: Acq92OFnZD1dLTwntlm1wI3AhBlcyRlDB3rNrLshBd7HdECn/YqLOnQtGXN+Auy86Po
	Qeiz//bGL9RyuFTjCn3KqDGCPXtIUnDYOJ3xVEdycepvy1N1D1W9dPSjHah6u/WU0yjA+SBZWZj
	fjnMQf/oycciRACGuZeFpoDcIh6VOIrT0/SmFBwrnHLJOZ3Dtmuqj/Hf3FQSNW9XGgzGtIWG7tb
	JREZ4GjXERIOWUyHvNmj/TUcs3wMQlxfYOv2Ud0igBR3fcQK/yBi4e2AV3XhTRPcALjzCPeQzT/
	Fzye1XndU6h3HhkeEyJoRgf2/RfRaYH4vZDGUT/ytiHFGyx1B5SDD4r3MNHLHhH9q280AY6euk9
	44gKxrjFxW1zydHmGj9AeVf50fQNFKcw3aG83Hwm6ijqfYxt3LXcRA/kaQsKNSI6jTIyBgBG/eM
	IYyOReTnSl6hxLlrFUTBl8882mF5NZHaMDHOebEX+UKJRqRqfEVRKzn3uR7XuIPDkOMQ3DVA==
X-Received: by 2002:a17:903:3890:b0:2b7:975c:dacc with SMTP id d9443c01a7336-2c2efc6b45dmr28443785ad.1.1781174667592;
        Thu, 11 Jun 2026 03:44:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-121.dlp.protect.broadcom.com. [144.49.247.121])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2c1664a66f6sm25756725ad.53.2026.06.11.03.44.26
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2026 03:44:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aa5b598829so5234622e87.0
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 03:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1781174665; x=1781779465; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IijzkghcgYB9vbUIw0Rk8y2meYmPet8ll5Ozfmr8HfE=;
        b=NP5XmrRPsy9azIfQCuQUh9r7xH5/oZWpR8lteiuRWAFBA40y+SZg8he4ZGydN2aKQd
         TKu8hPhaHcqHWuoq7zZfU6rpOahKSah/XELpHnZOkI6i68dt1y1vk4CHPNvbWZbpo+o0
         ht3ICA+QFKzZb1AiZEdh0ftMmOp1qGCGfGItA=
X-Forwarded-Encrypted: i=1; AFNElJ9r4pqA2Rka3L1ZZUCc/4GPhgmaHWE0gji6ZQ0KFoT7YL1rjaTgQgmM7Gk8BxXKqMWWxluUExFiyyN0@vger.kernel.org
X-Received: by 2002:a05:6512:3a8a:b0:5aa:6290:f78d with SMTP id 2adb3069b0e04-5ad27a9c764mr696804e87.2.1781174665061;
        Thu, 11 Jun 2026 03:44:25 -0700 (PDT)
X-Received: by 2002:a05:6512:3a8a:b0:5aa:6290:f78d with SMTP id
 2adb3069b0e04-5ad27a9c764mr696784e87.2.1781174664507; Thu, 11 Jun 2026
 03:44:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-4-sumit.saxena@broadcom.com> <aikAs4X-2NWTuwCc@infradead.org>
 <CAL2rwxr1uGshb1o=jvP2OnBffNz2cKXj8tHuAUCN5HFuy2vB_g@mail.gmail.com> <aimSb9I0Vl-68hy9@kbusch-mbp>
In-Reply-To: <aimSb9I0Vl-68hy9@kbusch-mbp>
From: Sumit Saxena <sumit.saxena@broadcom.com>
Date: Thu, 11 Jun 2026 16:13:46 +0530
X-Gm-Features: AVVi8Cd88XM9WQCmkDM1ogPmYgU9Pn0rqq_dsX0LdbdBcAzp9xGlrg8ZceRzVXQ
Message-ID: <CAL2rwxqtjjFYkSbBo1VSyw8JQ7JUnX9nqB9twOH9jhuTY1DD2w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] block: drop shared-tag fairness throttling
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Jens Axboe <axboe@kernel.dk>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	linux-block@vger.kernel.org, Adam Radford <aradford@gmail.com>, 
	Khalid Aziz <khalid@gonehiking.org>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, 
	Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>, 
	"Juergen E . Fischer" <fischer@norbit.de>, Russell King <linux@armlinux.org.uk>, 
	linux-arm-kernel@lists.infradead.org, Finn Thain <fthain@linux-m68k.org>, 
	Michael Schmitz <schmitzmic@gmail.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, 
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Oliver Neukum <oliver@neukum.org>, 
	Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, 
	Ram Vegesna <ram.vegesna@broadcom.com>, target-devel@vger.kernel.org, 
	Bradley Grove <linuxdrivers@attotech.com>, Satish Kharat <satishkh@cisco.com>, 
	Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, 
	Yihang Li <liyihang9@h-partners.com>, Don Brace <don.brace@microchip.com>, 
	storagedev@microchip.com, HighPoint Linux Team <linux@highpoint-tech.com>, 
	Tyrel Datwyler <tyreld@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, 
	Mike Christie <michael.christie@oracle.com>, open-iscsi@googlegroups.com, 
	Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, 
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>, megaraidlinux.pdl@broadcom.com, 
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
	Ranjan Kumar <ranjan.kumar@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, 
	Daniel Palmer <daniel@thingy.jp>, GOTO Masanori <gotom@debian.or.jp>, 
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
	Geoff Levand <geoff@infradead.org>, Michael Reed <mdr@sgi.com>, Nilesh Javali <njavali@marvell.com>, 
	GR-QLogic-Storage-Upstream@marvell.com, Narsimhulu Musini <nmusini@cisco.com>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, linux-hyperv@vger.kernel.org, 
	"Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Eugenio Perez <eperezma@redhat.com>, virtualization@lists.linux.dev, 
	Vishal Bhakta <vishal.bhakta@broadcom.com>, bcm-kernel-feedback-list@broadcom.com, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, xen-devel@lists.xenproject.org, 
	Bart Van Assche <bvanassche@acm.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000038cc6d0653f80b67"

--00000000000038cc6d0653f80b67
Content-Type: multipart/alternative; boundary="000000000000294eed0653f80b73"

--000000000000294eed0653f80b73
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 10:06=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Wed, Jun 10, 2026 at 09:16:11PM +0530, Sumit Saxena wrote:
> > The motivation for this change stems from performance issue we
> > encountered due to false sharing of the 'nr_active_requests_shared_tags=
'
> > counter
> > on certain CPU architectures. I initially submitted a patch to move tha=
t
> > counter to
> > its own cache line to avoid conflicts with 'nr_requests' and other hot
> > fields
> > (see:
> >
https://patchwork.kernel.org/project/linux-scsi/patch/20260402074637.92417-=
3-sumit.saxena@broadcom.com/
> > ).
> >
> > During the review, Bart shared his work, which eliminates the
> > counter entirely by removing the fairness throttling. My testing
confirmed
> > that
> > this approach resolved the performance issues and improved IOPS.
> > This patch is part of a larger set, and I have reported the cumulative
> > performance
> > improvements in the cover letter.
>
> So the problem is just the atomic operation accounting overhead? I
> previously thought the device just really needed to consume all the tags
> to hit performance.
That's correct, it's the atomic operation accounting overhead.

Thanks,
Sumit

--000000000000294eed0653f80b73
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Wed, Jun 10, 2026 at 10:06=E2=80=AFPM Keith Bus=
ch &lt;<a href=3D"mailto:kbusch@kernel.org">kbusch@kernel.org</a>&gt; wrote=
:<br>&gt;<br>&gt; On Wed, Jun 10, 2026 at 09:16:11PM +0530, Sumit Saxena wr=
ote:<br>&gt; &gt; The motivation for this change stems from performance iss=
ue we<br>&gt; &gt; encountered due to false sharing of the &#39;nr_active_r=
equests_shared_tags&#39;<br>&gt; &gt; counter<br>&gt; &gt; on certain CPU a=
rchitectures. I initially submitted a patch to move that<br>&gt; &gt; count=
er to<br>&gt; &gt; its own cache line to avoid conflicts with &#39;nr_reque=
sts&#39; and other hot<br>&gt; &gt; fields<br>&gt; &gt; (see:<br>&gt; &gt; =
<a href=3D"https://patchwork.kernel.org/project/linux-scsi/patch/2026040207=
4637.92417-3-sumit.saxena@broadcom.com/">https://patchwork.kernel.org/proje=
ct/linux-scsi/patch/20260402074637.92417-3-sumit.saxena@broadcom.com/</a><b=
r>&gt; &gt; ).<br>&gt; &gt;<br>&gt; &gt; During the review, Bart shared his=
 work, which eliminates the<br>&gt; &gt; counter entirely by removing the f=
airness throttling. My testing confirmed<br>&gt; &gt; that<br>&gt; &gt; thi=
s approach resolved the performance issues and improved IOPS.<br>&gt; &gt; =
This patch is part of a larger set, and I have reported the cumulative<br>&=
gt; &gt; performance<br>&gt; &gt; improvements in the cover letter.<br>&gt;=
<br>&gt; So the problem is just the atomic operation accounting overhead? I=
<br>&gt; previously thought the device just really needed to consume all th=
e tags<br>&gt; to hit performance.<div>That&#39;s correct, it&#39;s the ato=
mic operation accounting overhead.</div><div><br></div><div>Thanks,</div><d=
iv>Sumit</div></div>

--000000000000294eed0653f80b73--

--00000000000038cc6d0653f80b67
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ifscJ8gSasrjdgcsGC9lCyPXLwfNEU5C3Mbnua8OK6sTBpf6mvY88HW/6AoKiSpfo5jxCZQOm4Zz
oJWD5ea7ThJ2XdDk1rRtGUkwFgN9GRNfOoiIwkkA7EdEfV0eQkVqNgkqUyBSABXcduul2sd4/JQO
SsVmTdSKid7L6yZsqk5b3Xj+GMJwPdRfeKP2SRoys0SVnajc9Di+9Jy7uGKxxtb562egZauDFX/0
o0UgYfZrbwWfzJDYMLKzlrOD0M8yGkD8BnyIiVECAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQURSmmYGaiq6dg3CEvXQGHEXJF
8xwwDQYJKoZIhvcNAQELBQADggIBAAl0pcCjujKdwmgtiGl2naEY5wB4G601Kuu3032tR7wmgZLg
k+lg9fhAA0boPsi1FE1Pwb93YDBGr/naS/oQ9JglSMeEVzeRvCqjFS4FpouBAFHB77c8w3ZwJ3+t
FSRJW9SbW0DADBn5t8GAjv2aSm5vDorqFe9MKOYEe50yYDQEUAsEt5QkrLTcEx9ntvVb25MxI8vM
bdfqna+/TyCmFmnGAz58jiw5DxLn++6wMmAk0SeUEuMrAlRIyhte6BBSBQ5cL1P+DWSqQbm/pwCq
NhySSLNtTi2dKJvvg6Ax9au913KiJj6uZfPlh6/0kaVKM5GhIABUcm3c6g2qD7ITJxB/p1kjYKLa
hVrtrjK7000lHKTPFr6MWB4Ggx7yKQ9yIlPMKKF/Lj8FabYCqeM5ovG7kaK8FYXug5vjNjN0nedR
X3P8o+8aL6WFIAAAKm2DqZh3252Gcken8v5c+f0SXWSJFvemfFNgrJiQFnFVrOE5v7qwvM/KvVCA
dYm4Ph9QYI0sm+Xitx8MkdOJtq5mcPWowGi8UiCgkOidv4ki1SA0wptfquUhbfS9b2M3XUHCEIUX
4ECvIjR3f+E0NbBIfPccWfYUaDLvo2qhLYS3KQbhKdXcJ83ha17mbVNZbDDo9upNcLO/oPyDbCNF
J6UpXZmis1wnCynhK4kQfwFhW7H+MYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMdI2Nfq/Vk8dzZMUnMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCBgNfCS
txCUmh9RVm3ywWZ+FqUrhzMno4QjbIxP56bEHTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNjA2MTExMDQ0MjVaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA4a94UH1n8Q6oB/bStbW3ay+559D8DevwSDQGM4pzx
YvFHxranMU8DCmF3wRjpr7OT19xPbxEmYvuFyy1qK8WnJYcZK5+3OaFgW4Q9+M27QrNQuhkeXBsn
KDxNid4QqOD1wDZKmePV3euKKF81Kep8eCZPLII7hVbBQ/OeCd1LU6jde54CMGFm45kIUKgfQxLI
lyXcG/vw10DPi3K6THNvA+QSYWXcyylarB1UgSiRxT/qn2G4JDDpZxGHexmaiqE+UQKDBj8K11k3
9w5dyXpp6wY/Ua9Y99FzSb1fRBZFDcyrRsQr6sn8ZJL5ZvUK93sSc2x59Pc4eIJoehPCE+dU
--00000000000038cc6d0653f80b67--
