Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE53C1F4714;
	Sun,  2 Feb 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738504609; cv=none; b=ENFdfW4VeDwqYJn9EERVJ3SeX/MYHzvdTpC9uxXnt2JWvU5bLmP7AzcoQRnQXEJxXeXUn90Bh19m/WOlhhamMdKt/esIB/ndB2eI+jgnDhkp3AZBH3U+ygXdufVYhynrg/pWYpjO71h2r/F8XqTeMzkpkRLsLFrdzpf6C1prvsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738504609; c=relaxed/simple;
	bh=GHtraLoVnc527Ri9N9ZFXy+zn58gDFxOrLai5V6sMkM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=TqnfYi9YjPhso6tWXp8CcOYO8y6NWLiTN/Dvrfg717XopJj7+ps0tmIbh4v/dyg7wsO9T0SvKHwh8xHuI5Z07f9nlvdkEAFwOWJ72iT932IjmQWMzHQh1z212bmSdfKyGMBERFtO27HN59lvjNpxbYHMq0ozEbNExA/gYxB2VfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=J1QnPkJu; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="J1QnPkJu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738504594; x=1739109394; i=markus.elfring@web.de;
	bh=GHtraLoVnc527Ri9N9ZFXy+zn58gDFxOrLai5V6sMkM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=J1QnPkJuN2B5/N7HAq5rvz/hFXA3H3VjjRYDLQ08AvGr0xzZGGp7yYXk5NgmUnUP
	 czxSNU8y+lMmJmpYCZuBm7PcgjdDJizHQGg+QNpwpUG0GlOC79tXqQAsv+Gvrcx0I
	 GKxUfRv0oM0pUu93wtVKSEbXkfzwGwwG8pryQFhK4bFA97vHQBE/6HmCMtIWKGALO
	 +wTOGAuWETT/dwVUcTI2t1Z0d2Z2CD3fv1SgQ7bEWzktyiiGVxVIu1d6FsQXq/UMb
	 O7hnex32BN5nP4DHg7LSuZydn2DZ9GFrmWS06eR5Wt6livi3JPJhawAK9EKPkMtsZ
	 DbU5dOCwhyUh0t0v3g==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.26]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M9IOj-1tYFbJ0sHX-003RUp; Sun, 02
 Feb 2025 14:56:34 +0100
Message-ID: <5b946d09-f67c-4a49-bba7-d73a549969b6@web.de>
Date: Sun, 2 Feb 2025 14:56:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Kohei Enju <enjuk@amazon.com>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Cc: Kohei Enju <kohei.enju@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <20250202090208.26890-1-enjuk@amazon.com>
Subject: Re: [PATCH] scsi: target: remove unnecessary null checking for bio
 allocation
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250202090208.26890-1-enjuk@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:EZO/Y2yxPleJzlRxo72cMcXLVehajPgNHb/bRt6kGv10UK7R2b2
 DVyEAhuNWD3BL1UKTUNfxZmEaTQpPhHZCEDMH5sOZ1pRhHhouaDydEuguBIgvhFdVsyw+rB
 liHACz91m1l87GepSLs0BN3lwuDWw5fZKnsKwS57ikcIZ3/aDQaaWwd7pZ131GukFy9Idq/
 cw2lUPG0FfBA+bI7/XcIw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SEMLvc8w+qo=;7y15rwq3EV3D475Svb+RztfCDWP
 wBnIXuugC7tJMFY3hlCQ7yY2RCSdAZXfmwVZ55oZ9q27OdCU/T4WrUrn/qxpEwzHwIfEwR/nX
 kNhEQ3h5PFIatRu9dG9vkxE6jOt7oM+RjNFt1VfMm03oiYXXBDB/AKcQikz2sFD1mtxckyqi+
 dTmunQM5szTxbT1H001WXELhV/ktbHaxa9yNTsBHXdmaa+6vGs4sAZ33aTTfS/V45zGiUGniC
 wHAxKe+DCM9BTl8ah991GrxOKqG1hXFDdnJkVfeDxfmvkshlx+Mqoq5pB6WmdwcTNBnzKebXx
 kHgqLDyzsqTl4x2SO7l/zQ63orVeRvUsUJwdxVb05abWMLUvdwiQvrULRzeTMu3dGvZJ9AKyZ
 5fFb58MXw7OUyCRkphZE06mq8m/xM55POyO5qr8074GJHaEIwWMW7obEFClN5uIarLgjFrQZJ
 IaUScMrdk9yGvaxVSKnoNask4O4Qn4cG7FgQwwhAeA/Lp4Mmwc+JMrtD/aL71A8HdPqcr95H0
 w+/qTtctamSoqH+v5j/gIi+67LQvbmjBzlNOO3P/R8Z16U85aIaiKXtoLuEEcakM3rWd1F85W
 IkZsgOQ5Q9w/EnpiJl49oW3UDbjKuxf/WGXNOVblluyImLWy0hCl2v+70TtGIqWTcrZuOUasX
 VMfpNXkuRS5xBz6Tq2aeDqsvfrMpEb7bGDUJJ5gLwpYp1matjATTqd+zGO0vkp43b6BewDejH
 Ym/FmO52t7Kai2FwdcGDQznZJptZcR70cdzIg0vPNCI9M2K9JP4OHMBSLNG7ogbJV49GcTO/m
 sDZbxjfPMSfzaaysGZu2gJqQwUXDbQ//9Yv/BBcRF588SmTAagccPZf+i+R56d0eddk/4LxYa
 AuQAeDYIedn09ddCCmn0h85dcwuj7k8nLAqQs64MvXo/bsWByexNNkf0h6foNG8aSaLrcTakv
 1DKResIclVJpP/sNpWkebYXRqiry3kZVI/YODL0nrbK25BR4rPp8Nvijxcg0Nnh9x3rkgEZZl
 lT81gyWoTRdJhR/hQskBbSzD6YA0mP+n9SFtQKPO1WSyFK7Cop1tUheOepeLbTIpqdt1sywhu
 sPxFcWAvZjZI/n6bWRBsZ+Me3qSzIiFlLKbZSQOScI0qT1OEisuFZWDgr2h874ZZXzKdv6xOE
 lKgz+9ZAq9MuSfm1Sw5C8KY9abt0Uh9587vkHDlDjoWH265Z+KLhalMBcL4+dV5oS4VK9nnNw
 iKjk1GYfY4J8YnhxXRRtXcvLfPL2XXBIWcxXCzUpogEVX9WrkYHmWFqEFan5+bcL40L1Sj+XZ
 bpg+kmKgz2Ibzz80melIONAfvv2MEaPpLzLNFkRTPYx0zSy2x81AQ1pA+Ein5+16DwY

> When __GFP_DIRECT_RECLAIM (included in GFP_NOIO) is specified,
> bio_alloc_bioset() never fails to allocate a bio. For more details, see
> the comment in bio_alloc_bioset() in block/bio.c

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.13#n94


Can a blank line be also omitted together with the mentioned compound statement?

Regards,
Markus
