Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9836C401A3E
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781183201; cv=pass; b=IfTqXqXBqaqNzyMErYK4wkIqThE8X6IchFA+4fNMziWRK5C5eFYLO4lQq0FkTlcGPPvGOtuEAinz0TZhd1V/aRwMCtPYqA3z+ycuGubfkVMtLrjZYWvoO1NShY1ISkqqqZRc9Gr7V7EyUAXgop9wMbijW9l0r2dQRH7T7TrOdeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781183201; c=relaxed/simple;
	bh=FQ6RSVo6oDa3NIfB1iqCtoD5h3yerqQvx3StG69KPcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UqxLYKljRmLL+oHn4sfbLFZt5XmOizroJv7+oA58FUdc+JkDVld8P7piCw8ytIxAcLI5y79ucVNc/X9oDnpE+NaXQWGStv3iekFL/nSyjzgKBXVY1lq0oL2AR7vTeZ4zWvVAqFAdAiDiQ9T6e3/Tmu5LfZXU93bNQqTKw7pCbz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3qw/ZqP; arc=pass smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3qw/ZqP"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36b9033d230so494173a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 06:06:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781183200; cv=none;
        d=google.com; s=arc-20240605;
        b=R6SrWsDG/cbMikvDo+5yw8jBVnIhQspGXgnA1UIRXbLssQFMSf7XMvpbEMtF0BMxw4
         6Yyv2lzRZ+ID4X4q4NyzfdyepVFOq3Ku1+EHhSO1Z94Tmp/S1PjNyQSe/wIADyEPn0uc
         XlfRWE9aseizAn3BY1kmVwjOxZQePYcCBTBTNEFk9yQtzU+CDZmlZO4XyNkm8mfl94be
         G4jpjlVeb0pm3Paahk3tGPqM1bJuB4zNE6WBy8Zdt3I0QiMxsfgo6pLox3hU23foONrO
         cHbG0HmMmuuFJyz6wDd2B2YWrWPb2URLt3R/zsfwdZ90FQIDwrE0FW/H4ZBJyNB7c6cP
         Igzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sFNyGIT6G3ar5kcBIurFraG48CjU0mM8dnfLSCFPRJI=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=AH3kx9Orzgm5WTccy5RsDUsQnb9xLB2+3TwPP+yisQDrO/RAtNdDdCSLsZCbOrpurb
         S+yG7102DiAiGxZgsn3N+EG2qgSOzxuPiw5DlIt83cNcyF2+5nWOWA1grXvmPya3zd2o
         lQxlvRWlzZHV8v3lnOHWvSdSxo8cHm1orF6CYHbp+soseP7Zez6VlwiPaB7Zat4CxlkW
         x7Pu7OQzvMJTzGtl1nv04ER8GOZFZ4XctbXu3DKyRrpEPjfWChnkVYI3qr7LIDrwnt9b
         PHdR2a02SMfTEdU+ZLUvxbna0DFq/IhEHdBWJNNomsebTMZanqrT1rUZtAHbgelbZpn7
         /cYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781183200; x=1781788000; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFNyGIT6G3ar5kcBIurFraG48CjU0mM8dnfLSCFPRJI=;
        b=A3qw/ZqPWubN4ehM/dWyVYmH6grJ5OmRklqmO6xv0yFrGhfPTNIymgvMjIybgC4mna
         nmHVbk61Pfzq7Up4VBtzB04AVXglAOnVxqim3fwgdOFwHKM5giD8r3cb+zm2hsGXbOTM
         AcujeTnccvTguBCJ46JiX2zKMrduZG0qjcxKHW+qsUvkednTvLlmErSC2LiWU09uCNwB
         Rs8ZjcebgcctWAYPfVweru3OPoAq4h5fsANV9nDyIt80lQLYtVeLVYa28bSg8Bp0nmpl
         y5XuGeJW/VyodzHq2mPD54pbwIyoyXP3jEo7LHtmdCm0Jdr4SPD5OzZu6DY3vcaS0iP7
         PCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781183200; x=1781788000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sFNyGIT6G3ar5kcBIurFraG48CjU0mM8dnfLSCFPRJI=;
        b=QJCZKHz1mXMdJ8vIsRUf2lccu+R6ByMrLYGTlAIj4shXKiM8UAXji7NqeUqrrYei6v
         VRb5oZrBwjuHB7nV9AEdKD6XflwlwhLLi4yVxhA64ay9pGLOI5qQfY57XW0REYhtyn96
         g2Dd6fcOIW0hD94kzTlaC+lH5oG2nVAsWXQJ16HdchjxwA3ISxNK98Rqjj75JJ+Rkja2
         TrxpCzsRySNsqpJK4Svm8fBszv5qJSH/iCUs3odngMReVugPsoq8xcyH9z+FGwno9yLq
         SXwa6coyJ0Zb7Niel2AJR00jkwdqXjUreNmTQgcBrqaQ+1CmEs20AkGrnhWKQ28dsUO5
         6P0w==
