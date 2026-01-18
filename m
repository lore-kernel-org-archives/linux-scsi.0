Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D138A280CE0;
	Sun, 18 Jan 2026 09:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768729333; cv=none; b=T8V8omjr15rCgrSKGAF0wYSHBkI2H0u5ym4KSDgGEahMQcL3ANWriG5KjOhvFPcj2tu4L29R6SF96RvewAIl87dLXceEpNh9D/suZX4wdSy8yeAjjBcrBYQkAzFovZnjH8t027QTRCl4zq9ohcgxOU5lT7UjpzOaengi3NjOQks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768729333; c=relaxed/simple;
	bh=IV3n/DQUjXMX45tj5moCz7FWPF86vcVvxDYQihvvSIg=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ZhEFt67Yts7XuR4n1BrglMG4vxt6KV9ZMoidB59Ns//kzf4Rw9EM0BE76Fh6IQmPQgjHi8sdv4rm3WdryON4h6DAr2ocb6iq6kIsQV/UtwTmLnKOlKB3wAn8Yrc/5ePWETE8Cq8N1ErLuOCuuHqjyoOD9Q+hoFMgKcv4uRp7Fr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=SfW4CwWk; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="SfW4CwWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768729330; x=1769334130; i=markus.elfring@web.de;
	bh=IV3n/DQUjXMX45tj5moCz7FWPF86vcVvxDYQihvvSIg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=SfW4CwWkoL2ZT1xBt7j2PQGTDKFL4h1ILU0w6/xDTdikEPAFcm9xiatYs0Mzw/Q0
	 y1+8HvB1EIh8vvUenNncelvcZqE3dO1uqURp/n4xVu3zORQ/Uff7JwneIjDcESTga
	 8FQblyWlL07T56tI2Nn/cd9BHu/cwqOK+iMd0JjIAkX1c0AgskpigklagAkW1cHaD
	 QcQXE5i9n8cZ6V4RYD1WEEGoJg1NBgvq3q+7lNf1IakBIkqbWZ6nHr2WdcrkcJ+00
	 Qde2+vM2nfd6NjyUWhSFwL/mj273nB8qVP26odyDsn5DcdCLJ+S50QdOeZcpmjDLh
	 GQI4SLokFHsF8RkRMA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.1]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MkVwi-1w4sPP3d0g-00dtOd; Sun, 18
 Jan 2026 10:42:09 +0100
Message-ID: <10e91bfd-7b8b-414d-9d33-30498f5ca018@web.de>
Date: Sun, 18 Jan 2026 10:42:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Chengfeng Ye <dg573847474@gmail.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Jack Wang <jinpu.wang@cloud.ionos.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260117101948.297411-1-dg573847474@gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix potential TOCTOU race in
 pm8001_find_tag
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260117101948.297411-1-dg573847474@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cRlFcuoj17TmBhSVR9KoIfdd1WbW+M3Dv+zMAH0eJJ+nJHUxBMM
 Mi0L+aFfeAQJoPn3RsqO+s1xjfXcBclPVMxVci3NbgtD7DcsDoWKW3KA6tY5g81ZrX64Q1b
 bcZD86W/yijWsp57fWmTILYMvBUQSl1DJh0XBlxWyl2nrWlCLvq7OSqtydidzstmBKZwlDU
 IIq2n293hTAZYFGqVQWRA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gUJ17GnSX04=;MlNi65rqxexq9w5G7mxGJlbpHMe
 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

=E2=80=A6
> Fix this by using READ_ONCE() to read task->lldd_task exactly once,
> eliminating the TOCTOU window. Also use WRITE_ONCE() in
> pm8001_ccb_task_free() for proper memory ordering.

How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?

Regards,
Markus
