Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA02026AE3;
	Sat, 18 May 2024 19:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716062083; cv=none; b=rZqlqRjlk7gXeNVapxznpicyGmfXfo6wzHwpxbCTAl3Z2dqxwXdfFL9txRnpaFHPog3ukPHwHa+8U0BJIDHUFpiA8pgppqxLKeV/f719rf1yFu7/ht/NUtN8N7oWceDzZ9QRO+H2xg3YlL9s8Rj8op7dBQs+BC53JQDDCr9HAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716062083; c=relaxed/simple;
	bh=SWo8HBI6w9jxtaq5Q7SajdN+RfCvDzxffUlu3MnUmgY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=pldjULgJPJFByBxHjF1CLdR1uXGzEDPrGvTqeAa+T98YsHHwAQQyskz6LG/K8INLpOcWS93GmJ9y0vle0Uohi2bUn2XkUcjE3V1UcGqNLta5vHLuUNULY7h3r9gDoveUa/VoAEAk7b09eGZ+OHztZCDs6v7EmNyVje2VKjswZ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=CPRVr7Ls; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="CPRVr7Ls"
Received: from fpc (unknown [5.228.116.47])
	by mail.ispras.ru (Postfix) with ESMTPSA id 8FB1F407851F;
	Sat, 18 May 2024 19:54:38 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8FB1F407851F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1716062078;
	bh=SWo8HBI6w9jxtaq5Q7SajdN+RfCvDzxffUlu3MnUmgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=CPRVr7LsfAb+LoPSFtuzaKmMAd6WhRWhYYtOL+znIW819orAyZ8JveeAmuLwMSmHR
	 soJd4rphAe/pvuFuJ+jz4tnEK4UPf55mvZKqCgC9ja5pD/Qs/UwT8cqhTtcB6cqF3/
	 7xfT9XQtkEUXuSMPaFY6Kcg1EuHA65TzdLnthaUg=
Date: Sat, 18 May 2024 22:54:34 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: syzbot <syzbot+93cdc797590ffc710918@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [scsi?] WARNING in sg_remove_sfp_usercontext
Message-ID: <20240518-36fac325699f8fecfd8da0fc-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <000000000000a6e0450614b960ac@google.com>

#syz fix: scsi: sg: Avoid race in error handling & drop bogus warn
