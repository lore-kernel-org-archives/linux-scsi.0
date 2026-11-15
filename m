Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794757978;
	b=p6F+vxch1We3QjE/2GqwYV6Ph3yjOlONZf1/fibp3CkqoA/iX8kotQoJtup8aB0u32v5
	 ZQD+ZB06OAnJbESYmBCjpbVK+m0aE2dI3M5/pp6OBBHXW1cb/GZ24CC3C0NyH5Q5xl2IE
	 3gO4olAAGs8m3XjJs+wL+PdTu5IK2VMLqvQD5ofxojXTWPXgsU/x+umqwdk775v9o3shp
	 VuMXopMcnD+uZQmvz+oikIxNlxEgdkA9Bzp2nz2PyuxDSbP9zUVw9fsXXPvC810lqQiQh
	 Ge/ZRAKJP6jWR2fQ7EBmRw9Yv98P5ZrSfBFGXjiDll7rtQTG7a1Ud5qkFKcaxEQxc1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794757978;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=zYLg9CDhxj90tCxncwjOVnCz5bkJHfzwDw5ixcwSYAY=;
	b=POTWUu7qxuZCA2cLDYyAkSrGhymDEU3XAyfXwEiY+jPyxDKgUS6SqUvv+OcjGyMexlIJ
	 FlnpqlGrVUWySSdGA1DgmHtLle4QpzYvQNEz255F5vAa0EZus2cPSMyaVeahHhb8WCt6/
	 4lYocm62JI4Bq7DCiXM39eBjbvH9M7OSGXF/8Fo+Xk3bsdnsLKXaYUd38cUTdBS5XmCcs
	 2rR3aa/HrTLj2sO3vKP/gB2HrfglDBeQ1Jo8krSB69rRf6HkyO6MQkXc3mjBXtD3LVZgM
	 6pAMM+WiEJbxe/EghJxDG9RZ0BPd82PyO2d2AX6dXZe7lTnOZSSZvioCHxhYI7/tZPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rowland.harvard.edu;
	spf=fail smtp.mailfrom=g.harvard.edu;
	dkim=pass header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=rdlVdlY9;
	arc=none smtp.remote-ip=209.85.222.173
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC9606A31D
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 15:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCEC9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=rdlVdlY9
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9495d543b91so102183485a.0
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 07:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1794757977; x=1795362777; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zYLg9CDhxj90tCxncwjOVnCz5bkJHfzwDw5ixcwSYAY=;
        b=rdlVdlY9zP8I5QcooO08a+w2q8HrBN2sNX3xECK2d+eML/sd8Zkn48dk9ZCC/IcWQT
         ER71faOAqY3oRAmrF+dwHSqz2bJtmOiZ1t3IeLlN9U/KJWP2ZUqCFSUtAU4bkZOACKyD
         3/ezPyBoMo2gmXrrMoNCMPaCXieQbH4Zuo26ev7oP4AfbpSwDQnnBsFOqAlhdAVcqDlr
         /WTrhv34lU+FmEcw7nCcr7TmHmTkty47Xq3euFu9M3akOFgdJ9qb1v3zdyiKFdkIAtXe
         ydJN/oR2QjSzMGDJmVcfSTeT2V6jqSA90xz5ZleQ1LMy9ACXbwC9GezebVKpZMYKfK1a
         O/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794757977; x=1795362777;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zYLg9CDhxj90tCxncwjOVnCz5bkJHfzwDw5ixcwSYAY=;
        b=czkxJqcIqU5lW1+6qCHvhYZcHxOhNdj5UCfjCQerjHjnfnBV7FaCrildnigBCtwcLG
         6vwDbaoNxNrLEtzh7PU3c4BnKpz5LfWW4TInt4WnMHLPqfM/FEAJyMPYdwuEcu5adUF+
         yS6Itm67GCNLKrwNXgoVqB8eo5gAdtJSTEdo4xUjBeXeLZMupkXR0XHTzLtY9SRP2M3K
         JgcZTD96CpriBxZtDnsBi8WKlj5QCKp17Qy9RgEA2W7Zr06bc08OHgPpRkLK6eCxzZkn
         /SJBQ0W9tiWAN6tb0XPcrPTp4Ny2/5wDmQ6UpxfTTxGjta8gxzstTqM6dWCKg4PiY+ri
         7XnQ==
