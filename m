Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9A1364942
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 08:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931925; cv=pass; b=axPoZAYQZDCkJGl6efS5q0QwHQu2M91kuyFM1uIrJ0Wbu2v3WoZkCjpo+YyQkBW6NFFHsQT+IDh1mYQQSwM8+RhpZqs8A/GwgnO4ha9lApCllWn8FW/+AX+JvgTkd1Rq9ToVVjOAwA2mj8SrxDfmR3bBhLYw6ZUs25k8uBPw6j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931925; c=relaxed/simple;
	bh=FBFY+j9O1ezwGMt8wjE4G7Wepfqjb6qbKfE3J0CWqXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=klpk6UqhZIX0Ox317726pOQC6GX0nCyzG1Si0TPx2jfV+1gk5a8pmn8bCkalWuLnHhugy3/sedmuRu2N1hJulUvAZdQ0Gr5C3nyA0Cl2GeFws03CVZheR9ojkEF5flC/ORqOChJx9xXRhzmqOBDYu7LKGCOJ5a8HJbpKFptcI68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LZxXHIU8; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LZxXHIU8"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a1307438ddso5837336e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 01:12:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776931919; cv=none;
        d=google.com; s=arc-20240605;
        b=RqElBhtdyp1vulJHZw1DJkTug8CwcYpl9EvgZHPWitqiCStDD/9xnt0A8wssSuNmo4
         CyMVH5pqU4B/wYsS3p06HKgEJhRfSWxuywzI26O22xR4j55JL/z5I88khnm9bFsnPSsM
         Q3ZOOGpph0y/2TX9n1xU9TAdUz4xM/TrXchwl1OnmrfYfMj/DPEktw7DnPMS5mtCcBI1
         KD9oEBb2yJYmqFf/zljLeIJArjt1+MoIWmmv1bmrVzLIJVYLS2BRWTW+5rPkVrJBVJIP
         Zs5KZDaRCWJCEQrQNDM3KnRDwoBEkNIeSkks8ZoimewhC7Dvt2vMg8V0QYf6pNPHccYG
         JjKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b1TJ69eD3+dlZgtU6Q/SGAaN/1k6mZejMgKlXmY0+Uw=;
        fh=UEF8WHE+rEQ8ID5GpXOs+2ayIhzp6Wny0MG8T7yiSUA=;
        b=R+GtH3G0rc8LIeUCZmeDRSQvFbr9RpkJATt5KoGg3dFgoXEq4pLE9RN+oMre7Cmxs4
         k7PC8u+PrvhN+cfju0xP0OT0kPfKHnPnGIdmwCXvsi6QMp41M8XloCm52xayu0wR1TmX
         t/+W2KoA95AZNBe+INoow7vjoM7zncg4oaY82R8RaTPQYNWYSHYoJS+24Le625CwXXwi
         F/jiBoj6Q0hdnrzPYpGdsZWcvx2hgSk4+092mN+EJcDnfqoBXflBo5Avy++sWUXoHaM/
         nsK6p4ahYxsgv8nqMaRtnodN41Dd2+UqqFioZCXnd58GhXkE1F4VOGLbZrOutixyVE1D
         4YAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776931919; x=1777536719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1TJ69eD3+dlZgtU6Q/SGAaN/1k6mZejMgKlXmY0+Uw=;
        b=LZxXHIU8Fzc1Rhw7AF3e24Cq9Ni9zaiXujz6UTCKT9+1RVtQJYQ1Bif0V/ah7S6AkK
         QVHSPaDnCiGC86kkVfX/0v9NsDcC9AvpwBHYU+RYi2FREgYsfWpyNQNSrU3FZGPI0mpi
         9zyKT0SD5wPkC17KDHbm1LHuana/JMTEpCIkZEa5hL9kU24I9hSAc6dtfa14gyAClMD7
         xSY8WK8iUrbsQtxsq7jtc4DDVn6h2BaHKi6iZuLP3g8THQeI21PZkbQmvsRKm58pjexI
         9zXcvvMXr+qUZeuExK8Lh5SEptOU2/ISlquzEcNa7+uQWIdmwaS/3aZ/Fs/Pp5PR2lk0
         QzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776931919; x=1777536719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1TJ69eD3+dlZgtU6Q/SGAaN/1k6mZejMgKlXmY0+Uw=;
        b=B2KwHwHpbFdB2dvnld2kWQCONzx1PQ010pPm/F33GV7MdhPw5QwX5EIfU7CjcFlLBo
         joM2TIFpdBlzK7Dq8Xsy0mrXEVbz7O4M9aFQc/8TtK9oDg4aTyFcjFnK4QvT2tW9zoX7
         KGhIZH8D8LaSA4JZ5qA/2jXSeiJt1E4c0TTDDeHJoQKVjfwHc32JV11EmdIZBgvMxkJn
         Uh6VoeYvEJV8lUQQHx+bv+TLrNG2Swns5eKJVeTnoBGvOLoGd+7zHzOBX/nbOZd2lkPy
         nUCTknohjagerIPvSCZX1BSJOYRR4axiNCzO1uF2VEhhtc/nvO9UM5IFLqIPdS0sAK09
         5uCw==
