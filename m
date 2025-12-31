Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CDF1DE4DC;
	Wed, 31 Dec 2025 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767198826; cv=none; b=eJa7fcult2SAFgAwSAN5YdJssLohh6GDTdxwTI8qjmQ12t2edkGjQClA7uvfM7PlyKB5J4iS+j7qu9FoBFhmn4IA3T8VO2VDAB7ZEwLe46aSMTBjS1aV5VRJiUEtU06Q9chV+SoBZ5vFWRO8H6xI8feCRONRDuQUx7LO49URo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767198826; c=relaxed/simple;
	bh=0P9GaaLrM3aj2tFHQXJmT8x/40X9qHw56e5ms7KsmrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJq3RsXgumVYSb4XxsOutmhGdGTNaKt9m78zGr/uEQAOYx4Vt01xex8nUmj1ntFxRcg3vqzYqghObnCgQ4xavfFL1cJcvkYN1MlM7UjPE/sCoK2HJqlInbJG1Z9LhOajV7EtMqqg35/+4B8Hjeo+FxIZ3WvjYYqU7VFosfgAcGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=lKPGLz3X; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="lKPGLz3X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767198814; x=1767803614; i=markus.elfring@web.de;
	bh=0P9GaaLrM3aj2tFHQXJmT8x/40X9qHw56e5ms7KsmrQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lKPGLz3XQFVWdnrchc4cKohXACiDa6OpK5KwMD9p30lloA8xRSYJIeIzUUaN8FPh
	 UmPCz/O6RWUkBpOaJZ/shhzyTZ4o0c3vL2/2MroVtD5y4CnFUfBDJk27Jwx7zQ1kD
	 6Bshk1fapTD7xapLwSuRzDuUkE85EllP1yPLe0aKaVTnmtVpC4ZogHyIc+CHDIX72
	 eWkAbRNqK3Zw0/LYLQYzgz+pmmLBYlVnQSkpldg8y1TGv5P/YeZ3q2HDonQvGHzjU
	 i4dd+C3ixJpGNzSuqHDyLFuue0MBMet//Gvicj9KnZeMK8Nq/FjbNqijKwKajzg3r
	 lrH569N/W7a4i/S2oQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.230]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MtyA2-1vtlXW0UQ8-012qHE; Wed, 31
 Dec 2025 17:33:34 +0100
Message-ID: <4e57c44b-24e9-408a-8458-845b0b9fbbde@web.de>
Date: Wed, 31 Dec 2025 17:33:32 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
To: Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Justin Tee <justin.tee@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <20251231151109.362373-1-zilin@seu.edu.cn>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251231151109.362373-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qJKnPk4BnqSp0sDQK3mal6BoH0W0edM2KI/+5iOeUotdaqdAgXA
 snB4fwAN6eSCtKs4Q842ibJytVjmz8wXu9SHoPfBM5U76Ylb0xIuDly9U9j9Gmw7kHAD7wo
 IfTL5REO7Qlgta8Sz7gD1xdxWEOAIFZJB7QWM17EBXtRT5MwRm0JKxlvZ8/UYX8bq2BrWS6
 nkFZPF1+V9Xjkwp0DQrbg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HTvt6ZMd640=;kOKA9TNGmD2fKN0/srcEzDf+yw1
 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
 EmGmzzz0=

=E2=80=A6
> These issues were identified during static analysis.

How do you think about to share further information according to
your source code analysis approach?

Regards,
Markus
