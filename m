Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA351F4FAE
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730300502; cv=none; b=St4pBjbVAE2tc/Z9NuawRpraI3EAoOFyyeDVSyJRdxgVKmvZMk/iRxSWMii6nexH3rPD+DUYLOiaqb+SVboJK01F7toVXDf2OadfBWnZOQJMXK4miOV+gMLtMjsiOzWyoVKgtcNRMODqjslRsoHBgfENSJ8c2zW5PIqf2yOrBOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730300502; c=relaxed/simple;
	bh=Ii1PdwdYCUdj69J1DtVG2dljIXrFXH+AtxJivPhKBH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3Y/j2w2ORQT+oAC5wsgN/sNHvQ2F1KEd1O4gor6fBTAQL7iOyHum/YDe1MT4dDa2yQ4JL+LdiJPNrwJQMB0W1ZT53meyCow4meHva9nSRjFUu1IDsB3bivHAm+Q4U/eX1oW/2RkLYFlA7AIOjhOBgCLhg8UJKoooeW52WmmqW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=systemication.com; spf=pass smtp.mailfrom=systemication.com; dkim=pass (2048-bit key) header.d=systemication-com.20230601.gappssmtp.com header.i=@systemication-com.20230601.gappssmtp.com header.b=1UQkIWVA; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=systemication.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=systemication.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=systemication-com.20230601.gappssmtp.com header.i=@systemication-com.20230601.gappssmtp.com header.b="1UQkIWVA"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a0472306cso934775266b.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 08:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=systemication-com.20230601.gappssmtp.com; s=20230601; t=1730300498; x=1730905298; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bO+LDlR/daX0QCMaFEkyBC2mrUAN56T2XsylQfk7uHA=;
        b=1UQkIWVAysdxKsX3ewujEwOmSuWxxrmozLtqauw6ztngCjLJs7qi1APQ8Z5b6447tJ
         /xvukgunj6Ch4gezco3YjyJmSeuVbGvZv3ihRN4sdVp5Uq51IEFRgH0tJDMHqJfoKdUd
         2jPjLTpC9M2a46c3B6GUyBMl2RsIe3+k7AxmGwzbTJ6TGQ2+dLN7pD++qrLEJP/Rat8e
         8j6D9wlUe9WHXFXy7nRWEKNQAmFYG45CGWrxU1q+vCq4an+sUuR3ot0DRgajs6d7XpNd
         JIpqn3uhGyycYfPmCSJ3cf1/DI1Cvkds445u+urv/Ox7ONZCDImt/lYiGnwlHb/i6Gg4
         dp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730300498; x=1730905298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bO+LDlR/daX0QCMaFEkyBC2mrUAN56T2XsylQfk7uHA=;
        b=YRowv/a4vOJPxsqwW+Ncwjv/7wvE8C/K99nQ3NV8GyQApjmxxwpI5kQdAEQSHLi8rt
         qXVzbxGDp/14WhHBHW8utAlDh10qkX4Va8Fr/YkLaynFpocxuKTZmlu5IbYOyZyZdkqr
         79VG/8Kw0Vc8P6CrPKJfqwVPOzMz/qiPTl5DU/0IElbuv79XrEdJcicjKY+Eucp/bEPM
         sFp8srDeGdkSpgn4ZU6FR491e7s1M9PblAFYa4gpvK5yvP8EjDYyC/OdbleE3Qe8gGbf
         w226hqz0Gary3bni7a8GzW2RUDK+kRLs5E46fMJNvf3cau7olXwp/G/uZLRM2GZco7hJ
         WLNA==
X-Forwarded-Encrypted: i=1; AJvYcCUhbYQYL4YVc9gXhbka0RbJRxOOAhKAWodrjWgRJ/JY/Zv3zm1I89dU1myXwnLITU4LCl5qwH+s7vzA@vger.kernel.org
X-Gm-Message-State: AOJu0YxQo8F3IqQ+dVU6Qf/j1gB2gdija6P7OB8v8n1SdFvrY+qcITP1
	aJddcKPWOmB6G4+mOCUnsOwApqA+FFECr6DOHwL4NLAU3thiuR2RMeMouEJ5HH8=