X-Gm-Message-State: AOJu0YyJCoS2Nt6Z4gNVG/xxH17mXzeE9gZM9Vi0ooT0rVfcCSM6vmiF
	NFGQJr5tmOgJCmBgwULnTifbY/q2txUaZ/a11fpBAnnWZPuccjTNoyH3jzUNn2udepWSda8HPDr
	1UN+H8d7Y2W67kynIuvNkQazVKebTOPE=
X-Gm-Gg: Acq92OFPTHjWwukhGOZ8yhZL7+LJVLjbfm1rFAAMCHZbscV+2I3mOuaN3gpZoeiDQgR
	q5LnBr+h7U+vHz/rNnqKyxf0ngp8GmSaiNCeuYWibgK/XRqgQhyB2O5PDFF6R3+ZUCIT3/qrbgu
	Pgpl05uOW1o3MR+8VSz55WJL95DGeiXBqCr0KqEPVqUUy2G3yL/kyS1oAlNUCGsUag6hIA9Uq5W
	BygMdkz7rlv0IhACKJDcobE7Bzxi7EDhTSrYmbMwmTxjCmz4HOYpL5gQV884EjBYl3/49DzlYuK
	Dxu2zJgGEzk9VFLqutI5U8K9NrykKCXxFP3lEZ6KCqaMRlQ=
X-Received: by 2002:a17:90b:5544:b0:368:864:62ad with SMTP id
 98e67ed59e1d1-377ea842090mr2110841a91.3.1781183199819; Thu, 11 Jun 2026
 06:06:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611123046.2323342-3-michael.bommarito@gmail.com> <20260611124739.5C9DE1F00893@smtp.kernel.org>
In-Reply-To: <20260611124739.5C9DE1F00893@smtp.kernel.org>
From: Michael Bommarito <michael.bommarito@gmail.com>
Date: Thu, 11 Jun 2026 09:06:26 -0400
X-Gm-Features: AVVi8Ce14aVwE3vQiXEX7pA-nZk9qQ_7xULB3yO3IwL6ucdMxWq_3yV-iH_jJ2o
Message-ID: <CAJJ9bXy4VXYQwcGx-r0SbEQAfHGnzuPDcnUTkaTvDDxZoJo5VQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] xen/scsiback: free the command tag on the TMR
 submit-failure path
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 8:47=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
> - [Critical] The return value of target_init_cmd() is ignored in scsiback=
_cmd_exec(), leading to a percpu_ref underflow, kref underflow, and use-aft=
er-free if the session is shutting down.

My understanding is that scsiback never calls target_stop_session, so
per the comment at drivers/target/target_core_transport.c:1712, the
return check is not required here.

The second point is real but the only two similarly affected sites I
found,  srpt and ibmvscsi_tgt, seemed low priority and not worth the
churn.  Happy to send in if someone wants.

Thanks,
Mike
