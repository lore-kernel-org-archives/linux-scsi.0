Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AFA200110
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 15:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251773; cv=none; b=qeIlKFE4+eYJwlBKwcvknCsLd/SaZwienhD7+Q+aF5hEYUlZKjQVCbIvB02nhSXncjp3uhfWEpLLujCaGeUnJ/JiYNKIrNUxKnVCtW25J00nFPUSEIPqaXBzJ3dunj37fE/ZMlMPHdx8g1wipqikXUaVxRaqmJz+SIWv1FtQB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251773; c=relaxed/simple;
	bh=zmFAmQ6VQsIyCjNwoHnY56NlKQh20ciOmxKzN945hNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8L0zmrn/8IM7PExMaBlDz15bwQGP4dvZ6ZPGaCp8sj/nnnrLtJcEEXMJNYDnwOhJGjOX4xAl2A1tbUvDjHZFSNad2ABjl/qNqwNivptXHVXCj/qQAQHPXZU1CxcMYzbrLUlq9sNtW+vZPbsotNGj6REu3MeAygJsi+rn6IDyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=ilXiG47Y; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="ilXiG47Y"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8efcef23d21so29985196d6.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 08:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1785251770; x=1785856570; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DNDsfCWu6nY/yb2/320WsNlh3QCHH2R7ZqSKweQdW/Q=;
        b=ilXiG47Y/3rD/4ioYzImHrSLNjLELyw4r/drgM8LOgS5L8t4/U1flpiSYpq0wNTZ0l
         ZJK1W1K0pVHOv20rUKWp/HhncaWJZReehLjiQXSS/bVPhhptgGXCp9Ud6ADT3LJb12oy
         +P/+0OOCwCEPBMgQgzdHjs3rxoXZw4LIfvyIwLZ7kTo6Bnt3xhKSFLLt/hcdqVZBSevQ
         ofUWr/sjM6u2ilmu55OefEnGP72oxALKBEsq99EJY9ukHF2CFmyQF84dJKYT33DQ1Sun
         /JKX9yjir5TGaBiFQoMDfavG7S6LlcF0tfzW7+OvpGJ+2SUDIUN2/MJ/M7A1/smJ56Mv
         4URw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785251770; x=1785856570;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DNDsfCWu6nY/yb2/320WsNlh3QCHH2R7ZqSKweQdW/Q=;
        b=XNr4nBP7iNAASw8NeJ7eRxQtpxMykO2kdsZplk76oVgwa6Ccm1ivYuhOhWEnUoEeV5
         c0Mwx7AzQdscCSaFSg/bcmtoTgLEi9qGMjO7rua+WxbTQrM8xl7ry7oGAqQC1VzJQh/n
         oyP5oxii1YZ8bokVNiZm9QbOYYE7rg5BeY0nXJs5tkK/z7rI4bcwNXfY7BcsDQBhgKba
         rnzh5YP/ZteKnms5vMco7TmMn2AvQw/9Z8omKs5MWlGVYxZp+HIjaCIyoO4VWfwzlhHi
         B0E4EfTg7u8Dird+Vc1RXOnQhr63SjfwF54Isjhc2SPj6ttNyncMAyHig4Og36L9nHoF
         ob1A==
X-Forwarded-Encrypted: i=1; AHgh+Ro9K6j+D4Oytnibe3s32Zc7z4JeIIrMef58j4SHnVV70/lOrRG9OHvv2sQcT2ysV80AISlyAPwZjrkv@vger.kernel.org
X-Gm-Message-State: AOJu0Yy630kG/qTUJ+e2AGuK/nPCsrUmJb9Pf964RlCAecovDLwCLPVH
	YsSXeEdBS28R9I/WrADXULg8mKwKGAVLFGMr1u7L5QQK7t49kXj+HrCCPjNmsMnO5g==
X-Gm-Gg: AR+sD10cO8QAe56sqQGUjbWtHog3eJArfs+c7hzH3cSTUkgDjfpx3yG5YcEoWoPpa4V
	y5rsc4+Kcp0ZU7o1sIZmxnDMk7QipoEJ626TlSfPrQ+5aKJufy+LEJ0oKGLMLsceQSngoNOoWGn
	JnG2bqkoHLJXIGZRQpd71yRjF25gTioP8td639fzQ8G4JJL0K0JeYajzafS5hBK+cf50IRZkDbr
	d2oK933zdb591uypBLGYB+s53IwRpo4uTDfmdbiFUqY2XzKVZyq56+Jswj1i5yqjSkZCKoi03VO
	RP7NUTBC4PvZzhgU+58WPMq1RKl92i/JTHggj/UJdvTMhHQzNGMGxMy9YOKeD/4y5CEqxu5xiAZ
	4kfZwKzlWy/zqYjWCSgWSouBxS65ISWezX4TZ5SZa9otkSROQl+Y6ZW7yqPANiX2w6SfO7Vi+Se
	UNua8=
X-Received: by 2002:a05:6214:3d9c:b0:8f0:3b2c:a9c8 with SMTP id 6a1803df08f44-90816f7f1b1mr29721296d6.12.1785251770329;
        Tue, 28 Jul 2026 08:16:10 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::883a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dc8396csm1305126d6.18.2026.07.28.08.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 08:16:09 -0700 (PDT)
Date: Tue, 28 Jul 2026 11:16:07 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Fang =?utf-8?B?SG9uZ2ppZSjmlrnmtKrmnbAp?= <hongjiefang@asrmicro.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jgarzik@redhat.com" <jgarzik@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: core: pair EH runtime PM get and put
Message-ID: <4d8cc771-6dd9-4221-97a4-fc4339e4745c@rowland.harvard.edu>
References: <20260727055615.2287217-1-hongjiefang@asrmicro.com>
 <a432da46-7b3e-46a8-8c6d-1269d51b44b8@rowland.harvard.edu>
 <f66bc8e5bf88459083e36fa508a7f4f7@exch02.asrmicro.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f66bc8e5bf88459083e36fa508a7f4f7@exch02.asrmicro.com>

On Tue, Jul 28, 2026 at 02:22:29AM +0000, Fang Hongjie(方洪杰) wrote:
> Thanks Alan.
> I agree that a plain local variable is not enough for a compiler-level
> snapshot.
> There is one extra detail here: shost->eh_noresume is currently a
> bitfield:
>         unsigned eh_noresume:1;
> so READ_ONCE(shost->eh_noresume) cannot be used directly because
> READ_ONCE() takes the address of its argument.
> 
> My plan for v3 is to first make eh_noresume a regular bool, then use
> READ_ONCE() in scsi_error_handler() to snapshot it once per EH iteration.
> I will also use WRITE_ONCE() for the writer that changes eh_noresume while
> SCSI EH may observe it.
> 
> Does this approach look reasonable to you?

That should be fine.

Alan Stern
