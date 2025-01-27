Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1C98632B
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 16:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737995451; cv=none; b=N8bZUop7Cn8tLwQF/N38cLT1mqkqhEVOxoIujEd+mN+1IacRx8z50Bm/5fRNCqZcyE0m3ehuH40n6GuYwNnr1E/pl4s4Y+xUJElBnoJSgFAYksRANO/gGuwXcME9CTIvIhQVZL0b+tq1HDLI/At3+Bfnc+n3PTo96f1rNykf/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737995451; c=relaxed/simple;
	bh=NJcpODpBkDL8az4Mn+xcZ06dSAItLCQL0ea5ixqU3Ss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gxS71pWwO2SGv5lKj/jkLs9TYzupsZBBl2IyzWtTQaTPOsW+0MGhlHT++PXgJgdpO6LQ08GaiVC9Q2u/ZMy53BSJeXTKBZm0BFSgHYwLaZ6nn16GaS25YcLK6W5hxiGROEC1jFw1y4bxjqS1tDx9eaxLEy0YDKiz6DjyUrw8N+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYp15hpO; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYp15hpO"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3cf094768so8800192a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2025 08:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737995448; x=1738600248; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NJcpODpBkDL8az4Mn+xcZ06dSAItLCQL0ea5ixqU3Ss=;
        b=QYp15hpOAfRM7lwO3ZaeMcEb/KhQl5POQsm3bg6AWQ2WOzYtfHdgpTSRjM2MqKCSUG
         aMGo2VJ4ni1LSwcbV6XakyymMC5rgIJG/qy3O09dubvyCogdDiTSflicm66OnW4E+svI
         MLgDb631AkhEuyLjsVrTqG3GjszJQ9s/ITSYcOKaGkTAVl7QNCp2nKachjWH4mJ8VNeS
         6ZI235fXi3o7QzQ5wCujhvwCnjhbrqfyvpo1o2r8DOlduH8vXssMTeeMnlwV7l8BhL42
         n5G6dbvF+p9P3NMIkIUjMe72aXNtzljYaBhYM/NoD88UGkyxj5xug5x0PhEAcJxvA42U
         wwaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737995448; x=1738600248;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJcpODpBkDL8az4Mn+xcZ06dSAItLCQL0ea5ixqU3Ss=;
        b=U9OkiDfo66A9tYCyE9SF4MVo1IXARWGHvJpugvUCP4xp8QGNrRG/fhN5BiWKQE0JDe
         uENKFh6u4ki/2MqhePnhiEYhg7XTJjmJCayfzVMrKtlPcnBhbGBqOFrlG3fIaommPlJZ
         ab6/gSFJf82t3wFYf8NzSBf9kVzWals7Jfm5n+TbCt+bU9wpNqmjhM+EwxunD40NOKHU
         ocLrH16OXTrLLFW1hah0xhaCwsCjxRbyDeilZHacjjFCJ6kDFgMZA5PpKHuceNM6tRBd
         p7aYanA7sq1k7wWL8mP9Ua+FqtOnyXFlxJTH4gICuy1qJCgleMrjV3BIrS9ZKRFTbXcu
         FxjA==
X-Forwarded-Encrypted: i=1; AJvYcCWiEXMf7hwfnzTA34+3zqWBkega5dMbAhW4RfEIKqZcfb3HmJcNSYnt0QNCFXBzph3uzXz5kFtKdMLy@vger.kernel.org
X-Gm-Message-State: AOJu0YzC+BkhBFksB49dZAWdFMrq0WQsEOj8hIPoo7uV2M++GG0hCqm7
	UthVNj1nRT53OGO0phHYbIr95kYuq7WGmFNF7QCx7H4qTvK8/dNzAJ4rxvyZaHiD4u6yZoPt2BD
	ra2nPiArufT8Gg4KgGsUHpk9vn4uDhmEPiRY=
X-Gm-Gg: ASbGncsCX8gtUDS24k4O8pXX6NA5FJF87yptP18imvCj7zXap31FQeOv3VPeeYD4wnZ
	wN6W4GPr9A+dQ/zNxghgNlHk+jEwqmjZJu+imy+YSsGs1xCHhOnXeYUxkVBxQbDs=
