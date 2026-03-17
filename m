Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB09E32B9A9
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 04:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773722013; cv=pass; b=Qd06/2LIeSjJilHw452/XumvJQAqz5notM4KKpnlOO4OhEmx2cW0SPf8qyq34jahSD/Vxb7QkpjT4GSDjTc4ZsId+fQUcj26lDq0YiLcK0d1tgtOr1acdgC/hLMCQiuSmkFnZej20+H3+cgaZX02BwL2npSCo/duGmN/GMPf/Nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773722013; c=relaxed/simple;
	bh=tiOslg2ijiNLvUEule9D7TB3nKCRsqgcCv7YiVviGdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sVspszNDwkJFW9tg2cGBeKMaUVCnte6lCQuQRHh3JUULPeENzsSqF5thg2waSUlcd6+1G8opp5a2xLrpOGgC3pEGgE8Om1ydNKqokLoPXdtQWrkEDWf0mZioJzz5D4VOP4fkHxonCZPnF53Zp3NzpG0dlqiatJsGJXAlieISmbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XOHBHWty; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XOHBHWty"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509062d829dso231011cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 21:33:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773722011; cv=none;
        d=google.com; s=arc-20240605;
        b=iylvxwU1Z51qy/sYqvm/myi/gxVewaJH82CINJQAo1ouzTTqmOJAfCBRLlzLWuo6rE
         PtfdewYW0CfrKlanJJ65s1D158Cwg7Bzts17zHKhbXMDjscjcr+AdjO6Wqadc+TVRSvb
         DlJFckVruXpvhhCCZ8Xj3kBBj0IIX/LkeM5nx2Qc9kdSkjgClu7SEAxf8fQjAyd9EJ+w
         uKr6kFzWc5OcgKgM+g3w7LP24wlzuGjSZTE0ssE1/CciGgSO1I+3WwkswgQqjorV30aI
         N2Wewvgz+0RcfvJYQnq7BL0SqTCAjMGgL322ZFer9DDAkP26atxUMeWgq/R/RKNb+Z8k
         y4ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        fh=Q4JM4/YWnWKjYcF0tb03zwJCov36QadJCihO88sVhqU=;
        b=BvV8iy6mhGdfqQZI5DHO879RNXoH+A/eHLd2dwY5ytZHTYIc8s3lu1bbJgcVZV7f5F
         3uoHynu79aOaFcNCFHvOiW1H/T5/VW5FOIZLPAFMWObB+uSeSBW71TpG6CBjB/80Ezpi
         GG0373+8Dfs1wTUsownCeDHtIdxSk0gYVE9gxr1gpMqQgcpRIm3H7frPzywD+QOVAZLC
         1m94iUD4vTXn1qagj55S1PTaxev4khlR8mlFnByoML9+/FoG8+IJsU4Bd76h0J4znNyN
         REVDK9xiS0cZEkCjOaFSjt1brRxeUvHR0DUY6yfUmY5ecky+d3h+hkXo+5coUFFbss90
         E06w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773722011; x=1774326811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        b=XOHBHWtyrlsh7Yoa4vNnjb6T9UyuOpn+BAQwM6/uhn8ej309RDdBFaM0vYPVNGoxBD
         fZ4VRrRF0P1oXYGRPa1P6vXDW4hEkqYusYkSgtFEpwEaBMZSkbBuOzVEGkYjLbJnG0ce
         QU79t/gmXkvF21hP+Hh0ZK69g3kK819Gvg5zCvpU2oo0xApP7o57C/wEJJ0VBa6Bacey
         wjarTwWHd65HU/pv9GZujDxU1zzk1io+Q5IMCyzum2RA6KkJ9FSc0WAExQYW1SjbtbTt
         34LW/Y1yWWNLOSsBOPPxDUV5NcywSZ15RzaSRhQvYN6v7clysze7Sd3FTfZBv4btjwv1
         gjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773722011; x=1774326811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        b=YgMaa2mQOulDKWfeja/yQICam4t7z4QgT3A7UA+gYZ5X43waAH/RJX2rebK5oQNw2N
         CX6ZD8WJDiIPC/Cc3fDe2oyR6zU7e9UwVyInrzXBa+sMU3sdYJq4odKVYMONPGUXCj/b
         JvtzwWILjvdyYcMIV/84PnClGkDqoXynuUsLPQQIueVoJVfZK1mFTjaG8o/dNTn+dCXP
         JuQHcZRVtVFVwqQkFxrehZdQbOE8vdulKBwfhhN1oJwV7LOXNfmLDadBoJTIyUw2bHog
         Zh51CU7U2HeeRkJBiRBDgNFNyY8xI11OptrZ3LylbgQNNeBdv1G8c1M1peUSS0+vDlhT
         GpaA==