X-Forwarded-Encrypted: i=1; AL+hErEVuwsNRS/VzollzW2+XSJDxxltCO/Os41rh1dIcqNjFwe/t9aRU1H7PZmhP1exU7p5dzBO+uP2gEMY@vger.kernel.org
X-Gm-Message-State: APuU4Z+C/0o+8fqB1RU20GL6uAx28BTk2ZFidL9iFijxmzjSKn2JXIYc
	oZNEZmf97AZorexmCF1EyE5qVtuoObNaGuv3wcunMpu4GUd99BbAMBDhtHoAv7ZKBmgkZ0Zdvtk
	lXFU=
X-Gm-Gg: AYBFou1e4n7H64+5fyxNZK9o3mW6OCe4lQoCFtxuts8Tk51/MZInR3lnr5/srNW8nR8
	9BMD+NFsT+F1NUYOFCS/FhGmIL3FYF97AQdPVWB9SQ4Wk5hcGM3FmoaBWYHPSQWho6dy2GOL6Ig
	cE4DrMyuBy80TXC4iqWmVskmCEjaEnZl0ecj9uwGLu0yhkWrEAogGVn1wU6DAgHxNw5/yFNHxiq
	30QduVwS3n3+Q1/tef1PlnbP5pU5pvt76V+Kj7qD0+Zn0+kg9vByBmWl/RgpAKd0SXWHkjidAzO
	/ts720cm+xgmWfCmDoVPA19N0gIURXhLZTLCpx9Av/6RqZdCNuwifaWP2ukRZMBT3lVkw7E+m0R
	SUipwrvUzL+X/s3UmGGUkLT5FFfVXTvVWKMyDbqhwJt4ADIpgaxKeX04kX+6NkMwnDnVFFd1Rok
	ssAao/VXeEWaLWrYzGFBdtLgwq76P4zgoyOqcy3FtQhvo63olqe67Prrh7WctQJvpl7qL5O6en7
	Q33juidXHSRAc88aoOuO/86lQlY1GxaZ9pGGeCm8mp5EJo6o3AslLWbaM23YHMCQ//GW+cOGne2
	mxRatYDFoQnkc9MNQlJTvhfex/rzh2w=
X-Received: by 2002:a05:620a:2994:b0:949:7069:3faa with SMTP id af79cd13be357-949706943e3mr449902385a.4.1794757976522;
        Sun, 15 Nov 2026 07:52:56 -0800 (PST)
Received: from rowland.harvard.edu ([2601:19b:d00:161a::d398])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db8d26sm66871726d6.43.2026.11.15.07.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 07:52:55 -0800 (PST)
Date: Sun, 15 Nov 2026 10:52:53 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc: Oliver Neukum <oneukum@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
	smartmontools-support@listi.jpberlin.de,
	Christian Franke <Christian.Franke@t-online.de>
Subject: Re: [PATCH] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 deny_ata_passthrough
Message-ID: <1e731b43-93ad-4230-833a-df6949c7d4c6@rowland.harvard.edu>
References: <20261115124046.5286-1-mat.jonczyk@o2.pl>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261115124046.5286-1-mat.jonczyk@o2.pl>

On Sun, Nov 15, 2026 at 01:40:46PM +0100, Mateusz Jończyk wrote:
> The uas driver blocks access to ATA passthrough commands for some
> devices it considers buggy (via the US_FL_NO_ATA_1X flag in
> unusual_uas.h and uas_detect.h). However, it does not expose any
> meaningful information whether the command was blocked by the driver or
> is genuinly not supported by the hardware. This creates a problem for
> the smartmontools program and makes it difficult for it to provide a
> useful error message (with instructions to disable UAS on the drive to
> get SMART readings).
> 
> So, expose the information in sysfs as deny_ata_passthrough. Other
> quirks may be added in the future if there is any demand.
> 
> Link: https://www.smartmontools.org/wiki/SAT-with-UAS-Linux
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>

Why was this change made to uas but not to usb-storage?  Was it because 
some devices can handle ATA passthrough commands over the Bulk-Only 
transport but not over the UAS transport?  Note that the 
US_FL_NO_ATA_1X flag applies to both transports.

Alan Stern
