Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D0D6F306
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 06:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718780359; cv=none; b=XrCJa0oDfyGrj8qD1AeIK8BIHQfuoRo6zoYQkzeVYEVjqWdwl0BhDCqNCGAO8YnIVtaLe2ecb0Pl3VfyEwSMWQjmjGj41pnPyzDq/wvvu9KWJ2Yc1IYJUTm/q/3h5zPQ6lW9ClwTf5i0SZpuwdzngkH8Kr6NyMWK62v2clxsdMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718780359; c=relaxed/simple;
	bh=Ex8XoHz2m30DmPv+kgvdAZKlewAU12uHOkN9ftTBENU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PDPdnjOYJOnPypZh0l64DD8wUysz7qCh6dTxdV11IxJPB8F0zn45LJbaVc8F0g97Oo4NiHF2/Ql1aYHeqPKLgCUoE5Q+yOBcP0DgfrwH03Is3K1f43qAP6BLbgweXovFrFek3mX7h7q9o+h03gnK/frOw9MMMJth8duCp6T3vhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com; spf=none smtp.mailfrom=smartx.com; dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b=elpDwQWs; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=smartx.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=smartx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=smartx-com.20230601.gappssmtp.com header.i=@smartx-com.20230601.gappssmtp.com header.b="elpDwQWs"
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-1f700e4cb92so54453165ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 23:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20230601.gappssmtp.com; s=20230601; t=1718780357; x=1719385157; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzjGU5wIa+JU8cPwc97EJTnBpHZIpaLeV58Ad7PrW+0=;
        b=elpDwQWsb7PjGQPlB9td6H3/T/5ZuTyu8wEmyKzMS8S5xc0CSeIlIPGLt5RJZJTWur
         PWH50a4YBiPXNaBhxFO4t3gys/UyHxDPpSmeIE5N7X7q4tpE9jsUynziavYtiKCoK3Zb
         UD8SB66wB39H5cnpRttoQfa8B0RzLAOJtSRH8AifI1xMk1qAejpUo6sWf/Qi61SEf5Z0
         1cic+xqt5ibEWdkjuqQ23cWHBCv4boI3cRAUF6N0W8KpBKk0TX5lKUg4LrLNbNzgS9pX
         acWBb4OBv6GSEOjugjORNWhdIiRTxQuzCKj71lVvtpXLuxYBmCR9xTdYzhj2vzDDfbMo
         r6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718780357; x=1719385157;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzjGU5wIa+JU8cPwc97EJTnBpHZIpaLeV58Ad7PrW+0=;
        b=jwtv9htbnqwijeuhr7ZXdtRbqpoIA2S2AXclXcdPDeAjJQPtHVHXO4F3Decy0gcxNo
         BXhuetzMqQDjvYtC8qYIn8ZZ8uK3540soHsStYzsyRhfv0fcUNfNcQTVazHGcfTOTN57
         ayqRfj6gtd3PpO3qQd1xLhRUt/K3DXZcTXnqJGQISbfReR1Dv3BsM/LOZFqc0ueNQOYI
         +cKCGTnAu3FL+UNUkKIEo7BXF4g5FIeQQsNnXrytO/VxEP+6xQs4LlhjXpgTZf47AS5u
         3szaeJS1ssWZ+9f5fgYmm7jKMsnQSGFweW5MtXfmDcg154WN4U1HD9wY6rMtiIhaOuwA
         jSww==
X-Forwarded-Encrypted: i=1; AJvYcCXHTSEHmvKVuGM6ukyJI5ljYNkI1DRsmNNlBWVvJdrXJMC+q08lqz40GkNh0DX+VRAH/oeP/KbtqmfihTGaWRQxxIuYq4MOBxTy/w==
X-Gm-Message-State: AOJu0Yx3aEyjRxDWInw+AdHRChlNs1w/wHFd4p13SEbrEsQ3zJqnaGaz
	xe4YRXrmOMPoVhlSr7EHEwQy/B6MWrN2nh+yOfMSMQUHxjghq7O5gT3zkm3gYgO83/PS0vTIPU/
	nh4CY57BjUlM=
