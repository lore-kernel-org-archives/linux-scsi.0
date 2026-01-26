Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7030EF63;
	Mon, 26 Jan 2026 12:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769432048; cv=none; b=pfsNH4DarJPLFAW5AbRLrK9aLNIE4lYcxhJhFppydXCmESuZxWqHljOw2w6xrIp5ejPDL1h8Xywf1CeTIfIgXs3ID1vf7C5IRM9AcQhsEndJk3QXUzZH189nhYRHLiSkzj4qb8zgigyBTyBQ2CYJDvTY+o2BYtYmnCQcWE1dYlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769432048; c=relaxed/simple;
	bh=aUSlfhaeAHQ/c7q9/MYIQg5Rt5iY/23h9cVQrEgJV8Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=HJJglPzw8NSoEN4ar3bKji10HErnpy+ubWjUhyWAa/2qsL8fBh52CMIvTvCzJxSXrlhCOactL0onAilV62AsVt54RXLv6OAR95x5YfTBGE2qRusq2pw+9hJFaheN0+yk1le2+30WOnyYia/5vTpQehQYtIuflg/6cjmHHKbpvzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=OVAOm44H; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="OVAOm44H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1769432037; x=1770036837; i=markus.elfring@web.de;
	bh=4WUyDiipmhhqYtobhh+TDz1pQ3VPpBW4lA3pS9ABtwA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=OVAOm44H+x05ne7bRPjqdp9T5WpPOqSHY7kTi1OhOgoCbWwn2IFKOEa/ANJkkNVE
	 Ow4LYme8ZR1b89LxyReiS+Qn8bH+j/kVEJZLOCXPr5JCRsnfcxFNzxQvzVRQDIMvm
	 qhe8EkX0jBLGdw9N3DUWc3o/J7jNmy3nUTyUObLwgSKZ3O4xp4Q7Uvx//8bgYIwvF
	 EsbJDT9jhgJmrmLzw1Kjobn11uI+hrUWmQkXzrI9VM06sMJ53KVwCMc+YvxSKysTU
	 eCCk66SCRA9erNw2Zbul0PULK55p9MLjuTRPqUdHdvEHT5zxMxuQK2pYTp/sR+NA0
	 N/cTWmr2BJC/XtOdaA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.253]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MKuOP-1vTWZc32xJ-00LI39; Mon, 26
 Jan 2026 13:53:57 +0100
Message-ID: <7e0dba2b-4262-4c88-a670-b8969d5ee656@web.de>
Date: Mon, 26 Jan 2026 13:53:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, linux-scsi@vger.kernel.org,
 Don Brace <don.brace@microchip.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com, LKML <linux-kernel@vger.kernel.org>
References: <20260125150244.2115157-1-lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH] scsi: hpsa: add return value check for remap_pci_mem()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260125150244.2115157-1-lihaoxiang@isrc.iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:BBvtZ4LjEoWwh8DE0TdXG+fAuyCH95vNxIKKmOGmOYaLTpdEQ4u
 ENcv1wmyksDxPjzglwHJMi+e0EXmX9MhcAP7tGjYvaN3SZpCRc2E+3dMyl3dPf87bELzcRW
 VcA4hyGbG0nIafCkZNqJovV0Ka0gsxvWIXtbASXb2ziMynnbp88PZN3G6Np9ENFcT/0GObG
 ONCIVm1BumlOWjmdnj5/Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:L7+u7i28jd0=;UluMk4BIGdaMdV86JtvICnG1HES
 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

> In hpsa_enter_performant_mode(), add return value check
> for remap_pci_mem() to prevent potential null pointer
> dereference.

* Would an other word wrapping be nicer?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.19-rc7#n659

* How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and=
 =E2=80=9CCc=E2=80=9D) accordingly?


Regards,
Markus
