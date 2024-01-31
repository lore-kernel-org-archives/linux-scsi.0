Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C0012FF6F
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706724974; cv=none; b=A45ENjY/2X7H0FtIkKZpfh5R52hkeSPCx4QnKnqnQAR74MKOGsktpZKOUrPNGmvFPU46Dzp9tBzeEviCfLcb0NcIQDjKXTy2E+7aX2o5bvJCewMsDx+Tlexsu0AnnHITH7QNyz6dmC8BdK1BR9nw1j//09ugW0VcGNKVJdAWnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706724974; c=relaxed/simple;
	bh=/mfGS9X1Fycipj1MsHNOiH5qZ7z+osYJL/vQLEyENj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iuuL1ZtJwX39oEmIfdeZLLYrVfDP3iMVO/ERy0hObATMZR2rkhQdsUOMTLLhCd6ewNM6zW3X9PyAkeOqBV0O0xK0eUpzCTqnfZ5lBTi5kHFww4WNTl1dVstA+EHfQyLd6kRT2B2V8xlaS1COz3m398tF4DKAkDHsdjbo1BQulTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T1YFQZmN; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T1YFQZmN"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-50eabbc3dccso7109e87.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706724970; x=1707329770; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FDo8R5256piwYk4oa+Bo0H2/lJ0uAashjVqOCdQYzwE=;
        b=T1YFQZmNc7c1Uj9uGkj7qeDWkTqAmqBzhu1SdGIXFK70VijUSsEQ+23d77uYMZ78B8
         pvxP0sYJuJnZOTuvbGiv6e2gaHZ9e4/theC+K/AtQQDcx7HkCq4lNrAz72Iwl69gy8Bh
         IO4Nc+VN9G1xHc5ALe2RcuqWuhneSRtv6w9lI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706724970; x=1707329770;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FDo8R5256piwYk4oa+Bo0H2/lJ0uAashjVqOCdQYzwE=;
        b=sZOgTyfDEFQZJmmiwEe3B+RDl64RxZgy/vKkRQqW+V5QpN8MbFcZzxytOfOGIrA5go
         VTwe2S8Mq2eG4OX7Ab/bE5GzXeEadF5oYz3ba/f13uFGYuWUViLZ7IxfoHfvMGUpc4wM
         MFvhruoa1aTtI1N0p8oOp2n+clw9JQu9u6yFz8pWFyIhM3KIJ1/J2L1n+GyaEyn0xzYb
         r8gLnCP6HFOhGNSMLfuEue452LU26qNQdKp3qE27qlSSpHjEgMYB0sF+gK5fxNa3UrWN
         Wl1wmXSIy3HPsTQAEAdqZzWFVbB0vGTaSSuk3lvoptW5W/yWAb+FMpWS2W8gkPjphoYh
         uhqg==
X-Gm-Message-State: AOJu0YwhKF8SYMfsIksSWamhqS1ePIXVs2SfYCj6Mx16sY6OU20uRpDO
	/rioGN9BwKv1FZK7qn7iTX3G7j1bNZBphVkYaVM0Cd8N+HJTiHWJ9fN11txvDQVzaINnY4HRsEh
	awU0=
X-Google-Smtp-Source: AGHT+IH5OoV14D236TW0H2PPx7yYtzYbWw4RgUO17kuAgTgUenhBiM56s5aNpEUBEsXfxkiC4bAvHA==
X-Received: by 2002:ac2:5547:0:b0:510:1364:7285 with SMTP id l7-20020ac25547000000b0051013647285mr208229lfk.40.1706724970607;
        Wed, 31 Jan 2024 10:16:10 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id m5-20020a195205000000b005112bbbce84sm28286lfb.36.2024.01.31.10.16.09
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:16:10 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2cf5917f049so1580061fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:16:09 -0800 (PST)
X-Received: by 2002:a2e:b165:0:b0:2d0:5dc4:4e30 with SMTP id
 a5-20020a2eb165000000b002d05dc44e30mr1825739ljm.21.1706724969503; Wed, 31 Jan
 2024 10:16:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c350958c01b9985e1f9bf9c041d1203eb8d82b19.camel@HansenPartnership.com>
In-Reply-To: <c350958c01b9985e1f9bf9c041d1203eb8d82b19.camel@HansenPartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Jan 2024 10:15:53 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi0GUPoBWr2HsKy2WhoJykadjCu1acH=qxQt23KYLJ_Ww@mail.gmail.com>
Message-ID: <CAHk-=wi0GUPoBWr2HsKy2WhoJykadjCu1acH=qxQt23KYLJ_Ww@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI fixes for 6.8-rc2
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 31 Jan 2024 at 06:12, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> 6 small fixes.  5 are obvious and in drivers the fifth is a core fix [..]

"Math is hard, let's go shopping"

Although I think even teen talk barbie could count past five.

               Linus
