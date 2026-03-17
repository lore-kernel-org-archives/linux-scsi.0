Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46846387579
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 20:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773780409; cv=pass; b=Zh90LGQbcG/kUOBgjd8j6m7aKta6kexOiWRq6GwZZgHDSiEiBEJQTp1tWxG7xDSzIjS6si3IgiEiE3DA2Nt7SAUdFTWyNX3c/7i5PtXZ9UOZenYR2x6D/R9EZV6pF8zlD6D+Oy71cRM3jBi4bLJLDKUbfYjKhIyM6Pq/LY+puyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773780409; c=relaxed/simple;
	bh=RK/TCms+LvhqFMYFVVVIbiPX2SpvDGczeYFrHJlFfsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hwMbLWDHTyq8V5nWzvvm55V0C8C8vJ5Z87uAbHe00qdIrNSBzvyUpp6ImNA5IfDt9v0BWvbWVtwrSz4imx1mMFQnOzVSUDdPutnInszHOlxQqg3owoBH+ona/udObROKPajjh7Ev7Ft+QEd0BBAo6iAfcpBDbi7eMylXzTvaFB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R7wwizPP; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R7wwizPP"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50906a98ffeso149841cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 13:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773780407; cv=none;
        d=google.com; s=arc-20240605;
        b=bCPwVunCPC9Tw/0gLUgY9VGt1RIdcM82DrQetQNctR6RVJkJ6EHAkZsMdRWX16uM6k
         hV/qyFgoKqeo65/1ir1BWMaFiWCGfSCPlAsnUxK+1arCYs7vhcnZiD46FQ7Cl/FPpu9g
         fe95fE2n6I0bDeHE1BLy1qkbLv8584PFiJfFptzDzb22iVBSETdeZDA7LO3akIwM4KVv
         NoKIqc9YqcnBgXQ+05Qwk1he+YGmwhlzjxaqyNwNaDw8eRU+le85ZhcSmLU9TPui8zEU
         D/3G7glHOWV4JWnDTnpqxVioH/bvDSjJXnCU83rqdPI09Q1ONAN2JoIK0/pOx4Kcdb5L
         m4aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
        fh=A5lm99z8Vb4VmoinHjBQLPrQNk1SC0NCCyF0rzkLMLY=;
        b=VY8KHUnPDzkrn41g+/eKZBnHzzO3eme9zIWcHAwQYOlS9716bjbc+0ThgqzJU8ojoG
         2ifehRkqTaxlYBLMoZ1S6X9AY86etaFLzRrGghxpHHCkDCYAAA7pI7oIeuqu9CUqrTgg
         W5Pd3QNi6oh1jGtXWStIlDhJoV9/sZpBraOVzxa8z7L5j4y9UYrY8Gj1SYn56YtkM2sn
         SLvW6pLkvHtpkt191VOEc7eoXbnESJaimUbyePs540oZOf0mF2fUHJ3EmecKllCLR88W
         GNqno9Ql4u6vHtzCHcpVB+Y7ahSCT4JkOAZx9AdIlvDq/6DozdRlaFywKQ7mfUiK3+vP
         +X/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773780407; x=1774385207; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
        b=R7wwizPP7dIx2oPvncRf5HBKNPKyAaVPKVkYmDRMxz0B46r+fPFmPBqna9GPZ7ifl7
         GOGmPQyLNsC2D+dHxvnj7L/nFYjMYOX/uN2un6bKHtLyQrbLVqro2DG8Ns+L/uuYldfE
         gNofHLRtSGWY0uigMa2awoJOlXvX33szc5mINax+vPuq3Ur9RwutTYt236NNI2+CUi3X
         E58UFuY+bM2rUL4cDdcWDsoQ0JMcMkNqMWLGvVCYMiyoT5pQQ8PhyXwZdT/Yu9SnPTWA
         LWmqRfmCDhx+tlZKoAYQILEY1NepardJAzZxu3KxNP0moF+PWsxvbPQLNCg2f9UKMTCx
         YrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773780407; x=1774385207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=puh87Pmz2QIedt98QmYFqHshzK8OJIco1FTLmkjNO+s=;
        b=DXSslXLw1Qt4iqQTfXoICPeiTMSJp9W0YT6ep5d1tmMFL/hXv9U4U+penP/Q1q7P3Y
         XhjXZ8oj9Hu/qsValjX3a7YzYn1FG44Sb0nWaYbLV/advLBMmUl7HNJqJbXSw0zKW3ZB
         TttI6b3pTSlvml1gqA5RXozbBNdzU/znjiHFlsUL+kpbfPzUd2L8fOaHx2+HidbwTXGx
         y/xPnwczFpH7Y4RJZ+3RXJmv2z/wbaqZqNLOZCvsvHOMVar2J+Ht8yrlDzQrZsYBgWFh
         L3IRM+HucqquyKDtrfZ+F7c0zS0V1F8EkEmPpEehzil0BZwff0yUVf0slJNnyVSJMTh5
         84Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXaT4hLeeYxIJ+kUr2nnGkSjc3UJ7rTsYXA8MxSFJUuoqpkeXFSq3pOTeiUumCjyASbvNGrJtLyBGUW@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf44KbYhE+MDzVk2/znZApRDFcGcCroKGoCbkl/o8qCEuA5Icc
	oODKGjaBDQURVbu6Jb8o46oHSEwiIuHVO8SdjA55IAfyYnaLWVKyAcMqKs++qd4cQ6F9/XQLcAG
	zu22S9wi8lpOYJmYxprWMiP0GCrQjSimqGi0fshhP