X-Google-Smtp-Source: AGHT+IH4Hg2ja9PHXsWUlxALPRdk7O9Natg/ThYu4TL/SSVWScEOL9kAECYG7ajmwAEzw//QMJql+uPqMawtQfsE+ZE=
X-Received: by 2002:a05:6402:27cc:b0:5d4:5e4:1561 with SMTP id
 4fb4d7f45d1cf-5db7d828becmr35936761a12.20.1737995447178; Mon, 27 Jan 2025
 08:30:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+=Fv5TdeQhdrf_L0D89f6+Q0y8TT3NZy0eQzPPjJfj6fqO=oQ@mail.gmail.com>
 <alpine.DEB.2.21.2410300046400.40463@angie.orcam.me.uk> <CA+=Fv5SXrc+esaKmJOC9+vtoxfEo1vOhgfQ739CBzmVcArWT8g@mail.gmail.com>
 <20241030102549.572751ec@samweis> <CA+=Fv5RX-u_X9UgpMg6xzwc_FwLZus7ddJJY8rHMMyUUGc3pxA@mail.gmail.com>
 <alpine.DEB.2.21.2410310517330.40463@angie.orcam.me.uk> <CA+=Fv5Q=eS1O4nwiHkJQRpvZ+JiDncnEZtqCUAyBPf1ZOtkzzA@mail.gmail.com>
 <alpine.DEB.2.21.2410311656400.40463@angie.orcam.me.uk> <Zyh6tP-eWlABiBG7@infradead.org>
 <CA+=Fv5Q_4GLdezetYYySVntE7KBB2d-zhNGR3rXawsvOh_PHAw@mail.gmail.com>
 <alpine.DEB.2.21.2411042136280.9262@angie.orcam.me.uk> <yq15xp25ulu.fsf@ca-mkp.ca.oracle.com>
 <20241105093416.773fb59e@samweis> <alpine.DEB.2.21.2411051226030.9262@angie.orcam.me.uk>
 <CA+=Fv5Q5Q1BUscm2Tua9y1b=2f33+3SkULNwe0gKQpJFL1PLig@mail.gmail.com>
 <20241112145253.7aa5c2ab@samweis> <CA+=Fv5QF7yUQd=CnrrDSwrFVbBC7wGdzXffJV__AjP9TDxqw=A@mail.gmail.com>
 <alpine.DEB.2.21.2411251925410.44939@angie.orcam.me.uk> <CA+=Fv5TVZ7v43EQ8jx7g4RV0n6F6Wb1N83oEbeWnMAQbNQvT5g@mail.gmail.com>
In-Reply-To: <CA+=Fv5TVZ7v43EQ8jx7g4RV0n6F6Wb1N83oEbeWnMAQbNQvT5g@mail.gmail.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 27 Jan 2025 17:30:35 +0100
X-Gm-Features: AWEUYZlh-NEZaMleqtLsvlgAdok19XsxM__35jI2WILd_VaqsEIJx1VuFb3qQww
Message-ID: <CA+=Fv5Sq89wYF3a16omtDUTnbjb23sUY-9ef8KjiEtNp4bv0Hg@mail.gmail.com>
Subject: Re: qla1280 driver for qlogic-1040 on alpha
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi again,

I'm returning to my qla1280 driver issues on Alpha. To sum things up:
SGI/mips need full 64-bit DMA addressing while anything above 32-bit
DMA addressing on Alpha will result in file-system corruption. The
hypothesis so far has been that some ISP1040 chip revisions don't
support DAC. This feature only appears in data sheets for chip rev C
so it's reasonable to assume that rev B and less do not support it.
The problem arises on Alpha systems with more than 2GB RAM installed.
Up until this point the only Alphas available to me, which has more
than 2GB ram, has been Tsunami based Alphas (21264 UP2000+ and
Alphaserver ES40). I recently got my hands on an Alphaserver-4100
(Rawhide Family) with 4GB ram. On this system I see no file-system
corruption with the ISP1040 rev B card, even though it does seem to
emit bus addresses which are greater than 32-bits, i.e very similar
addresses as on the Tsunami based machines, the so called "monster
window" (where address-bit 40 is set). This gets me thinking that
maybe this really is an issue with how DMA/DAC is handled on the
Tsunami boards, rather than a problem with the qla1280 driver and DAC
support in various chip revisions?

Any thoughts on this?


Btw, does anyone have access to "rawhide system programmer's manual"
referred to in the kernel source?

/Magnus
