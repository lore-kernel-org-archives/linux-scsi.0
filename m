Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BA030EF9A
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755276012; cv=none; b=tF7yBpH3wWIQMj1rUiLUiAXH7dRW7ZfLEhX073o/cFz83zeus5p0sfyT/OLwiUWUK9+akW05sdnJb9u8PjaBbG9X+TKCC8/ufzMEzMtHwNaBZOgRhONeWlwd4I69g15y20KxMUwIW7Dyg8t28jI9iyNumhieKfgwPNdmf9D7kGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755276012; c=relaxed/simple;
	bh=0W8u7p7sODDxr7QwRUh6c7h9fBVSVIGB+WOIbnOvImw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pe6JzMSx6hRMMpEGW2jn/K6ApC97d6Lv5UVd69JLBYqZxVrpKye/xucP8hi3wczpNKjlUwRCHVXKdykaJD3ct0+3nz0b74SahJR7s5lGuLCBgIkzEoii0l8nLlAyDcfjGhgVnQbWVz6iqGk/RCU/3uo19TDd81bEwiFGvU6V0hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fFFdE9I2; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fFFdE9I2"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-242d3be6484so335ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755276010; x=1755880810; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vaT1t/JnOjZIL7G3qMRP4enlm/yjFIEx1N7dbjqCchw=;
        b=fFFdE9I2UCHiNsSEEaA3xlWukumv53nLjmk5Zx7RVyBcXvaWd3KK/PaYpiAKQLeQ0P
         PddPARfYhohWHxy+pTogTWxTcLN9V515KgIGpA8dlIB7qF66Gw4tTFNaYFEUurM1qF2t
         OIJnGXAge6qdioNhaMYBNlJ66wK/1wBCh6g5WarA80NJH3IENFhLwMsBvN3xLKpzUl6o
         NNtWwUwzC6iuQLQftp5As6wWllwE4mXPPPAv+AiUuSjKbfQFMshTnNh2cHwEMhzvp/Pg
         n2Ohb6uIsMfsLeswcbI+BwcFr1+PmxxaO1lhGKl400TwxN3ofT/mN3U8iQltlGa4EkVv
         ecOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755276010; x=1755880810;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaT1t/JnOjZIL7G3qMRP4enlm/yjFIEx1N7dbjqCchw=;
        b=iTofzQq2GKdeUQ41XTT7u0MnsEWexPYEyFaguYPUT6t0gNJ1cgszjbjclHsrg1UPpJ
         TOzhISwpOtzynuTbDwixgywrdLHimeJ9OESBjukMiM3Kb48Fps5wxoXtsFXNhDZli/Q/
         6FZGBJhhOnPDDLEUa00sUdI7DTzmDnxzlDtXJy6zj59FWq70Iad+xPDxOCDgwXqKe9fK
         7txQOKJLZWyekWEMe8QTdNTi6pbbjTBDXDiAueupQ5oJ7vnHYaka4kxYVk5fZOBEHUov
         TA+JTCvzPtJ3uw3APCxzv1lDPtwKX7DDbR7chyC0FXm2LMF5jIqO/ZsOd2H5WGSA1dp5
         4LGA==
X-Forwarded-Encrypted: i=1; AJvYcCVmumAI+LoIx/lysDeXqZYCHP3ps+cfew8ooW0sPSpxvfmKMfhxGP1Dc4or3H+TW0rAq0L1prtBE9fJ@vger.kernel.org
X-Gm-Message-State: AOJu0YweDw3oKc/rgycBIB4BzoBVcxL8X9TsesTYuPNRcuxNQYSixkw8
	9bbUWS4WzKOQT+hY6F0/tAouF0fGPk9OEnIWquilxDvXaGXey/NfLevldgLoT1VAzQ==
X-Gm-Gg: ASbGncunH33YCn7PxD75AsNu5TP8VhIMXBA9C44T/+fKAENBG/4hoperke1ZF4snChc
	V9l1ir+xZL459XB7yxYQRQwXCtfHp1tZ46rp86dW8ucUg00RQox20QiF9oVa48y8CdN7aasTw/H
	IZh5ymSA0Em5RZNEWndV5EsqGeuuScIgfkt4wKhF35MGfJxOTKAzQbPra9cHfEWjp3hSXMLLxL5
	+3b7FvqNg+wXmun424z+OWmHQzjo1icgV48qVLP6ySqCTGTkGkNPiGy/2dV5YpbvpWU3ZT/WgMq
	FdIGuDax83hLlznWG64dUGfGi3rF9GPhfFj+xWfYfSZj+zsdYDB9nqhoPheMJ5hNsreIzfrGNvO
	MGxmkdaYCOyf23xpIRu4NIz9b8SD2+eIuXwA5pXbmPOFujxre8EgZorcMTGPdLloMXpokUdjFgN
	x8CiNbBBJo0A==
X-Google-Smtp-Source: AGHT+IHov8FjB7Xgxflq1JptrUWw91rNlGa7E2Fs0xXvEaQaLS/6JxHBU+6v6HTQCC2VzifyDGFkNA==
X-Received: by 2002:a17:902:d50c:b0:240:640a:c564 with SMTP id d9443c01a7336-2446adf70d6mr3540855ad.3.1755276010061;
        Fri, 15 Aug 2025 09:40:10 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446cb09ff8sm17690295ad.50.2025.08.15.09.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 09:40:09 -0700 (PDT)
Date: Fri, 15 Aug 2025 09:40:05 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 10/10] scsi: pm80xx: Use pm80xx_get_local_phy_id() to
 access phy array
Message-ID: <aJ9i5ZJj9tCPIu_P@google.com>
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-22-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814173215.1765055-22-cassel@kernel.org>

On Thu, Aug 14, 2025 at 07:32:25PM +0200, Niklas Cassel wrote:
> While the current code is perfectly fine (because we verify that the
> device is directly attached before using attached_phy to index the
> pm8001_ha->phy array), let's use the pm80xx_get_local_phy_id() helper
> anyway, to reduce the chance that someone will copy paste this pattern to
> other parts of the driver.
> 
> Note that in this specific case, we still need to keep the check that the
> device is not behind an expander, because we do not want to clear
> attached_phy of the expander if a device behind the expander disappears
> (as that would disable all the other devices behind the expander).
> 
> However, if it is the expander itself that disappears, attached_phy will
> be cleared, just like it would for any other directly attached device.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