X-Gm-Gg: ATEYQzz6dEKcXe3Tks/QdPbPE8bKYrv+CkkcIPiBd9w8S6C9UchAiYKpe2f9nXwS/OC
	9PjO9bz1bQ6NIPYYytlKZ2UKQ56pk6LqI2meC+MCyGIhlpitATOF8A1mxkXyoJsq92yNGkSttJ4
	CXwTTQ8ALsNTxaySKql4sg3rJXiXe0Hu/ZhlMo28fUSzx5KKUvezO8gfcYObeQjLqk/xCNLfmdL
	onAfvqNHmJqCXQOFsxEEvLx6MOJo1BBef8gisrUq7JuVDNu3vvGA1N81MjuUSS5c6wNG9c2B6MA
	O8LMfH97horKB9zILNUx7nOsJtrXCZPT4ZrD3Q==
X-Received: by 2002:a05:622a:130f:b0:509:371:f2ab with SMTP id
 d75a77b69052e-50b14848d70mr3924821cf.16.1773780406374; Tue, 17 Mar 2026
 13:46:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <d34056a65bd387286f4e155d52449106ddc99f78.1773695307.git.ljs@kernel.org>
In-Reply-To: <d34056a65bd387286f4e155d52449106ddc99f78.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Mar 2026 13:46:34 -0700
X-Gm-Features: AaiRm50ZSv0JOBEsyaTpLpUZLAlSOUqng_UaLNmSO0lPuUbLHyEvRlv0uikpAUM
Message-ID: <CAJuCfpH653zdE=mXArpx8BUszVVC1PoN+rvp+WxdM3aAUbpqRw@mail.gmail.com>
Subject: Re: [PATCH v2 10/16] stm: replace deprecated mmap hook with mmap_prepare
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
> Also, in order to correctly maintain reference counting, add a
> vm_ops->mapped callback to increment the reference count when successfull=
y
> mapped.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/hwtracing/stm/core.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
> index 37584e786bb5..f48c6a8a0654 100644
> --- a/drivers/hwtracing/stm/core.c
> +++ b/drivers/hwtracing/stm/core.c
> @@ -666,6 +666,16 @@ static ssize_t stm_char_write(struct file *file, con=
st char __user *buf,
>         return count;
>  }
>
> +static int stm_mmap_mapped(unsigned long start, unsigned long end, pgoff=
_t pgoff,
> +                          const struct file *file, void **vm_private_dat=
a)
> +{
> +       struct stm_file *stmf =3D file->private_data;
> +       struct stm_device *stm =3D stmf->stm;
> +
> +       pm_runtime_get_sync(&stm->dev);
> +       return 0;
> +}
> +
>  static void stm_mmap_open(struct vm_area_struct *vma)
>  {
>         struct stm_file *stmf =3D vma->vm_file->private_data;
> @@ -684,12 +694,14 @@ static void stm_mmap_close(struct vm_area_struct *v=
ma)
>  }
>
>  static const struct vm_operations_struct stm_mmap_vmops =3D {
> +       .mapped =3D stm_mmap_mapped,
>         .open   =3D stm_mmap_open,
>         .close  =3D stm_mmap_close,
>  };
>
> -static int stm_char_mmap(struct file *file, struct vm_area_struct *vma)
> +static int stm_char_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *file =3D desc->file;
>         struct stm_file *stmf =3D file->private_data;
>         struct stm_device *stm =3D stmf->stm;
>         unsigned long size, phys;
> @@ -697,10 +709,10 @@ static int stm_char_mmap(struct file *file, struct =
vm_area_struct *vma)
>         if (!stm->data->mmio_addr)
>                 return -EOPNOTSUPP;
>
> -       if (vma->vm_pgoff)
> +       if (desc->pgoff)
>                 return -EINVAL;
>
> -       size =3D vma->vm_end - vma->vm_start;
> +       size =3D vma_desc_size(desc);
>
>         if (stmf->output.nr_chans * stm->data->sw_mmiosz !=3D size)
>                 return -EINVAL;
> @@ -712,13 +724,12 @@ static int stm_char_mmap(struct file *file, struct =
vm_area_struct *vma)
>         if (!phys)
>                 return -EINVAL;
>
> -       pm_runtime_get_sync(&stm->dev);
> -
> -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> -       vm_flags_set(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP);
> -       vma->vm_ops =3D &stm_mmap_vmops;
> -       vm_iomap_memory(vma, phys, size);
> +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> +       vma_desc_set_flags(desc, VMA_IO_BIT, VMA_DONTEXPAND_BIT,
> +                          VMA_DONTDUMP_BIT);
> +       desc->vm_ops =3D &stm_mmap_vmops;
>
> +       mmap_action_simple_ioremap(desc, phys, size);
>         return 0;
>  }
>
> @@ -836,7 +847,7 @@ static const struct file_operations stm_fops =3D {
>         .open           =3D stm_char_open,
>         .release        =3D stm_char_release,
>         .write          =3D stm_char_write,
> -       .mmap           =3D stm_char_mmap,
> +       .mmap_prepare   =3D stm_char_mmap_prepare,
>         .unlocked_ioctl =3D stm_char_ioctl,
>         .compat_ioctl   =3D compat_ptr_ioctl,
>  };
> --
> 2.53.0
>
