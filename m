Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01124381A3;
	Sun,  2 Feb 2025 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738509792; cv=none; b=IPMmcqeWhMgYSW0cTatXQ7XGMvUSaT2uuH49OkgzFgb8vDTsi+TmLGzX93CKYndTOClhpyFmibZa8Fc8hPV+/wJww8lskTV19LjkujTkM9eW81bgng+B5kRVggZH4h91W6ya/93OZrAnx4ya48R00PLvyvHY3aaB94qh5Q5I6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738509792; c=relaxed/simple;
	bh=E/NCaMQTm+yT1nz5VJq9kS/IdA1zonNMg2KRejpLQRw=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=CIX4dGuG1KiANB+j9GQIc4/psP4XkjYoWxg5nhkE/Dae3HrFlTArmT/trRrJTI0kvyrF/nJA/hOouOY8klK5/5lKJhhRyasewQOb6Dqyxluz8Ann9q0BwSrN6EBl9YcTG5pF1gr9DVXfLNb5QV63W2WkjCG/JYBZ3qyhEIuP8NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=q+O89bp4; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="q+O89bp4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738509761; x=1739114561; i=markus.elfring@web.de;
	bh=E/NCaMQTm+yT1nz5VJq9kS/IdA1zonNMg2KRejpLQRw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=q+O89bp4YTMDPINIU5NmnfYgp0iva4584wtQwVy2V4uE7fJeW7qjRQGhfpylcoMr
	 Dzaf1RlJjMC0A9/l5LWxhHVEMB8cHdNhYIrnJLRBQavb6QgLNQmp28oYW1ZomcZWI
	 je3hmk24jM6n7D3co+XJY2jP2A7BBWVHGRpL2f4i6826kEvn54m+RKSBtYt8+zPvq
	 Mzv0PUvNAbnbpTDuvF4Wki9LJWm39C/nXxE69ozA+R725BsaLj09PanCXTDNQ7CGN
	 sHScmacejTPIB3RjhX1t+kPlat6Cb0EsOlt2jNZ0/mqTfIFck76zrpO/1AqmGfYE2
	 nmAkVIA9Nlk++FksxQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.26]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgibW-1sxZtM3bTQ-00b8YU; Sun, 02
 Feb 2025 16:22:40 +0100
Message-ID: <19e1f5ac-1e1d-4e34-9fb7-75aabd208fd7@web.de>
Date: Sun, 2 Feb 2025 16:22:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
References: <20250131213516.7750-1-jiashengjiangcool@gmail.com>
Subject: Re: [PATCH v2] scsi: qedf: Use kcalloc() and add check for bdt_info
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250131213516.7750-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:odM+UQVNVfx53UsEsfCAGKEkMIaG7yRcPWS89EiYHhb4p/UVaks
 gBMR+W8OvgGKyL9XOVSvU9TvSuSxN60/3lSOmbGA6/nuCBdZndLulMgOfRmF+B5WhiYJi2o
 kG+roq9y5msTe4uYV4S9sSj/sHaTXLAlSiNcqfLg/BXoMie7OeklgCYQ5SYBpC06doO/+wl
 wucydvYT9hIuCzBKySCEw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mcWCMyTDjMs=;7xZla9LftM27nsdPgN/Hyty3qYL
 Bw+AOcErfgcPH0IE5uZjrzftPn1XkLeMDl4Q+pYpUhq1aNp5OgkmMfe9Z/8DH5rDqWCBPpxvd
 Ew5C99b0wFblNQ2SMes+Y72DwbKyArg+6+1mAlH3U2RnbDGiMQ3EDBlb90BeDarA2nX+l2IBz
 h7NrtbAYroIoN6Xc+ULkL+FCYIBo6pGRdP2KJFCEpsTh1AsueYp54K7bpcowaLwUfH7zqsJc6
 sV7KFhMl3B2BdbUeClHW6PsyY98WdjbUcSuvos9kjPmd5ItRZj6O/RcdE797PvaUL2sksYgkJ
 E0h5LmdF1xk9DMotjikELG4gvQt3/ARrcNwP9GlfabB80f9/NTeT0tUV2zXHG7g9IrNuz7yyJ
 nBsjhaYN23Y/ZzqfukAHk/VROt6UrriEc02DqVROv/qJGv9p0Fu8qxTOlyKzoG9tpZ3ayVGxN
 z8QYPMUJIpKr/nsO2t1wJnNYJHzew6C34yJ5mLfzq2c+HZYrNeOoPZrjNQD0zZyM8DmQjQrC9
 +ybgTqpq9O93UoiXHSyQXRCDQRff/pULZERjRETCAXUli8ApLas7yhLtLWF5/aDPPakRt/ukl
 0TWZtfhDVAoC9ytHXKQMkVAn+0c2EDcgIB6rTUO78T8ucoeElTDxadJhBa8ns63LlhgVpE6wY
 xNfQiH02IdqnRpuWKL4a6IE1lm2wzOUlOE+bfemVBWCHpA2ZkGsm4cNG9fGVBivx9fr6Tj0sr
 KrWeMKgbjXLJCq/K71FLqI3pH+DJoYIL4pkZG7gN5OgvRHqwaagSaonutXLQ2czBo8imB4IyD
 TyFGwyKV0h6vXiWTOt/CGupZXZHG7LGWJRmCl9ETxxPko4pYsfApZ6FGV+NN8doDyZmzH9pXd
 RLp0/VlwUJ+QDvwlnEZs7A5X/L000R6ZxWWGY9XJBzjQHmmdCuFC2JtZpox/zdCwgWEfG9JXJ
 kqJiLxI07owSlF66IWhj5CtTf9EoAtzScU2G+hp7AGwxfX9SQpCZSKs7jKk6rHtPQJBir1kIg
 WpAnrG/exMl0c6Mlt4cjGCWcVT1YifSLlJtSYlThUjpuYYpJrKdFxi49hip4XHTq+pBzREsrg
 3lTPlDCLNDkwdpch+phZVyUz0Tboz6sl5GCeXp+/OYsrgYUwFbUYrIgpoJSztFpHd+mJhfeQN
 OLJIAB/rIOn6GoT/W3k9BFxbIKQTH7fxPvWxMyQA56GfuXrmOdP6QyzrA7DmUjnOk/tL1ki8B
 vrzRTsneplkjKR6NRYsjuyaE7L9BPTn9KTHt486CjRSdRrJpfAf3MieYyMR+1iY8uZaSPA1WN
 +MZEV1t3KjMHgX9/S/3lV+rq7QUlpv9sgOgB2lpKLGFOkYHwZRJFWIMN0ZHK0P4d/kp

> Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
> used/freed.
> Moreover, add a check for "bdt_info". Otherwise, if one of the allocatio=
ns
=E2=80=A6

Please provide desired changes as separate update steps.

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.13#n81

Regards,
Markus
