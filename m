Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D735F2E1C7A
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753196793; cv=none; b=ZjS5fHs1rXi0XF7o2AjE03C4QYLBnuAXQG9Fc52+A9/X2LfJb5w0pCOXm1nX49ViBlKzCfAy0lsxQ173AhoIplSOJnWl1dXmnLPHJM/Eqo23vBIaNB5sQh/68JroUGEKs5C6VDKgzlgsbZbBXzJN8oapCvxNEc+SHyA20qEmrDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753196793; c=relaxed/simple;
	bh=kJmn+YfBRCKzewAo5FVbT4YhMdRYJ7MgEYCNBPp04Hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b30EUyxbfFGWVtmfNW2sERDRTYMI5m2PR2zSwWbOZyq/RRTXsm+x0gSFTzg/CoX3/ehufCA2pchQZkbG+vUhWa0ZGhHPofNRdJPLGj6E7QgOKPk+cNyhR15EzmbBOH5B5C6LMKF+kXns7UWxgLz5zMIDqdh3BH3bLqYqndBMW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=b5RJMxSn; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="b5RJMxSn"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55a2604ebc1so4909881e87.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 08:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753196790; x=1753801590; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ggu2pWrIsN17HHhh9zi3F4V1OT1dHYUTYyb/fhuagI=;
        b=b5RJMxSn1WfmEa8gBzi2ITKxrKdeT7zfrPT3zFXP+AGyYFpmvcrf6/b9ohC/XmEQTE
         XmkVQZyEYMipUbQEj27kHKxR/Y9KsmxSVoYSfFWc1B4bUn8yUJs0L3elPX7Yj/Z+9CNB
         MU28HNAGud3r4ppCAlSoy3U46wZrhRZB5Kc8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753196790; x=1753801590;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Ggu2pWrIsN17HHhh9zi3F4V1OT1dHYUTYyb/fhuagI=;
        b=NwY23H8neazKNEavBm5IdoHGwLuV1SSbVDb1XdzeBbut1IUJfTcoEK4wVD+UhLRXS3
         TfwYX/Sjylyf5n+uo7ciaAQc1INPHKLtjBKj57RDONRFW2QIjTR+HP9FQD5eDEr64uJQ
         4Qh3VAEsXv7mCMil6CKfaANUalG3djT1els3VyVcSH33kKce/nBtwQdZgXpt7cMIjYZy
         yNdVR5WKRe2/MwCtlkshGaTpwncqRqlRAbZaPYSRmh/CO4WEAumbfXFiQO58dM1sFh0Z
         xFV5CYrhOBir+ZeXnI+MnXb2pgBCJKrr0TJPc/DQZVIyCZf/L2pH5g6xW6d+494TWNPW
         bxlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiAa0c34FuSTbHmXyl0+IyfDrrPsSv4awwrk/hOq/nqfzmJ7D3fa/VsPsfSNBcoNOMjzA2+8TwhQb8@vger.kernel.org
X-Gm-Message-State: AOJu0Yx44BZNfgxzJk9qVlaTp8/pwF2O0U86zs+i5WvpK2tS3cGaBMsk
	aC7LeV6+YA3TDr4okRL4CDUGF75mp2LqooMuP6a9Dfi3pYhukwQXMr4iix7oHjYsdRhWmHbXQbh
	kmo4HlI7Bxo7lgYMooAdjkkUhwwv1m5LnLFAEOKs=
X-Gm-Gg: ASbGncs83ueELS0C6W7aLMTWD1XAVBej9NeROOh/b02M5X9bPt3KHK4swzmYiNT9was
	TbTULKDg0RlJKIiTGitupSxe4K1cJlpt/wSzFS2xdXsxKSeUB+20NePGD/jawbc3h35GPUmHGL8
	0CmztwzHwpUGw/fOg6tRwdhL41K/9i9pCZLZrTOr7CoNKT6zKNJSmEESqLcVWGgoYbRqokjeCM5
	rMQd0JVow3YzNXwwQ==
X-Google-Smtp-Source: AGHT+IFtdlA3eQMGkZkYL+1wdOnEvGgQW4Irvm1BVEkzKfu6KwJsRw0JlNaMCxYHGSw1bP8mdG0aN90Zq/1lMLOUbM8=
X-Received: by 2002:a05:6512:1511:10b0:553:aa2f:caa7 with SMTP id
 2adb3069b0e04-55a23f853ecmr5592301e87.36.1753196788201; Tue, 22 Jul 2025
 08:06:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com> <aH8oUpyOhTlo-sZc@infradead.org>
In-Reply-To: <aH8oUpyOhTlo-sZc@infradead.org>
From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date: Tue, 22 Jul 2025 09:06:10 -0600
X-Gm-Features: Ac12FXzOz62YM5KtBUXLauf8eZPreGusQXHkZx_c0HbldFthTvYh1glCFC4A96s
Message-ID: <CAFdVvOx2RCtwc2H-K=QOQ+fG2=5s-TN4oOd0qJsCXvzfOpM69g@mail.gmail.com>
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI commands
To: Christoph Hellwig <hch@infradead.org>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org, 
	martin.petersen@oracle.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000e8761d063a85ef04"

--000000000000e8761d063a85ef04
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 11:57=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Mon, Jul 21, 2025 at 04:35:46PM +0530, Ranjan Kumar wrote:
> > Extend DMA direction override to handle additional SCSI commands
> > (SECURITY_PROTOCOL_IN, SERVICE_ACTION_IN_16 with RELEASE) that
> > require bidirectional DMA mapping, in addition to ZBC REPORT_ZONES.
> > This avoids issues on platforms that perform strict DMA checks.
>
> I think you are totally misstating the problem here.
>
> The Broadcom MPT3SAS implementation, probablt the SATL is implemented
> gravely incorrectly, and rewrites data structure in place against
> the protocol requirements, which is cought by all but the dumbest
> IOMMUs, but Broadcome until now never bothered to actually rest the
> junk they ship out to customers fully.

There is a resource issue which prevents SATL from doing double
buffering and RMW of the contents to map the data from SATA drives to
the host buffers for the specific commands.  Our firmware changes
leads to performance and functional issues, So we are left with either
failing those commands in the driver or changing the mapping, We
decided to go with changing the DMA mapping as we know those commands
require both read/write access to the buffers.
Any functional issue of changing the DMA mapping?

--000000000000e8761d063a85ef04
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
8wQJuWG84jqd/9wxggJgMIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEICKGMCGs
qoj1AUdo23/urUntd0LRqG1/N3p+p5DX7t6qMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI1MDcyMjE1MDYzMFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZI
AWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKglVwYz34WsXgz8HvEMW2neQE3Kdjm6VeUCG8jc84g5
aCulIygDGraGJ35PdpBNWuhJm8IK071GcGOxN+lvtasIyvNxAM6EAtKk0OvEDv9kUV9Rxzg5CkmR
xfsbyjxn+37+1YgWji6ZU6albS8wwHAlAFFVkokdjjcsfXbQjoKCzvDgRmv7CAJx+SpClikLBRSb
jn7ur5t8pszTennPsxCtul9EgxrVCfpww015mVmmYXKtePJoAz75jByIAZT8Q8YQ/LLBHwrO6q2K
N7ISfEQfiw8ur00JEE7EDQ0LTfO3y6sdNUHVsvShlaL3hWMlGV7CNc6ss9MxszCNlSlTOgM=
--000000000000e8761d063a85ef04--
