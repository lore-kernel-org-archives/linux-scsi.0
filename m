Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97B83C0A03
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 02:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789871661; cv=none; b=iMdVcFs96lZJe2sX6Z6OFTHhw12CNoNd7EHGVPfUrAbLTvZC/OcIcVHeMg9DkvMs/w1Fz95JdgsHWOSMh4k1aJQ/cA6R1VWCPj/OLdDrWFuMDELZf5Sd0BlZR4tAonrkZv7fH7M5m8AxBeAf8u5dZONawK7TlUv11nVx6EZ2hPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789871661; c=relaxed/simple;
	bh=Fzgv+nvZ+4+OGBtA0LANbeAB7bkAOU+2uKJwOc/JXL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyxlLOAM7rqjNgUgDDwM7d85FbDNcPQreEyfAdK+bDQAYy32q4ypAP5CCSmRvDvfOxdP9GmNrT0qFpx6jDYWfwsRfub7dysh8BJxpLHFgA2NXsn8tsZ6HcvB/2gQaKEoqneDBMZHtEAke7X9QyS4gzFWZ4ar/CBw7x+E7si44m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=uEoy4IBz; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="uEoy4IBz"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93a222edc62so216175585a.0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 19:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1789871658; x=1790476458; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LkCkftG+yeHdNoHYIJ4SF/P+dVcP8n47VYh5wG/1Abs=;
        b=uEoy4IBzhuOOcFJKEJB5oY7lk/BEarXflY7iQpbDOG8T4nnrFchMkrmyfA7cV0Wkl3
         UcoCZLUZs6oSmHWQ7Dw9rK5NmrjPe/4VzjUSHTcz6umGw+e6+q/4jj5tKg/x6pXMYfvO
         FceKW/m7R67O6avLBzS761jrAvp+ZwkgFkyAtl0d7uUdjroKoTMz8s6vqLOQddMUZ5fa
         7HirufBVRee+mkBaS8rGTQPJsaZ+0qi+subfYziDZGaT7XepXnL9VtLl1O3ECNriwEV+
         5tTonx3E7+A5a6koR4++isCwgrGVWMLN4L/TnN1Epfmk2gO5hYKlXV2kq5PX6OXj0ZJn
         aTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871658; x=1790476458;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LkCkftG+yeHdNoHYIJ4SF/P+dVcP8n47VYh5wG/1Abs=;
        b=ziK377mp/mPuY6eo7i4+affUTRbNYe/YU8Xa5gBIvWycRob6OTwKnQNv6Y57BAq1ur
         1420So4Vxm1/OhEgy6YYLhZGdk+DWgCQ5aMY3boMT8uwky5zS2y6PX2kMOFLBfiwQjqZ
         DuQE2A4+HcWw4LecihiJlCBRdMQYodGpp19OIYvSUtQydRtgaaxI5vpeOkB2eJMSAY4e
         79LeqFxMnnZyf5I2dQLAdt+RpOg/lm2A4q/VK4KYYGOJQwmjxUfwxl6wWsYnjRnZoDWa
         JAhp1IUnnCjx0VMs4eulry3o6P/W0o4h4w3yOLRY0mtLJqppYmB8zSwMcags0RnhPqgc
         4Rzg==
X-Forwarded-Encrypted: i=1; AKwUvBw+07n3XD43dw91NT8PqahchnIgwT2QxvwWsHtv1z32MTEv92i3e+7fnzszoiUlqcUiNZfEcFN7PS7/@vger.kernel.org
X-Gm-Message-State: AFuF++nfZ15TLFsY/0GwgM0LsVs32JUVhF0pyz/s3cWqI2VBsLdNCdQ/
	ksQS+/bsvub7zXxUYFgkLQAD6GR1flkUj+L6K5CAzjggPG1FVYe+bTc90jVHrcaCew==
