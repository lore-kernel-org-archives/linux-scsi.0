Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5467126ACC
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 13:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768570929; cv=pass; b=Hhh0y5iNcO7vVV2Ux8DIdBdUM7t9DJq8Q/o6pxpBLCYHZQCK8VeeEir0/pPiZ/HKBridWCZCR+LwnFc57PoMFB0pdfP+xDqouHvO3wUBOQhB/wMPoLc/0D+IPHsMQbnHZxeMeAwMPoBl8VAaL5CBhsJCpzwt20RDwpKtEJAQtBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768570929; c=relaxed/simple;
	bh=TbLdI6/nq3E8X1CVvm93X+Ndt4WNaKBNNHTY19nvLzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAMLFv7Q6CC2ZPeSXaqOaLoK8Fdik6flYl0oG68sP9dWBykMFXWxB21L+eFGUbAHbFxTU6v42/VQj7KeYw/n9Mr6rLwL1d9bnrQS9RC83BDpsoOcHGWu4MWiH/9agNIuXnR5Dz7LqIwYnOcRqyNCnKjFnjKfoeshZrmHFP/fq9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G7rgQBZG; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7rgQBZG"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b6f22bc77so280854a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 05:42:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768570927; cv=none;
        d=google.com; s=arc-20240605;
        b=j0Poj+BW74dNVVcDFHB026SGvEbeJ8wnfJXCW+zVEwm/75OFzeVvbE88XmkMLJXP+d
         Q/VmHEt3+Y8lIA74+yxKCDcMTPT4efvox0VeAEY9jYoA+pRCP/lPvCytAJ03bBaBtDRv
         1vCuQUDwX9D3k4pNw5+bw5H47rBKmtZk9s3kJ33SqPoYQ+pUE6jJyYNrrA5y2N7iJPZ1
         4eT9fhafxw0fQd2XhXlDE1MMb26ZWSkZ40b63C1qxpXfc+xPlD+F707bba7m7oi/3p9j
         ijsd+BeU40Q4vimdLTZLlCxZD26D6wvVPqp22OsgAzAL+j+HFzoipvgyC6SXAn09CjP8
         PtdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TbLdI6/nq3E8X1CVvm93X+Ndt4WNaKBNNHTY19nvLzk=;
        fh=T7XOA8RDuv+iRSPvz4lE2Evhy2aScQ6VtfPKfPXg5XI=;
        b=knw0hVuK7XGfRafo/Bh89Uop0/kc2YDTRk9R5XQqHVvgby7PCrlgxaN4oaHHGEUpxv
         4Hwm9sQDn6Wa0E1z4YuIlYEWPLCOvgDAatuqYVv+NTSPTV7WJcg5KwbuTN5aH8LA+kzk
         63ST8WwX3Boo1MO9fVXs3JWIC6amnQZekmwsLS6TsNIkY+5OtwTaQB1gkLuxTkq1D0UI
         7LEIAPtiLEXcMZ4LsrHGI9/C8rGNsTG7S5gs+88HsNc4NodY5LMaA0qLjYWKIeZj8NJk
         MbUKbVwVdPnu+SuPEmkcCw54I8ta8zBzFOTRWVbdG6svExE1444zEw/Hf0vHn0STjSdc
         nFnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768570927; x=1769175727; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TbLdI6/nq3E8X1CVvm93X+Ndt4WNaKBNNHTY19nvLzk=;
        b=G7rgQBZGJSkpO1elmfKZaNuPADuBQv3d0i+k9RI4Hl5XzWwt6IWDD+K5ml991/K6VP
         7FTOHapRHgBiFhCbOSSv3n7pT9ed/LVJF2AAz1kC4hWcn+nVnoBDrulcLAMmXzI7in1C
         JDhssxBxlGUblxgOSRJrW3vi9u1ZjsnoEA404oIVJLKYfLBxYcgTJw9nCSQPX+o+cIkP
         6ZlDpy53vzTpjiK/+rAvOeh6iYRoaCYXsZocpO9OXvdQQb+stK/+8gYP/RVfsGcvZS7S
         9irlKKQR/TJJ3Zy4Ekh5e0JsNhdULPYPr+SbSmM+Gs+NbThdrc7ttXgpwRoOE++0Xde4
         rx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768570927; x=1769175727;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbLdI6/nq3E8X1CVvm93X+Ndt4WNaKBNNHTY19nvLzk=;
        b=jM/jaSNBW8FjrHyety+7JwBWC9GRgo4XkdEbbtr2MDj5VPuSRwTbjGtkhLvuWgrHRS
         79O0+upNjNuRSKg+BctCb/hjgO5UB7/Ye34Kp63eg3BlGsACJuA2WT3d8204LhxaG4Em
         dEnuaWDtw5npBHbXlxMUrxQOGohOwdjZXFZMtddXB7l6JVT4+3pSKbtlIKSh7qjbqfk5
         soxssxHLckFBQ1lkpS+3anuUt+YAlmo3vneS6QdgatJQamvE9RDnKZZz+3Onjbp9nhgh
         koAc/wqz+P9T1WGPLxFTrt5m9oubnGGr2MUEFz1iS31UBFQgtxBZX2SwVmc0EfGSoAj4
         1mxA==
