Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C28356A3E
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 10:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771843801; cv=none; b=FQ+6xFo0pkTmIDYuhI6CHJnDZKv2BzyX5ivTFqfoVrBOzpUWyZ1F3j5PlN3Ic/KnxTY7gQzw2kyk1pgJ0l+wk3TE9Ep44S/DV7CIDhODXnG3FMYQwzu3/vCkWuuFNsln5NAdaGtWWX2eEgnEDDeOLUUMq1zAkIFoVcQ6oPyfBNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771843801; c=relaxed/simple;
	bh=x+816UkHLyRvuKb/oS0wEATvXuUn8rJpVOodqIFEeMc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HZRFDT1A6zM4vw808ebn1TgUDdBeAsVHSFcvLHdkVmBX1fZeFnUvju32aNy+YebGE3RwBUnB9tc0uRTFCnQsJZuDn9zmbzhFjxc2DBi8Cj0mGPvmPguoKNr0rrNUt0+TEr56tR//jw5CM7GlBFQ1xIqt4wrLOuZxd2h2+lLnpoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HdIT/5Kf; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HdIT/5Kf"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4836f363ad2so46630455e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 02:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771843798; x=1772448598; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x+816UkHLyRvuKb/oS0wEATvXuUn8rJpVOodqIFEeMc=;
        b=HdIT/5KfbG82S0hp1RME9DD4/xjGjskBI9w/522BIoTBxIHYFTMTBV20YFDTDrOMkH
         XNk1gU+e8tAjrmyayAZg+HWgsaTA1PQFZLTMoBn+SReLbE3AvH6ul3rg2Ny/sHRijF4h
         WuER1y0K5yWLp5wp+mTrcptNlwt1xoidbsfe+HqL1BFcwB5MI97fy9WiDj0lY3WaX7X6
         CcKNxjz4sInGKm1up6bM8INWw7divT/8Mkgiot3AawSrdGoq/kZWFWLoeKWt+APFaaH6
         TFByzlrvdV3UrS0jMrsp40JCjuDWAce4IU/5GPmt5TGBmWlxyCM18Idzx7Hj+tLJM4Rt
         lEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771843798; x=1772448598;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+816UkHLyRvuKb/oS0wEATvXuUn8rJpVOodqIFEeMc=;
        b=rCAW6Dsin+Y9e7E0gWFwX9mifhZve1aguehumOuWyaHBzXaJV7TclznJTw1zZkiRXr
         C3xBkp/H5Nk2L1KNtp9w0Eq1qI/Wh+8Jyy7rggyU//YQ2pdo0UDhbA4UGRnT6voBDVpd
         3dFhOsA2fuUJpXIjNsH3l1ingpq3oaOgHyC9sEtK8ho+XQSIwQOhiR6ErEHUdwR8plBt
         Hu9R5ky50W9eLnZ49ok8JlcGGFFY8ueuRZ9MefxNlbOhYHSJsF/IBc/fhE0s4wguf/AY
         70FVkPMvH2YdUyMQ+mw+gzBQry2t0JoZeQ3htrAK00HuUkoNZ7T8DZkB7OrXT8AxncsA
         oeXg==
X-Forwarded-Encrypted: i=1; AJvYcCVK7OBq5+418Fg4l0QQyLhppet7diw0HVdaHqjTg5iZ/mcuPQBQndvNYnSIKDnRgQpwiXNvvoUyHTGU@vger.kernel.org
X-Gm-Message-State: AOJu0YyEJy/vIcuxn8M2sn+ppypcQObLLv64JptOp9VMb1ql92ZW0kZS
	RFc5iEeq9YuQS+UAHEgh3ZDTOdOiAKPviY+ng4dTrDxgTGA0ZXBpFus=
X-Gm-Gg: AZuq6aLCM/e57+N7O9HXEBDSt8qP6LslZSMBW9cYct0BDeFswJwIuXB7UjHl3WY/Xaw
	YnvOCeqa38bzqxOwV9YCaIWAeg6J/wWmcWK2j4yrOIQRRBz5PyzJArMyreW88UL1RrxrQ5c6T6/
	I6CI1UcJmrQrOT9H7PDiSpPrfH5BrLM4CreX8VII/rRFoYr2OqpmnERYMyxvXboOQ8wEA0YpxMo
	oylXPlPxUCcJCqbfbQmVaFwKC1icahtFT4UGxcuNxskGDUv9B/WZ0pck+ExPakoMB/A7vE0j5Cl
	3lmyaoSsyVJ6wUBnR06FI+zB6f8RHTsnYcAt5eM95Y3T3hrK2ghOgDvPLyONS69p6mOdvos0jgR
	lS2iynNohS0p29vw12XRDRjMwP7T0aN5urfSxhBcmqO2z8yfUpYcu1L26McM3RIGqR+e8eRzRxj
	Db8JOSNIT5rVyJZqXd1M0ZFQc=
X-Received: by 2002:a05:600c:1e28:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-483a95fe96bmr115063385e9.32.1771843798140;
        Mon, 23 Feb 2026 02:49:58 -0800 (PST)
Received: from vova-pc ([78.155.60.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31f0370sm448490105e9.11.2026.02.23.02.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 02:49:57 -0800 (PST)
Date: Mon, 23 Feb 2026 11:49:55 +0100
From: Vladimir Riabchun <ferr.lambarginio@gmail.com>
To: ferr.lambarginio@gmail.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@hansenpartnership.com, himanshu.madhani@oracle.com,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, njavali@marvell.com, qutran@marvell.com,
	skashyap@marvell.com
Subject: Re: [PATCH] scsi: qla2xxx: Completely fix fcport double free
Message-ID: <aZww0-I8gw7AZkib@vova-pc>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYsDln9NFQQsPDgg@vova-pc>

Friendly ping.

Best regards,
Riabchun Vladimir
