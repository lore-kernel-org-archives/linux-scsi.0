Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8BF9C1;
	Thu, 28 Dec 2023 17:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="f0EZc7ey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1703784019; x=1704388819; i=markus.elfring@web.de;
	bh=2urlG1UjR0tpfga8xw3ZUqweTdSjOyd7FFrGW2jHX2E=;
	h=X-UI-Sender-Class:Date:To:Cc:From:Subject;
	b=f0EZc7ey/rLunFcUa42I4aR3muIIkSVjuiMqNwVsXvmiU6AxoP7U+/WbcWmW0QrI
	 jXZkiMN7p86fKocVjFdOtbKELEVdSKWRwi9c8eOrrAK+Yxdc1Zkt5ft0pUu7c4peY
	 I9+g60qDNNsGlL35j9eGnQGVlZd4HcAKTTAx48Z4QryIgj+T4gXtpdlK8y+F3hqSN
	 3XaWKrZAxT+xb5PLBIvRua74ntWH0yD1w8AMjsMbQL6ykEdJcl2wmMsyhje7GEq7b
	 sDvVFkoFBwncXMecakCJ5mE5s7NgaOT/JcOu84YZYP8cXyxDGMBQNZeVyJn5T7iM0
	 kQrWbYDookH3mA+XjA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M1rTG-1rGh8F25rk-002kEy; Thu, 28
 Dec 2023 18:20:19 +0100
Message-ID: <48a127e8-ca4f-4fc4-81b7-226080fba720@web.de>
Date: Thu, 28 Dec 2023 18:20:16 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Dick Kennedy <dick.kennedy@broadcom.com>,
 James Smart <james.smart@broadcom.com>,
 "James E. J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/4] scsi: lpfc: Adjustments for two function implementations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kebKLcoex0ts5glfrT77uO30AG88524gwKOMZf4pxKc6ph+Ca57
 dKMI3Hy+UxsnCyEJxEQxLO7Xp7j4vRTEweev46aqhB+eZZdv//cE2Mx1Mt+CC18FwhzvBAx
 uBVSzes3ipZBOFiSn528PH/5M0Lm8QZhcZHhaSb28vehKKFBw77/Kdj3ntP/i4PnGuyLVl/
 X13BWMRJxOEsstoW8tDmQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hsI3YWB7Y8U=;TPdEReWVwAhlIoIJUBGOhRvNyAg
 LCPjC0omoSe7xKbla2Wq7NJ/xWJQ42BIcPBWYwGuzSQ0nzkQXpvOV0kitOwgCU/W80h3FS829
 AjHSmVXMR15gPD65vjTMwwQUQoesKtWKxGg+opdwyoYkUtqXLsruPWY+efWIWKc2UGiNQYQtg
 ZqFJ+IA3zQ1tEG7mVlX5QYtrNKOq8AhzYPOtnqWw3bCg3aRRJoI5lp9Q7okGWd8sqENiT9VIo
 uRVIZx4usUo33/8rp+OLbh5IbR0HqVxQ9s+00GSRSuGIBKzn49SgHmA4a9dCU/sKNae1bwal8
 bBj01+RgCL/mL/JyrOrfCQb6y0witgT/G25dGLMKHgtyel5r7ZnKwKTpN9SYq5h7t54TpxS5t
 z1TmbiiEL/sZd1rOFiawzz2+vcznqM+yjwWLiZJRi4dmBJgTUPbiXdeA0hXe8v3x9W4GJgs0Y
 uCIaLXPNjMRrw9SSZRSp546VKzvs0AzT1upb3UaUiP5VBV1wj3Zp82zNbsBIwMzWmstyjuI2N
 qzmOMRobX0U/sTqTEBgd1h/64u1j72WFfXTeZWRA3IZWn2CrFRhVhh8fjdIOwGYHz74hdz0hx
 YZt/e5mex75KYWzaJpNmjQTpyX7fanoztyZmztAKgTfKH3lBMhc00WtTBF3CPjjHpyyj4vFpN
 WujU7B+rSyEznTc0CS9bncQI7GCHR1KQaxwNw10l7x108RG8ayTvikt9f1aZtjMlmBPPpOypG
 dl+EmYIx7bhHmaPAKDzMBLKosCQWdGq/MvIRZ/dXoAwz5Po9rmbHiCXC2KulQbyVgiTQRb6b+
 KeJjqKfNQXIEqvFq2BXpTNFP7FRdpe+MZdGB3L9ZNG85A7muUtsTqcpnQTlrA1rx9UUhqVeta
 6PUq/HMJL0gFtsrgJA22E0niL1F1711IHbyNy04/9SQ4WTcQULJ1La6N5jNhMny0h5OJwXxAq
 6uq/MZ4M5pqIC+Ulm1GbdjASAl8=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 28 Dec 2023 18:12:34 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Improve exception handling in lpfc_rcv_plogi()
  Return directly after a failed kzalloc() in lpfc_sli_read_link_ste()
  Delete an unnecessary return statement in lpfc_sli_read_link_ste()
  Delete an unnecessary variable initialisation in lpfc_sli_read_link_ste(=
)

 drivers/scsi/lpfc/lpfc_nportdisc.c | 18 +++++++-----------
 drivers/scsi/lpfc/lpfc_sli.c       |  5 ++---
 2 files changed, 9 insertions(+), 14 deletions(-)

=2D-
2.43.0

