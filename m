Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B386A022
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433684; cv=none; b=k1NPJoR2QCTWl7lpzMa7zId35RovV+UzrxcWfMGMwkN8MstKbI1RJPebMpguJ2KgY8ymhlj1+jpCn+VaSELqiJeEG5ORG09f+Rg4hxdyTiI7BLjyVl89gRcFbLLZhta78nz7Z11XbNXCUTOfMyuKQbdikLeCZ4Gax1wSQq8wCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433684; c=relaxed/simple;
	bh=mdVR5DRCAlUSw+xlybDf+S/9XIvFQblFmhn0Muinhjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HEacvFtIHDjffQU+8LCHtaywaFQAow+tMqZ86Bw70IJjFtQfciK3N0Ye46yIQFWBI9Xa0CAreYoBOHgsJgLdgfAexuiEydIa0qAA71x0BaaoDnwNWQSU0zBHIXLGkUfXCZPVbd6buAxldn5cjyfQ72/Xwtz0bMUTs7YAfY9mkSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tSeDj6eI; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tSeDj6eI"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c46bcde211so1428945eaf.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 03:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433682; x=1721038482; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=18mFUjlhCEFSztkcHmlQ6M7fE1sy3dAJtP6H2AmzxHQ=;
        b=tSeDj6eIjkW+IJkgWUeAl0cZurxmv0Pw1t0bB5Bkf8+4CI2U61LynOPqZAo8J5PoMl
         ZBstK80tW+zwtb6mDrfHagNiMQUgaGzntUsOaK9ah7WEK9p7Q726lq9QTP692MoSBleX
         t+Og1wOCBwK+K25UQ99uDB3XKjwxGPAffccBTN8bXEzJw88+IYy0/M5apbRgd4pvuo4t
         KX7wTMV8iY9y1Sv/9F17uP5c0OWoaDEd9tcHSioxH5TMEO4HYmRcswylEwTgmgeezugA
         hV/55ve5pTa5A266bwE+7errpEnGisTXcWuGhuNAXKj7/HLojPGV1V5g8AMNBf5R+2hL
         dmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433682; x=1721038482;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=18mFUjlhCEFSztkcHmlQ6M7fE1sy3dAJtP6H2AmzxHQ=;
        b=kvBYLJ5WaEkCQiqtNxB/0eTnNIJ4xjtjKfQlSMu+RmPnIpdBgFcsc3eD7QzVdqr6bO
         zGuY1EJh0IYw7ZxcLT4AfEYI145wJaW63rJu1psrSQobX2etSC32VSH/jNbLV8xUagGs
         oc7ZyOT5BMU3e7cqZnNMRjkfRzEPuAUOe9U1zNaKypvQiutHP8XhGIfLw95emmJV28EE
         IcTp17c84BUurVfgGfsyWX8xk54p2tY4VJy7BlE/N6hHr24zDndM70xIBVRWm0Oa+Wjl
         JHKqHgUj2UuJokxgJ3D1oPTLosASLGLyAV9Y+WsYbVjt8W+yAUMm3TVMwdRuDytumZs5
         eoZA==
X-Gm-Message-State: AOJu0Yx1MIZIUqgABiSMSPET3e15cbwQQ7NwKTZt8G9U8+6ZbzbQf5vp
	pynjsfbbuofxQcVa3p4g7x7BFKeExFsYl0MX4jx8hkbjNFCuRrFgZdvjMRpVnyCIpvTdj2hCiY4
	FaJPpC8IRLaOuvZPzxIaXzlIB6pI9lEApNKwceg==
X-Google-Smtp-Source: AGHT+IEidV5BA3GbP/YUGyFWXUPUfjUVbg/HkGroMH2IukzlChvyhkwiqBj3UjHON66KEYrUdeF5hH0WDWHlcPueGqc=
X-Received: by 2002:a4a:2:0:b0:5bb:1310:5f37 with SMTP id 006d021491bc7-5c646e9798cmr9054879eaf.3.1720433682004;
 Mon, 08 Jul 2024 03:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-3-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-3-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:14:31 +0100
Message-ID: <CADrjBPop5VwR+QW8XQi7ALEwWpt=OkB1X7bPjfk9gaWHn95r9g@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] scsi: ufs: core: fold ufshcd_clear_keyslot() into
 its caller
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 2 Jul 2024 at 08:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Fold ufshcd_clear_keyslot() into its only remaining caller.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter
