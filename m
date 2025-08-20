Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F22186284
	for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755720389; cv=none; b=B5DdJIc6eB69XAcgNL847awDKtgIcs8q+4yYWWVRiFOsWXOO5XZg1FxVUp/1C/OuXU1qgIgwioC6yDhRodTC9oNsujl8LKjVySaLwCSyimfEfGKXLs4tDDJtUPslunffFiS3Gef5k+yPplJzSwSCaH3SDS6TZdO9MEyx46fBduw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755720389; c=relaxed/simple;
	bh=ztEsOKgOGhkOLLBEaxQErT0eY/aEkvcpopDJpCjcwqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPz54Phundphxz+h3p3Ua9wzSXD45+qc2jkTRen3PCvm/dTsrqPjdDuX5pWpmZpZ+opM7tCuhMnzdo/2gy7wt1GtwbZoTADgpx7uC2Z7g6zILB79jjqtESJt3hGvsF9XIPKWntm/6hA2bjsGn4UFfjtSdZ8n3zQQQ7tfmwTSTOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk; spf=pass smtp.mailfrom=philpotter.co.uk; dkim=pass (2048-bit key) header.d=philpotter-co-uk.20230601.gappssmtp.com header.i=@philpotter-co-uk.20230601.gappssmtp.com header.b=EXZgzHI4; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpotter.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20230601.gappssmtp.com header.i=@philpotter-co-uk.20230601.gappssmtp.com header.b="EXZgzHI4"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9d41bfa35so243667f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2025 13:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20230601.gappssmtp.com; s=20230601; t=1755720386; x=1756325186; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPRIORLZJLic/0oP6MjeZBOD75ymlcPvAsVkfv5abFk=;
        b=EXZgzHI4+vecfCg4WAvD6JbDNl5yTXYeyTFw1DLa9df1N8NE4cGI5wvQeOtd9cwFxi
         3/JduaesuRe4DgmhrjG0lyXMN9mp/FgiuxaJfU43ZgpCj0DA22SIRNK4Q5rhVHSoR+zK
         9fnqdNYK0Lo+AvARHJbitxUNt/YKj5PzzzAdJzGGgcCeaKzXfSdO/FlKIrZtQ7ydIyU4
         ouPR6mdkEY1N3HHU2FuMwtep73ssaf/xiIqSIl89+yOpxnIe5ys/GqSEVSxb85NRnpHC
         xnHj0GfV70/DnbkHpouZsAq/uZMqlRgBpDOptNTrDFs8p1As9hZxHh6M2ZJJY+j8L/5c
         hyQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755720386; x=1756325186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZPRIORLZJLic/0oP6MjeZBOD75ymlcPvAsVkfv5abFk=;
        b=SOrweEyPZTT+ddmcelb8DivQdSYO4HUh/BBc0i2dSJtPVV823JxEn6rAC6GKSXyQqv
         bj2CUFUPDNOLeLj9HeWQ5zTAcRyHLQvUWEQpK3iovq1dL8NOHJZv+BuAbe6gEXtDI+2x
         JEIF7an7yFi1+uW93Pu40LW9biQSmaUbmsM81DFtDO5GxJuAMOihV7xiC93pfsbCI4cO
         Ln69A8GNnX2mbrq81aZ5KgF0W1EzzeTenU6yYOcw6M6Bcz4qkRp8G2QHJpd0/IY9Sfwx
         0VGdrd+FcnRIuWEQi/TQZG3DYynj0ggGz2yXQzw2tFa+WQx8AxeYFS9Cvj4d0+k/BKfX
         PdXg==
X-Forwarded-Encrypted: i=1; AJvYcCWCWBr/7W74DjCM5FeHd/3T+TTK4GgxRfEvSUp0PprUt863fGnjFr6AMb1tgt7vyaQUCplNeAEcI2mf@vger.kernel.org
X-Gm-Message-State: AOJu0YxEtAkEJB9QjEGjXAV3QSxPphBWpzIMyyWBGW1CSTo1lmcbAgZ+
	O5iPAXZih02VL+fKtC7etf27X42LyVKFHp2lYXAgwa6Yv7kZlXxQyoXqmpolgDJLdUG2LwZvutC
	stHCl
