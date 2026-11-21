Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795227344;
	b=ujFdWhcu7IVw+xMDTgncs7/iKe0SXgzFbj8LE9ltGGUwevxuxMjwStYiCvOJXg9zbzNa
	 Y8wqwXBANCl4qQtxjH48sutIN5Ae+UB6f2WUpz4Z9dtJiNS7k2b090m6BJRxURDKXW5t1
	 ToCiMp4hR+50Zix0FeiXvd6RwZILO0lmOZE2UmVYgN2oMs0cCIOFFHBIeeRMq8HaybUE2
	 fUp73+o9cOMMUgl4D4Cn3tH9NICDOQm70eyJ7JndXrgPuH2burrGKJ+La+Nirq4pB+sTO
	 BDcCGLgrpTxs1TfW3EXmNuqGcctahfH1mcmKcwOgVO1/6shrcK/QKJINb9gncceFW+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795227344;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=dyZECRVrIljDlHnUfBPendlKCSSiK7JRQLVRxVs8FHk=;
	b=1FxdndKPMS9WZN7O3oA5ERFsnYOhOZFJpw8R9KWM3E0KP0kOvEcsOCBO+oEta5kde8ls
	 4BaXpCrxxc38bz2Di4CvvlEo3+7+L0GKIwv5z1P4PQV4bAugDgrpP/Ko5nuG4MiAFgwS4
	 L7FDuPMp8rwEgd77pdJN2Tq+4IoKN2KDHgRzC6xgddGpp3oJV6tbRjQYOMBVTTNoZgIIE
	 Nk/pNTghMeyaI2CKz8nXwVR6w2DoIUr/zjZRfrFGXMaIC0MlltWWbWoea7EVosC+XRAqH
	 3H291XLfhbNyKjpw8az4oVNP1bHlO7w82/cJMdVxoM5sfNC0FIShm4BnIDCKjabT/Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNSgPkTT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A467606A69B
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 02:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oNSgPkTT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC341F000CA;
	Sat, 21 Nov 2026 02:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795227344;
	bh=dyZECRVrIljDlHnUfBPendlKCSSiK7JRQLVRxVs8FHk=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=oNSgPkTT8QIWpmXkjF/5bydWso/02EmhFSMhEWIxAz8Ro0itcjt1ar6BnxUSCRpPx
	 eGIGMCMuBDhuRSTkY/o+MPT1zZwmmv8+E22v5zlE7iLCYbPJuh7FgSfznP3YIHDK37
	 FNyb6EhK1GhVWp+I3jkNYOE+jXloc2nsvV+wWgb2Fm6jS4gvhE56WI0c71676OFwAX
	 D2UPeyQjF278355Zu5QOA4DX8WGuoHP1Iod9qc3H+hGS2vYm0s4/S3HmnbbDHisj40
	 2ZFD09PZxI3S4peu46qJrC4OsMt8Ch6kRJG22FMqggUBz6UAOBeJklazb+/yNUbKeG
	 1K01AGgvjTv+Q==
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org,  martin.petersen@oracle.com,
  sathya.prakash@broadcom.com,  chandrakanth.patil@broadcom.com,
  sweeti.vandure@broadcom.com,  vishakhavc@google.com,  ipylypiv@google.com
Subject: Re: [PATCH v2 00/20] scsi: mpi3mr: Fix issues reported by Sashiko
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
Message-ID: <yq1y0annd81.fsf@mail.kernel.org>
References: <20261119071133.127282-1-ranjan.kumar@broadcom.com>
Date: Fri, 20 Nov 2026 21:15:42 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Ranjan,

> Fixes for issues in the mpi3mr driver reported by Sashiko.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
