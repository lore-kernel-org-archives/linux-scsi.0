Received: from mail-08.mail-europe.com (mail-08.mail-europe.com [57.129.93.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25B734389B
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 21:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.129.93.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783976893; cv=none; b=s6inL0B2LYWVmKw+9KGZDz9+ZbfsaM+6svlQ1mjkxJjgRTcJKa5NMVwSvkTvLVT07VEdE2KW/I7eIjBFnK39UEw5K0VDNuJ7C2fODYphePr+sKE9i02NnHseTEfLHiorMcWG5xui5TuOAj2LanznoiIHyF4hCN6LTY1qVe3FHdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783976893; c=relaxed/simple;
	bh=Qtl5fkFXLFfwI7Gp9rLKD5YocvNVBC8HOnIYuYlpkxs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrqYQHeBny+qfe7uwVeWY20vVikwls56jjKzNV5aVqDL3H7DPvClbdHSea/k9z465lJ7TbLqtsUkXlyQz+EAAMuY+mHPX73hlnI3x/N5pLZmHr75qB2pvKJ5LqBR+EJM4OjCyDOiVuCvEPGDjSvc8tNljc7odJnJO1ASc/S8lts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=danielfernau.com; spf=pass smtp.mailfrom=danielfernau.com; dkim=pass (2048-bit key) header.d=danielfernau.com header.i=@danielfernau.com header.b=MZRaI9Lf; arc=none smtp.client-ip=57.129.93.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=danielfernau.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielfernau.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielfernau.com header.i=@danielfernau.com header.b="MZRaI9Lf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danielfernau.com;
	s=protonmail3; t=1783976873; x=1784236073;
	bh=oATV7RVz7+2I28db7Ze02kZ11P/otyLyRcrwhNkRhso=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=MZRaI9LfzavR0QgifTDdCHN6/djt3lbXj04P+4Hmbdmjz/OuDEc4uRy/2yEsU4zf3
	 kw8BKkxEn3cnRVxzNKpx4i8CGv7sTNBXljEDbGkqbzTSbVWBEjw75mJlmaaaVEyfL/
	 MUkRARl9Q1C02DoxAVIPT2USdUsqdO4WN7Bo1LDxYkTdrm+LkOsGt5bmMiEl/rNUPp
	 xyYZQGfDnLjTWmroTmwA5Q7i754Xj5fjgodpMlPOgkLvsSvtpgOTbQ0iAmXy4Q1b6h
	 Gl24GPNjgPPs105OdTfk20R77ABbQr0BlpJOo7v/kk1ZcEQO95DwrCCo/lukcAom0g
	 lRzj59Q7U2qRA==
Date: Mon, 13 Jul 2026 21:07:48 +0000
To: "Martin K. Petersen" <martin.petersen@oracle.com>
From: Daniel Fernau <mail@danielfernau.com>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, me@magik.net, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>, Mats Topstad / Intility AS <Mats.topstad@intility.no>
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
Message-ID: <YKopBh5zwX7tXjDOqU7R0K9CQfVpd3r9_baFGNLwcZGgb4m0cddKjzuQwp0lWZJqixIfpiHm9YwjQfRvNJjBZwl1PaqtuuuCd7dJ4lmirSY=@danielfernau.com>
In-Reply-To: <yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com>
References: <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net> <yq15x5lowt9.fsf@ca-mkp.ca.oracle.com> <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info> <yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com>
Feedback-ID: 131378921:user:proton
X-Pm-Message-ID: e98a13889e7c7fadda74f80978dbb050068f867d
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

Sorry for the late reply. I was unable to follow up on this earlier because=
 I had to prioritize other issues.

In the meantime, we pinned our kernel to version 6.8.12-4-pve on Proxmox, w=
hich has been stable for our use case and hardware. Given the recent 7.x re=
lease, I will take another look this week and report back.

We are using KIOXIA NVMe SSDs, so we will see how it goes.

Thanks,
Daniel




On Sunday, July 12th, 2026 at 8:16 PM, Martin K. Petersen <martin.petersen@=
oracle.com> wrote:

>
> Thorsten,
>
> > Martin, do you know if someone there ever looked into this regression
> > and the proposed fix? I'm wondering because Daniel and Mats reported
> > problems under the same subject line (in new threads), but also didn't
> > get a reply.
>
> I think this problem is just an unfortunate side effect of the kernel
> being able to build bigger I/Os by default.
>
> Typically NVMe SSDs report fairly modest maximum I/O sizes compared to
> SCSI devices. I suspect this is why we only see this issue with a few
> select models. My hunch is that these drives advertise a fairly large
> MDTS.
>
> Since there appears to be no traction wrt. fixing the MR PRP vs. SGL
> chaining logic, I wonder if the patch below is sufficient?
>
> --
> Martin K. Petersen
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index ecd365d78ae3..b93a6d1180ff 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1978,7 +1978,8 @@ megasas_set_nvme_device_properties(struct scsi_devi=
ce *sdev,
>  =09mr_nvme_pg_size =3D max_t(u32, instance->nvme_page_size,
>  =09=09=09=09MR_DEFAULT_NVME_PAGE_SIZE);
>
> -=09lim->max_hw_sectors =3D max_io_size / 512;
> +=09lim->max_hw_sectors =3D
> +=09=09min(SZ_2M >> SECTOR_SHIFT, max_io_size >> SECTOR_SHIFT);
>  =09lim->virt_boundary_mask =3D mr_nvme_pg_size - 1;
>  }
>
>
