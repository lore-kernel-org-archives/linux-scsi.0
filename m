Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706D322A1CB;
	Wed,  5 Feb 2025 08:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738743975; cv=none; b=MuRAYO7tUfQeGzYA4eJdS25OEZr/GqE/gn3rESKIlHG/OIZsqhbqn6u3eUsJmD5hFfYLQ3/b3MxQUCiJ8GnMpP3mVcKYZoU/eHDDPlqz+F7eBKf35VoWuirbGqka9qZQl26cZNXu4VMfP4KmCqvix87NYAiIS52krR/ZTSeHOVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738743975; c=relaxed/simple;
	bh=VOBquAEgmcp5Rh4j1vo1naFqZdkT82CR5wKpqxiC+P0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SU41P6GpDIzHQ1jVRvH5287BfS/ZnfMiOKeNB0np9PUkuAWpLLu4APBugr+atSY5XZ1TYP5hHFh5/IGPe0vfpd3o5t/WnFkSGOZNGLIcOPTbKF5/mhp2E6QsOG+ZQ0u/pqjwpOfreuANA+T30B08RaobseaO2IXmtu/xFcZ/Dz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=czHAWhZa; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="czHAWhZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738743970; x=1739348770; i=markus.elfring@web.de;
	bh=VOBquAEgmcp5Rh4j1vo1naFqZdkT82CR5wKpqxiC+P0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=czHAWhZaEj/waPD/Um7MeT0RPScDJesYlIp5k1tzUz1XdBBq/ojwaU5TlrRnnMUb
	 eL/L0/jEjxc5mF/+8kPhJSguw77USsjsCb1LwuhsBBLQJy2fMZY8cjrc4av3ODq7E
	 789s+YmpiTPyE9u1rdUBE/NzPedhtGjXZUYFdGdvDQhQqnwst8Ylcqq1XER57kR3+
	 e6RgXTyVIyF5x07wJOCJ2UrAK3nbG7sLbEBPjsQwu7LydJPL9SH/0QTi/F1X4v7FF
	 RQKr76t/g+yks+aECyY8CwTXksdhToNR3VLUEB5DPD+Ug9uCEA8DCjKHrqKw247Mh
	 CEk41k4VG0ZQ8VsOVw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.30]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N8mzy-1tKMRS2Aac-00sabI; Wed, 05
 Feb 2025 09:12:08 +0100
Message-ID: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
Date: Wed, 5 Feb 2025 09:11:42 +0100
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
 <444d6d33-d916-467b-aea8-25c61977713a@web.de>
 <CANeGvZWWFk4HjFGnzqW9aGc_FPFw_8xx_vizY48AYsP2T7q_WQ@mail.gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CANeGvZWWFk4HjFGnzqW9aGc_FPFw_8xx_vizY48AYsP2T7q_WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nWtUnieaPTES9xWTK5XIZgfoYkluWGBDIpSdrK9M3hape6gaa0L
 TH/vv0ID/6NdSQFWvDzVPnMKGnnJ4vBuPnoBHm71T+vEmGMquLg0JKIPQkiAXjsWIlk4nQ8
 r5xpemKHNv+Gj+gWpvmL6H0wCMR1rp1qM28+Gz9tcWL019cabYU0/9Js/hm4XgBO8MJkdxq
 UvDNWBGI66iSfIyDF16MA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DOlNUbywRvg=;lbYdz67jSB9WqsnN4neFcGuLZ97
 ojxouwKAFVCcxtjTUfXbLQCsttNacUVDJOabkbBDNSia4kkdkWlnyvT4ZIIc1a+Og4ph56Wbi
 v0I+lg7E1/Fc2PxfuntGMtel7FAwsrzqE/8cdi7UvYGZRKvnLUqZI4dKkDZQrPTVl6vytKUS1
 GlTbZPc4qK/IOieQF5jsaPFFVxnMXw0qDia8IOdE1d8IVzT2ZjJXObFBkqHCK9Z9D99ybQBlR
 tRKFnu8KBwH5Docb1OpFwKLZ+7RxaLMDuvpqq4Ymhe+S2ik0ZpEb3skbyk2uEADMDdMdniPOn
 /ayBF/NHSPBQICN/nQ/CybW9grkUUPz9+gSRq11A55U3A70CZIOoNjMhzvCDs5nD3lrmffXJs
 KdUPWsshFT4RR1GizBh6mWRjIOsoXwUUYfU2YitZzQqD280y/KKhQoq6Nc2GjfgWluPxbi5Pf
 z7GVwaebQ4wNecSUllqGf2nuTUNiVzeGSdG2+3AqCBqmdXxsB39jndRcEHuQUBQacV/qDqWSP
 tcGx2vRwRYMeDUwaKNzZCTHUeAPlD34DZ6TVa1tIBGh7LFK2LU03jk61U5zHjJrkBdvz0mGjJ
 vE0eEYVQQiz2gmZqlq8aX+VNpGeTSTg2uniXX8bIA4Wjig/DDUzadksNd5HoReFTYI2jEJ/tS
 VNg0381zKowhLUGxL9aH6BatxiqR5/M5bdNAB5MMqiXVGq+XLMoe0U2gQFogs0lzlDZ5NrRFf
 YQV01KuoraFuazXnhhvHmWqfwoKAzrwzUCdJFT8i90ZCPPI/+o5uveKA9j48tXNNf79twXQzS
 RhHJDurYcD4q7VHfjwq0g+JYdwU+TfgXPykc6nQbHrPEr4hKHXOUKQMy7ts0q5C9RyeD865tl
 3vb26ZiMdRuERsbyGW2wNExKswZyZ/vQM920sf4nf82G9IPTneT8SR+L2V9/K8Cx3MdXqujPK
 E1PsKNqEcO8jrlBuurJMPQHwZ8RQGj6CNx+k0n2++3jT+Km0UAVljmvouJXwkzpvDeXHScCMh
 soGdqgIA6slWaAjPYq1BH0pxgujKBvIasx8XP/voPq3Z2KHG2wdDlR99ZNg8RbvvUqKn5MCI2
 C32QUTReVbeZfg+BO5cbF6Tc29/zv8otVA0UvdjTN3Q+E36KyfCCOutvEt7FZNHsriFli0xlc
 iLWK1Y8U0h8JYLktzuwzWtGjBSxRXLNeq5ZvYc6eiltpr4F+GFKbHbyr9GvVDav2rJTVBlph6
 C/28DOu5QcjkLOyBnuOCoQlCHjkz/Sg/Q1dRFuZGQIXtpX4yR2R0W6lfQQjlGA8nDLPxzKBGE
 uqX6ZdXjl4V+qyegO6sNdL6PGAwLK9BQkJsILp5UJQvna73AIoc/Xfi9/EOFRCBNJF/rdWEir
 ZapUdWRCQ4qHP8qZRTiTpHzK3+JdBdgQGesBngX9qXJs/fSS3FsHEvauFC7heUJidSJx81/hQ
 k3RmlLQ==

> Thanks, I have submitted the patch series.
* Would a cover letter have been helpful?

* Why did you find a =E2=80=9CRESEND=E2=80=9D relevant already?

* Is there a need to increase version numbers?


Regards,
Markus
