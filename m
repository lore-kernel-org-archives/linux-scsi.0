Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14D0369238;
	Sat, 31 Jan 2026 19:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769887096; cv=none; b=cKPTz/Y+btbuENwxRq/dZ5kurCeyS4V8m4bBC82x8DJz5O6ZKr3UIA3IjJxFWCKnzrBxJBb4uIG9hVF2f6JWZYcpVZPDpfjOWUzdO0+TryW6V2KYG+yDHlSJ81VsjjNhQ2VV2mKTHMnqeuY6jIQ3k5eE54IARsHmxR9aPYCdt1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769887096; c=relaxed/simple;
	bh=F7mmJTUtsMaWpA6bXLKlro3ICubv0RYzZrCp0eslm4g=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=M7lppsms3OpMviu8nbaQiyZfL+SLGOjAE9d6hllqDDzKMGGR9LsC9+Pl6mQNhwWYUKSWUM3S4JyvflVC8GTge4oBKEV+tWqWvUb6qYvvlQUFrR6dzCPJVj03buDa04OzlRxPs4KaKuXUaY1Okscg79//gDJNjDZaZDVdd8PoM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=fyaFuEuF; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="fyaFuEuF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1769887092; x=1770491892; i=markus.elfring@web.de;
	bh=+qsk+/zfc+9zXEipkUCYW5ayyVXn6XkB+gufFB+PX9E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=fyaFuEuF3F7vbVkTZxitgpkmxHMZAB0XcOSrt+4M3/4AAZydpsn15ql0OYhA5jS4
	 k1AH9f2IPWDYUEsb/RmNRetGnLiDJgsMUYRprBviydHUdytWMZ0hi57mTCLhfEWik
	 ebXQ0HtZYchQmni9GzeAxDNqU6JtDsdzUn4ecCFgBBXmekdhVF1C0uuYOiBmpwJbf
	 fh5mws9OPjZYmNtxI3wn/hEN6ohxVCHPyQUpKsWUA7/tY7fBAflBZWyKRmT3Q0XbR
	 dqyTUThIkqrOOxW90ki6E3Z2AuGFu1lsrdPQ4HzDrRRJwJZ05CYd/wQlTZDT5b1Tm
	 TPns//O/cvPoUN77ww==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.223]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mfc4g-1wEzam24hk-00owt1; Sat, 31
 Jan 2026 20:18:12 +0100
Message-ID: <9d0292db-1498-405b-9b30-1e0295d893ab@web.de>
Date: Sat, 31 Jan 2026 20:18:09 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Zilin Guan <zilin@seu.edu.cn>, linux-scsi@vger.kernel.org,
 Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com, LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Jianhao Xu <jianhao.xu@seu.edu.cn>,
 John Donnelly <john.p.donnelly@oracle.com>,
 Mike McGowen <mike.mcgowen@microchip.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Scott Benesh <scott.benesh@microchip.com>,
 Scott Teel <scott.teel@microchip.com>
References: <20260131093641.1008117-1-zilin@seu.edu.cn>
Subject: Re: [PATCH] scsi: smartpqi: fix memory leak in pqi_report_phys_luns()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260131093641.1008117-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6uep6u4U3xVbRpnuaaRSEhOOqe/WtqbAfPjiyetRGrvqhrqkszb
 35XByVmDkpvnjVBmHS+LMNZUNNdVCe4ZABWvwPCYzi1tOvJB6F6xE/J6sf8hzuderKkIEWF
 5vQS0mCt5Hg9cYckF/Obo9t9IRcYHwCgu8OT6I2Sm+Rz68mG33jhlwK0kgNHZJpMpoxx3Uf
 JHKnXDwUkdpAZt2C8og0A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OHQxbEN8KVw=;gCCpEMkhkoft4bE1LnC1Ih/a7Fg
 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
 I4yarxSeP++7SBsw+ZMZ

=E2=80=A6
> Fixes: 28ca6d876c5a ("scsi: smartpqi: Add extended report physical LUNs"=
)
=E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/stable-kernel-rules.rst?h=3Dv6.19-rc7#n34


=E2=80=A6
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
=E2=80=A6
> @@ -1275,6 +1278,10 @@ static inline int pqi_report_phys_luns(struct pqi=
_ctrl_info *ctrl_info, void **b
>  	*buffer =3D rpl_16byte_wwid_list;
> =20
>  	return 0;
> +
> +out_free_rpl_list:
> +	kfree(rpl_list);
> +	return rc;
>  }
=E2=80=A6

* How do you think about to refer to the local variable =E2=80=9Crpl_8byte=
_wwid_list=E2=80=9D instead?

* Would you like to refine the control flow a bit more for the end
  of this function implementation?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/coding-style.rst?h=3Dv6.19-rc7#n526


Regards,
Markus