X-Gm-Gg: AYBFou0n3MmrQEMN2klm2Q/q9hPlWIXay/zLxEb+DYkV4N9lJ3tyuc1XKY57XvFIXtN
	a1xMelytzfwiML2pxwmNaoAW+DZO6vXFkiqunN0PGq8eSYAxD0SyZPYHl3zCaEN28RTH84g5PrC
	SIkSxplPrfH1ljJ/DNppFFa7ap4M8Mr0A1o/xKuBJRs29tWSVbvsnXThPKPBlh47Cd4MHUuTwJh
	IZwZxpXUgKYYCE8+MsJUPAd7mJFUKBLY/RutAG2it7rK7iWgbidhmYZ7FFl0M+kR1F+Cuidz8TE
	vjgSZVrXoLPRFk2p27CLbLe7ye2PolNArkpEeR2TdxkTOUzTMGP90SkL9R1I19jTRwtvHE7nV6A
	7PRPs3foVob5yLLBjoNd58yroarPTGLaqG4o+5w9MCSTsmtT9mvnk2Bbpl7c+XoZRq6643dxc5X
	jt5ey0vGykGa7xJ/N4M5/TOJmNVUof7SC7yN18sbEj56K284bWisSO47vE6uvpusXBya9T7WTh
X-Received: by 2002:a05:620a:43a7:b0:939:6de6:9516 with SMTP id af79cd13be357-93bf571799cmr418996885a.45.1789871658556;
        Sat, 19 Sep 2026 19:34:18 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::7544])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedaef96csm316488585a.29.2026.09.19.19.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:34:18 -0700 (PDT)
Date: Sat, 19 Sep 2026 22:34:15 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Oliver Neukum <oneukum@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] usb: uas: quiesce SCSI before stopping endpoints on
 driver unbind
Message-ID: <98374a38-eb18-44c7-8da4-d5e34944e72f@rowland.harvard.edu>
References: <20260920012358.3362053-1-lijiayi@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920012358.3362053-1-lijiayi@kylinos.cn>

On Sun, Sep 20, 2026 at 09:23:58AM +0800, Jiayi Li wrote:
> What this patch does:
> 
>   - set soft_unbind so endpoints remain available during driver-only
>     unbind;
>   - cancel pending scanning before removing the SCSI host;
>   - for driver-only unbind, remove the SCSI host before setting resetting,
>     killing the anchored URBs and freeing streams;
>   - for physical disconnect, retain the existing kill-first order because
>     the endpoints are no longer usable.
> 
> This follows the broad ordering used by usb-storage, which sets
> soft_unbind and removes its SCSI host before releasing transport
> resources.

> Open questions for RFC discussion:
> 
> The change above fixes the reproduced failure, but it is not clear whether
> this is the best way to handle driver-only unbind in uas.
> 
>   1. Is enabling soft_unbind and moving scsi_remove_host() ahead of URB
>      teardown acceptable for driver-only unbind?

Not speaking for the uas maintainers, I should think it is both 
acceptable and necessary for any USB mass-storage driver.

>   2. Is there a more appropriate way to quiesce SCSI commands and UAS
>      streams before endpoint teardown?

Not that I know of.  If you don't tell it to remove the host, the SCSI 
subsystem will simply continue to try sending commands to the driver.

>   3. If this ordering is acceptable, does the driver-only unbind path need
>      a bounded fallback when scsi_remove_host() encounters a nonresponsive
>      device or ongoing SCSI error handling?

In general, a class driver like uas shouldn't care whether an unbind is 
what you call "driver-only".  It should take the same steps whether it 
can communicate with the device or not.  (Note that the patch's test for 
USB_STATE_NOTATTACHED isn't fully reliable -- there is a window after a 
device is unplugged before the state gets updated.)

But to answer your question: No.  Rely on the SCSI subsystem to handle 
its own host removal properly.  If, in your opinion, it's not doing a 
good job then you can submit patches to the SCSI maintainers to improve 
the situation.

Alan Stern
