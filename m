Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1C728726D;
	Tue, 30 Dec 2025 12:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767096571; cv=none; b=OtG9tCqQ3nmqysviakt1rGe6X/8/Z2mbAh5lxD0Tcppx1YbbkNxL44mhPOXUUUsE8M4LO/Li8G84oPKSRjOLqGYzEpd/TgUPEHS5E0UtR0VDXokKPf3PPgHclzRiwwWs2yNe0jibQNQ8UBT/drmq8cb9YnHFEeM6z7lS8kwk3so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767096571; c=relaxed/simple;
	bh=4NX0puiXN3lUQ92iwv5EIzzYSTZ4PEANi/WpqrB8A3U=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=E+bX+BwAcb7b78x4ZGchIEBjkr1GP2r5Mod4uo1/3bxRx0SJuMKKW+3ezHgz4m95I6mOTLjkwd/1X6yUKQ9c2qLwTZAfkyNMnT91gevM8pFGPAZhmfjI7KIpNzMlWqTeQbypkPYPA7coS2hOmZYxIvlZMhoXgDtHF/HQHNrekf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=r99juCSO; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="r99juCSO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767096557; x=1767701357; i=markus.elfring@web.de;
	bh=cSOXOqsh8DbgjiQ2ftskG77MYQueweBE8iGmjVRwwvQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=r99juCSOdMU0g6ZBjA7UPtMKZ9y1/ltsRu+ZZCn/bl2mw50G/v38prIA/MhY2VDE
	 Sgt3N5uFpNlfKgEJsCSEXLXIrDA9FM3Qth4EZZYjq4mpQQ33Rtnv8rZXA28uxk2Xi
	 Mc7VAc0Gz11iWVy3FL40V/2foYP8NBjWaW8pdFUJ3k7HnBhuvo+ka95uMcfWnXfxw
	 rLbLRQcPz7on14RSlqkZnnvmu73v2RKTWJcuge4N8DKU30mcWCHprzyrTWla+oG7L
	 0eKwwFOjf/8gLFDhehSpYQFlXcOQVsS/1coeED3XGUbiqk5Za2lsa4ervWPNYmP3C
	 J8skSqpNK+ahUGZiog==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.0]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MovjQ-1wGpdL2jny-00gIf6; Tue, 30
 Dec 2025 13:09:17 +0100
Message-ID: <667efc45-7970-4064-8357-0c1d9acf3d66@web.de>
Date: Tue, 30 Dec 2025 13:09:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org, storagedev@microchip.com,
 Don Brace <don.brace@microchip.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20251229152938.481054-1-zilin@seu.edu.cn>
Subject: Re: [PATCH] scsi: hpsa: Fix memory leak in
 hpsa_undo_allocations_after_kdump_soft_reset()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251229152938.481054-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:F2N9HJ2/veNVMP+Ch0YLlWMZfFWIOtkL+PK1whcdWc7kG9ZZfo1
 8o5/EQQYCHaj9KSoMIUPLd0ld+UdqR2JQc8MfQ2g689+rFv70Aw5WvjC7M0ciRUJEnr253s
 edkl424xpab41UVDnM8XqtmUaj/7EJYPAaXIaFoxUMsSFmnKcp02mghumEoP83V+rNZXaHV
 0FEbCEmfZjXBefL5+23xw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4xh5ZsadA8I=;OB1dKTpAL+SFYE6LmrIn8Uyukti
 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
 L647rLi0=

=E2=80=A6
> +++ b/drivers/scsi/hpsa.c
> @@ -8212,6 +8212,8 @@ static void hpsa_undo_allocations_after_kdump_soft=
_reset(struct ctlr_info *h)
>  		h->monitor_ctlr_wq =3D NULL;
>  	}
> =20
> +	kfree(h->reply_map);		/* init_one 1 */
> +	h->reply_map =3D NULL;		/* init_one 1 */

I find this reset statement redundant here.


>  	kfree(h);				/* init_one 1 */
>  }


Regards,
Markus
