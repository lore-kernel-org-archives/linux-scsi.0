Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D76F14A60D;
	Mon,  6 Jan 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736181838; cv=none; b=jIkHtm9slOoc6Z8q2Kkgd09Wv5n8rncLZgkP6mTUeXSgK8UimX7LRfeZz0hCGNzAajTjj0N3aW60G7GE/A+2UVGLBXlUQOJ7gz6nVF/mjYcBH0dGf1o7Xy+GoUiN9QY2R2ws9V3EeDSsjaLKqgg/tm6hT3uqlpu12JRvwrxomkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736181838; c=relaxed/simple;
	bh=S/CLvRCWcm/JiF1LhSZaM9+53gJlg1qC8zehmChUU0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRlAoNvMBLkef7ejW0KZFVccZnh8qt2neJXmbKx3H1QZVodTStp0gcmXwRRSnPxG1ke7V21px6K0D7XZmnEEjGDhocFIsKzC9CAgj370CYd7aLRqOJIeOJw0M5DD6VMj4zxhcaPHqbWqOyjj5UuJqoGQGhq5O9FREpl0Ddg2LwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V68rJAnS; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V68rJAnS"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2163dc5155fso207209505ad.0;
        Mon, 06 Jan 2025 08:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736181836; x=1736786636; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kDfUiwJ69HFGrwdo3um2EhSGNvffCdQcuHSqZ0QeiY=;
        b=V68rJAnS4/tKsHDPvnQJvdotQRsnTF9mkL1n+R6hKKFp0s1eHZETQrr301yK+eaalU
         uUAZtSxFNcEpS+jy0P9++a0JYsKAGy/VrCb3Y8amBQC4vOLT7J1mGZ4R6MvJd01MMGYY
         38JoB4n1DpFJ0HMhEIqwbUj42qpXPZblq7qLxf+xbp9vuIkxxTXkTL6Vwx9NQERlfrRN
         83MCqDvXRSaOQk7qHQQW1yQDKlQLTbZKCZlmWYCsZURfldwhHSMJ8cSdlbMcJ0H2BrAu
         D/3Td9VbIQ+QO/qgQzw3dzK3JVGNJLXUZkHTn2pGQwSEhd5vNxgJWyhD1PvH/is7Xir2
         fYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736181836; x=1736786636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kDfUiwJ69HFGrwdo3um2EhSGNvffCdQcuHSqZ0QeiY=;
        b=rUlARSSyKFruzht4EVPJTXhnbGdLDMOZaX07JM9CgazANkA8ki9EVYoNSjqIFsUltR
         uuTxL2PMijZKGgwBvSTj9SD9Lkf1yE5xImWOplbl6ySB98c8iu+TbQY7bMhjT0SBt/ya
         mgZsdVGQd9UwDpCTpgWOdryB9vs8NSo91sJUiWiGtyfvwtt0fVwqdYV2fNOTCBt8C8q7
         91tmp4PvbwaNEg88lEHK7Z27Wma1DQYBJY16JpKbByXp2jkoMXILeolgVE7OwjFCvqbT
         mFFoHTT0sWdr9d43x0P2Sm7Wk9Tnlblkhn8I4bsj8u3pV0USRpXD3iWGWu7GsI+LrRX+
         S99A==
X-Forwarded-Encrypted: i=1; AJvYcCVdKVxY+OJYSgqwRQHnxrdFW3t6Bfcga9dHK+mlFEhfm7at+BNR0zusIROUJTxfdovzGi+NpJWfnwfgQA==@vger.kernel.org, AJvYcCXPhnBBftjxIMehEAyZOgqXvTwdLM9JjLAlbboxNV/nee/d/V14huTQ5kAis70d/tE0SEYoy2fEvX5bMU6Z@vger.kernel.org, AJvYcCXwXu+bzVcTVVHq4jMtN9rnfOzp5du1OxN4KuQweNzvsnmZHoi3PJArFmTp/KLgFdOTnirAzbvjXUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYCS8xsDbBUKTWzwsD+9Bkc1kEBjpQaO3bWZ5a6gyLklRaPEh+
	OeoP+qq1G3c2+DBhcX1nBQ42fmQeHSBkKdIS6CcMHPR2Gt8ygoO7
X-Gm-Gg: ASbGnct4uPchRKFC6SzddMeUZvffuGnKpv3fWrlEIybmhQcHPOWQt7vAkYkmb4Vu6Kf
	7ow6pFP8I7YLKy4iciW/0KmuIBgx8/7efvAVJLIEczuXozB3eVacuVt7DrHAOdhYHQxYJ42lyPv
	ydq6l9vVl3TdCOa6ROM7m9jgLQfWli0bniufbwvS9a6Wyy+ZBb9vhr4/grynLiKiLZ9nzHaRsPZ
	HVyvCQgS1oUWpkPUh4XjPAKrzjQnyKu0k3W4Q8TwrbuvusUGXNFUl597/2PMBxsdjmKxA==
X-Google-Smtp-Source: AGHT+IF2NffWhv2hyM8zq5AYyEuwsrGSgNfji84wzNeb8ixG8wYHK75igkuuY6T/6r66iOtFjw1EhQ==
X-Received: by 2002:a17:902:d488:b0:216:60a3:b3fd with SMTP id d9443c01a7336-219e6e8c5b9mr662315275ad.3.1736181835771;
        Mon, 06 Jan 2025 08:43:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962e0csm294813375ad.22.2025.01.06.08.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 08:43:54 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 6 Jan 2025 08:43:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Daniil Stas <daniil.stas@posteo.net>
Cc: linux-hwmon@vger.kernel.org, Chris Healy <cphealy@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] hwmon: drivetemp: Fix driver producing garbage data when
 SCSI errors occur
Message-ID: <89d05805-74e4-4cf4-97e3-4d25314be013@roeck-us.net>
References: <20250105213618.531691-1-daniil.stas@posteo.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250105213618.531691-1-daniil.stas@posteo.net>

On Sun, Jan 05, 2025 at 09:36:18PM +0000, Daniil Stas wrote:
> scsi_execute_cmd() function can return both negative (linux codes) and
> positive (scsi_cmnd result field) error codes.
> 
> Currently the driver just passes error codes of scsi_execute_cmd() to
> hwmon core, which is incorrect because hwmon only checks for negative
> error codes. This leads to hwmon reporting uninitialized data to
> userspace in case of SCSI errors (for example if the disk drive was
> disconnected).
> 
> This patch checks scsi_execute_cmd() output and returns -EIO if it's
> error code is positive.
> 

Applied.

Thanks,
Guenter
