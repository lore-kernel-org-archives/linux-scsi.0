Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2918D314B76
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 06:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782196356; cv=pass; b=N35XhB/YRaJSJdy4mia7haEtrwRrgYQ7qmKJweHJyhQh8Pd++1/lszGVZA64+m0+ZpitDzoc8DcnfR/s7cP7cYQPSiKvWhfGjDllScLI8wjOOWJblDe13a6ICK1P0jdgw4idubvdquUFY3ZqjY1jaAWxnjER2X5g/yavNWbn1LE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782196356; c=relaxed/simple;
	bh=QwIjawHJqOj5H0dPQva+4F8BGF+VPFnCtHxr73rBkhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cnrrFbBmR+WktZEiXWFKrr2VZiMtGTvqH0zBersGp/uAli+hB2weg7bul16I5ysmFCPaFG+Yf2EgpvTnIVieUbLKJ6bThsTBvoKfEAHlHeD4TTHjocfoP4XeLFwCp9rEUb7AhOwst0549Dhv6VIV6HUnw6tBm8wMZ4o9LXx1l4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3R569BF; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3R569BF"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-46019b190b6so4000748f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 23:32:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782196354; cv=none;
        d=google.com; s=arc-20240605;
        b=Xq8AbP1g1tpsdK/vyEKPrtoNFvUQmsuZUww9/NxfI7SSliToH5H0UV6rhSY5GH5XLF
         VR7LDDfbiRREkDyPGEPAmv42Nv7vz3S1sw5dm8vbwJW2SWUScdRV1IByd52yM4n/AIr5
         eJd1O2qkZDKGmHNdpbEGZxA/5DUS8tbon1quF2tihI47pTT0eiHgqf5Y4k6ZThI3Icau
         GUuUushv/PUK4K6w/TlQoc8FokjUmPQnYSwW/aPUF1K2874mxmw859UjNjswhu2XyGK/
         Rr58VKNLwj2bJwjeE1iRtKujrP1NANYHr0KkGAoOkRwv9PZojNzQlI+piJ/RaJqb5EbI
         etjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QwIjawHJqOj5H0dPQva+4F8BGF+VPFnCtHxr73rBkhM=;
        fh=5W7KM5aUfcVSFJeBUhtS6L1Wyn67U9GIwTWTyTZbn40=;
        b=Y9YlYoR1r/1uL02nXuxThzkxby5PZWnyBUQgNdBH5TGL9CM7x1Brmsair43nlEwuVA
         TO4InRF9HUqKmR6CmnqUuNs7vNTjyB2RHGfXvsfU+yfq/1K1moYLCCaWkQL8S5/Ez1rL
         SEJmsfz/YK7+4YbTgcEB5M/BEk9/FZbFyAPAjbXQ9wyYBkoMz8CZuQ5pgv2qto6zqoNo
         2V3q3ULShxY+pVeaX/gNNJ7+zGmBnXgFp/hG/zhwf+px72YUaLlg/3JWN4vMvk2Nmz3Q
         +zh+Qqeq9rJvyiCSDPh3m0BGxF63w+ue9B4+t9ygeLqSjHTXooiGwxN79tw8Hl5jtVhY
         dv7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782196354; x=1782801154; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QwIjawHJqOj5H0dPQva+4F8BGF+VPFnCtHxr73rBkhM=;
        b=b3R569BFS0yQceX11VwL5RTzlckrhPn5/01VcCNemng4ryhm1ugCUblsn6hv8vtato
         3SOXjYQNrB+Dy8HPrSUOMiRYGma8VcYZNyZdo75hAt50VwzqVgaNhRyCPSrZ6028mlsA
         UZ3g0mplKflV0ukKtyOqQLo15orERy7igDaaLzqHWKJJagNYH6DA4ZNXm7vuV/uMHKdJ
         QESslU10LhSY4BhKoCFGDAObYBOQftm5Hfkp8TuU5QKzQ4Dl7xZ6UD+JJQGs+pLlNA1i
         wSZoBnYRdFTNXHr4Y6ScwoZMJDF13f7m5M+DwieFb337Y4gwVvPeISC02VXjTo63Xm7Z
         wQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782196354; x=1782801154;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwIjawHJqOj5H0dPQva+4F8BGF+VPFnCtHxr73rBkhM=;
        b=LVggOsolmhDL96wQKuWmQQ2pTiAVL5t3gIgu08/BWmBCeA7idZy+rFUPvuoFu5GkVA
         wtOCnPBlVNUX2gyQ9BfZOCHXMDdZXjZkmHgyMohKq/gkBcXR3nz9d2t3bqRhPXEIugIa
         P6MPAn/EozA8X5Ka5BFms6kZxHmki4/ke4z670hVHKKIHMok3vxTTkbefpLQZSSebcCK
         6kuWNPeUDivGX+AVVzCbxdC8a9bpADFFbJMpg3/hAfAHULBlO1hlEfBwl5Wc4ETt90Vs
         w3IWoq3fQqKdcXnFkVJxl7BVqesBfm7GRhkbUPcyymYLPBZBhn1phpHmKure1uS1QBSW
         l62w==
