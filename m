Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0D31D95A9;
	Mon,  3 Feb 2025 07:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738567241; cv=none; b=uH3TJx2Z674/amIvLc+qKVuXFmIGiXquJj7lWk7PtPyJsWB5UgBHPcQRc5bBqXKBufiZHI4jW6IHKSrYLZHuJQT+eOIP7szive1HuAxy9IM0DmNHVQDGlnuxeyMya+VS10Be9EAx9hHfX6fc5Hd2fhk9bOygfM2qJSo9EFJqiDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738567241; c=relaxed/simple;
	bh=A0EZ6L7ivBF++ebxR7chi9SXMlbOUzNu/WUxeVJLCUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HGkBe9rDC5G824NRFcDco0kgIQtGj031NbxX5QW+wttOjSsnPy2ydPw2Av7wBE9Za5J8pEBjdG02+zH0t+LYDAbEZZV+wPekEavGSatl29+4dM1JAM+ZkeiEQhjFxlodEz3Jkg5+1xdtuwFX2iYK7rO50DRYPmLTLiO1tGQbG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=RFr1MlVj; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="RFr1MlVj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738567228; x=1739172028; i=markus.elfring@web.de;
	bh=/Ojl0b89DBDLJ+6s6lUlTKOm/iGFymmcDFvjos5OJN8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RFr1MlVjDLeFx4EV7748A1W75wmTjjcj363fg2hypnQt19/b1CtLVYlitql9B5v6
	 sEHhhTko3s5BpHyxTnTa/1X1PZhJdfU0n8EnpJiYOprWWZkJk/3t6koOMAMF7OWNr
	 giz9rofr/f84tY0wBVMs91uwTVPEcIMIAgUQN7zi0I1j8ukB1WrCUeApbJxQ4amp6
	 RBtQEGm+MnAW0mPDqN3piJhZz7qEuPN5ziG7HO1y2E4xYHclj6zbqWQeDLcDFBcXe
	 RkSxeVRGh8AdyUgkqJkKCYMcD2TepqIQ7IsA5i2fi/zRtHghKByPdM5rngTcEfic1
	 KGZe8z2gXCLWjO38hQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.29]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M8TBS-1tjGbE2bVA-003A76; Mon, 03
 Feb 2025 08:20:28 +0100
Message-ID: <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
Date: Mon, 3 Feb 2025 08:20:16 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3?] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-scsi@vger.kernel.org,
 GR-QLogic-Storage-Upstream@marvell.com,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Javed Hasan <jhasan@marvell.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Saurav Kashyap <skashyap@marvell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arun Easi <arun.easi@cavium.com>,
 Bart Van Assche <bvanassche@acm.org>,
 Manish Rangankar <manish.rangankar@cavium.com>,
 Nilesh Javali <nilesh.javali@cavium.com>
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
 <20250202213239.49065-1-jiashengjiangcool@gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250202213239.49065-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BWaavV+6BOBCJqOvwjcsGmx/zlaWt3KvVTwU+CnpCPuhtPPbwBG
 zRbZ7gZq5/fiBxiEBVnsyZ2xd0326SZI3SQvBdaEuEXHdoZg6SbLRfTKYeJfEFx5M9rkLMj
 re1M2U4bSOa9OQts/7r3CiBtoC4BykR0EHsCqKjpg5AyRzppVGAW9/y+tL0KyU95LZbBqM5
 dqaQ5lFmp2K6I+TwxD/BQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1nfzjk3aVP8=;LCRvLCHki9gMX+G7JpSLXJgiEqF
 43bpguStrzwbn3vgGdy7dNlhgQuzHsda1xSAzOY9iZnjzmY5uT2TtoTFH+JOsdnkjI5amlnCE
 Ty9VpIEBhvLbj0xJOttXjjNXyzrYdHgWM8Ip9uT8OsKFe0XN6YOU/vmGM1zGOkIROyuGtnWDh
 dVbxrrX5NVsX17mpk530RO7ebvIC/q45JoKGRQR+9mZ4QZuWP35jPawOFkA4Js0jAeCR3NK3P
 U8/b7uxQ0IeKgnEY/tYBkwX5BvleedXTtK9LguysMDg7ugBhuTg4wwp9EWHsG7DzSY8bwDWFR
 bQ4K+2IaakG1IHq990+e16SmkDEFxYhNg7WWYB2VA1tpiLyfKxajBRlRsSo6gOGPXdWi9JwHz
 eRgNhyV5qVsesZlKwhWq6H4+LvpieGB3UFTp72P9vxafMDWIOlgiLN0W3+ZEYEoCrQ2TXN4Wv
 gev5oEUsLnoe4CkvsPm23nVzX3zIacej5RRITa7ts/ybuO+gfOSUUHjc8UCuNsDHHQwQXyhWS
 rBM7nIy5LgbQSwLm1eaoUXzLSw27vh3vi60p10/3OljarEfJ+wVxuGgqglZQUd/Be+TGXcITX
 aJnMKWtfeAbGTzTcWke8Md7P+dg90ZMWm69Pux4+uCUx6XS75IeRIhUUFDvV8kPao4vbBNgDg
 gjKfhyuHLlNx+LVhfT1oyEciMXS5IEkI5TZV21Bf3l6191wStRY46fU/TrT6Rm/OGLVZx3RgM
 TgNkt0rSbI/Nhs85buEfJKJn6Vly9YFuu3GljSFTFzvrIN22TfeMynACou9jSzO1zfa/Km9sX
 W+LyuUhLvseR/daafUp1+a7rB3vmLNFqtZ3ITsRe7FmFdZftlUZzbr5vKGo4MZxq+oFxicabx
 vbz9rjPRzdISLMefUQLnWDUDEpwUX8Rcf8uDQbfY/dZi1rmgs6KZnWQ4kAuPTa/qwzgovMdUF
 dwdlL5zDOBZAfPjQN4MrEktc5P6woeOTLJx1OyCxICOC1483V5mzZg5+WByJl+2O1qJYh1pCO
 IOxc0zqZDrpHMDvCNEX4x1SYCX/CoZVIBkjwrZxOq2G0BCUqkcf8W0qQI10jnCQ8xxzFV/yDk
 R4lv6jidr4f8yGWlHbXnuKaRQa64X75aEY2eXkl4X4DJmeMIWDeLRK/xQdyTo0ISQumuRquZn
 6HEBTdx2VMl3DwDbkPMgI0p/FlGJZwrzFbBqdc5OpUad1SeaoZkVLQWQOioMvDvUoZ6sv7JPx
 43wJgF5XQqs9hIGpCaz6RPWEyvYzHdYAtk84chMYngiHa3iz/KgIYBMdO+/HkTit4WfQDlzAe
 RDgI6534XC0qgF7JgnjFo/Zmqwj5vMFhoUJiA+nny2++2nxU1CdyAH2VBPyPdu8VQFK

> Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
> used/freed.=E2=80=A6
> ---
>  drivers/scsi/qedf/qedf_io.c | 4 +---
=E2=80=A6

Will you become more familiar with patch version descriptions?
https://lore.kernel.org/all/?q=3D%22This+looks+like+a+new+version+of+a+pre=
viously+submitted+patch%22
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.13#n310

Regards,
Markus
