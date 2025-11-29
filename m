Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C21DE8BF
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764428508; cv=none; b=MngUqv6uzFIcHQYaW8gAXJ+lF4xB/KLnP8nuv+ft/UQTJ8FuhMWI/fMz7Hw666z8ASAN4j3sYVvPhmpFa5art0QZeHWvw5lNWAh4NZAoc9P6MSBGIY80h6qXzb8qSgxpClvZvpSECcs0a5b/vUb+bkZVMMH32V4ekdlK9WqqSTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764428508; c=relaxed/simple;
	bh=S82F1K7S3wq+wEZwqZYNaKQ6Z90pqwCr0/1QZlEP1+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RSWCJvJUWaKiOjPGs66wq7kyLHODW38TjYZ/L9meX2/hiR7x1unLV0X4x03YwIxWcFgj8mtwjSugDLuXAilB0vFDTDY189ZR0YI+EOYXB7vtQE49w01PHgtHZyIew11JxUuqJwW2eqPcIWjapfoJkETXGxwClTOYIBgJi3Rt98g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHuzSgkN; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHuzSgkN"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-37bac34346dso18809401fa.2
        for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 07:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764428505; x=1765033305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=2DyIri4gHptV5hDHgdSaKb6KWPh3tki3cdXW1D5aCBI=;
        b=HHuzSgkNo8bCdB83l/XSrNqWuUvM2pvRHnQ1s6d1V/YSOOmrTXGZA5L6rYgiyZmYP4
         uWF7/dcj8afw9Fs15l8jzDbcy2zTq2HKY1GNlok4HRSM54eK5N7pxgXq1WYlPHBll3p9
         1GWTlrITo3tSJfVkDtJSMp/JKRNxpCVB9TognclaIKG1r1EsVL0hNWR73B4l1DWqAhUu
         vtU3zK1TT2yD3e2iIBoXlTkDHJeRNsK+kmAkEYKAAtxVvHrW4UZ0+nHpW81TLk6DcQoL
         C+RHImekTlrHfeR0P2X8lFgVJk7z0cmYrj1qHpoguoU+aSQa4j/mL6ykQ3XZpH3V2qLV
         mZrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764428505; x=1765033305;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DyIri4gHptV5hDHgdSaKb6KWPh3tki3cdXW1D5aCBI=;
        b=PxnVdaI+hAH1y70cpfGrZjSRobL+ydHv4/UYecCfZKbZgCI8rGbQDbU4Qjzi1Dqq/q
         nZt6fUfqbCj6abOdMwNhCFV+1fVQRMqKRVj7aK3c/hDFrHaFssW3lsFFvQ//hzIU/LeA
         FCxaK8NiNaE0vliWEzPRfT6m7InaZ3ZM35GTj+svSkDw/qDTloqisoWRZM1yHOX8L4eb
         MtPgUBmtLlipGEi/2t8kHntgT/03G44CU6t9+7Tug/NCqE+e9/gUZg0ppCgSH+ydzp+F
         pZiA+c2IBUQRA9ZQ42VZerFs3InmowXLF7SZIJVEiBxxQLZfhJCKlN/Bj11of09Xv5bs
         3pkw==
X-Forwarded-Encrypted: i=1; AJvYcCXZkyhhBD3vTf6Sh6jSen3O/33PsitbrkK7IBh3DmS/6ltpkDXe/hzeooJgtmOD/a7LEHfqESQWDS9J@vger.kernel.org
X-Gm-Message-State: AOJu0YxFVHhOwKOchGDxjoMTPXbO3jtu4bhgf0I54QpCv5EgPjhYtKlW
	BBn6Zv6sCGPT60h4fzSEapGn7/D2yLuB76Gie0U39PG69PA3j+iQ9WFH
