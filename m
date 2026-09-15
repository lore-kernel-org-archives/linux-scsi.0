Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BB43C067
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789508304; cv=none; b=hYaL9EjtE8sBycf+1+mkbd9OoYNHVYF4xjLpFs1lGMBB0bS0koKn0aodwq4N9UM5jJyG+PHZMXZFxEKineq/3DoKH7/wHf6Uy4bZp2R3Yy5tYiZlqy/utBsMOZe1AIZdAkw4LJPTncDt6xtRBePLV8K9lWZ2NU4Z0nCmoYhPy+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789508304; c=relaxed/simple;
	bh=sRJdjMNq8iNjwpDIBmIuNCaQb8aJVuFJtpaL92IS5G4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGwlMKiZp3g8t1UtB2TsXkuDKdVU8UGDRGYH4j9HcRxpDq6DH+2luR/AcBfaFQJthZKXvV8yBsalw2V3yUkUwZz3lVrXNH6cSTEleBDYGmT/uE6/RVOXBmrN8zUZigZq7CItdwtv9avJ6mt5uw9KjO9N+2t/EBrKIuuFV0agKZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkPNjjH4; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkPNjjH4"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d8239so1836535e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 14:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789508301; x=1790113101; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sRJdjMNq8iNjwpDIBmIuNCaQb8aJVuFJtpaL92IS5G4=;
        b=NkPNjjH4ifWfKCLHhyBQYoFDXvaCxHl/snH+ZzcGXQ6PAaAw1xX15lzb6VHsNpp41H
         dui6RZiXwRY+bBwEg2uSJjGKVBv9Rnq6Y5AmbmWSbTLzZXMfzH0+sYTLGyqNdZoszVLh
         vaKGESyrKLTFjnq2S/2R2dPr/PLZt6UlvWX40qviv3X9NXhekJK0uXmWgbuuatiP0EMT
         MRCY8+cet5lm4t1akTdAWehW6R7blkp2Dfjh6UmFdX3bZCpv1jIsIdLnniE5dxA0R1OH
         uP+hSfgf4xbtymHXRsyRJTv3PWEqNRJU3X60PnX4xx6ViG6gEWgIPmw3vJnJDF2zTNxM
         9SnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789508301; x=1790113101;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sRJdjMNq8iNjwpDIBmIuNCaQb8aJVuFJtpaL92IS5G4=;
        b=x5+ZAXvLBo0lPRx3hLnZUhIinLriR+RcGmwwAJJw3yiOA5MKiKmQhRo2JGKqXrtoSn
         mVwEtOj+I1FJsJh7bbQCly06AT9/Bl/U9RZAOmH3wC0czPOhPAN+QW9olZCzdGmqgNB4
         iCHiG9q1mMGGozPcls2t3wlM2QRhTOS9zbXxYVJq69ZrYdgQIPbW94wqyVG5D43HD4GQ
         /xr3x1chuf63NKbShOfz/kIVcowUR5Q5t9eLfZvEa1v31/6f7r6gPE+Ll5vv4HvV6OEl
         d4qHYE+3+sE6I6Z8Y9huMjS/bgYfUdGOVFQ933GACykBeCKALS1v17MwvtTi3EkykeFT
         jzNg==
X-Forwarded-Encrypted: i=1; AKwUvByy1bmMe8Yy37ospO9n2vZ+2hIfzbTXonmTyPTvTNO0MM2mizI81M2XDPs+65Ci6JRZFkA3zaeKiPV9@vger.kernel.org
X-Gm-Message-State: AFuF++kyickw9kDoqflXOv6ZZ9y89FgZCSH+bykTcclAjNQ/nGmtk4T/
	ki9mSPCclZdjAzgJDZ91A+pkCXIvO5NB5FzLHuh/bX7R5azHkzg3FSG0
X-Gm-Gg: AYBFou3AgDQ0FTVJmQcvfmz9kjErN51y9becOXE4Ie0r3r5SfAkRoQ8aSks4KtP5Tc3
	HrxlWvUnp7tBd8ZZBSfd7/enr3+5c17aU3aJVhVxfEf/nYkSfBpXsLO7Abl9AeAoiViZE9Ts7Xf
	/56Aufqn89oyjwGmVjcMk9ruLm7MjTECEij0y3H2YSuhJ0C2qljtuEwCozIHmORxBvPu/gZEfDm
	LF3DLH11mEEIxDjk6/Js/jM+IXtAKM0StRS7oRYFsSvjd4A7rPmKF/84R9Yz2PV5tHHPSXdI7hR
	PCbASjJzjtCMw7YBNS7SK2GCGSD2FPo8dBhkNfk/erZQQcMMaVF8MmA9vYGWDkQVHiHnzFr9Trx
	1CNQMHIsukMH1VK2oQXnJjeM7sZPg+6U0w4qPSdn6hisgl/7FlRRFTozIYuqzFWelH2gbXB8Adw
	tRfYTi99wJSnawUK00pW0GEpIwwiR15duZDJ/xuyCA8wSk46BeEVodH5oHYZi9hLoBxG7bXagtC
	viQIZs0k6E=
X-Received: by 2002:a05:600c:c168:b0:496:c1f3:e8f8 with SMTP id 5b1f17b1804b1-49e7a662e89mr107381965e9.7.1789508301467;
        Tue, 15 Sep 2026 14:38:21 -0700 (PDT)
Received: from foxbook (bfh234.neoplus.adsl.tpnet.pl. [83.28.45.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm1927059f8f.20.2026.09.15.14.38.20
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 15 Sep 2026 14:38:21 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:38:18 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: djraszit <djraszit@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern
 <stern@rowland.harvard.edu>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] uas: JMS578 returns reproducibly incorrect data after
 host reboot
Message-ID: <20260915233818.5881ad97.michal.pecio@gmail.com>
In-Reply-To: <CAFKhL9eTD7DxtxMSMuUVP9cDG7Nq4jvrkTCjYfwr9puZfuC4Gg@mail.gmail.com>
References: <CAFKhL9eUM91rtywaz_7Mz+4mJH2b2csmOmc3+86ii3a0Ka3Q6g@mail.gmail.com>
	<c335085d-a824-4632-ad3a-c06715258c81@suse.com>
	<CAFKhL9f6aLZgerw_7bohbQWvzMxSfd-m-LFcuNP1_p1vWkN4=Q@mail.gmail.com>
	<1320caa3-85b5-47dc-aa2d-56d3b003c6ef@neukum.org>
	<CAFKhL9eTD7DxtxMSMuUVP9cDG7Nq4jvrkTCjYfwr9puZfuC4Gg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

This looks bizarre and it isn't even obvious which device to blame.
Have you tried any of these things?

Disconnect the USB cable and connect it back, without powering down
the disk or the Pi. Can this fix it? Can this break it when good?

In good state: disconnect, reboot the Pi, connect. Does this break?

In bad state: disconnect and connect it to another machine without
power cycling. Still broken?

Regards,
Michal

