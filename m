Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7585B2135CE;
	Mon,  7 Jul 2025 17:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751909067; cv=none; b=eqh8Kw8IFjBJOaSp+KRyy/FHtOigd+vrMRIvBmlIEDeTyebcyTMdthMgoFhwFiuNKH/S4ijhplpkGpzkN2cvfSYlf+BnDYJHgjhc/jDY6707yqhdJbjurnIFqKdL4SwJ4VJhDlNyfdU0spFDiVsDrgt0jFzKSXNnf3I8upMnpO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751909067; c=relaxed/simple;
	bh=LE5lOnV1r6sEYCrRLSbv+JwAGegUabn8yUwH1H/NhFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i/BmhiHweptdiyEHBR/XD7VuYUt1H0xOu/Sd9fyEildJaiyup3sAd7WZms9bYx95HiBkd5ACF0s+dwaIVySENsMD+NkNFDAR6XX3E/7Jz1o4fvkjXlaqVZL2wHfZ31V83uMV9bWU/7zLxJuTzCMhSN3eiPRL5mO922/PMJei41M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B0le2tee; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B0le2tee"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bbWLw2f9Xzm0ySS;
	Mon,  7 Jul 2025 17:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751909061; x=1754501062; bh=69KTYEFmtifFl6F+XwfdQSIS
	iwSApdb5o2AdPYlIDQM=; b=B0le2teessx03Mvotp6H2wWDVBfklJXHzPY2eRtu
	2Kt6d89ZTST2ezD6vD14RsTtINUAq0oSWMMDI3XtQB4V0iUWUj1KTwSYrHUtpwkD
	NJj89Hq3l8epZx91bp8ToczxTUi7k4EWGcC5WXjQVM2YxPM56nFSWSQeOjU/A6b6
	ohV2h3a9MBLu0x9LYFV+cLXhdBjfLXIPpzb+fyEpibUTlWyW+CezVff+2u+nYSM4
	z2Ec+QP8UoOoGWkRbAOyG0bHv2ay6JjwjR2UpBsXkODD1t7PoaEV4JxdBDCk7Vyy
	HwKsIDXKBbezJ4wzpP/TwVFkHpBEjQUmEYfTzrPtMb2Thw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vZUE9ek8VnuB; Mon,  7 Jul 2025 17:24:21 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bbWLc6BJ0zm0yTF;
	Mon,  7 Jul 2025 17:24:08 +0000 (UTC)
Message-ID: <970182d5-6b67-4b02-aa05-0485d0f801d6@acm.org>
Date: Mon, 7 Jul 2025 10:24:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: exynos: fix programming of HCI_UTRL_NEXUS_TYPE
To: =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 Peter Griffin <peter.griffin@linaro.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, Seungwon Jeon <essuuj@gmail.com>,
 Avri Altman <avri.altman@wdc.com>, Kiwoong Kim <kwmad.kim@samsung.com>
Cc: Tudor Ambarus <tudor.ambarus@linaro.org>,
 Will McVicker <willmcvicker@google.com>, kernel-team@android.com,
 linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250707-ufs-exynos-shift-v1-1-1418e161ae40@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/7/25 10:05 AM, Andr=C3=A9 Draszik wrote:
> On Google gs101, the number of UTP transfer request slots (nutrs) is
> 32, and in this case the driver ends up programming the UTRL_NEXUS_TYPE
> incorrectly as 0.
>=20
> This is because the left hand side of the shift is 1, which is of type
> int, i.e. 31 bits wide. Shifting by more than that width results in
> undefined behaviour.
>=20
> Fix this by switching to the BIT() macro, which applies correct type
> casting as required. This ensures the correct value is written to
> UTRL_NEXUS_TYPE (0xffffffff on gs101), and it also fixes a UBSAN shift
> warning:
>      UBSAN: shift-out-of-bounds in drivers/ufs/host/ufs-exynos.c:1113:2=
1
>      shift exponent 32 is too large for 32-bit type 'int'
>=20
> For consistency, apply the same change to the nutmrs / UTMRL_NEXUS_TYPE
> write.
>=20
> Fixes: 55f4b1f73631 ("scsi: ufs: ufs-exynos: Add UFS host support for E=
xynos SoCs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> ---
>   drivers/ufs/host/ufs-exynos.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exyno=
s.c
> index 3e545af536e53e06b66c624ed0dc6dc7de13549f..f0adcd9dd553d2e630c75e8=
c3220e21bc5f7c8d8 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -1110,8 +1110,8 @@ static int exynos_ufs_post_link(struct ufs_hba *h=
ba)
>   	hci_writel(ufs, val, HCI_TXPRDT_ENTRY_SIZE);
>  =20
>   	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
> -	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
> -	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
> +	hci_writel(ufs, BIT(hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
> +	hci_writel(ufs, BIT(hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
>   	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
>  =20
>   	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
