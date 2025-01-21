Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E3A1F237E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2025 13:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737465021; cv=none; b=sp9RxNinV1j+czRMWfOVVbEsQ2KtL5SFk1TQRbHcCBYBXrWBfK1zcmcjO3tpWXA2jwrci31hbmbslSSVV+sVxk6NmI4B8bvhVC5aTbQGF4/bZiAy7pOZaVpD2dGN6abHwwvfJIKW311f+EVspWlpXyIdIIw3IOB5OCgZIJUNNYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737465021; c=relaxed/simple;
	bh=ubkTeEXjB+6kBZe+6bzx7JUdL5KKTSDgfnagzKRKKcc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=URsy+K8frZD7ZUEHVnihMOGg+uB4qaMWOKaxXs+TQea5GaEBkS+1fCC/2Gf6yG7CTYCZnWRwtU6F+OHMT/HjKDD17dF/KeT7OjWknbbl30DFNjImhJtzsIZ2DLgBKnYh/rrjiKqfnZd+l6G2CFPSeL2WKKjWMOKSO+TN3F+3g1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbuQ7QUL; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbuQ7QUL"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-aae81f4fdc4so1110818566b.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2025 05:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737465018; x=1738069818; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubkTeEXjB+6kBZe+6bzx7JUdL5KKTSDgfnagzKRKKcc=;
        b=dbuQ7QUL8rRlGAqMsXnMh49o6nfCerlktUfTk1gQqDZ1RSzxoIKjvAPmp8C8VyPo+N
         AIKqKhygSBlrZwlOJTzc4j8v1/VdpNB5ebbdpPkHQeWTEQTf274/Fmn7CCZwQPuHG9tJ
         TqQs7vi2cwQ5IVFu3x2l/JGxL91peTYZTGE0mxif0f7aIXxHxEKUXZrtA2QVTgvDxpRN
         BSchqtq+P+zTXVOsVomxpNdtxY17C2uNaQqDy5d8Om5cUX3MqwXfaXvFLXfnwtcwnh83
         YsoOZ2ZhPfSS6wPl8QDdH3Sp+2nw17UddUNIfJlidAi07Ibg+ny9O2QOF4s6lVqLLarv
         79/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737465018; x=1738069818;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ubkTeEXjB+6kBZe+6bzx7JUdL5KKTSDgfnagzKRKKcc=;
        b=wl3bMburF1gT9dC6qUuN+qOO/sgdYJsjYUp8WrMEzSMSJltR1tZJtY3n+EZsq/NcNP
         VeZl7uz2xcrEFP/TTwTjyAv7we5xCK1Lc+j8icUsyP0+N3wO2l+ajUPiHIGDlZnGnf0q
         51EpRkvYOxbczUj9FvpHNCwW1ElJCItRxTk78Kal3uXUGG2qGn7+hA1whKIxwP7hW1xQ
         0ZN9FSJtidyZ5AGM3cJk6RX8GuZLjfebJRwdxdMiI8o9eLMdVjb5X1GNQI9KNvZO6eRx
         TDiABhHT9nRosUZZxoenOPCaPRRjFHZQ7QKOjS4iynMk9dju2sMALccbB5feCbKMR7M+
         xGdw==
X-Forwarded-Encrypted: i=1; AJvYcCUlP1vFIgxrV4amcLqQWtQhKoJIS2grmLx+NXyK/mNO5k8IDnZDClw1YwJXKFLjVY01vrIcZr+/9igF@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb50VIduN4bjdAXteqnTqrbGzl9SXakQccKJrR9xClNP+ERbHA
	cR2CH/5D50q1Hwh4iyJ6NMA2mzKWqhBRtRJ07nd3vreo+Pr5BoU/
X-Gm-Gg: ASbGnctYlkPvOalXvcNS4rapON5CuP9tEiC/oXsdswOjljFfKFK5XbLLigFuSLGCCqR
	A53ggZ1bVMddnrU9e2H8vWICznm4rPMz/iSbZFs2Uskz5YTwqxdPHwQeHt0Dh9qhB8u4rNG7PTr
	QGpv0mcKtafWsCmMbMQ92h/qoTv4KBJUE66/pxKCU3Xv3F1VGoWfhzY0bVz2BC9uAjG2anviTb3
	mD2ZKPfRZG7xl5O6Tbc5Pbgo+v6w72e4QtHQjfdz8wvNXdSwqReaB4q3YroJIzD3Y0UVUnX
X-Google-Smtp-Source: AGHT+IESTSybQfUIqAIl7Hdht2SApfKchkuBkrAKBemy/JMScL/5VqJdBcp+sgsm/c5qLUGIm6q7BA==
X-Received: by 2002:a17:907:3e21:b0:aab:9342:290d with SMTP id a640c23a62f3a-ab38b1e5969mr1552657966b.8.1737465017638;
        Tue, 21 Jan 2025 05:10:17 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab644adb658sm79930566b.134.2025.01.21.05.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 05:10:17 -0800 (PST)
Message-ID: <d5a524a553deef7fd294fe1c8e71a27273103953.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix error return with query response
From: Bean Huo <huobean@gmail.com>
To: Seunghui Lee <sh043.lee@samsung.com>, linux-scsi@vger.kernel.org, 
	bvanassche@acm.org, martin.petersen@oracle.com, Avri.Altman@wdc.com
Date: Tue, 21 Jan 2025 14:10:15 +0100
In-Reply-To: <20250118023808.24726-1-sh043.lee@samsung.com>
References: 
	<CGME20250118023817epcas1p1a7cb68709776f01c5ebeeb02908ed157@epcas1p1.samsung.com>
	 <20250118023808.24726-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2025-01-18 at 11:38 +0900, Seunghui Lee wrote:
> There is currently no mechanism to return error from query responses.
> Return the error and print the corresponding error message with it.
>=20
> Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>

you need cc to all of UFS stack developers, then your patch could get a
quick review, not only just sent to scsi maillist:


Reviewed-by: Bean Huo <beanhuo@micron.com>
