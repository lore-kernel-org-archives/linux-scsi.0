Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3FC1E8826;
	Mon, 29 Dec 2025 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767022036; cv=none; b=t4cGbjF/OlwqQ0qwCvHY+omGhXLMCqxw6fEjubSpuYBYAQ/kWu2hWBhoXfxjuRzvc26aBhCI6kgBzfzGEudbImLako5qz6LU45rKuM+H98uoCshbRZZCf5cFUBEoPv2Kh/O5/Tugfs/CzOrarIdcLjTkt4UOyCutt54iLAZ0lEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767022036; c=relaxed/simple;
	bh=xHWn4AFuI31ZBp96VrHcuow34fKBdTgL0pW5boGoxms=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=S1/Wf+2MvIPMFPcfx2xkgJDEGhpYaRvyNIsqGO/SUiQPaq1fVEmfIVLtA+3Cfg9gIF8xngN0aEGTnGsUYDAxQWtU+wvWj25Ue21Jq0psiA69G5L95c1zMffpB2d22qopd5Fgke9ScdcqppbF72lygXFyzZIwASYeN70LdwOVa9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=UQpIHVAD; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="UQpIHVAD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767022026; x=1767626826; i=markus.elfring@web.de;
	bh=xHWn4AFuI31ZBp96VrHcuow34fKBdTgL0pW5boGoxms=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=UQpIHVADcR0t/hW2aSMZq1umM385UjQ30WimqhN8UgPSZoWSqh2yvP3NyKEa2il0
	 YYwfS9kSBwT7BAe/vX3aj/T1UPgrFGDG99ctD0eM0l0FBNBpeXRZflFcFc1dIHVtE
	 nR2SRGvxwvRj3SaDc76GGyb4fd0Doisn4r8A72fEF7FEaBlzcVaJWLxpzjP7Nkt43
	 cpn4PaMxVVV7INQBZ7sl13GQX7MY1sWMthDTVj/tDzmtRp73MfbPWJzsuWEMn/Irl
	 nObD5M5gCBdLWZZNtida9zzrYqyPKNP3TsNq0QL0A68MECcPc1+FY74zFAugLlEWW
	 0BNs3BvxR7WJMQR5ew==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.231]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M3V6G-1vZhBQ23rm-00AAri; Mon, 29
 Dec 2025 16:27:06 +0100
Message-ID: <89c72b9a-b23a-42a0-a4bb-31dfea448a1c@web.de>
Date: Mon, 29 Dec 2025 16:27:04 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, linux-scsi@vger.kernel.org,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <JBottomley@Parallels.com>
References: <20251223141547.1506688-1-lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] scsi: esas2r: fix a resource leak in esas2r_resume()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251223141547.1506688-1-lihaoxiang@isrc.iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:gEfiyNMAkVfpe2cdZMJhtlBabMWHXAMApiYWuGr7kwlvmzwMhGb
 MnesUyfqPUuVjxXNHMCeEMKzz7A826YvE0c415vUrgz3Bk4Cl/2i0N9m2gr2hJc9/ZVjtKn
 woASyXElh43LD7t2n5vhhdiSI5+xpJGLPBaMGm86kU0I/ecCoNEdOxNztNVkZlP4yT2g4Cb
 m3xfXsfIPloxj2mBp4gVw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mDcTHtCJt78=;G5PwenXWnN6HZIlq6l2KZ1++GMI
 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

> Add esas2r_unmap_regions() to release the resources
> allocated by esas2r_map_regions() in some error paths.

I would appreciate a better change description here.

Regards,
Markus
