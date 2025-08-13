Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5549984E07
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 19:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755114521; cv=none; b=SULugICu0g0nyB1zEf6P6ZO93G/UB+eiIcdakFpB3doDro7HIxNlfd5gp9I5tukWivE2/N8Jzc99wZsuj0SPssarwGFzoz6j0mod3mqc4flxcWqcJDZzTK2rX1MGtOaDU+8Sqa9Ll4Qay/HXltYr8FENyZ+BsQbqhAfeB5c7KjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755114521; c=relaxed/simple;
	bh=ktTyyp53p8OO/IRzNzXJ6qDhVEZOmmamcNhq4D7Xuzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0+b8zTDgxt98P6Em408oeFVuu1o2WSAA23QqxedVhdR3EZpVpz71wWceHoxVGb30bHR+A2mQYkBIhHe47TQ5+Zuo/cehni2l/8z4zyI10XLQmpW0dm4vTbZxq/EDWopycppSAoauXMfIDXLCL5ZzRdWmD8kj+70uU1UclpKcSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Osc7jhl; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Osc7jhl"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-242d3be6484so1955ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 12:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755114519; x=1755719319; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eHRH42egAIusUuOasGn0w4ypr9ZLiLmXjaA1wfwgRnA=;
        b=0Osc7jhlfK9day5o20+flu0ZRvvlcahjM4+QTopZQWAjzn+HzVIF2ENLyrQmHWB38a
         vuBnanX4f1lvb/XZRuTsateNhJny+K6SXnp1M6BmgqHqgBU8WMizCQt31mEDmXh97zdd
         NQPVeCFPLdxMvkXqN1ELdO+BMoHBprClxq0PUPlCvXS1dwAhsF0PF06Rq/QaMeJJlPnr
         Ch09/PAuxBq/7n6K3Q7iyyPnWd7+BIY27Lxrcows2429BLVL60aNm49PJ9dWI77gHFwm
         1g2LcJKaZsvM38ngdFTlps20il+7sPaz2ZDx/l3YOb5J2dz8aPXjLfRs1yedBMXHidtW
         qb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755114519; x=1755719319;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHRH42egAIusUuOasGn0w4ypr9ZLiLmXjaA1wfwgRnA=;
        b=LXvPGHlloIf/cbveslwmjpKjdeD6BIbHSMsjTNMgXWczY+k9DqJifAiVjO7cUTYgnA
         XQczDalDcWF+JY6esXv3tJItoXmve1uNu/2vKoPA2S6qNxocedb7aajI5Qg8z1pu7SqZ
         e5kKFzMWvpRJyCU+oWWWrTs9HZqhokHMbDCqhx0HIo11J96dgsb8+5uVAMAAg+uZ/m3Z
         Z6X3uLe+Lv1Forwgw3el9FKe5GgJzP6+IAoQBG/3Sz3PrJDxbByDh+viUEDzkCGP1TZy
         v3MfPpww66KAKhFMHoNHxR3bEGJPPY63n6w8w1aaUH43vh8HuwkP4tF5keCMxx1ShcNA
         xyQA==
X-Forwarded-Encrypted: i=1; AJvYcCVjBNycUAkJXQi6APYMvfFWPP3wjycVlCuNKe1ox1fuS5ESG5FNH4ugZlsj598yEw4kkr+EjfEX6zQQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyzFgJR87ACvu4N3mI+/uirdjlNTNSc779pSIAITT//gh33Pjua
	oYkmTKrZ/BJUmGzApu7sNxc+3Y0z3UOSduwLYO+tqxMsGp/EKGqb8nRTWALL/z5ZxQ==
X-Gm-Gg: ASbGnctVfO0qqiAWTyTu7Pf2sAb72UqklvvQDrm3yeyEc2ScG9QnJjXz9kEcWD/X5s7
	/MYq4RO7XdsRir10UThcjTaDdFStoyUOuEF+SZ0JNWIf3FCwGh3Jb44ddsF6cZfAR74I8Pagjqd
	35B7KdvvmeL5eC/ZVKgt5w7oRndrL29+s++9U8V6ZxgcQrHb9y001KGQkSKI/cW6+4Z9rNL9LAY
	n7zivXcqk01YdCna2DI/eTCqhUUoMhfBbp23pL9JIgxC0/wJMNlG6WtiA8Nivz4/5Xc1/Nszy2p
	BkDa2gON2OKuwz/BgDbk1rONg1vy5L6lw6sB5GMRytOKJHFDHr6YKOVjfJFmLPYdDzMxrJIoxAu
	TcTqcd38hJYChkGUYCjYRP2VIePcbUsDSMv94xlCW/vtfHs190lIMd7BpLg==
X-Google-Smtp-Source: AGHT+IGQFGEz4g7f2uoTOjDxIvOIFeiRkZ1JJtxYG0+VT7rWci4vcCp/B4ZvMDM9051K5Ur/eokvsw==
X-Received: by 2002:a17:903:1252:b0:240:86b2:aee0 with SMTP id d9443c01a7336-2445941aadfmr85385ad.1.1755114519285;
        Wed, 13 Aug 2025 12:48:39 -0700 (PDT)
Received: from google.com (57.23.105.34.bc.googleusercontent.com. [34.105.23.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8976a1csm336189655ad.78.2025.08.13.12.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 12:48:38 -0700 (PDT)
Date: Wed, 13 Aug 2025 12:48:34 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Niklas Cassel <cassel@kernel.org>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5] scsi: pm80xx: Use pm80xx_get_local_phy_id() to
 access phy array
Message-ID: <aJzsEjufcl_0nJY_@google.com>
References: <20250813114107.916919-7-cassel@kernel.org>
 <20250813114107.916919-12-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813114107.916919-12-cassel@kernel.org>

On Wed, Aug 13, 2025 at 01:41:12PM +0200, Niklas Cassel wrote:
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
