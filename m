Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86431F12F8
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2025 23:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765235235; cv=none; b=AGQEWJitUDyf9dmyR1Nd+Vm+lwAfC8Sb2AlmJ3RgfrhzqC8ED+hmwbaOvhuYlBIh7soQ3xmnrfGLYZEuwsux/LoiR6tGS3xoJQJ7Mq8X3st8mAaJBAEqUvUSdi/fbAvBemegJYPpAuqmZj9T0B34K52OOWaDDcGzoYVtvsFylLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765235235; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I/fhRDrAx1i2nLppl9K2/st6DzsMK0ifZg0Di6EnTddMD8aACEM7UquUHWkDYykAxWAJwLxlentAOb+l4PHRiw8PvnFa5UfZcir8725yRy944hH53GZj9z8+s3QhbD1S3YVU/DtAtKc+Nnp/vFOQaAUTApbiKuTNUOJG1d2JpDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B2V6VF4+; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2V6VF4+"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88857efd317so3297136d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Dec 2025 15:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765235233; x=1765840033; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=B2V6VF4+f33WNq/CdIWhGOCWLTapHYx1TKWHc02mRVS0aySykifuZ+w9bQrYHRFJWA
         IeAiSehPFswhNo333nMiEc23kRTh4sWv+OSk85OzFLgVdVMKFy+Hfn9T0oDMDG1z5Kt7
         LKHhoDJZMe7SCNknaSmhHqG0Lat5BK9h32cNKmbY5VZ9C4rWpE1NQKmUiNzD5n08SwhZ
         xnjQAGHaKQ7JfkhbamfcrDjtmQf0wpphhpTtjvH1L6uOHR6NCwnFQcMYb4o/8fSKNU84
         7/ZqrsZL64JWZxDQYrnLgalxv2PTxaaPotf2fB6SSID/oOAN4KfRUC8qSIGcBAn8I9yZ
         2OeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765235233; x=1765840033;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=rHU1XgHQJudCZ8eGsH1l/AXdGpq3PaAs4zUMu9RbrCWy2r/JRWPH1GX4Cp/bsFcU5g
         xA5uhxYuqJDyqt23maryazvg+VVt8W7Tys9YEyPhHCFn6n2riR8h5tTJmTo1wG2AMAaF
         g65wwsTcmy6Jz0aB8RUPtIJ4+EfrwRQhJpaDmVW+0JBahkGdlAFtQdT/IPfg3TXTHxMK
         fQOAAtzDJL5czJYSqF7EUmlZINu7oysEi+uk9nfNIzEgykJCXLvWxzfOtZxnt4sGB4r9
         TXBhAPOYYUmM7GeHDSXxaRLKWd0khnXObdmDYomLsNnvikxrUETBDmy1iZ850SZ/o7AZ
         JTkA==
X-Forwarded-Encrypted: i=1; AJvYcCWycY5iMWxGnm0aOSZMQIXGiI8k8vZTDFeHMfHRZQYGg5NxCz60UtvQCixhv68VaDICXGk78ZE4h40r@vger.kernel.org
X-Gm-Message-State: AOJu0YyySABnzXybMcutEVDoeaIFiYNgTeS6ZahPJFIbsjPcdOfu5VJu
	ac4FoDkR5vruOvEGYNxxXX4812J+LXBjpMglKMeCydGVilShSnrdQPjp8n6Ab2qq/AK9PhoPzyD
	GcfXEOAnj9AKmoNh8age2PXtBE7SHRlmPOe3hKOE=
X-Gm-Gg: ASbGnctN6pfPMMDm4QO35xX8CFV8EBqzUU5FecUwNmFEQzu6eR9z4b3Gm8Ljn88LaFi
	FVUmgftZsuANzHcyO3Y4WQrbitbRRWZbvwr0jg7QkZXNdHrLqsebQGxc1MvQScYMwaWQrRfRE3D
	ipqj6K2hsEJBKqj1fG2JKOtMCx4yfR9R40Jwf3vaJvUyEkccoLjdqqf9KNUdd+EBEd8bQIAGiN+
	6eJKbUhBGjsV4TXaWtwCBLcattrk1HJfO0sw3wfhcUa0/nY5OHyLS3S0XINII+kT8cnQird
X-Google-Smtp-Source: AGHT+IH0ZNpv77Cq6z1jrJVAFVz4ng2ny4rL0crWlWJTs1t0ZqCwqZtzZUwaMIS4WZADKjbf8sBGoaCA5zEsP9j6gMU=
X-Received: by 2002:ad4:4eee:0:b0:787:8e43:5761 with SMTP id
 6a1803df08f44-8883dc4c0b7mr158508006d6.56.1765235232700; Mon, 08 Dec 2025
 15:07:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251205235808.358258-1-yury.norov@gmail.com>
In-Reply-To: <20251205235808.358258-1-yury.norov@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 8 Dec 2025 15:06:09 -0800
X-Gm-Features: AQt7F2pYBRWTLO76bXnH5mkoxgW-wPYkypLigb8m9vtmnLFqguvskMdTgKX6OfM
Message-ID: <CABPRKS_FBkq4PHWMCDWbCusmWTpq8XZxjhoYo6hEVfmkn+EY_g@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: lpfc: rework lpfc_sli4_fcf_rr_next_index_get()
To: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
