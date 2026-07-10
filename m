Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB6B3B71C4
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 21:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718451; cv=pass; b=C/+nPQdWAI0whiXUmC/Glo4kDtitxDTw0apjlXwpP7ZZM4rma3ufStLDp6JhWUWIlLtV+m574Fly46oFaEOh+AdwtluRnxTv6c+rEd519Y6uheIwGtBlSNRv8YhKFJm9qyrWX6LSLbzVnf6DY9MW4Q3CSpuv1fPR8KdfkKVpQjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718451; c=relaxed/simple;
	bh=wkO38/dlD5gJBLaxlIlRDPnanLV+lBE5oM93sK9WuLY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WF9c2INPmgFnn2XjKMDrywTues8JFER+qgSy7c+LMrubBMHnXP0bH7yDcFlDQg1XT0BuBjusafPppBsk9wO1sIOWOmXT/0D9FpA2iBxtrl2N+PoKUpYSfJUjMCAXQv/MtRDhevlcPUY2+gScZKEb5tACfxy0C7kcSYt1LH7TAGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yh8+C3it; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yh8+C3it"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so10699046d6.3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 14:20:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783718449; cv=none;
        d=google.com; s=arc-20260327;
        b=lxQFEPhEcjzXRet3NP/o/TG0Eowylt1d/7goq0uDMg2Af4zQUQ4uEYiX3/4BVTt6on
         kUL2HITzk8i01obWG9rp2fMx6H/NGko6WtDufTSpqnWevaRrGEMV9eZ4ExmZKWeVKrJS
         3fkXE6I+xSfFg0V+Kt1wwbUHn1Kqd2rBRhxhk9d4uqab/C16N/BO1GJx8AggIr2oWljx
         xaPv2DblC7RuF6dUANabf8K2jY5lB/+wlDMEzFN89g8Ky6i96/CUGaVx0c7fAIAiY9ls
         1j2fNHcd3fYnimeQElodzYWYzeqnsyTeF74whzSd2IdRP9Je28uYL8w6JlW5qL9DVnly
         97dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wkO38/dlD5gJBLaxlIlRDPnanLV+lBE5oM93sK9WuLY=;
        fh=aiZ7jBwm6WTNFEQnn7xNjX3buh1ub//KjWCcrTl6Y1I=;
        b=CQBz4dbhnb1N5z6rlimU7ZB12ayNQriZZZBhgefR+PLd4VVi5MtDVk7w4NXyXnzjGG
         GlfSdl3sV+zVDmjLqfxjYvK3G0zgFyUjaE17G8y17tJOuIVe5LG3H8pBAhO3k4Qpqb6O
         VUDZCYsm9hvTKg6236rROrS6UaIYuh9LKJQFyUzl1HUCmOTmoXjM1J+ydjKtd1qWmCQd
         Wo7nGh6igFmLXOBPaeuIeWdwI6VcVNfRyCIm2pja2J0AZYgzKQU0y1XLIuLsf/0RkKqH
         hTyIFzCY3PlExXI5rzXJTOJEtPHdZZALBAfBwDpI9Y3+0fNx5WY+Jjrduir5yn3t1D2y
         HbFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718449; x=1784323249; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wkO38/dlD5gJBLaxlIlRDPnanLV+lBE5oM93sK9WuLY=;
        b=Yh8+C3itoZ3hdokDtlVugxbrV/BWCiGX/bqcjO7wWh9BIif5gp75jSMwWXFb+j1ZJ0
         nU5DOfu9AvdlTncsgDf8zvjzTM4ifbWKMTuTRj3eKd3yZOMhnTqHS/FsztQGITgE2ffo
         PeGO6N66YbwJb0iRCHhlJryxvFKevVdTOJXkxXhrXVxZE+jmojzBBD2+K7qnMz3RwXE+
         FnUdY39LiuJ66Ly5SJZ2zpuYz2LciFNdvdwT24RSEA8fbNFQFQCAiRQ4AHnVR0CxG0Iz
         b+28qIj9et6XnArjYlaxFyyHukxYaR4n6eB6aVOSBzXkx4GANCp7oINH8rAik7lo28wH
         I37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718449; x=1784323249;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wkO38/dlD5gJBLaxlIlRDPnanLV+lBE5oM93sK9WuLY=;
        b=fX9s+OTOF05hb8IQuF4+gNfi8/RZeQ7N/fLv1+wpIV9mEFDWg/7K1dhaim9ddydNWR
         cgyIWHFR+fbFq8R9JCTDyZGsSyovtJEamY8ti7IykTJUwz1jXl75hyXWuKv/8dP86sE6
         Rvdhf78zBqKU+Ui8L9EQY2O7YKvaRoID6jhiIgt+dJ+eLz+Fujvcb+gtxY8w9lx2YqIY
         rRz7jVIHKrKE4VRKjiOMctvfhWNuG7QNLF56SFxUJHphZUDMeV+r4FClc2Ep6pzmbX6w
         enxB1BS1/Q6Tu775pvkYhm7GCUbUckhtqb2RqSvKhUEE2wx/QSDoEgriOsuyzk+wr4nf
         AeqQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1N3BJT1uLKfY6yOfRRX00FcK2xU6rE3o/tI8pZJQwyc8I9mYgkt+M+xgaNht2n3R1x9haTYX/1i3p@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+of80iDKruPTBE9iAyZndYkqsBRE8Mt3QeUvmDn4SSTRCt8++
	/ssiEEF/65UQoCdHALyyUtMHgVVnJVs+d0/37pnnek2rqJ1BFy84WUjOt+Pih+XlAFV/IrVaLv8
	mNgp3sFZOU2Y0DVbD32gVWB5OZm7opuc=
