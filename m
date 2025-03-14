Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4023202C2F
	for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741967790; cv=none; b=nNxrs65RamS5zMSmuWyd4T5huXqLwG7eCr1wYx5s860Jebs1VUYdep++M9rc57Xf2b8GuA0UmYwjD/9Pg+QSSUGKmI8Tj6dA1o/SLJE5W3c5SJbei3BEa0dZsqGt/ltBR+C27ToyqWfa3yHhqQS9tnvl4rcXPHJO4VgnBAbsvbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741967790; c=relaxed/simple;
	bh=I7WfoJdrMa7iiui5bCs39L2nw3ehuuL7qs8ypQidpC4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j/dZ/FL+woJBonK1q1W0fE4YH04LEsq/fG5mrW8kJmm/IOV1/VMwBnx3+mwQPPU1lA/+l1cT/01Sjwn4U1K1gwSJaKflbbxtS0rt/+doIgT6UwBH8J0XCBJ38hgdLQ/VmEioi3a3a+H8/AjTS9S/UZdQLHrcS1lORC8Q78Er4f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DQhFt/v9; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DQhFt/v9"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so15227635e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Mar 2025 08:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741967786; x=1742572586; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I7WfoJdrMa7iiui5bCs39L2nw3ehuuL7qs8ypQidpC4=;
        b=DQhFt/v9nfss5saXPC3XavcuxWFTs4+kZPx2c6sMgZkJcT5H1QyDCwtx7KfdHdWlw4
         7qQGuMQZgaBFbOCq2rKep2nZXV4jVkdhzAMei0ciuvz5tj9fDVWocl29IQ5N0HVrtoxi
         qZoORn1Upqt4+iAu2iKRBh6rZxAIShrGJhidZC6nKs4+eYBChyJAANDqmDy2i8e+mmlU
         aIeeZP5GQR8SDlhuM80Xd6jvshkKE3kgLExTbc0zSbBUZVkXxInQW4WCzayYI03RAXmY
         71cLUcY7kYAXNLd5nXtNINmE+UDyQzVZvkH/8xkOVhBbjKkm0FSmczHgk65WUzsUnYhA
         zMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741967786; x=1742572586;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I7WfoJdrMa7iiui5bCs39L2nw3ehuuL7qs8ypQidpC4=;
        b=ODxJzcN+Gxtc0xNjmRqu2F7VWJenoeusifUm4X8gmfwlF8rgrJ05DJzMyo4GN5JyNe
         BhBVojvl5bg7nYp+NI1vDmzRjg5qqkIsMm8o31lxfWqnwM0CfR2X+Xu4/hUt9PwxS16b
         D09+7Pun8kJvTw3TcEvfH73IX6yznkwbx2e3+u/hv6vtSk/mi5M2XBht/D6FBi/wYeWV
         H9an8NkSglftG/CHBvAcyp6DJ7rZ3fPlDRKPoNlvK3o+kWykZ06fe89CqwpsSgmS8LfW
         5MwoEVFxe0VmFTyxFBOGYohWRWDg3PiVlK/9S5AhArqWjfNZwd6kelvyPcHV8xxf6S7E
         gKQg==
X-Forwarded-Encrypted: i=1; AJvYcCWzbWhylJ3HbbydWdE994c9Iz8mw6vKr3xFyNUjOBd6Izsre2CmU+eIiPD9nfl3+JvVNJWZhXmsM+9w@vger.kernel.org
X-Gm-Message-State: AOJu0YyqZ8AS+agJ6GABCZ2xINdbMoAADK8JHf3UJmSZ91+tvwkvVeb1
	ZhKApaBUcFWU3u255keMIUHRok0So5HmtrO4xqojuGwkM2QysD1La0I6YMu7UsE=
X-Gm-Gg: ASbGncuinhRsqFHy6VrQPgqtTfrCD5Ebl7fYJrWxk3gU/2u2wRk33+PTI4ShgjJvXx5
	xkzzHNT0QzSkj9x8TjvTESKf4tUkmIxNAL/A5UT+p4lZs71Jj+AUOsgBsmVoecjfNdzioeoXXDb
	1Hi3LMnVsASdzeAJkBV42QlaiYo6RmyOaY5TU9FjGtQOlj0c/Gqy+Oh/IN5zhltJiWaex3Fzz89
	qX0uw4lWeoC8ZveI1lYyHmM0Bw7N+WMFUGQnwW67QLB+/N2kxlgp+JmKS9sAObIf5mgi5J8W6HI
	9q3j1AMX9mx/19hC8tNwOwliOMRBt7AwT5uzw46HaZHQqBpLOHQIsCjjvEg=
X-Google-Smtp-Source: AGHT+IHCF3yVkeabT3o+pvpbobh6GwFZochyn0C61kckJRZQkd4Gy9mZ0YDU7EMFdvPBpYowc1DQVw==
X-Received: by 2002:a05:600c:4f87:b0:43b:c6a7:ac60 with SMTP id 5b1f17b1804b1-43d1f235e45mr40033045e9.10.1741967785964;
        Fri, 14 Mar 2025 08:56:25 -0700 (PDT)
Received: from draszik.lan ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fe60b91sm21467905e9.31.2025.03.14.08.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 08:56:25 -0700 (PDT)
Message-ID: <8ccfdccefaf0cd651a3f085aa78227907f03a478.camel@linaro.org>
Subject: Re: [PATCH 1/2] arm64: dts: exynos: gs101: ufs: add dma-coherent
 property
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>, Tudor Ambarus	
 <tudor.ambarus@linaro.org>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski	 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Alim
 Akhtar	 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart
 Van Assche	 <bvanassche@acm.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, kernel-team@android.com,
 willmcvicker@google.com, 	stable@vger.kernel.org
Date: Fri, 14 Mar 2025 15:56:24 +0000
In-Reply-To: <20250314-ufs-dma-coherent-v1-1-bdf9f9be2919@linaro.org>
References: <20250314-ufs-dma-coherent-v1-0-bdf9f9be2919@linaro.org>
	 <20250314-ufs-dma-coherent-v1-1-bdf9f9be2919@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.53.2-1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-03-14 at 15:38 +0000, Peter Griffin wrote:
> ufs-exynos driver configures the sysreg shareability as
> cacheable for gs101 so we need to set the dma-coherent
> property so the descriptors are also allocated cacheable.
>=20
> This fixes the UFS stability issues we have seen with
> the upstream UFS driver on gs101.
>=20
> Fixes: 4c65d7054b4c ("arm64: dts: exynos: gs101: Add ufs and ufs-phy dt n=
odes")
> Cc: stable@vger.kernel.org
> Suggested-by: Will McVicker <willmcvicker@google.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Tested-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
Reviewed-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>

