Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3316CD05;
	Fri,  9 Aug 2024 11:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723201460; cv=none; b=IIcjWqENte9C4MdZnhKDXqUVJvDT1Q0fT3I3ijkX8Q9k4DLcPGsKExiuWFqXEZxI6JYkYKHMmlVs/oAEx7O230ePRfxuPFbS3jbdBgAlUagHav0WX669z9CFT0vR2nIpmMRDNJoZfxjyFHUI+6XRcr8UjLak2/5xMDlqjSyA/1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723201460; c=relaxed/simple;
	bh=CXs4b1dg6xZmeIRz9ZbLqupex154c1w/Kp8NOYoyDs4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FIWyWli2rqv1jtAcdOVNRlCiq+uIdQvMfYOFQmjAhN3mNvnEQOqCb3asik7+2L+uw8bwDv19TVvB84jEpTgoM0zQl5lbrTwtlkxB0Cupafhmqp7AzfRvKhnNxTSwG2a4H+kJTm7jy0yQa3YHztba8vY3jtaz29y4F/4SUE9ffhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ha56ndsm; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ha56ndsm"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5b7b6a30454so2376902a12.2;
        Fri, 09 Aug 2024 04:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723201457; x=1723806257; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CXs4b1dg6xZmeIRz9ZbLqupex154c1w/Kp8NOYoyDs4=;
        b=Ha56ndsmb3L4rG8TlW/S7rPhcSo4p9sWiZcUtqgzC4imnafHxAlUgNAzco14gZGaMr
         DYz1EvM7jQNxizzQbpWTftToxGbjBQJBZv1AiMxcAmfKlFbDhGI4iJcJkYYrg4AiEcFf
         BwpE3GHEYkv2OHc1HImS4SzgYuCiMO/wv2HN4StD/vUClXg4vpGG+TZhwKdBYeYJefCo
         YQub30a/XMJdyQQxn8gIhF/KBOp97IFsPx7f0DRhE9KzL5GgYB3X98bmQ/Pf215KS0VN
         g52zPFpHiLIzrpAovMfffXONLev1+6IqIUX52fbfWT3AX4aVVEFQq3Ot/uYN67pdFnpj
         bpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723201457; x=1723806257;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXs4b1dg6xZmeIRz9ZbLqupex154c1w/Kp8NOYoyDs4=;
        b=efBKS9g3UbN8HZnXE+orA5KsJm8BP4WHui2bkfHc7LMDnekiDcYOT9ThxDLLmmtYs+
         EOpucqKTDTPhBkrlN5XBLjs4nDtquJpW8GzkmZbCuNhjvgYXp3fxOnRnjT95rD0G/Uyg
         a6xbu6Nij1YH5rSBdf8yccZS3aSBFHe/3OeVNjdOX8WwJ0q/GWPEG5BLhS1YzFltT1I/
         E2zKdKAaMuCbKKkzkesVBmmOqXjJTGFqLgazUJP5nR05z7gVCaYen+VyOxdD6kLB9hvJ
         5LHirBmj4iHEf5UUi0MBcZu/MqT3dDYL+DYPGeuuVOnaMrMtFw/goWfAwVqLhndYU/+T
         AOSg==
X-Forwarded-Encrypted: i=1; AJvYcCUchdcqNPeKf/Tld31AJ3CRYFt8l4KvKI7nQkZa4PxK33KDq4xbw0zp6LOCw3EbJfmQt4e7/MlFjIOHrZp6nbtJmT8ua2mrrZoIoJnD
X-Gm-Message-State: AOJu0YzOTiYX4Mcjty9HteSOQzAUkSmZovo0qzWQyRzpzoEqJIlr711Y
	Yr9lLtuJE1CmCgkbfyawOfsCORk/mtO6+ES2XeySUBCegoSwSajU2c2NklavC5A=
X-Google-Smtp-Source: AGHT+IGHspZsJuWt9WKlQbQf8dLUXBYQwhfn/vxKAjZAQEz3ZIdbjqtsZlivlK/DN9RHmQJ/Ir60cw==
X-Received: by 2002:a17:907:f15e:b0:a7d:a2cc:5d9 with SMTP id a640c23a62f3a-a80aa67ba25mr100820066b.65.1723201456888;
        Fri, 09 Aug 2024 04:04:16 -0700 (PDT)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bc3c8bsm839346466b.1.2024.08.09.04.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 04:04:16 -0700 (PDT)
Message-ID: <62ec4a230339da56c421e884c312b0b6141abc60.camel@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
From: Bean Huo <huobean@gmail.com>
To: Avri Altman <avri.altman@wdc.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>, Keoseong Park <keosung.park@samsung.com>
Date: Fri, 09 Aug 2024 13:04:14 +0200
In-Reply-To: <20240809072331.2483196-2-avri.altman@wdc.com>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
	 <20240809072331.2483196-2-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-08-09 at 10:23 +0300, Avri Altman wrote:
> Prepare so we'll be able to read various other HCI registers.
> While at it, fix the HCPID & HCMID register names to stand for what
> they
> really are. Also replace the pm_runtime_{get/put}_sync() calls in
> auto_hibern8_show to ufshcd_rpm_{get/put}_sync() as any host
> controller
> register reads should.
>=20
> Reviewed-by: Keoseong Park <keosung.park@samsung.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
