Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F43F7345B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720473235; cv=none; b=m0gdmbLh+GBCDU7GkWppe92ZIK7qhbb0qP3WX3x7LWvs7j28a4GrGsEdt19NoIlDgrAWp15ZXRoXY+t3+mic2AVQ3uFgIje+T8b5DLNrb1SAzynnM+Hnfdfd6rHPbTFe2Za6b8SjH6xgq5IbItNNNfBIjyic4ehlTZEIGUwz1EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720473235; c=relaxed/simple;
	bh=dUpigZmOB6FfRYclS7iYwUFCqWQIP6ilU/BJ3JjiTuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mLSBLbGo7Bdy/fDX8vkvew2ljYmMnpwHDcaS+97RNdEqYrtoIZ1uNLo4jR1arXKJYu2LNbHShIxybkr+P8NtvTqR5FLAsrHDBLvaXC0w0OvoqVybRfPauXh3Te6s3C3bgAJd2PJj5vFlh2X/JB3Ml5EBxRlycw/UVPmV5rd3jhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uct4HeT3; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uct4HeT3"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e03aba4ad2bso687073276.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 14:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720473233; x=1721078033; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/gjKT/rFBM58lij5FjeNlTtg7YfGiNvwawZ0dNLZaUk=;
        b=Uct4HeT3flvIJzFWDSbH2J0lDQ/AydBtCjKmAEv9f9wGPyIzSRWU0VlkcjX8nrzbfe
         GgtIqkuipid8tETMa62H4HSND2o/PoJvQx4IdBf0WO/nT6SvpE3CrrVom71tYrpDbWoo
         GBh7Ak0hrlQEA7lYXv6AKg032V3faDYhxWbr+x1k+RBzgTmWYjcEUu3gDZ909DolRFbz
         FW5WP1kXE70pWJw9JemgoET78uHNh1cH4brzaauNxTGIWGRxQv6Gkd1FzR/m/z+HRNKG
         9gs1SYR23WE9ZP/G09eqU1ez7AfRkqOlqjIJWQXNHfFAD6zed8OpKusgH4dgxwO+mCGc
         5mUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720473233; x=1721078033;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/gjKT/rFBM58lij5FjeNlTtg7YfGiNvwawZ0dNLZaUk=;
        b=JnY0e7OA+VOMYcn0S3INLJ21olVW55A1jSHeSPm0Wl8uKczgrySLt7nUElEnqroy/5
         PrGTd44f6XlJkInoSH5Y7G5SNtJINgNDAI4/GfQv16JRmyd4+Aq9Hilkrxccg6wwYobq
         BWxZ54hVzSz1ybV3k2sa61O1tL4CEfzqbEH8FUjviOm3jwitG12p0xYjD9aULo0TyWjA
         0WWDB/db3ePOSXx9iurzXsD95+S+cgoFlAFL6JNEkHBwpNvQ0vslgswPSPQH2m2Di6xI
         vDgcwIoBXDVb+aBb8y/PBz+zY0xCLYR0/+Cr1COzhrgpyj3iP7RTZBOE61a1dzW1c0EY
         1Ctg==
X-Gm-Message-State: AOJu0YyaOVfgD+2GCVS2Y33/FzIC7SLdJxZhmj6KyiJBe91G3DMINowH
	scq7NjLaSJzebFE/Kr2jyMtqUrt7IT/u++OTmRJVY69nQ/BQOqQouwlHlVxGVJEAv6196lYNbMy
	L+PPss91zIkZ3ACejJkQi0gqe76k=
X-Google-Smtp-Source: AGHT+IFnf1r7xaoc2X7LHE+NxFylQJsMuwnOIvkOKrlaTNkCrInA+glkXlupIgLZAMtB5t/vpUSJIsX7Brh1+PA2BIc=
X-Received: by 2002:a25:7453:0:b0:e02:9a16:9626 with SMTP id
 3f1490d57ef6-e041b4a9147mr851670276.6.1720473233137; Mon, 08 Jul 2024
 14:13:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALqm=dfuV5038UezFUHZGXh9Dx9xj24_aucxnqXf6J9jGaPNCg@mail.gmail.com>
In-Reply-To: <CALqm=dfuV5038UezFUHZGXh9Dx9xj24_aucxnqXf6J9jGaPNCg@mail.gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 8 Jul 2024 14:13:42 -0700
Message-ID: <CABPRKS9GmXYmz6uTzt5Ak1-TE0C3yaHEzsfygXGRcFvu5d=Gkw@mail.gmail.com>
Subject: Re: Asking for help to debug a lpfc driver panic
To: Jiatong Shen <yshxxsjt715@gmail.com>
Cc: linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Hi Jiatong,

Thanks for reaching out through the community.  We will help direct
you to a local Broadcom contact to assist in analyzing the kernel
panic.

Regards,
Justin
