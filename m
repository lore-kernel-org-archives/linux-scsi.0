Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE323B0
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 22:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754347890; cv=none; b=ttQp0tbFluLHDo7kwjgMIEGoSADEfMS2UKokGB55jHhVJIRJCEEf2oapyx9s5sFFG7sFSvSAgsy7Dvl74rTbvS2cAiporXe6/hwXwnKyqYWWIrmKqfq2uukzFPgfWqMYFnWs4PcBNvLrahZXOEAgMHvcVWZZ8GEvDxnR9szCBIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754347890; c=relaxed/simple;
	bh=eTCc5vgH7mTmuNjv5YdXM3W0rT+oMhpUpKTRoQW4KPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y1K64BL6BY7GB+nwr68aICE4HB4T8wQpI/wTnPyKENArUBwHoIMQgSgyTVkWyIyqxG0T4BJ0JFJCS/zrRQqVe4BuELaoKXdER6JDCXdaHbMyVwxwHCefBbIUrF2e6fPVsLHSufCl+ehqvQ9AjZojwdZjK5LXQcaZ/uxLItbrhyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzoM4Hxm; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzoM4Hxm"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71b6ad2d6fcso39874237b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 04 Aug 2025 15:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754347888; x=1754952688; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNBKgGxoms2bbi/7jVNQ+WzTykZqSiKW09jFZKMltk8=;
        b=YzoM4HxmmUVhj2LRYMFk2XvIRzLGmLtFGyN5RV4GaTwT+gVISMQGnCbSxaZeQCXrl+
         N+JaVgNGAkvX+Wo2oOqscVplTroRO/cDSM2qRpx+WdDh5STwwvahgYbShw18jEib0iPW
         Sq0uRRLzxagx3iNT6l2GeuBb0gZOxm8KmfuQKImESEgiGxuEEj0aaJHb1D7RkUU6dyFh
         mTp9bXTFbka9epAufL/WUJRW7oksnmyIgblzQGO1QYS6ayxu2fQXE+50uEg7KwTB9CUf
         i4wl0i6YxQ1Uduzbh0wFS3rdnA5HLtLshhl2xHsZNTeiXKTFR/hGmOpmhDwLKzaHxET5
         gSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754347888; x=1754952688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PNBKgGxoms2bbi/7jVNQ+WzTykZqSiKW09jFZKMltk8=;
        b=XfZadmyLOzJsqVQCxosLJwC1ZA3MMXe8SdJC5rvcjH/l2UfltQx9+yEDEg7vEodgIi
         WEqt2JFQBTPNIQ3PG9/3jfwl74IP/V/1wy8jPdd6Z3zgPoXr853Yu9BM9OKYSaPQ/2P4
         jmYsFnwZBOAW11Z9gypxyKKJlUvbklbzHBlsO7mwoaJRPyb/r93+cf7l2p/gnxklneIG
         8FzBl1rvXAJAQPRiEvMSm4XNBpOLQpBNK9jDQCEQXBY5Y/tw5Suj0T1UOojFQK7khlgn
         bFA7MsH/E3rEq/jiy3qMCHDug+U398CWrfwputkdimw+ivmDlcXciSeG+mdERAy8kQuc
         3Afw==
X-Forwarded-Encrypted: i=1; AJvYcCX+TXLhKYMy0WBxUcl2Vv7sTE/k3RDKrRv3dx3k1uoOXb/wZroG+UZSx5nJK+EFM6dNU/VD5Z3Xuoi7@vger.kernel.org
X-Gm-Message-State: AOJu0YweqGOmDv2qEEo5AVeO0S6aUAsR0TRJz2QXgLV2tkB/vWL27Wf6
	RusNqc7Q2wzmjJ7zrC+HKihUKg/4Rfw17ApgZSiZX5ByR6kZVcNfUvxa3jyoqxPhYonNNSfVpuh
	8Fx4x7YfYx2Ju9elyFIP6XPLfRBkwFlE=
X-Gm-Gg: ASbGncvzz6ZT+P2T2v28qX3Qsvr1oSAc7SWCMaQ7VYFe47X9HUhj6c5gUAIVbNai8cv
	Nuk28wFKngRiFHYEi3YzB22UqITIclHCaBZgF6XP1KvGyjM4GZbL4rbUSDj2T6VZgZs/TkJw4L1
	pouGYJYaecNAkQwUj2xwLCBNE656s4syRTBZbfovyOl+KslzEGgGC6BZ54r164AZ8H06hk4dn8l
	gUH1xdE
X-Google-Smtp-Source: AGHT+IE/WXaua6RKOi/WAX3KVo1v0H9xO7q08cYpzfBxCPP6oZjWfbSc2Suex2cR80lZXzDPhQzSrImgMXwKnUbP1jQ=
X-Received: by 2002:a05:690c:388:b0:71a:730:12ac with SMTP id
 00721157ae682-71b7ed51fecmr124105307b3.15.1754347887683; Mon, 04 Aug 2025
 15:51:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SJ0PR19MB459028F515C43C5B91E662B4B223A@SJ0PR19MB4590.namprd19.prod.outlook.com>
 <CABPRKS8ja20chFQZmXTw2SOkzcMXMrust3HVu7Pq71ctuc9X4Q@mail.gmail.com>
In-Reply-To: <CABPRKS8ja20chFQZmXTw2SOkzcMXMrust3HVu7Pq71ctuc9X4Q@mail.gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 4 Aug 2025 15:50:02 -0700
X-Gm-Features: Ac12FXzx8ttehZsCHiq4fzBebyQ0hxZS3vb8KmWtNLa5W4lmKsrZmkO38WklxlM
Message-ID: <CABPRKS_Hh_LyLO_DjyERYdbbu4vVr5TOWAySQRJS543BAwLK1g@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix eq count mask error
To: "Lee, John" <John.Lee4@dell.com>
Cc: "justin.tee@broadcom.com" <justin.tee@broadcom.com>, 
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Thanks for reaching out through the upstream community.  This patch
> pertains to specifics better discussed in a different setting.  I will
> get in touch with you separately.

In general, the default settings in the lpfc_sli4.h file are what=E2=80=99s
recommended best practice for our adapters.  So, getting a feel of
Dell=E2=80=99s specific use case would help us understand the context for t=
his
patch.

Thanks,
Justin
