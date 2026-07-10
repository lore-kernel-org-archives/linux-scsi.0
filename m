Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2643CEE3
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 16:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783702409; cv=pass; b=CSsKV/aCKLfD6+euTSoUwoq64uxBuLTQd8ACQqtkmzMg6uUJUicpCx7TgYzv9smRb++8FoimiiQQhJ7g0+Qh9DSoepIDcRfJvEX6imEFo//ao9tostBiEosuvPRjzPR9ilpKcmAyAd9lZHl4vJAhJ/7x2kyTo1YlSBMtIBDfGqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783702409; c=relaxed/simple;
	bh=sh2rgKkO4vakz349Bs2qGYUyCofEHNHCVR7gaYL1B+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0wfXzH3A3nHY1m2bcEE0npvuBwq1jXGKbN9ZMS/FP7t0JC/lhhXXn75XHOZNQjN7r8WxKP92hX230bxxp64W3wdo3Cm4fbmhAojf5vjBcO+18QawQVK/paYS0kDkU/oXYp25qXaoVk2gDNSBfZHTeTOyb5VoLJG6wXS6q5q0nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUkn0xGH; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUkn0xGH"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ee6912d86dso8872236d6.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 09:53:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783702405; cv=none;
        d=google.com; s=arc-20260327;
        b=XkRBrKY9kPkAqCEkRjzFakpPJAW8DT4AwO6neyswE5hsE9xQn3Vo+aknh/YcP6ETiY
         G7w70rz5CyN40X/AsNVz/JoXy/4kqT0T4KHxzXDW2IBnynDALSSgvcmRdMSS4+/rRaJ3
         mGsH1o3hq8EjAIUtLP/s9IysM+4wHxFrH08t/v3KaRaYUp0BuZI3vf9zMBgfuh1crDli
         qxKeokhziUpmrN4EPNROPAyDKkOr1JV/uc4Dib1HGxyHUyw/iXxIyBP8srjukugyLx/W
         AVYWKqSehxRPRDvSgPZ5uTg9nMk8+glNwSaMOt4Vag/rA9VDFuvOxjuRUzz/0xy7wOCt
         TiGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ECI5IhnPRnGOgmvpWFYd+7dPzotRRtzBx7qL4XrCfvc=;
        fh=fkk7BBqt3ZPCCz1BOU3Me7r9F8uSZEYSyMXGqNdR1z0=;
        b=GdkG1k7g711rR+2HzI6H04SRi8COFm18ZFaIS6YP/BUSNt7cjc5LV1p4QRBvi4dL+u
         j1hadoCWIu/y1nOspiCC6twh9gJgZ5k7P4nt8kUz6L/gNx8TESluJM2PkG0ZYXJUyGBV
         NE28u8Giln7Spu7PPrn3InwPFWNFjlOorJBaHw3p7MwUeu6eHlQNRJa+rxXNQ786io79
         cdAtwlfBu64URJgyOVRKcmj0bmgA/SopWaGQk1sEnLfwdQK7DrF2FfDNa8tXyQZPiF9W
         gTx0zyZKiAcRyuLUYeFCnzvWjLYVDt0GGwVoAn+3PW5qdny2aHPTqgrcuEFM3YMjwxFC
         WyKA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783702405; x=1784307205; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ECI5IhnPRnGOgmvpWFYd+7dPzotRRtzBx7qL4XrCfvc=;
        b=QUkn0xGH/sFQbzrxuvqMhLQE+YccZItf3SOAwxgdUVeVuz3/WwO6pX6v5eDPJWFjq1
         xBYQglwA+VM2AEbzmoYjIDkzQKDMcmUNoCx3uSZ2XsgqpnjAoQGgtT7zEWmf3Bycmdpt
         tXAzpjHAnq0nzZPnWV1NxQgDLrg4XFxw276eDKOjbh4eLLSjcASJ7MIIBVEjazcc3uJA
         Sc5hp9/ori9HcCWKpHfuyvxjdd1PwL5ULoMFQNyyADAWb20waMV4AEqpw0Ynxr8MjIN7
         br4K4KNOHoY4drCrasBwlXNbtW8vGytLFhU4suUODcM15xPz1r8HKtChAWmrN1ugoHdM
         B2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783702405; x=1784307205;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ECI5IhnPRnGOgmvpWFYd+7dPzotRRtzBx7qL4XrCfvc=;
        b=hFLsvd5vohTLr6WIa/4ALTPdexyrp1c7H/7W+4vlmIJNQMfNwvzABsFuxeonMk4/p8
         P8NmGDdO/wfMwI3s8l4eZIDGb9hno2T8k8W+osEtJz6GNLkwe+QzsqJJPZjQSLEi+/xH
         qYowpxS8LJLh5M6eVbuXVw4ITik6Fvbw4y/rtheJV7YjdA5Q8jsXhWqWYeQ/6VtNoPem
         LjqzbACdkH3BNgmW1jFzvLK5K+vvlq/cP6KJk5jIuxypgH65Wdrw5CaZvUFyDlkuuxPw
         I86uZ6p3WxfLzT/nXlvjGAy7jf4Sf61vCuf92RKk6RZtvOVZvU+IcC+w8yoBStZaZowa
         Y3aQ==