X-Forwarded-Encrypted: i=1; AFNElJ9eAFuiZHO+9ZqRXhdhDMHjmnowbqNDQWWuxVM1BEk7s6I/h+C584qjk9cfUFQ3Fkg2Vqhn/pyyuxpK@vger.kernel.org
X-Gm-Message-State: AOJu0YzOdZFtgRHEZyWaaYBwCZ+eLhLbMSGI4rYZdJwp5tAAlbqAE3Oi
	vvRs1MWAkY061Pij1jVn4wlt+ZwQqrjoX2lF6VD8ZauvkYf7E6r5Uc4Kx9+pzMQQeisximFyXDo
	Yovdg07XY5oGgHUQK3mIl5K89fZlQ9E8=
X-Gm-Gg: AfdE7cn4LHdlF8GavB4syGVj+nCsyOSQhZ7Z09wN3qKEAVXsZghJw1vp8NhX3nLO5i8
	6vuJhCatZmfpRm9zDqbvd/UdKHwk8H98zMCq0sxS/gmINCZIyAv3xpUZAVY1WRDI2u4w+HPtWR3
	6a9IjAf+KF4XVjwIMBMNUS0vp/o2z1vDA6X93X6mpJSiJuIWb5ETp5YOuD7anoca6GUF0Z3rIjT
	rknFHHckhKpFzhmPpMa9nG+hz/kV6IxU2yftqLxfZfov6m0k1JC1vckX2VMYEA4bPISEb/L
X-Received: by 2002:a05:600c:628d:b0:492:4668:27b5 with SMTP id
 5b1f17b1804b1-4925b3896dbmr17301765e9.6.1782196353485; Mon, 22 Jun 2026
 23:32:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <178214622623.2376914.7843191393281628987@maoyixie.com> <82be2f83-5454-47cb-8719-b259209a5e2b@gmail.com>
In-Reply-To: <82be2f83-5454-47cb-8719-b259209a5e2b@gmail.com>
From: Maoyi Xie <maoyixie.tju@gmail.com>
Date: Tue, 23 Jun 2026 14:32:22 +0800
X-Gm-Features: AVVi8CerLroODDKDgIcaK-BNCNegXQKRvgiych1sIwc3taaWHJh7M7qYdmm9u6Y
Message-ID: <CAHPEe=GH8GJzrrpuBEoEzn1HXcHRbOot1MutFQeXbReR3i_w=w@mail.gmail.com>
Subject: Re: lpfc: unbounded QFPA response length in lpfc_cmpl_els_qfpa()
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Justin,

Thanks for the quick reply.

> Is it possible to provide the fabric switch and target hardware details,
> i.e. model and version numbers, used to reproduce this issue?

I do not have the switch or target hardware. I found this by reading
the QFPA path in lpfc on 7.1-rc7 and tried it in a small local test.

I understand your point about the trusted source within the fabric. I
appreciate you taking the time to look at this.

Best,
Maoyi