X-Forwarded-Encrypted: i=1; AJvYcCUVYtmOZXIjKuXiBk1r1adlyybbWfeP2jBezCCxz0cWTrDd+wZZ1BdKhwzBi9MINdqAZy97SP1t6GEG@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/QqR3FEqpFnDLeNZGS1YWw3h1lm9nJs2Sn8SqJRlwhtyqMips
	UYgDGHtZY5vlOL+XDwruzoSZ5tJ6j+aG1ApMZqdViG5AuherzVu29Gp31h4WGg2xkJ1um2QCv0s
	dnvPHSZKeSlVHYLigw1ddjPuJ9+o8Omc=
X-Gm-Gg: AY/fxX4mmHJHJ6Cw6APjwTOLAi1MJor0sCEl7kIq2z/HEdafQIh8XYgFtPih5u99iKO
	ik5IjU7HimeKterFHFMWFpvuAKF9cU2+r+39Pvvrt2SgNvcYIh9fSBlzCNG8U/5dk3KmFPIeLA3
	JTE+A2GDOsdoifFyPGHD2YTWQyR1HwnY9UiykFPdx8wSet7UaX8ZfXRxwfMLsk3a1iEJXECcZjs
	npx4VMW7tDsjm8t9Hxm27Iph4A1tSxuP6x8/LU/9f6D7PUyZMcucL5V2Q8baOLzg08DE+kD
X-Received: by 2002:a05:6402:2684:b0:64b:76cb:5521 with SMTP id
 4fb4d7f45d1cf-654524cf81cmr1297957a12.2.1768570926455; Fri, 16 Jan 2026
 05:42:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115175427.290819-1-dg573847474@gmail.com>
 <CAMGffEk3cgah3-xTaokDeiM0RGwKQn1OO43dWLJAwoaVDfHWdQ@mail.gmail.com>
 <CAAo+4rXpSK-LzrHgU0g-c3n=q3xB3j+-GtmUZOLqQ7S44yS_2Q@mail.gmail.com> <88b042009eff363d098f8b80238329385837c6f7.camel@HansenPartnership.com>
In-Reply-To: <88b042009eff363d098f8b80238329385837c6f7.camel@HansenPartnership.com>
From: Chengfeng Ye <dg573847474@gmail.com>
Date: Fri, 16 Jan 2026 21:41:55 +0800
X-Gm-Features: AZwV_Qh2eJSxC5ZH_77uV3RbAR7ekxUzfJH7Cna3mv8L8Pf7UMRAHZ1WGQ7KY18
Message-ID: <CAAo+4rWk2ZgjSVk9bMSh683drt-bW9EjkYgBsS4q8CcraGDEBQ@mail.gmail.com>
Subject: Re: [PATCH v2] scsi: pm8001: Fix data race in sysfs SAS address read
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chengfeng Ye <cyeaa@connect.ust.hk>
Content-Type: text/plain; charset="UTF-8"

Hi James,

> I think everyone would agree this can't happen for built in drivers
> (because user space doesn't start until long after driver init), so
> your theory above rests on a race between inserting the module and a
> tool reading the file which can be fixed by waiting a short period ...
> it just doesn't seem to be an important issue.

True for the case of built-in driver (most use scenario), the race
window is short.

> Whereas taking the internal host lock in a
> sysfs read routine could potentially be a DoS vector.

Agree that using a spinlock just to fix this hardly triggered output
issue may not be a good idea.
I think this theoretical uninitialized/torn-read issue could also be
fixed by delaying the creation of the sysfs folder until
initialization finishes. Can help create a new patch if you'd like to
improve the code, or we can just ignore it if it is not worth
bothering with a small issue like this.

Best regards,
Chengfeng