X-Forwarded-Encrypted: i=1; AHgh+RoViTzpaqwQNfPcgSJekqH2rA0fjF1zwunCwrVvPAdYLO/Tr7+MfDXlWiBERYsY4udabQucRapaU1gh@vger.kernel.org
X-Gm-Message-State: AOJu0YzrkvKxHwa+d7gkxx+MrmVwA7cJ9jcfg8PRe1xHDd/IjnvHDIpQ
	XfF+un4M5rSxCTxF3rqjSStb7nJLAL0bGcbl4CZpruOS846Lrv5ib/tF++67GCj1OYnaekl5APL
	FtqfzmTu3w40S0efJXl4wUWU9+FvlqTo=
X-Gm-Gg: AfdE7cm5lJXhSO/NHPtt3EdqwCr4RM4rBfbeXZAp9xgk/AVvO88JrlFYtNEjMTU95aV
	zbDWYoZfo5+fvEqbGKKXm+felkSJ1eNO8dpRrIlXhygSVnMshq7O7Pj6abOOcUuR8ZsMJYM6usr
	kln4j7BAHnFJzHqPL83C14D+Ho38HXeYbvo1SVX+hMhj5hyZvI/CuD2stT8OzIt83wNdpRFJxVX
	VsqTu5Q7xWc1nnQ8KWrskE3mGwfHZIwPxgkhm+RTs7m5VOGvDxOEH1MdYq7xPiFapfTEzDMCefa
	U/4klTNXSmZyDUM6cEQ1nl+tw/ljBjPl8Rp5aOBb
X-Received: by 2002:a05:6214:590c:b0:8ef:5103:df9e with SMTP id
 6a1803df08f44-8fec07d407amr146637396d6.8.1783702405016; Fri, 10 Jul 2026
 09:53:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260710022932.3741311-1-michael.bommarito@gmail.com>
In-Reply-To: <20260710022932.3741311-1-michael.bommarito@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 10 Jul 2026 09:53:00 -0700
X-Gm-Features: AUfX_mzB6NY5-r9woFXPAWIrMvWpGzwtwgNIeOQYOY4j24PTnnUcebtYzYymwHs
Message-ID: <CABPRKS_3BSeCjaujZyrFKNfUeN7=ND1xu0jKnyK5UQDHvq0M+w@mail.gmail.com>
Subject: Re: [PATCH 0/2] scsi: lpfc: bound EDC descriptor TLV walk
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Justin Tee <justin.tee@broadcom.com>, 
	Paul Ely <paul.ely@broadcom.com>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Michael,

There are already current plans to address this concern in an upcoming
lpfc version update.  Please stay tuned when we post the version
update.

Regards,
Justin

On Thu, Jul 9, 2026 at 7:30=E2=80=AFPM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> An adjacent Fibre Channel fabric peer or device can crash an LPFC host
> with a malformed EDC ELS frame. lpfc_els_rcv_edc() trusts the EDC
> descriptor-list length from the received frame without checking that it
> fits in the actual ELS payload, so a short frame with an oversized
> descriptor-list length walks the TLV list past the receive buffer and
> trips a KASAN slab-out-of-bounds read in the ELS receive path.
>
> Patch 1 passes the received payload length into lpfc_els_rcv_edc(),
> rejects truncated EDC headers and descriptor lists larger than the
> payload, and avoids logging a third payload word unless it is present.
> Patch 2 adds same-translation-unit KUnit/KASAN coverage: a benign EDC
> frame that must still parse and the malformed frame that must now be
> rejected.
>
> Reproduced with the KUnit/KASAN test on f5459048c38a: stock trips
> BUG: KASAN: slab-out-of-bounds in lpfc_els_rcv_edc after the benign
> control passes; patched rejects the frame and both cases pass.
>
> Cc: stable@vger.kernel.org
>
> Michael Bommarito (2):
>   scsi: lpfc: bound EDC descriptor list by payload length
>   scsi: lpfc: add KUnit coverage for EDC descriptor bounds
>
>  drivers/scsi/Kconfig         |   7 ++
>  drivers/scsi/lpfc/lpfc_els.c | 195 ++++++++++++++++++++++++++++++++---
>  2 files changed, 189 insertions(+), 13 deletions(-)
>
> --
> 2.53.0
>
