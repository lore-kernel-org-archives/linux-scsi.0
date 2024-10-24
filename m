Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0200816C451;
	Thu, 24 Oct 2024 04:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729743785; cv=none; b=EabjYSQKkW9+iZGctkwgo1iI4q6gVu9V/Dit+Sa3KqGK9wTztUqxBbNMTr2HeiFh978UimynaPW1UVSlo/hHWRbSKpKjaFpzjh7IhjUW9+n0SRQLLDx7OEFjElzHHe7jvt27LNXPz1MD/eZwPtF6+Kwgdp0lxtxXifGxS3q1CUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729743785; c=relaxed/simple;
	bh=ltyryit/pCASlQIhRQSt/hsaG3ceW24lcWv//gyNnRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bFDFNv1lSkALOgew3t5Vo3FlnbUChg3rgeoM7IuVlA8Av6539VJcKtFYNhi6G0Q5X6dwqiCXrMfnUgN8/9Uw6t8/9DNt9BEiDkQwEwfDB2gPP/g/wlzeRofKfhm3S9UOGLzd/FN56ah4SAqH0FMfu/sIeH7flDbWTAMGntARnrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+wWGNIT; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+wWGNIT"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso54663966b.1;
        Wed, 23 Oct 2024 21:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729743781; x=1730348581; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z5woqYSL4j8aB832acx6nClZKfil6mOTdOS8ULzyVik=;
        b=S+wWGNITjziZ4j+GRcc5tXkwEifd27hyvpnpMxO6Zhq2Ky+Abr6nn6ulIymkiKJcLE
         iYcP/JDLMNSnHnojY0EaB8ImrLBQLDCH7fve8iqMvnIN+LHmUCXEgvMwMQo6S9xmRe7U
         oZXUw277MDc1Z06+HMok8B3CW6Pgz3O/TPDMS/BeMnrLYurxG7mlPnyalwUm3omcMSr8
         hL0IeOxD9EcTLoHuotnrk7t3k0Km0TleG620PRWhp0VfbxfOnhEj8kp0xBBBBU4wjIT1
         YVWZ1DT2tP5Jzt1Zw2ma3ToHDADTZI3M1/mFBNAfZCwH+ZGGFhnY9eJTxberi5mSYIyf
         4EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729743781; x=1730348581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5woqYSL4j8aB832acx6nClZKfil6mOTdOS8ULzyVik=;
        b=OUg69pnVBgCB+q9ws3/3hWnCjCvGylJCs+GkGyhOX62ud9a1F95Uq0sajk1lMp2SZi
         XnCcRmExtTqPaOKYy5bVDe2VzSDk37RGmNDpij1YrmOvzV1ofdZ5/WfUXyi151dQDsW6
         0yxvw7yeMxSn/KLVWF/IHZX4DMBmnpS3cqrzCdPzaiBC5o+3tSjpj38ZXN4v8pd+2D1d
         weXpV+sR12hzzYjQvtW83MTDSsR/g2bVVy/Sv1asBpn2yOR5CSAeiJ+8pRxe20yN9LWc
         2XQdZc1Z4xP+vHQ0iwa0RVcsGuXDlJYmX1knPtH6oU94StmbcNSDoxjSDyAsFbPqHn9V
         yvjw==
X-Forwarded-Encrypted: i=1; AJvYcCVMx+1fyotqCUvHir8pUn+oX67ARa1DtFg/M2J49i03Jvba283d7dq7TJNk2GrOAuqGsQM2Tkzw9YGPTK0=@vger.kernel.org, AJvYcCWF+rrtJxVxzzGqPOblbKoP8kJMSvo2WiQUVNUf082PRwl9TiqVtoPg68hGdrYgM00xYB1n+yEhhOPU5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsmt2aqCvYqwZtL9aGOzNaLg12K4Yt00D3kgaYp8KxwZ5XAUJI
	u1bc0UXQ/GfQcH58OQNPyuS6+vIVlYQbabNd3xiP1jMrxY7OHz3W
X-Google-Smtp-Source: AGHT+IG7ayHwJSFjPCb0O7Cs7avdwOw8DAwicCfkxqnGXHqz+GiQQz+gVMvOJuGTFOZP+mxrnC2UBg==
X-Received: by 2002:a17:906:6a25:b0:a99:7539:2458 with SMTP id a640c23a62f3a-a9ad288f856mr53904466b.65.1729743781056;
        Wed, 23 Oct 2024 21:23:01 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-182.xnet.hr. [88.207.42.182])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91573603sm565365066b.179.2024.10.23.21.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 21:23:00 -0700 (PDT)
Message-ID: <414ef7aa-a1a3-4c13-887b-25a51236f83e@gmail.com>
Date: Thu, 24 Oct 2024 06:22:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: gla2xxx: use flexible array member at the
 end of structures
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20241023221700.220063-2-mtodorovac69@gmail.com>
 <9ca3fb4b-85d9-493c-8b90-5210f5530e7f@acm.org>
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
In-Reply-To: <9ca3fb4b-85d9-493c-8b90-5210f5530e7f@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/24/24 00:25, Bart Van Assche wrote:
> On 10/23/24 3:17 PM, Mirsad Todorovac wrote:
>> Fixes: 21038b0900d1b ("scsi: qla2xxx: Fix endianness annotations in header files")
> 
> The "Fixes:" tag is wrong. The one-element arrays were introduced long
> before I fixed the endianness annotations.
> 
>> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
>> index 54f0a412226f..ca9304df484b 100644
>> --- a/drivers/scsi/qla2xxx/qla_dbg.h
>> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
>> @@ -31,7 +31,7 @@ struct qla2300_fw_dump {
>>       __be16 fpm_b1_reg[64];
>>       __be16 risc_ram[0xf800];
>>       __be16 stack_ram[0x1000];
>> -    __be16 data_ram[1];
>> +    __be16 data_ram[];
>>   };
>>   
> 
> How has this patch been tested? Has it even been compile-tested? This
> patch probably breaks at least the following statement:
> 
>     BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
> 
> Thanks,
> 
> Bart.

From next-20241023, it seems to have passed compilation:

  INSTALL debian/linux-libc-dev/usr/include
dpkg-deb: building package 'linux-image-6.12.0-rc4-next-20241023-00001-gdcf82889780d' in '../linux-image-6.12.0-rc4-next-20241023-00001-gdcf82889780d_6.12.0-rc4-00001-gdcf82889780d-4_amd64.deb'.
dpkg-deb: building package 'linux-libc-dev' in '../linux-libc-dev_6.12.0-rc4-00001-gdcf82889780d-4_amd64.deb'.
 dpkg-genbuildinfo --build=binary -O../linux-upstream_6.12.0-rc4-00001-gdcf82889780d-4_amd64.buildinfo
 dpkg-genchanges --build=binary -O../linux-upstream_6.12.0-rc4-00001-gdcf82889780d-4_amd64.changes
dpkg-genchanges: info: binary-only upload (no source code included)
 dpkg-source --after-build .
dpkg-buildpackage: info: binary-only upload (no source included)

Perhaps I should have told that it was from the linux-next tree.

Best regards,
Mirsad