X-Google-Smtp-Source: AGHT+IGYJiuSb329vpuDooNBZCxgjh4+pTwi6oA6HvstVECBkmFsElOKN/hCLR1ldyGD9tbIq7uvwg==
X-Received: by 2002:a17:907:8f07:b0:a9e:2ff8:c440 with SMTP id a640c23a62f3a-a9e2ff8c712mr318489866b.9.1730300497054;
        Wed, 30 Oct 2024 08:01:37 -0700 (PDT)
Received: from mactool-usb ([2a02:3037:308:80cf:f7b7:3877:51c2:64e7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9b1f296f32sm572333966b.119.2024.10.30.08.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 08:01:36 -0700 (PDT)
Date: Wed, 30 Oct 2024 16:01:34 +0100
From: Dirk Tilger <dirk@systemication.com>
To: Sagar.Biradar@microchip.com
Cc: james.hilliard1@gmail.com, martin.petersen@oracle.com,
	khorenko@virtuozzo.com, christian@grossegger.com,
	aacraid@microsemi.com, Don.Brace@microchip.com,
	Tom.White@microchip.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gilbert.Wu@microchip.com
Subject: Re: [PATCH v3 0/1] aacraid: Host adapter Adaptec 6405 constantly
 resets under high io load
Message-ID: <ZyJKTug2AtqWs3BQ@mactool-usb>
References: <106f384f-d9e2-905d-5ac5-fe4ffd962122@virtuozzo.com>
 <CADvTj4rd+Z8S8vwnsmn2a7BXDPBwx1iqWRmE+SbtWep=Lnr20g@mail.gmail.com>
 <BYAPR11MB36066925274C38555F20FB17FA339@BYAPR11MB3606.namprd11.prod.outlook.com>
 <CADvTj4qH5xuK9ecEPi3Pm9t962E=nnH0oTBqWv4UPmibeASqdQ@mail.gmail.com>
 <BYAPR11MB36065EE0321C0AE6A4A3ECC7FA049@BYAPR11MB3606.namprd11.prod.outlook.com>
 <CADvTj4oej_E3tHm6tzOAhA=n2WughvDfQsaxKbP5Sxb+CeZu=w@mail.gmail.com>
 <BYAPR11MB360625E5945D5D3B29571857FA099@BYAPR11MB3606.namprd11.prod.outlook.com>
 <CADvTj4oNCrwHBRu-rUZtnxoqVkvyxG_Cg07RTAuwpNsGfjWKcw@mail.gmail.com>
 <BYAPR11MB3606FB1E651EC9B51BD8A0B7FA1B9@BYAPR11MB3606.namprd11.prod.outlook.com>
 <BYAPR11MB3606E15393A4C11CCFAF9C53FAE69@BYAPR11MB3606.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB3606E15393A4C11CCFAF9C53FAE69@BYAPR11MB3606.namprd11.prod.outlook.com>

On Fri, Dec 16, 2022 at 08:44:22PM +0000, Sagar.Biradar@microchip.com wrote:
> Konstantin,
> Is it possible for you or someone you know to test on your original test bed with the "msi" set to "1", and post the results?

Hello,

I had lately some exchange with Konstantin about the issue and he
suggested to document my findings on LKML for the benefit of the wider
community. 

I was encountering the same issue with an Adaptec 6405E with 4 connected
disks configured on the controller as "Simple_volume" and further
utilised in a Linux software RAID (mdraid) configuration. My CPU is a
i7-3930K.

I had set "msi" to "2" and the problem persisted. I have not tested
msi=1 but as far as I understand it should have the same effect with
regards to the system hangs.

I have applied Konstantins [PATCH v2 1/2] to a v6.6 line kernel and the
system hangs disappeared. My system has been running for 12 days without
any syslog message indicating a controller problem despite occasional
heavy I/O load.

Please let me know if you require any additional information.

Kind regards,
Dirk.