X-Forwarded-Encrypted: i=1; AFNElJ8DJpdZeXFkcMqsXwaRPqNjC7CVWMqIYhOThITc1qwvGutKRLjrgGTDYctbrvYx+wm9iBCxgqr+ny8k@vger.kernel.org
X-Gm-Message-State: AOJu0YyFF0Jx4u6xmlBQJv83D9HjjL5ABXptF13JPWWYuIL/43dkOZWk
	iJM/3f4GHFSK4IHyF0AymaR0wVhksvVQakXNvHP6XK0LUrvaU/nDSs0jlptX05eVkX3vKdGHKts
	Tv3lJWilulrvZ6hKfcR9I9h9GQuy3rHPpgMXJkvrn6g==
X-Gm-Gg: AeBDieu9APOUKiRMN/bj8pO02TWBUSJ6vbBLczF9TWpNIX76R5erJD8O9+mhM+e4WKY
	L/DG4vNbSmE/yrEKHgKpfQBbT2CdUNokrN/Coq/LdZ86OhGWYTJjeWS1tFS7pIsQ84gYh+zaiEj
	lqmiDVts/A/MkiO+33EE7NCzR1o6WngQktw6W9SJbgApiMItPaxjVd+B8hA4og6aaOhnd/ZPjs8
	GMrTRFV9KcSHwRHGABDWv8BzSco+W4KXcyPlFqhRwmT9e42r7WAPMbHEyEGjFrNXjhsSPgBE9RN
	bx6F58thoYjYBxgJ85Qz/JH/RDTTRywuDDdwh9iJMSbSxOloKWU=
X-Received: by 2002:a05:6512:3ba6:b0:5a3:ff60:b72e with SMTP id
 2adb3069b0e04-5a4172eac66mr8218916e87.39.1776931918554; Thu, 23 Apr 2026
 01:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416192942.1243421-4-atomlin@atomlin.com> <20260420131152.243488-1-marco.crivellari@suse.com>
 <tfkr5mlsdzbhdzv46ookoy2e7ed2wcozuxanv4wagjf6hqb4sa@7i753lpqkxvp>
In-Reply-To: <tfkr5mlsdzbhdzv46ookoy2e7ed2wcozuxanv4wagjf6hqb4sa@7i753lpqkxvp>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Thu, 23 Apr 2026 10:11:47 +0200
X-Gm-Features: AQROBzAAJimGp24FdJwHT7vl8MEKvFnP60qRLQ-HOdwRzLvk1TNgQokO0fGWBCw
Message-ID: <CAAofZF5+igiyR8vne9We5tnfouuWNO2H=BdwWbFCN+gnpUXoVw@mail.gmail.com>
Subject: Re: [PATCH v11 03/13] lib/group_cpus: Add group_mask_cpus_evenly()
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: James.Bottomley@hansenpartnership.com, MPT-FusionLinux.pdl@broadcom.com, 
	aacraid@microsemi.com, akpm@linux-foundation.org, axboe@kernel.dk, 
	bigeasy@linutronix.de, chandrakanth.patil@broadcom.com, chenridong@huawei.com, 
	chjohnst@gmail.com, frederic@kernel.org, hare@suse.de, hch@lst.de, 
	jinpu.wang@cloud.ionos.com, juri.lelli@redhat.com, kashyap.desai@broadcom.com, 
	kbusch@kernel.org, kch@nvidia.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, liyihang9@h-partners.com, longman@redhat.com, 
	martin.petersen@oracle.com, maz@kernel.org, megaraidlinux.pdl@broadcom.com, 
	ming.lei@redhat.com, mingo@redhat.com, mpi3mr-linuxdrv.pdl@broadcom.com, 
	mproche@gmail.com, mst@redhat.com, neelx@suse.com, nick.lange@gmail.com, 
	peterz@infradead.org, ranjan.kumar@broadcom.com, ruanjinjie@huawei.com, 
	sagi@grimberg.me, sathya.prakash@broadcom.com, sean@ashe.io, 
	shivasharan.srikanteshwara@broadcom.com, sreekanth.reddy@broadcom.com, 
	steve@abita.co, suganath-prabu.subramani@broadcom.com, 
	sumit.saxena@broadcom.com, tglx@kernel.org, tom.leiming@gmail.com, 
	vincent.guittot@linaro.org, virtualization@lists.linux.dev, wagi@kernel.org, 
	yphbchou0911@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 7:47=E2=80=AFPM Aaron Tomlin <atomlin@atomlin.com> =
wrote:
>
> On Mon, Apr 20, 2026 at 03:11:52PM +0200, Marco Crivellari wrote:
> > Without it, I guess the kmalloc() in `group_mask_cpus_evenly()` will
> > return ZERO_SIZE_PTR:
>
> Hi Marco,
>
> Thank you for reviewing the patch.
>
> You are correct. If numgrps is 0, __do_kmalloc_node() will
> return ZERO_SIZE_PTR.
>
> > Should this check be added or it is not needed? Or maybe rely on `ZERO_=
OR_NULL_PTR()` ?
>
>  - File: mm/slub.c
>
>     5275 static __always_inline
>     5276 void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flag=
s, int node,
>     5277                         unsigned long caller)
>     5278 {
>     5279         struct kmem_cache *s;
>     5280         void *ret;
>      :
>     5289         if (unlikely(!size))
>     5290                 return ZERO_SIZE_PTR;
>      :
>     5298 }
>
> Regarding your suggestion: rather than relying on ZERO_OR_NULL_PTR() afte=
r
> the fact, I think it is much cleaner to just add the early exit at the ve=
ry
> beginning of the function, exactly as group_cpus_evenly() does. It avoids
> the allocator path entirely.

Hi,

Cool, I think that's the right thing indeed.

Thanks!

--=20

Marco Crivellari

SUSE Labs
