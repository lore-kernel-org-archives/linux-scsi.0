Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223ED3C8C62;
	Wed, 19 Aug 2026 06:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122516; cv=none; b=az2tHOCIw24F/pYKe7zClqnfAd69aoyHMMSFLD3GoRGkRQ2P77/VJiZF/TFku79gq40jiz3+Ce/XJmIntuixJNXohQ6UJrQZcs/AOtLwXjd+/cYQ+e8L+9OU0TiIYB4/F78iJSL2b7N2s1NWe6wOCVermu138WZlxkXLGfdqJXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122516; c=relaxed/simple;
	bh=uGCLcSGgQLdCSCR6SFFXz25U6IWmW9g+73JdHM6xQqg=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=K9H9tOwTdD6oLw3xuHqEi77I1gLD4PBsIrDrkpOuaYVqUKYO+K4VWgIv84fULB8w8cZG2r6iCizBCEM8u56by3M/GImB0QtfjTHmPcPetI2nshz+nY7HQkrzTfEnilRDSVzxbqfL0QVt40tmrClc2ADJTJrPHwNU1FYTjii1U6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ugmQsjk5; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ugmQsjk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1787122508; x=1787727308; i=markus.elfring@web.de;
	bh=uGCLcSGgQLdCSCR6SFFXz25U6IWmW9g+73JdHM6xQqg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ugmQsjk5hzIopnjpH5igD6TzR5YimEg1rxsOj2h5f7hI+Qm8H0bLpBArjyclgCgJ
	 09lF79EIiM2FKxAhR5nqa5h6a8N8Bc3ufF2pXKPcAVD7+GXiMPgvf6iU1wkZ2iV8q
	 3z/MNSNOjNmtrOTs/vSEXOwG+Uwd+iFTEKU6AvB+s7JFXr1iD6VkgjZVzirS0KBg6
	 XSDUop/vzYgYYJl6dnrHt/pADWjda55ClS/ol6NYcwvejo7lkWMuaY0LcZ3XkJBDT
	 xIt1n0ACplYliYjyCnKBMHVG3BX8HiWTwRROhKlr3Nyg+5bMFs7mlkMh5chAk7cKE
	 +Ix19InFitjEjRydsw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N6sFx-1wtecN1QyN-012gcA; Wed, 19
 Aug 2026 08:55:08 +0200
Message-ID: <a150412e-f102-4dd6-aab8-4cbfe4487984@web.de>
Date: Wed, 19 Aug 2026 08:55:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Triet Hoang <triet.hoang.dev@gmail.com>, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
Subject: Re: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failure
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gyfZxd72r4+wF/azpLnzkrOrVQWY/7F1DdT9Q58mfYGBJbIEkxg
 IkogfHKAx+9O0NrGtzdgYhD052SlC2FQWARQpetHABIjQFMlMp3pXmvqFnxP1uWvBAQGmtN
 RsobMHOCcXjWM96/2iWh63ZFXwr/2lDq2MC0SdCuQsbCYSsAeWaIsMFMrXqBb9q54xYZeDt
 jwkh21dWn2BO7fSbcQdXQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:BRFiANZfuMg=;t2+zq9g8gfw9X8C7fobqoe8sd/O
 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
 2pLVG20n2ekpln+Dy5SH9bZzYA==

> Check the return value of pqi_alloc_io_request() before dereferencing
> the returned request in pqi_submit_raid_request_synchronous() and
> pqi_lun_reset().

How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.2#n145
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/stable-kernel-rules.rst?h=3Dv7.2#n34

Regards,
Markus
