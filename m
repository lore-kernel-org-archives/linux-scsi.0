Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D377333740
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 08:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763024124; cv=none; b=DN5O4np7lMIALqqwynb/GMH7MhdZSwr34WgYB5ZpKuPIgQlk6cuIPd/AoPW8lQLQpP270Io/7rdQPjZ7lQrjcZnmPlJ/ehh87jcNCnzsz7G/+o/rGM9+nZ4JF0u0kLhHjtkSAs8eA6uPgkPy6Xmu8PQOWaw6qEnGSKpyG75ItL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763024124; c=relaxed/simple;
	bh=oqFFefcanov3Um6l3KaQ3SgfwADSa1KKIsncfWKh/BM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLmOgNKgBqHibgcvbdJCwtlx4h0PHv9PnltYhXEqa9Pl7X3BN5rNQ6Z+nF1qlsX4MgsDaOzXNR3yNOIkMaYHE5XzdNIp4HRFC+LCG0EYddasApCv2q332d8Whc7krSPR7TOTlLCK225E/d3Etp0m03MNmyQH2ex/2VDbGxL7gUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fxGTiEmI; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fxGTiEmI"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37b95f87d4eso4725741fa.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 00:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763024120; x=1763628920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oqFFefcanov3Um6l3KaQ3SgfwADSa1KKIsncfWKh/BM=;
        b=fxGTiEmIPITtpBRA1lSFEIdlJr1gfpBqic/I5HNF9HyNUa6T8nsHQ66XHS4jESevha
         3EtdEuMFD7hnUAhByP/A3g8iydvYz+z3BtqXXxX0v4qg08xjXWAutV/ZXoTgPt44Wmlq
         VvN7HJdi6vn6iO1V5gTER7iqMmd/ngIJg/7unZv/4FejkaplDmxrVdbtOoTQS5sFbE/o
         GW1VyA9hYTVsVsLumqoU97cDNJ3VfMahyJ77uKJ8qTP3mQusW5UK7fMOGg6+R0PZB2Ij
         fsgL0F2bFGdoPlAovaTxXmxGt0Kn9B53R46rYfF6/6/ccCSdg1ZoOtKpZ9q3t06U6Ej+
         2B/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763024120; x=1763628920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oqFFefcanov3Um6l3KaQ3SgfwADSa1KKIsncfWKh/BM=;
        b=ejWKIRShZ/JsvnXH9q6tntzrAmFunzCs2pi3uUB3rfLHPEfxF0cdiZTOX5agASJdM/
         k91xiN9eNHxx9mWwlz99fENjGahJZ7neS1mjDZMVIU4oGdgFNRwH1KerDDamQ/9PA026
         juWvbzL8q+pSk3GwTkoT0D5ALBYLb94syBNrl7yoyvHIGggSG1GQltwYj9Et7AABMLaC
         cmLtUVlQU3HZTag9+LAkzwft40EaAHIFH/gG3Z3FnUaOMleNVKk/NpReAwzZLUdHc8cz
         x8KDN4Mm82L2OFVZq3xacZHG3Uw51O3hE/mvxNTiK7tGuWvsuMN1ldU6BvPghYMulB8D
         6wCw==
X-Forwarded-Encrypted: i=1; AJvYcCUYhFJxTyWoa0DNs0mCN5WvAG3ma743lPx6IlFAiS5gHABoTo1CD1IVDUnpKc+tV7HDn1oxt0hycUA5@vger.kernel.org
X-Gm-Message-State: AOJu0YzHcw0/Rtz7tsI5ef8Os8HqtPf7mN1E6wumoGBV+b864Mr1AT45
	hNWNCMZrobiBKlakLzifz1ua0KvtSB4f1jr/sMxeJNBddwBw3+CzXaeg9YFTc38yHDNYVnNSteM
	vMMSLI1O2cwcq++ZQZ6mjYOsdAPhyG6fjCsud9DIQvMCpc9ID3Dl4
X-Gm-Gg: ASbGncsGq1lxYevg1s4YlhASbDO+MDoHq4ymzsNF93I1zdCYKC8FflifdKD1TSdtu2c
	NmWt+RO+BLCAjqjrfFWVuZWEnXwAf8vIvDTXKDg5C0S2D5KzsH5xg5Uol/AKa87PqjmOVAT8YgF
	GbNrDD9tMkdMAYOmref6eHrWSbBfGrrRSDrFsh3uwAyPeBBdfn3MCQMWVLhOP9nsXAs75H0HRSY
	RxOOnMpbV0nu2tBXXk4vhgGiWgqpPNW05ixNwKd3je2+eKdxQpz5b2Zp6e9vDVJN0/5/PC5R8VT
	k54lwkoTPCxxCJKvlA==
X-Google-Smtp-Source: AGHT+IGhNZssejb7sPGrO4L/+9VcIHDp1nlVWFAAUidHbPBR/ijjPcKhcW+oYOoxYOCrlVAvlykPZrOv5uuq4iVhn5w=
X-Received: by 2002:ac2:4c4d:0:b0:594:31af:4de0 with SMTP id
 2adb3069b0e04-59576d9c67emr1905817e87.0.1763024120126; Thu, 13 Nov 2025
 00:55:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031095643.74246-1-marco.crivellari@suse.com> <yq1wm3ud5nw.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1wm3ud5nw.fsf@ca-mkp.ca.oracle.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 13 Nov 2025 09:55:09 +0100
X-Gm-Features: AWmQ_bk3lDKoQX6ocQVr8RbfDQjAOX0gR7NyBotclXyjQUjDz14brjHk4rM_7vY
Message-ID: <CAAofZF41Jn7o2KdbwHCHjrspHub-pLdOrs3Dp4JUKUij8MG1eQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] replace old wq(s), added WQ_PERCPU to alloc_workqueue
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 3:38=E2=80=AFAM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Marco,
>
> > Let's consider a nohz_full system with isolated CPUs:
> > wq_unbound_cpumask is set to the housekeeping CPUs, for !WQ_UNBOUND
> > the local CPU is selected.
>
> I applied this series and your other applicable workqueue patches to
> 6.19/scsi-staging. But ugh, that was a lot of work.
>
> Next time, instead of posting individual patches, please prepare one
> comprehensive series for the entire subsystem and submit that as a unit
> so I don't have to stitch everything together, deal with dupes, etc.
>
> --
> Martin K. Petersen

Sure Martin, thank you!


--

Marco Crivellari

L3 Support Engineer, Technology & Product
