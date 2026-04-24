Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B257A18DB35
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 06:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777010443; cv=pass; b=k1dts0CHVOLoCObWPW31LrNJouAfdrrCyb+AWPe0DN9Swjohz4ZCr2FDBEend3Q8DmeirGX9XzxpdOQSHN4jBkOddZmNHJYzY10ghPFkzVX6CEStu1aKnPhetF3ozoVUpc7xyTeIHZb8w7rtW7BptK1cw5RTpKrHewhx0omQxnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777010443; c=relaxed/simple;
	bh=47+fEWej/SPazFwb2bx6i6bA+YnOTBp01O/lgG5e/4c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fdxzVhfiDRgkCS5OdZ8ZmCzGUIKPVflyOYV+vK9V3UiRH0lu67xsTVGd/GH4TFClprDilFhG6XlgV1OAnMDFu4xx2EgWwF5fvBjhIYT9ujJbP1YtFqz34BpOojpK3TXUdmhsoYjCIyGuefJ5Tx03OfHZ9A73zFubhaVstReTas8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=VNLGnCOL; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="VNLGnCOL"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9c7b2ecf04so125471366b.3
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 23:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777010440; cv=none;
        d=google.com; s=arc-20240605;
        b=ab8DbBTQ1Do79ER9inmAFoAAgBqxJpifbVp3LCNjzRCVOgmFAKJ1M+X7jQqmOJXh6m
         Ypq7HjiLOp2WxHgym8H+6dLLWzk9TZ9dm4kEkrXFKD3sawrEne2VW6WAEe8aO7HBhSNo
         dsyEFBsaG7nqC16KPQNIRgcqf5s7Rqhq5pQMNY3sde5G+PmwfG2BKZuuTkmj0IE1ozLb
         vFHbbwR6y1GWRG9yHPnDrJc3EMO4fRWq3pXG4/ObOsxDXt00b3aFNtAqUJR2fqxhAQs5
         EH8vfKPlHkPfBAv8iV7g0PPgnAJ2N9Hb2aulkjps4WN2om6RhG9cMY6HXZ5iEpIsIFRH
         vsIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8PshLiRG7065i8PHlCp/QU3acwVHNiiTlweYHpZl1ao=;
        fh=06py22iYVd1fNASj789UF+v/OIiqsJdwFN76UVMP8uI=;
        b=Abz5rk9an8Xszk2YbljslxmCqnOCseIfJgDNg+zLJfrmKvarDxBkZ6SYBuM0Y/UxbK
         AobWX/IkKOAf9fHkP7QHb6/i8psuuF8mOzqn88npll6689+dWL+qgEDukMXgpsRGnD3Y
         eFKhqpGzAjMwgy05BKFnEpghv5k4eTm9IljXfhxapX+GhIgEUUHgKVYiVzn7+xMEdPxo
         JZnP8bsKo3DuKusRGYgh9xTZnQy3MHeMsXhbcpngnDWeY3x+Mo/NAVqNZ8QSQYjtIKQd
         S2WjzaX0oxe/ZxWVzi/xJ/N6wgrc42p7MlkRggF4VNNnfol7OOaJheU/354OKTSgQqlk
         JsuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1777010440; x=1777615240; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PshLiRG7065i8PHlCp/QU3acwVHNiiTlweYHpZl1ao=;
        b=VNLGnCOLsgoyPm02XMvgBoTmFDvKzlEYao3gEZTNLyAqO13l17O8T3LsEQJRV6oZMf
         w2LFqbAzMPYp8x0E2QTVcTcdDpDkV+hfGEQfja85jhdHCg1aEJsrlyCjWh+sT5jujXTV
         Vdq2C6KwuxrivJMm7ShBiOEr83ha3es4yAX50BUcok6iPOR6LA+16e6lisqHi7j4sm6h
         ov68O/LOowJclJpDjcuiTxfskdgu/9M+kLGIReyyji26/csOq9Y67QTSSNXCsUCsA+Op
         bcsoczxeicS8s3hAf4Vlr+PDm/BnVcpM/WY9PyQtwZlvt8rQ5pZqxEir2x1fQfb9Hkyn
         KaVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777010440; x=1777615240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8PshLiRG7065i8PHlCp/QU3acwVHNiiTlweYHpZl1ao=;
        b=K3ZYeeMIo3LtjWiDGuzMg9KOZmH3gnoZNIyEigI45bHPOj+R9UsTMWISlWvpVnQDft
         fE2OVb/blkevfQE8OYgsjbp8yegGOPuRsqP47I2I6Rfxsbi0nkZIAJiHEHIvZqv0f8ej
         eHChSl+0q39v3QU5V/Jt4r8feD6EekDTt269KpoI2TlfZ1PluQguC/v/UroB2BbkmGIP
         nNt/pUc0p1vVyZji0rtVoit4vM0ROd7vQ8sQtoGmUs4DkR7jghXrYdDF6AFwsKfFfTZF
         JLYDiYu9TOgUf5WegMn2Gm0iaKh/W+ASIWt/+E6dp1hPufrpGVWJ1OCcjsn0uelG6XSZ
         0EDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kbBRh3WH7ZxDQd80BrKjqwvKWk/omm0Y3kndaWN2rVHeFQBsZnxqU2wJvqWRGIS6W27+ql/8cAjVH@vger.kernel.org