X-Gm-Gg: AfdE7clUogfztQxH9a53iOamUVvypsFEmIeK6RGs1I0bhwYe/mMce5VCF4r7GC1undb
	owt8PACgGSb+Y9fZ9MW8OujiJBVAfw5L+62X+xz4ax3OgaMCrRcS1PZDG2OnV5VyZlnzCVukoU4
	xu1hcgTKolsYOQBYFf8fOlBOEoDlvKcZKTAfMNKj2IzY3oERChkSY5Tu2M6q20p4ltPWWUee3We
	zSC6ltkzUvET++uNA8En9CRyxk/jk9bfCsaBq0o0aGW3G0eNe0INanDn3J0hYk+7D40P1cm/WY0
	yxuRrs62e/m5wLClfpB5BNvxXzclfQ==
X-Received: by 2002:a05:6214:c85:b0:8f0:4e44:79e0 with SMTP id
 6a1803df08f44-903fe450e8cmr9311076d6.1.1783718448596; Fri, 10 Jul 2026
 14:20:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707065304.949135-1-nihaal@cse.iitm.ac.in> <e9ecb5d3-cb77-43b0-ae75-f15a28bc86c6@web.de>
In-Reply-To: <e9ecb5d3-cb77-43b0-ae75-f15a28bc86c6@web.de>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 10 Jul 2026 14:20:23 -0700
X-Gm-Features: AUfX_mzo0Q8HKuQ82Eb_1CQeDvkaunnykMh2QD7BuZJBtufUgw5xnipZWe_KVRE
Message-ID: <CABPRKS9BUF84OuiK-FLfrN-z7t0E567Nvq0=1pjLNc4sH4yjZw@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>, linux-scsi@vger.kernel.org, 
	Justin Tee <justin.tee@broadcom.com>, stable@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Paul Ely <paul.ely@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Markus,

> How do you think about to move the mempool_free() call directly behind
> the statement =E2=80=9Crc =3D lpfc_get_sli4_parameters(phba, mboxq);=E2=
=80=9D?
> https://elixir.bootlin.com/linux/v7.2-rc2/source/drivers/scsi/lpfc/lpfc_i=
nit.c#L8180-L8191

I think you mean after the "rc =3D lpfc_get_sli4_parameters(phba,
mboxq);" statement, but yes completely agreed that suggestion is
better.

Thanks,
Justin
