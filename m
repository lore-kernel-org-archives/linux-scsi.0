Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA92286417
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 17:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123344; cv=none; b=AJf0jah0kiCc0LLpmmrx6Pk+kCBHuXnJOn5hf3NCOD5CdikRjuIMCnnSHUwY+HmRG9BfD6/jEOt4P3dwL4sox8s6a2ux0//1z6FtY0eKBkqQmHxmFBrQMplTxgwrnfGeWsDJqt+CYEcyyDclpqgA5S8S3jn0fx9xObuunGBCmFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123344; c=relaxed/simple;
	bh=gofxanE+/kIuw40mG1qX/TpGESQ5g7FxX46dxG7tlxg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=MKYOrBEOIWrIk9S8ruq6pUUfDDHot8rS/eJB7KMsoPw0FJW9adKGlig/zioLUMoCNHcWoM5FBAw7Y7FUW+HrlNgC9tNobHRdLlXBD8sVF9ZFxGVOQ3OMWI3gOpeYuaRqG2+TGs2eDQSW1kFQBkKA+pvZmvaCa6CdaZ+qxZE3xFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXMJ+sS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXMJ+sS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB771F000E9;
	Fri,  7 Aug 2026 17:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786123343;
	bh=aYJF4EOwT0mK8aHgSb81odq/KaGBEjA3oSTN2y69ofU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=RXMJ+sS1FxOql5sN1Z1QeA2qkQYS24xu4NXQoUlZJrGtZc8ir9Aa9DHgMoR3QYOtB
	 jb8mMDAAwtPWgckRUXOT4C2PtgclXLasmfmUch//jtA3XxFN/Af/9kA/da794Aqc+O
	 Lf7GHrSRA21PJAt0Jd1rC1AsvknECPVQapkdlKVBitxdg9CxOuQhNiFuCaIz4Kn2+R
	 kcY+E7kaAi9kfy03cVsYGr0VO2iscA/sd0CXr5zvF/ZHtoUCgHT7BuhrB8XLconFpU
	 AxgMVdD66hlxx/V+yYrHaMdWWx1QhzjIv1b/UR6Pmhd2BPWzNokxzdCJRd66DkrzTs
	 ZThYZeUD14VFA==
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
  dlemoal@kernel.org,  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/3] scsi: sd: fix probe error cleanup, special_vec
 leak and sd_done() sense gate
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260707030333.22245-1-yangxiuwei@kylinos.cn> (Yang Xiuwei's
	message of "Tue, 7 Jul 2026 11:03:30 +0800")
Message-ID: <yq1ecg93kyj.fsf@mail.kernel.org>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
Date: Fri, 07 Aug 2026 13:22:21 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Yang,

> This series fixes three resource-handling bugs in drivers/scsi/sd.c:
> sd_probe() error cleanup, special_vec mempool leak on prep failure, and
> sd_done() sense handling.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