X-Google-Smtp-Source: AGHT+IF0QuYNMormgx3auX8/Izc4u+XSl3cTe8yCrtE7iOzIASVVYL+Eeg/BX/XzR5adzYxi97hmXA==
X-Received: by 2002:a17:903:32d2:b0:1f4:b9d3:adce with SMTP id d9443c01a7336-1f9aa3ec015mr20708695ad.27.1718780356839;
        Tue, 18 Jun 2024 23:59:16 -0700 (PDT)
Received: from smtpclient.apple ([103.172.41.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9b97ab2d6sm2332845ad.56.2024.06.18.23.59.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2024 23:59:16 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH] scsi: sd: Keep the discard mode stable
From: Li Feng <fengli@smartx.com>
In-Reply-To: <20240618084706.GB843635@p1gen4-pw042f0m.fritz.box>
Date: Wed, 19 Jun 2024 14:58:59 +0800
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F36E434-F2D4-457C-860C-4CA31EAE99DC@smartx.com>
References: <20240614160350.180490-1-fengli@smartx.com>
 <20240617162657.GA843635@p1gen4-pw042f0m.fritz.box>
 <DBAA6B83-E60A-437C-A8D8-B854E625F6CD@smartx.com>
 <20240618084706.GB843635@p1gen4-pw042f0m.fritz.box>
To: Benjamin Block <bblock@linux.ibm.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)



> 2024=E5=B9=B46=E6=9C=8818=E6=97=A5 16:47=EF=BC=8CBenjamin Block =
<bblock@linux.ibm.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Jun 18, 2024 at 11:06:13AM +0800, Li Feng wrote:
>>> 2024=E5=B9=B46=E6=9C=8818=E6=97=A5 00:26=EF=BC=8CBenjamin Block =
<bblock@linux.ibm.com> =E5=86=99=E9=81=93=EF=BC=9A
>>> On Sat, Jun 15, 2024 at 12:03:47AM +0800, Li Feng wrote:
>>>> There is a scenario where a large number of discard commands
>>>> are issued when the iscsi initiator connects to the target
>>>> and then performs a session rescan operation.=20
>>>=20
>>> Is this with just one specific target implementation? This sounds =
like a
>>> broken/buggy target, or is there a reason why this happens in =
general?
>>>=20
>>> And broken target sounds like device quirk, rather than impacting =
every
>>> possible target.
>>=20
>> This is a common problem. Before sending a rescan, discard has been=20=

>> negotiated to UNMAP. After the rescan, there will be a short window =
for=20
>> it to become WS16, and then it will immediately become UNMAP.=20
>> However, during this period, a small amount of discard commands=20
>> may become WS16, resulting in a strange problem.
>=20
> Ok, interesting. Do you know why this short window happens?=20

I have explained it in other emails, you can read them.

Thanks,
Li

>=20
>>>> There is a time
>>>> window, most of the commands are in UNMAP mode, and some
>>>> discard commands become WRITE SAME with UNMAP.
>>>>=20
>>>> The discard mode has been negotiated during the SCSI probe. If
>>>> the mode is temporarily changed from UNMAP to WRITE SAME with
>>>> UNMAP, IO ERROR may occur because the target may not implement
>>>> WRITE SAME with UNMAP. Keep the discard mode stable to fix this
>>>> issue.
>>>>=20
>>>> Signed-off-by: Li Feng <fengli@smartx.com>
>>>> ---
>=20
> --=20
> Best Regards, Benjamin Block        /        Linux on IBM Z Kernel =
Development
> IBM Deutschland Research & Development GmbH    /   =
https://www.ibm.com/privacy
> Vors. Aufs.-R.: Wolfgang Wendt         /        Gesch=C3=A4ftsf=C3=BChru=
ng: David Faller
> Sitz der Ges.: B=C3=B6blingen     /    Registergericht: AmtsG =
Stuttgart, HRB 243294

