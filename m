Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29338635E;
	Tue,  4 Feb 2025 08:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738656355; cv=none; b=t1uA3DPrO2JF2hO2/ILskS2AdOxKMIePO4upoQN8sgwWrFSJ385SoKe/LR44OnqGeWqa3AM/AltKA1PoQm9PNcKFAso7ffmK4xAirE08jVyNNG+7JRRHOH5uU8mYqTZA/c33Ezli3ZQ4nv8ZmlPV7oCKeuaF7JV8bT9XgXpxXUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738656355; c=relaxed/simple;
	bh=5uNyUoJPtzpMgfLNyDpqgtKdgGl0kwhLW4I57KsMsao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsO85YR+wVPY2GirzMzJuRiq8qaXC4zvVM3tVFth6iCWTPF68ZanFsOY88KEAmaX01pmUZn8sgh59Bo1be3XuJtQfr8A8dMl9zKAQnER9hHst3AhfP/5afrWx8/SgPMKlNxoCdyct3MJdQq7gOEeCgV7+eBdn/pITp4pKctsUqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=wgm1NVc9; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="wgm1NVc9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738656308; x=1739261108; i=markus.elfring@web.de;
	bh=5uNyUoJPtzpMgfLNyDpqgtKdgGl0kwhLW4I57KsMsao=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=wgm1NVc9kfYvhzuWZh2VlSL9zGAMSA+EVSF2mOHVHO+wtzeyG0emlGxfs8XCY5Ec
	 TeEPzkGLfbDrWyCwjUH0rx0bLCrm+NQ7UL95NjlJ/NXOGK6EEwx31MXAE83XQYGCn
	 M8huuMU3qqb6U3w1P77aExJzPuqkd4MGIbAFjvmpYHmYkOpH5YOjRVom4tZeVo5Vc
	 z6/pCijitt/nIsYHq1PALM1OvCiM9aEVCgximpc0PKHbkTSibgvWSYTwRtUXvqpM4
	 VP1T2LP6qI0u9Q5/6g35wxfOP1qiDgg1W+Kr5XlcSqFpqAX+tLrNaZGgeLe3CXLbv
	 xUWmEVxzMPlQQ9T10A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.16]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MPKB5-1u4Bzy3hz3-00JTFK; Tue, 04
 Feb 2025 09:05:07 +0100
Message-ID: <444d6d33-d916-467b-aea8-25c61977713a@web.de>
Date: Tue, 4 Feb 2025 09:05:05 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3?] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-scsi@vger.kernel.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Javed Hasan <jhasan@marvell.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Saurav Kashyap <skashyap@marvell.com>, LKML <linux-kernel@vger.kernel.org>,
 Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bvanassche@acm.org>,
 Manish Rangankar <manish.rangankar@cavium.com>,
 Nilesh Javali <nilesh.javali@cavium.com>
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
 <20250202213239.49065-1-jiashengjiangcool@gmail.com>
 <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
 <CANeGvZX5gcYj+Wjp+t=GLtOePHBjMNmVxiPsk2nruqsbiRaqVQ@mail.gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CANeGvZX5gcYj+Wjp+t=GLtOePHBjMNmVxiPsk2nruqsbiRaqVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:uaTnEDMk6fvUlP6vWWCn1n1zkmgJ8+CHseWqYQG9V9GKcslrRG6
 5GwZ4at6HuyqUhLjDoVcerolP4rIKtaDYH+TVZQOhkqnQ6M/zwmJleNf4/pzdWYma6Ijpre
 IAhN92ITrbUXOupmBnrmvDkZ1reukTqN0rFFECcLiEAxllzibiZLx6jMGaNch3bFScdMt8k
 pk9ZRNk+rFpANQ33qlACg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Pm3W28ysthw=;rEZcCXoXD7Hkevtr5fWlUKKVppd
 zuRs1AD8LCzm/2Jd5sQdCHbxBlaqCdk6v2TDV1GOB4A/LfvbAwbmD3ovizdvtlIIXWDhZpyPr
 V3iw1VOCoB+f527txZYehcCwQnOcufIUfP4hghkxeQudOG8+gFIGCVzPfmXDGL17sx9JivA79
 XapLZ8whN+P8hU6M+eRkxXbbBrSkX5y09IDORSm6O97FnjxFnyJuEyVyBIgfRCbiLfyUpYFZe
 7EZPFLQvTlgd1OdOiLRcj229yAuxTMeMjebR1S/iUmPBQM8cgUCC0zCX1+Oj9qSkVESXkQN5H
 FmKmZmf3Gs7U1TSsm5FiTLS9SUXxlied1mg5aoc7WMW4oTyq8lkXPUShmUmseUMP0qyiENiYd
 B3aTNwK8ooof9TYO+fPj8C3EfLgNQ488N8ZuJJSgTX7jouCAnGrOrzUA1Rrqjt7ZyXtFWtUmn
 uk4C2trDGapZLihGcxJNTl8fB2kj+I6FYaMr2KakCCaOq/hou+EaRD8lrGViRJT2FN5iED+ec
 jtXUcNJZpbL1133X8+U6XkqYsJA472xVvg0b4vjrrD1bug/7iUOpzhTb1bIME466QjIQwDZuq
 c3zFdMP2xrj9pK9O9ZqOAqp2vfRDX2jFuNcM4k7V6SIB5bPZcBfApjCzfG1ZzB860KPmJPVf2
 x5NRIkpc1LigwO5bmtSpe6AymB21WbiHGzWrRF2GqAm3/EXha8sDgrGQI8BNjCRWYLl3pD9ko
 Vp3uP6li0jeI/V9t8ULC48NqB2Tig1B/zFikWm09Mu++MXIGXGJDxNWQiM+3025TusE8j9i7R
 IcIOZn2VcJ2z1M3fQdxuuSazrzjDU7ITROUTvATaWr1da44GYG3dCKMNFwh+1YBsu/MG5gdn0
 1F4O6RtyEiFXDBg2tGVnSMrebpIsiSJ1+ZyTyh9qCmus1KzOtnZNwP5jGwmwcGKXp8lMoaUYZ
 lq2bGSF5pGiwKKbcz6Q/co6lHofkiMsNUOjPEgodeN6OY3HtIuYq0IX+csIQIYZs3LMIkU5CM
 4qFev/Zv6Bkw/+oujRXgHBeyvbacIke6+g2qWUvNAeZXMsN3Icmfr7FpxU5lGRjjYvBHfsqJK
 KlbkEivI1Rq62QO4cE56gUyOibeRsdq2lPYMHHi3fqifEalxMIrLx7VyXgltj85d6WhpUSCvk
 6OyVXcUVf9VGk3MZc5gP7cJ13xtoP1T8ivHModB8h0t1be6ySF0QsEYqdZDH9hBy9LxWxu8Pu
 McKfAhOLEb1xhv5bDKQDZ/THS126XKIcK2j6wlf7WHf/F6PLON55HA8OcW25vN9pe8pGEswEN
 ZgkMKc+53jqMcVnoD81fbZ+QVuJoUaWwhedrrKrTK/ZlY4ry1lujVQK2Q3a/ozc34x0

> Thanks, I have submitted a v3 and added the changelog.
Are you going to improve your version management?
Would a small patch series have been helpful to avoid any confusion here?

Regards,
Markus
