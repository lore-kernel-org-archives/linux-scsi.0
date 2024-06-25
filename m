Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176C4146A64
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 23:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719357639; cv=none; b=pXXvMjTUC7apFZrPF5602zwEv6bl8QLKm1bzmuo6C9yO9mlMLnovOwEFDdhNB8GVHMac+LE6LQrt9RC4i78+vRnk2RkKJhWaCdagXNG5/Y+sjZdz5/fQVycx9aONhTh7o4Jnjr/px2zbVDrSVkk9B/0VD53FFBzqq1FrqmGHMx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719357639; c=relaxed/simple;
	bh=lUVra71rm8HFPLESRaUJVGWnwteFoPTukygmHz9N474=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLnfam5g3fUJl2+JzsWaJ0i3HyqmuNU+kjYXFFpH81zpXacDcrxWTlXk6Hw67R8RrC0/X73A+2IPdD3dwwLkwva/qDzwcJf96nrA3OcAGIjLDzP46KWRV54KEeND+w05/qMpYOOA1+V3LlRFVbmIgAmCiC2fAydnGaGmSYtFMhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eagt5iuW; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eagt5iuW"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-dff38087349so743765276.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 16:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719357637; x=1719962437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUVra71rm8HFPLESRaUJVGWnwteFoPTukygmHz9N474=;
        b=Eagt5iuWvJqgwgL5DUFJF0Qvy3iT8jPA8hUNI49d+FihkMnnYy2+U0UMvLefZsTrIb
         TN0SQSOqeg75zBdLof1puf4JjOV7D4vI0iQmflUNrT5H+FhV5WZnQUwrJ1YSIhcesUXr
         3EUo10JY/ZNFXzvKsoncvJ/DsNDbpyZzs0FIWr7rVGpaqZfdnVmV0xMvMR6asHmz4j0+
         HeMeoDtFbOZY6mhpEREhmJW4xherwkYTn5rqXzwgmh80zXiZljhfJTmrXV3obhYhyDcE
         glIUtSa58sxm3wK+cZ16NkkUpXL1lLNOrFv0i+RcX0UzJixn2KwLzOP0ijh/b6VFNYqB
         kmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719357637; x=1719962437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lUVra71rm8HFPLESRaUJVGWnwteFoPTukygmHz9N474=;
        b=QEU7ct9ivkkxhPMfFExhLahnHPs9LUEgynpzQ40Vq77znQBJjwiAzFWyDc0sUihhG+
         A+XphcUZcYqkFx6v19PtaF9CYpKEwYdunTOZXehdgORaPS24ugoD/Sq8uPWSA5vNduMh
         gNJ88xd0BoeNP8h/nS/aWuXuD3LRlidfNRhtVTB+Lw5w7MZYztLvs+uTJ5VXd243pEUP
         qKBavlNMHS/gfPJXrAuiAFx9hOXMRZ2tTrSjYnDPhaEzLDYpM5vCTohq79bbR+offqGk
         v6Z8oK9R0Am4PBbDrQ19VEaQsCrGh0vgTQnML2iDI4PRrh/Y5wf8cay6NHYYtD4/I2e3
         /uGg==
X-Forwarded-Encrypted: i=1; AJvYcCXWq0s2025SIDkfjhw+J5h2eCedMvc3aeK1+GrteHZCM7e6h3xcFj5esYjswCvDaAVXnx3/vOtcaF9kT+e+XQDpZ1yJf6uKP8BzxQ==
X-Gm-Message-State: AOJu0Yw1Xg9bGTOCqfYrPpefwC0M/QapEysfv3tMQ7Aa+BhRk3s+Dn45
	W4lWig4Mu07W/vAvy2ogmIHcJ9S1FZbjRwHSGiD+zEBSk3u49i2AYf2axcSBYFDxIUkcwXeAo/K
	mSrcWjTva/X8WHT/I7UuGAEyaymJf4Ds9
X-Google-Smtp-Source: AGHT+IHbIXWcGD0kwc7/s+/U4f+DnvV7CzoWgSUTxHo3m+uoJDygo0kgkIrutA3VG3oGRh+I8nk0g5h7yoqjKnOOL7E=
X-Received: by 2002:a25:7403:0:b0:dfb:54b:fbc1 with SMTP id
 3f1490d57ef6-e02f7219b0fmr7480339276.0.1719357637007; Tue, 25 Jun 2024
 16:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625165643.1310399-1-prabhakar.pujeri@gmail.com>
In-Reply-To: <20240625165643.1310399-1-prabhakar.pujeri@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Tue, 25 Jun 2024 16:20:25 -0700
Message-ID: <CABPRKS-rKO4kVTDJ9Te0RExK6i=6JAu0x+7xCq1dToS3G7EpmA@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Simplify minimum value calculations in
 lpfc_init and lpfc_nvme
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, James Smart <james.smart@broadcom.com>, 
	Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Prabhakar,

I=E2=80=99m afraid I=E2=80=99m going to have to echo similar comments made =
in the
initio email thread here as well.

How is this a critical fix in code paths that have been in place for
years with no complaints from users of Emulex HBAs?

I am reluctant to stamp a Reviewed-by on this patch, which alters code
that has already withstood the test of time.

Regards,
Justin Tee
