Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E23117BA9;
	Tue,  5 Aug 2025 12:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754397504; cv=none; b=J83iDKq66JLbmxncFyrNWUPPD9ky6ax19q7E33DfC/X20gzgYUeO9g0ir/b5zI3hGEsGtHhpQ2CsOdCXD/dovnFWYjxxxLpV9ts7gEErl+u101V1bcQO1Fu2CHjvm8GsxCsj38hIBahriqRTCHoRLg5r4MEe/LrQ4+7j9euZA40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754397504; c=relaxed/simple;
	bh=qHbBTPG1UJ8cBJ2YaUMQZRyIgpuBO0D5IJ8/WOEQMTI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=NUAMu5Q3sfsKjUGajyc6xzPK1FFGzbQwuQw7PSRCFirb1eg4HeI9e+uYg0cLltTVneacQUJUXp1JeQ30OOwY6oNtS84oLu0lABzNRfMFrtye4k7/NlKAsoqCrIMBC/YlpA5xDVqNs2nA3P06HW9snObuvvVK1kbHkw2Oy0AWn6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=J4Ihm0QY; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="J4Ihm0QY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1754397498; x=1755002298; i=markus.elfring@web.de;
	bh=yJVfYsr+/JvuLvjumXDsAFZCsRtOulyYX5Cj3PNiwlQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=J4Ihm0QYYgVGO0TOHIaIqs6XtDKwTAbzAnocDW9RO/1pAuoSjNvXv1rXKXG7rNyH
	 4OJneZMkYYqHBFcqWFtsOLy8wbfgUZjabBWjSQLrnUxMojQlkKhsUktiRr1Ur7EAn
	 v40+kdXcO9O38cLRkNRWSC7LHjRTymmzcxhDkJbI/67PEAgJCT8hnUq8/SP6N7sKE
	 W3V0/RkQXppVH3ags4yLLcr/ECxTzaSbY3gHlIQem1kwVG5d3wp5EiUju79pjE41B
	 7o3oy8SVU+dvNwtAVryZrnRkWrxSsnSRd0AyIFeRyRQNa5B1a0v473ZNg7c5AoXI1
	 sIorsoK0GNjmJiG1mw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.245]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MbCHy-1uC82M1zRI-00mNRV; Tue, 05
 Aug 2025 14:38:18 +0200
Message-ID: <45f3ff46-fcd1-47dc-aaa8-dab7ddcf37bf@web.de>
Date: Tue, 5 Aug 2025 14:38:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Qianfeng Rong <rongqianfeng@vivo.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Bart Van Assche
 <bvanassche@acm.org>, Brian King <brking@us.ibm.com>,
 "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250805022637.329212-3-rongqianfeng@vivo.com>
Subject: Re: [PATCH v2 2/2] scsi: scsi_debug: Use vcalloc to simplify code
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250805022637.329212-3-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tYfY8cieiYXpRNcARYHB+ayuEgz8RR1XV9oSwOqxSUYhs3p4jz4
 ucMhbljC3BOi/lCl7BXC6dM4k/luRxfbc504+D7ElcgjgH12A12k5MyI1HlKzSmgtQG0Ely
 WZi7LZ0P0HigooTNKvNrGVMyTxBXVpWI/PqavHQ37OsYzc/QUNfTH22EmV74LKjbufwkXAJ
 HStrnMDS3fxSKXTHVMuGA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3tAQ7BxDAV8=;yTfvQfRaXMS6xsO9XyjODqPWGU1
 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

=E2=80=A6
> the functions sdebug_add_store().

      function?

Regards,
Markus