X-Gm-Gg: ASbGnctAdaJ3WCrmPHJmAG3piw45gzJ4eQYWYZXrYztjgyOylXL8wleRW0/gDzhaDMW
	3+BTHaAF7J3IIKa0+tSwCwexB1Dw+yqT5eb62E9XRA90CfEHbraHOCfP+ngqRS1BovAByZdyDDF
	T0EmssaXdBNR1bQAhmZ8Y1xdlhIl9WFlfw1iw2IpfVmSedTv6ZPcEOYcZ3v9fkyd2zzzIVzSOAf
	OpyDSqchX/Ac5Y154KXvcsAUl01gWIOcT/mTjJeMMj+Sr8SEUVrd0obsIiEDoBnhakJ9UA0T+MT
	cJ+mUPoG7eLhAHNxucSirH3pJDYpEI4atFcO5jiuMfWL+wxNKGPseAIof0VycTKUZu0VWR+LXxH
	JIGhvaTur4I2KcxP+gu1VVGE5rwD5k4FSisOOfD61jig+AlW9RKEYE2UebzqEJXsVGqHd4ymLU3
	yKoanv
X-Google-Smtp-Source: AGHT+IFZoRI0AMFMAPaDlpVvz3RfQCKXg26W6gF/w2Djot9dOTMU/+XmyPpjyGfYLRjptRJSFPlD/w==
X-Received: by 2002:a05:6000:4284:b0:3b8:d32e:9222 with SMTP id ffacd0b85a97d-3c495d47553mr84126f8f.38.1755720385979;
        Wed, 20 Aug 2025 13:06:25 -0700 (PDT)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b47c42cf1sm49041585e9.12.2025.08.20.13.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 13:06:25 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:06:23 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: David Wang <00107082@163.com>
Cc: Bart Van Assche <bvanassche@acm.org>, phil@philpotter.co.uk,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Subject: Re: [BUG] general protection fault when connecting an old mp3/usb
 device
Message-ID: <aKYqvyfSO-jSTZAr@equinox>
References: <20250818095008.6473-1-00107082@163.com>
 <2899b7cb-106b-48dc-890f-9cc80f1d1f8b@acm.org>
 <7c8215f8.87f8.198c6edb9f0.Coremail.00107082@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c8215f8.87f8.198c6edb9f0.Coremail.00107082@163.com>

On Wed, Aug 20, 2025 at 06:02:05PM +0800, David Wang wrote:
> 
> >Phillip, is this behavior perhaps introduced by commit 5ec9d26b78c4
> >("cdrom: Call cdrom_mrw_exit from cdrom_release function")? Please do
> 
> I manage to reproduce this, but It turns out this is not about my old mp3 device, but about my phone:
> Just connect-umount-discnnect, and repeat, after several rounds, an error log would show up.
> (I should pay attention to the USB Product  name in log......
> It is just that I check the log only when I have trouble  connecting my mp3 device, and assuming the log is about my mp3 device.)
> 

Interesting. It seems your phone is emulating a CD-ROM/optical device,
which is why the driver is being loaded and attached to it.

> 
> 
> And after I upgrade to 6.17-rc1, it could not be reproduced ( I managed to test 10+ rounds of connect/umount/disconnect cycle)
> So I think commit 5ec9d26b78c4 does fix my problem.
> 
> Thanks
> David
> 
> >Bart.

Yes, as you point out, this commit became part of 6.17-rc1 - it was not
present in 6.16.0. It actually removes the cdrom_mrw_exit call from the
module unregistration function, and puts it in cdrom_release instead.

This seems to have helped with the original issue - that of crashes when
removing USB optical drives on Chromebooks, and has likely helped here
for the same reason. Good to hear, and thanks for testing/confirming
that 6.17-rc1 has helped.

Regards,
Phil
