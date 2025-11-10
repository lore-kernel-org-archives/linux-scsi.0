Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4AE302163
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 10:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762768816; cv=none; b=Q9cYeIkXWZfSrscglqLUb0bOpNmE+uTPqzIDsliIOlHvzX3ANkoyUmAJdOF3jmhJAzoIlg/qirxdugMcBhpCpXQANofuVFAVTSV7mC+Dr2hHiCLDO1Ae30/BO4YmHUGg1jBB5nXlDT3PaR1ueELI8sc39K0oT2KbYK3Fl3GTV4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762768816; c=relaxed/simple;
	bh=5Rij/2CviNlBvh7WHWIbSwpeQ5DLytBhS65BWZYZRHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=all/h3jUsk29nJN6reNgGC9l0D9JgfGpAJjJzhoIZAEYLpY/dD/H3U4NULNrzXyVLzep1z83GQjWPWh2M4SFnqjW19YzgeRkHpAD5otJN0NTmmKt4Vn9sFRW96U7lDSEdxAVKi2MoJJiRFWHgujgCxScByPpx7ZQxhdE/ej69AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cXuvcRLO; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cXuvcRLO"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-594270ec7f9so2539562e87.3
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2025 02:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762768812; x=1763373612; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Rij/2CviNlBvh7WHWIbSwpeQ5DLytBhS65BWZYZRHU=;
        b=cXuvcRLO7hIVHuNZB800UQVwbQ9EScKJULlYegscC5Dac+ke8/jJpYE8JrSSOeJ2Lx
         oSSK7gHKuaV2Zl3rq9Aoembv577k7mkMv/A2tSHKqdzXqCKY6cdbmTu1AvBF/gGfF0+9
         VtXZ5jMX42kt7UZWyHtimghf+h3H66LK03briXMR651GiOcoQzyHG3h980BuqG31iddY
         bJdYOL1TZWFmvqkUPTqQ9XlaUg8ESu0yQI9nkyE0dBBxsysuTcEK3luVRjmm+8Zy0udO
         9A0U2k949YkQmigR1VNmg9dQ6zk0+Bo4+7PQlFdwVeByxfnMUGyZKPb9VN20vImUmZt8
         hQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762768812; x=1763373612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5Rij/2CviNlBvh7WHWIbSwpeQ5DLytBhS65BWZYZRHU=;
        b=Hh4u9iux719sc/Fq34JI7JEE0cXpDSHSJdCBHUKJe9NErIyNla851B82XnChVUpRJb
         sSKIYqgmTYYaXFKMbJIVmdx+DIUz01HACC+iOFM4MNI4hszfEFx8LbgWnR1d/vlyvzd3
         ZZPS5zqutEOhOFTINY0DWKZu9Jw1akpvUK+HO7H4RuUTliac+0cgriITqhrKASRSvcXR
         5Qwpzjux3TPRbx8QK+hDm3DGCvLxfheWP5EWsf6N3bd4tcLmuWu7h5Fr9c0zDjuOkTS0
         0kzEvZI9T3CYIAC+KjtAw8I+oljofwao4CEZPGAEgtEkDJ3tejKNfZpjvykf1UlejyeG
         yNXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf6Dmv1zZspxNvjaepY6mDqvxjNHTGiosV/eGeyIB+m08wMPvJHHZv4htW9ivmH+YQj0KlBIviF9c9@vger.kernel.org
X-Gm-Message-State: AOJu0YzaLzb44CTY5aZWZ3TYB1TdGd7eXM/TCc+722wqY478hyJFTaAx
	YsV7AO/+2/pSIzLyLywegFuN6fezUyZg/8xeP06avPNGSPRI55rCfD2TaHr11y82ZVeYrZ5WMC9
	nLkD3sD8LxMhym24mmRF7o8Ek5CIuP2LXjgoLP8FGRA==
X-Gm-Gg: ASbGncswCHxMYkiiNH/unyqJ2NH5yxXHqoUwQ0lZ8Hrf4+Fe5Tg5Xi2KLX6swzjGMwT
	w90A2EwdS0la6Ma3T8EvIcNQ/ModsYT6bMlPM4UTXsa6nQnzh2diVubrc+inydVmQXK4Y3WFocO
	nLYRXg6ctIrnzuBcJpAkcRc312tfPKg/0NK3w16fdSDvVzro8ZqB2PNHuYWFvXki2jOn3pxLGR/
	KJf+I+c8xdtn1lxqmGrv/+6wB2pv/RiZHiE6FaaPEiUiWa5Zl9waf7T10/NWu1gfzVldvCrLP3e
	I4a8sRFv+8zxhcvviQ==
X-Google-Smtp-Source: AGHT+IFPhh9/9d3Z1KExGsC5qR1rQ2Nm45Wjmm7VVABR3qn4IwSK1xAdFqwX6aTWdeHPxrH9yQER1j4Dx1YablgrOh8=
X-Received: by 2002:a05:6512:128a:b0:594:4fee:c1db with SMTP id
 2adb3069b0e04-5945f1db997mr1889652e87.43.1762768812265; Mon, 10 Nov 2025
 02:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251105150336.244079-1-marco.crivellari@suse.com> <yq1zf8wigcl.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1zf8wigcl.fsf@ca-mkp.ca.oracle.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Mon, 10 Nov 2025 11:00:01 +0100
X-Gm-Features: AWmQ_bmvKQL49SwnIgkZ_XaHesOHafDeJPxGggUELlJwkTEaqkOPLpOq1fkn2Io
Message-ID: <CAAofZF5pwbtvfCqdXibRyDJirnrzLRzoCr9dgJ=N1w-NFJkv_Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: fcoe: add WQ_PERCPU to alloc_workqueue users
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 8, 2025 at 6:29=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> > Currently if a user enqueue a work item using schedule_delayed_work()
> > the used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> > WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies
> > to schedule_work() that is using system_wq and queue_work(), that
> > makes use again of WORK_CPU_UNBOUND.
>
> Applied to 6.19/scsi-staging, thanks!
>

Many thanks, Martin!


--=20

Marco Crivellari

L3 Support Engineer, Technology & Product