X-Gm-Gg: ASbGncsJ9Y/VTgzkQJIw/FSgMI7ZXwrB9PqruIn3r5IbXUVew9sYbrOUuiTYZiL0h3i
	mqmUb8P3jjpv+Y76SWEioKolQTFEi16U5PDPJpCpVlF660Lnm6DgdbcyAF8Sc9Y9Qx2SdnNVxBc
	sM8lFOaV2rpvqSdKqLG4z/I+wJlxTvABMw4JV6uJ0K3pZFc0NryMZ7r8e1K6BSmckFV1onfcpQb
	lHgLva8QM6dSKP7N1zzoFjvnnyHPubTp/qakh+4Hv25bFQbw9XnLuvnCSdd4Y2lj2L5cTR5bwIq
	kfn/pP7TdSE4xD02ureU0FjfwzsqJ55iRov31wOl55kCzAOyQvtzXPq81zzoawJ81S/x1VyaC4J
	Cqj3YVZ4TiRNZv4DwC2ZI52xsbV5Zuh/CPIoz99jczZvg4LXsA7Z2oILp4aHKPdhnK7gnm0+0aL
	ymyg/8XeshrR0dMLKsW+62dhBdCftZTbQuh5I1aUySVjMj
X-Google-Smtp-Source: AGHT+IEYMiFXC3v2TmshLvb59zyfSm9LpspO+/OfzyuqNLM4yBmG5ZGE/1yqj4SZxSsPzD0yHRxSmg==
X-Received: by 2002:a05:651c:2148:b0:369:55f3:57f with SMTP id 38308e7fff4ca-37cd92cd20amr61236061fa.35.1764428504526;
        Sat, 29 Nov 2025 07:01:44 -0800 (PST)
Received: from [192.168.1.149] (nat-0-0.nsk.sibset.net. [5.44.169.188])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-37d2369067bsm17074441fa.9.2025.11.29.07.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Nov 2025 07:01:44 -0800 (PST)
Sender: Maxim Nikulin <m.a.nikulin@gmail.com>
Message-ID: <c5bb2474-b66d-47e5-b392-b12c4db979df@gmail.com>
Date: Sat, 29 Nov 2025 22:01:41 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: admin: devices: /dev/sr<N> for SCSI CD-ROM
To: Bagas Sanjaya <bagasdotme@gmail.com>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
References: <a221275c-53af-459d-97ed-05a0766adb04@gmail.com>
 <aSqPHMSgtHN7ty8-@archie.me>
Content-Language: en-US, ru-RU
From: Max Nikulin <manikulin@gmail.com>
In-Reply-To: <aSqPHMSgtHN7ty8-@archie.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/11/2025 13:13, Bagas Sanjaya wrote:
> On Sat, Nov 29, 2025 at 12:12:32AM +0700, Max Nikulin wrote:
>> +Usage of ``/dev/scd?`` as alternate SCSI CD-ROM names for ``sr?`` devices
>> +ended around year 2011.
> 
> What about "Support for /dev/scd? as alternative names for /dev/sr? has been
> removed in 2011"?

If others support your suggestion then I do not mind. Feel free to 
commit preferred variant ignoring my patch.

I would be more verbose however by adding that it was removed namely 
from udev:

Creation of ``/dev/scd?`` alternative names for ``sr?`` CD-ROM and other 
optical drives (using SCSI commands) was removed in ``udev-174`` 
(released in 2011).

Perhaps I am biased by my confusion. Noticed that wodim tries to access 
currently absent /dev/scd0 for kernels >= X.6, I tried git blame game in 
kernel repository to find kernel version when scd<N> were renamed to 
sr<N>. It took some time for me to realize that it is impossible to 
determine scd vs. sr from kernel version. That is why I would consider 
adding explicit mention of udev. Otherwise for me it sounds like that 
scd? names were removed from kernel. I am not a native English speaker, 
so I do not insist on my variant.

How long I should wait for comments before submitting another revision 
of the patch? I hope, pending changes are not an obstacle for those who 
are tempting to review the whole devices.rst file.
