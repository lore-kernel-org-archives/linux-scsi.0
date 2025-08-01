Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843715A8;
	Fri,  1 Aug 2025 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754087718; cv=none; b=oEuxL8B7VOoHchFXxhL2Jo/KGx/KBr5pJDu8QCgCNu45/PN4h5PlJJ6+5+aF/5vSrGSbdhIhrGeClG1Zhoai5RR1fCM5mVabU6OWUf9gDTl0Ay9WMoQajfsyFjI06Tn+bq9rut87P7IlN14EB6zJbldUno8PGu7OBoEXwttRMrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754087718; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HjmQj45QCUAfTKNsfDhcTrd3p26ZgTxBtp3zEOAJLmxSOH0B96irnztuMNge9nbh87X+SfJwQHz+/lX97bT0Lm6Eq6Pcv723fuS4tage5yf4TNkE7DO0APiPuPATdrm0FnjQ5USU51Fr4LD89pAumnEOyMG1F/lDhKWPqsU1Nhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hEf5WbW3; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEf5WbW3"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71b737ec362so12222627b3.0;
        Fri, 01 Aug 2025 15:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754087715; x=1754692515; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=hEf5WbW3w4GTBjUyzG0kqnMsV0ymc9TbM+Z0RPGryVS6oQdQ68zxgxL0vkAkWRGfWi
         eWLUgbmE8EvsYy6VVAamvRE51XapaqKfj3g3bZ1tQMWCpbMYjOn3agTCRtw1qgauDd78
         ULEmfU29C/oOL6Pvm1AmQu1CcxuLjp3L5qNNwiUHZjV2uIWFpxC35kzetk61+DriW3uS
         0WTngx+e12yeJhd5uBSuQ57L/42C/SkLriCPTgsgF3gFtq3eIomkUVn4k9+x0O9MskCJ
         Vuuxj2Bn8/BpDRR3sa4vCESuX+2bfND0gyZ10/nJ7rQMc+P0NanDRgvljYs8l7/Ll2Jk
         XvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754087715; x=1754692515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=JSepO7lnY8HUfLjTGLILiXqHtn3AmHSooY2QPYN4qJPyLFLPcL18wDatqraD2QKvHk
         HqWF664XOwVdFMJwfLLA83Jci7JWlJnjOpWXyDxQFQTJk7KFM68gQVss5Ai4GDakCHeE
         RUMl7X66Y8IVHHVr/iBm7inWfr8I3dxXWEB8Rd6QsvOWRY3nZbYOzcI2I55sG9rtZcfS
         QBsa3u+tXo+bdsR1GlXivEHW+VleJiVEUHV04TNi+VxPv9+l0nwuTxuMwl2seGFHTlIF
         HysTBPm4SbKD/rPVAOVhCBZQpXkFTiUAJU1rPlQKCFaKgLhfznTTPGKxer0qKVDINw0c
         rxVA==
X-Forwarded-Encrypted: i=1; AJvYcCV0LsSs3y55JMx2DnfkVuzqa17eiDH42r/IpYSzAJDAlPOl4tMwGhZcpN3+m2dUwi1bjPBYcyTzkcZn8A==@vger.kernel.org, AJvYcCXGAQZYdHIb1PJjOGbNe+PZbU6FKM2YrHbxut8WwrWnsKlYHNDQwHcrFscPHWvjZe75gWx2AxD60KagX0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHHBWw1tudO/5ef0IUMbeX6cxnVOxP0yNDUxEUs/2lGPmRezsM
	BiTaJwqCoMHp9q6AJoP+pvYtjBlHaiJ8Ex2ajkRzkbKKW7mX1/ptUeNDQIx73JzPmh63Qu/kGuE
	RUfoiBku7DLdXp6w1xjwzvvug0U8xXrs=
X-Gm-Gg: ASbGnct0y8o1T3izY85lLVFDSR5rlX1E/feYlSrGmzmu0HCrNU0Qj/RICP/mKF9Vx0S
	BSa0Eh2EV7oc0kSzFsO7iDtNVglo+kVk5wJzRVEKRtT19Zosx5HS1DwZATxIAp+pueMiipC6q8L
	ZMQHhlCfRAr8veaFSPqip5z4dsV6WroeGXr29BbGKzch44CQgYB5IZ6+NwkpevRsaajztfTxk7E
	dQ5SOYE
X-Google-Smtp-Source: AGHT+IFi2Zjp5vZJ2utAdRJjj0113seSDlha4V01BsuCoBuJBa8Jzc4rsI+5KoCO/l1q6fpeV+NpMpxuff+EFWpSnW4=
X-Received: by 2002:a05:690c:dd4:b0:719:6608:f488 with SMTP id
 00721157ae682-71b7f563da8mr20749177b3.38.1754087715102; Fri, 01 Aug 2025
 15:35:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801185202.42631-1-jiashengjiangcool@gmail.com>
In-Reply-To: <20250801185202.42631-1-jiashengjiangcool@gmail.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Fri, 1 Aug 2025 15:33:51 -0700
X-Gm-Features: Ac12FXyMlFzNZMstdIJdmEbFgAkZJrnU4JfGIRuTtMNGI-uRRbbSow1t-sB7rVc
Message-ID: <CABPRKS-gAHcOQ7XHsq2OLBoe-oAy53Mdr8eHbtMmmJHXYjmPhg@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Remove redundant assignment to avoid memory leak
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