X-Forwarded-Encrypted: i=1; AJvYcCWBY9Qd1+rB+y9e1KUY/MG3yRy30Tl8itRh2aHiDNQ3Laum/85HQDODSr1TTZKNmbUpvQOJqC8rFFno@vger.kernel.org
X-Gm-Message-State: AOJu0YzOPp7qZRkZztEfG3QM6za2dvBwWwMzGf6hcNiMWsny1B7xrEwA
	/nUJDmwxn7ergpl4krqe8EZWVHWtGWfxGFSwEyIIuE/JsrDxscc36M/c+gBSbdY4BzN/aIwEb9M
	1lE1YkY+RDSj9b0ms4JylYpPJ8RXBrC5kjtPvqZPL
X-Gm-Gg: ATEYQzxpg0AbVBQJwCXZm6d6QpUvEAxcHwbkdbesgUZQe4roRaGuNXWpxbNi3kg7oDO
	ZwbHZNrH3CcRp0RAKWNjnEMtH7eoE85QE1jHrUtRLGEq/ZagJV3i8aTEXOMeuwVBEBV5S6vWHYq
	EyJUtT1VoAQI5e6pCjHVi1jcPMY6tnY9WVB3h8uQv06vrNVuCmHU4DZPdvlWPf/RMqCltQvWafo
	KQbL6iHzl616a/F84Ypucbfw6fD7RgDbWX2Iz5n3LKAOh/z6TEDUTubaWItNV2iVGjAN9MCf5Q8
	iYOnZQ==
X-Received: by 2002:ac8:5844:0:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-50998d3b42cmr9273521cf.10.1773722010151; Mon, 16 Mar 2026
 21:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
In-Reply-To: <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:33:19 -0700
X-Gm-Features: AaiRm50Qx7Mej7rYBXyqChXz1IjfagNMkbSFlVwOhEN7Z-gN2V6TQSUIzNbqMWk
Message-ID: <CAJuCfpHBfD0zO60tPCEeNXSRJSoDi5Azs0LzutpYFEBW2z6JJw@mail.gmail.com>
Subject: Re: [PATCH v2 08/16] hpet: replace deprecated mmap hook with mmap_prepare
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
>
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/char/hpet.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 60dd09a56f50..8f128cc40147 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
>  }
>  __setup("hpet_mmap=3D", hpet_mmap_enable);
>
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *file =3D desc->file;
>         struct hpet_dev *devp;
>         unsigned long addr;
>
> @@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_a=
rea_struct *vma)
>         if (addr & (PAGE_SIZE - 1))
>                 return -ENOSYS;
>
> -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> -       return vm_iomap_memory(vma, addr, PAGE_SIZE);
> +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> +       mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
> +       return 0;
>  }
>  #else
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
>         return -ENOSYS;
>  }
> @@ -710,7 +712,7 @@ static const struct file_operations hpet_fops =3D {
>         .open =3D hpet_open,
>         .release =3D hpet_release,
>         .fasync =3D hpet_fasync,
> -       .mmap =3D hpet_mmap,
> +       .mmap_prepare =3D hpet_mmap_prepare,
>  };
>
>  static int hpet_is_known(struct hpet_data *hdp)
> --
> 2.53.0
>
