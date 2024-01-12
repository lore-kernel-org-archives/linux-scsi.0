Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC2814A80
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VACd8jId"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5585fe04266so3532438a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 10:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705084515; x=1705689315; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DVuPEd45J8g9I3ZNEDA/EaMu/i6TqrreTASAObU9uDI=;
        b=VACd8jIdbUDiw/9EAJEouZaIgQ9qSFPq36Bg3JECc8DmOCU5PFSzSn/dihVEYHfkly
         NhIwgmWWcx9KolBCxvKBdJnNR2tIjW81fVr3uhUZEvezKHpGHt/3TKmqXNzY6E85xfzr
         eaPIg7LBXtIXq/leahx0D3RgowGDxA/BwiDgY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705084515; x=1705689315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DVuPEd45J8g9I3ZNEDA/EaMu/i6TqrreTASAObU9uDI=;
        b=dtCpEtqO/8RbCFqWxgvGHABodrf/dMO7TO2WImUbIB+dJx5mcrUBx4YlWP1wfIJEl6
         hNhQqmRqhKNRryQu0HyTCCaiEfFoUqI0DbXs4dNzxw60v5xcpOqdrWbwbSC/D43CSrBg
         0UBL1yW+L7Di3XhSctdbW76/lrkjHblMwqit0eLztvAVmHGlnA154W7o7qiLFvmYdPbm
         qJu5OpNzqm8uY4nhzNFStFo+xzKIpLNhqYY3pIa6TUGITNklZx5eEcejhRgZ8TTInctP
         8ihphnLNeh2O7QrZyS8tOn7x15k4A6N7gvbQzEVM12VkN2eI0Un67DMMaNDeigg4pNDO
         DHoQ==
X-Gm-Message-State: AOJu0YwbUxUBREsWevlmW+ARFwIp/TzRc+rBKmlyAwBOFHp993ItgV5k
	fNJCupD/vyxx46mfKB3lgRuk1+MrB3ahf5HfgiB0sYorzRd8PV4u
X-Google-Smtp-Source: AGHT+IFDPSL/pqFbgHZHlJ1zJyX2UpKJE9hdg5eDT1Exc+o3+rjM6AHzzXJW4NOSDGWtqL2xXZYJcg==
X-Received: by 2002:a17:906:9c87:b0:a28:fab0:a818 with SMTP id fj7-20020a1709069c8700b00a28fab0a818mr935799ejc.16.1705084515140;
        Fri, 12 Jan 2024 10:35:15 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id k25-20020a170906a39900b00a27a25afaf2sm2054685ejz.98.2024.01.12.10.35.14
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jan 2024 10:35:14 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-555f581aed9so7891592a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jan 2024 10:35:14 -0800 (PST)
X-Received: by 2002:a17:907:9247:b0:a2b:2bda:b501 with SMTP id
 kb7-20020a170907924700b00a2b2bdab501mr632927ejb.140.1705084514097; Fri, 12
 Jan 2024 10:35:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c5ac3166f35bac3a618b126dabadaddc11c8512d.camel@HansenPartnership.com>
 <CAHk-=whKVgb27o3+jhSRzuZdpjWJiAvxeO8faMjHpb-asONE1g@mail.gmail.com>
 <CAHk-=wiHCkxrMCOL+rSGuPxUoX0_GSMLjgs9v5NJg6okxc1NLw@mail.gmail.com>
 <255e3328bd48c23fbaae0be6d927820d36e14404.camel@HansenPartnership.com>
 <CAHk-=wi6PenRqDCuumMK_5+_gU+JdUqrBEDS-XwFiaNdVRZAHA@mail.gmail.com> <20240112-steadfast-eager-porcupine-2c9b3a@lemur>
In-Reply-To: <20240112-steadfast-eager-porcupine-2c9b3a@lemur>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Jan 2024 10:34:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgvK8p7-Knxdy9WTN6RB4tczbcRvuzQ3jwE_RYBc+nGmA@mail.gmail.com>
Message-ID: <CAHk-=wgvK8p7-Knxdy9WTN6RB4tczbcRvuzQ3jwE_RYBc+nGmA@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 6.7+ merge window
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Jan 2024 at 06:27, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> I'm piping up just because I know how to get the output you want

Oh, I know how to get the output - I can read a man-page.

I'm just saying that the default output is unbelievably bad, and
subkeys are really atrocious from a usability standpoint, with
expiration making things even worse.

And being bad from a usability standpoint here is in the context of
gpg. That's a very low bar to begin with.

               Linus
