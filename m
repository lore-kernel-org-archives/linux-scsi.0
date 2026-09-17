Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEC0346E55;
	Thu, 17 Sep 2026 02:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612124; cv=none; b=XAut82gAboDStxPr4r+/lSwwhqiVx/WGLjC/qzqjx38Q7RiEIyXiwi5dOTK8+YUpoovaijd/RjP1bC97UIbQveoyBgJKkDA9aIloZOi3STP64MBPFz4HCTpPbti7t1B3gvYEy5JNh39+MltrZqRYtwJ+4fDnzK8tlrmW+I8GNso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612124; c=relaxed/simple;
	bh=HComf7gzNaosTCfD07NE/EWO4aHAsDApiPffbVxYe2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CIv56/nB0ZoXQtlETGbjXbCxUme6hRQ9GZKygfya8gU5YwrWziwrI1Wms8Ery6uDIfvwcwVwOkPoJZL4MpwY4UEWM9Cc2r5kkBGdkT3vB02KtE3odXEKyaTClCLdBhkfwaeMa/rkxa9Fwn/iMwkHgJolo0f5+Sc0qyr4vBWoV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtxrqimA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtxrqimA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DE51F00899;
	Thu, 17 Sep 2026 02:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612112;
	bh=I2sJPx04Oh40Lr8y1341A7zhQ8JBun1t07vqhWLMmqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtxrqimAfD5tKiD7lzs58qiQTOXO+AHGX+Y5hQ+iR0i99D73uw5xfuF29OSZV94bN
	 ew10FmmH3Ruje2qSD82P/RnFlzBmCboumZvru6Y3ag9yWKLaNCOLwJwxsNHoDuDG2A
	 EV19rOFmBYViE2QHz7pxtjIArwXYWFWp4FTZnksDhTus0AIU67bzZO1LC01g0QTTsg
	 Xs2YdIwvuHzYACtb/8p1qRsqZqMnqR6J4f2/Rse3KnSDDb6eFYRbWOFrpybWNrkyqy
	 mx+f2mbehRdSSsJcLCsfH2LpVVS5/H2gfdPGmhoaSN11SIk2IZbs7jr1423b1RHKD/
	 gfkE0hGZFQyZQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Dongdong Hao <doubled@leap-io-kernel.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: leapraid: avoid -Wformat-security warning
Date: Wed, 16 Sep 2026 22:28:14 -0400
Message-ID: <178961190602.3672510.1766179045058667969.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915202134.3534708-1-arnd@kernel.org>
References: <20260915202134.3534708-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 15 Sep 2026 22:20:59 +0200, Arnd Bergmann wrote:

> When extra warnings are enabled, the alloc_ordered_workqueue() function
> cannot be called with a variable name for the format string:
> 
> drivers/scsi/leapraid/leapraid_os.c: In function 'leapraid_probe':
> drivers/scsi/leapraid/leapraid_os.c:2062:58: error: format not a string literal and no format arguments [-Werror=format-security]
>  2062 |                 alloc_ordered_workqueue(adapter->fw_evt_s.fw_evt_name, 0);
>       |                                         ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: leapraid: avoid -Wformat-security warning
      https://git.kernel.org/mkp/scsi/c/278210c60c6f

-- 
Martin K. Petersen