X-Gm-Message-State: AOJu0YyYnG1K0LFhbla7y8wQSFKrNc88pMNpMSfOQyMsgUQ9dRtVWvk5
	Jq3skM39QHHT8zX3PA4XKLvDrYolTgt6E5qQWsDxm86WeKLhumxewNePEhg6BwiIlB4EY+MuIpy
	lQnx/q0Wm1vtLlJMqstafJfuC7qZEOBq9F/IaQauSGg==
X-Gm-Gg: AeBDiesXDmR4LhZ6xncoWaFOaDbwS/adNPihBupieUK+GMzYyq7Cf489HBHjtFN1LhZ
	tQhufMc4Qq+5KnHD1ulsc4Ntpse++IlHl2fv3zKtABvfp5sXO1CjXlggM7E/vFi8jYXis0LPjyd
	UL5aF90A41OZsxGI/IJPtTzUGe6VHbk/PvFXDtM47cyxQIHtMMuOrOVqRX2/UXfTS5dXcEKZwGB
	wAVijvVIb82OFBQOmx5zwabZ/e6dJ5bSyY7niVubhz84JcYQ2i919iH+s3qbpaffERHGc0zbAQr
	MsFmrufkeirrLSoFqYhdOqqM0rrDBEXqs2RAOZedhYVtwgE21yA=
X-Received: by 2002:a17:907:3e8a:b0:ba2:a0a2:6f8c with SMTP id
 a640c23a62f3a-ba4154d92fdmr703485266b.0.1777010439897; Thu, 23 Apr 2026
 23:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421212218.433963-1-sagar.biradar@microchip.com> <66414927-481a-4464-8a3d-d6d77ab1aefb@kernel.org>
In-Reply-To: <66414927-481a-4464-8a3d-d6d77ab1aefb@kernel.org>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Fri, 24 Apr 2026 08:00:27 +0200
X-Gm-Features: AQROBzCqqvZTzC3ZruKyzhYMgsZVz1eDaE7vzpWo1FooqpOWX_GKiWyL7bzvFgE
Message-ID: <CAMGffEmirEUEy75ZULdXFE13WLMnciWLa_YsLQOyF0r6TArzPw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: add MODULE_AUTHOR entries for new contributors
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Sagar Biradar <sagar.biradar@microchip.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, 
	Don Brace <don.brace@microchip.com>, Raja VS <raja.vs@microchip.com>, 
	Kumar Meiyappan <kumar.meiyappan@microchip.com>, 
	Abhinav Kuchibhotla <abhinav.kuchibhotla@microchip.com>, 
	Uday kumar Bagam <udaykumar.bagam@microchip.com>, Advait Churi <advait.churi@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 4:35=E2=80=AFAM Damien Le Moal <dlemoal@kernel.org>=
 wrote:
>
> On 4/22/26 06:22, Sagar Biradar wrote:
> > Add MODULE_AUTHOR declarations for the developers who have
> > been actively working on the pm8001/pm80xx driver in recent years.
> >
> > This helps properly credit the people involved in the ongoing
> > maintenance and the current upstreaming effort.
> >
> > Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
>
> Well, if you go there, then you are really missing *a lot* of people.
> Just run:
>
> git shortlog -n -s -- drivers/scsi/pm8001
>
> and see the ranking by number of commits.
>
> So in the end, I really do not see the point of this patch since git log =
can
> give a full (and correct) list of contributors.
+1
>
> > ---
> >  drivers/scsi/pm8001/pm8001_init.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm=
8001_init.c
> > index e93ea76b565e..487f9bc237ef 100644
> > --- a/drivers/scsi/pm8001/pm8001_init.c
> > +++ b/drivers/scsi/pm8001/pm8001_init.c
> > @@ -1569,6 +1569,9 @@ MODULE_AUTHOR("Jack Wang <jack_wang@usish.com>");
> >  MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>")=
;
> >  MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com=
>");
> >  MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>"=
);
> > +MODULE_AUTHOR("Abhinav Kuchibhotla <Abhinav.Kuchibhotla@microchip.com>=
");
> > +MODULE_AUTHOR("Kumar Meiyappan <Kumar.Meiyappan@microchip.com>");
> > +MODULE_AUTHOR("Sagar Biradar <Sagar.Biradar@microchip.com>");
> >  MODULE_DESCRIPTION(
> >               "PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077/807=
0/8072 "
> >               "SAS/SATA controller driver");
>
>
> --
> Damien Le Moal
> Western Digital Research
