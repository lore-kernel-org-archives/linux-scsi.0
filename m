Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5110E31ED81
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2026 04:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773721852; cv=pass; b=Y7PxqSEsCfpupKpNKJ90A0yaUMgNDJxQQn1yTQLhq4Tltnzx9zI1RTXwx7kEWaV69FH4ytdR/dd2DJMV0En6VEtfDtSju0br8hvJprTGdojE0K7fMFvOsjYqbvRWsfV0ZSezn+kDQuzbzAHIX1ZrCwTOSBEDqcuuht5yTTbrSC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773721852; c=relaxed/simple;
	bh=+qEdsUsTBQ5PdU99AN+GVBCS7vF9AHbvt2iuwIsGSck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ouUHDTByr43ahV3NAK9QAjjT7IO6HGsvNHnI29yTQgtXINoCz77j2kVfJppKI/o0FJ5ygKKL7xLPa1tObEHRxPDupHXtAdusIHFEnbShKqea1q0789WmyIzUVsvB1x8W5zG1VWmaK1ut40L8oW77pauQ5xzzWl3X+B495rgXyEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dcHz9jWS; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dcHz9jWS"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5091ed02c54so192541cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 21:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773721848; cv=none;
        d=google.com; s=arc-20240605;
        b=JCg0PDlw4zak+PhcNBW1/5lc0aJq8kJraOLbBgi+4cfwkP56mv59MKx2vAetd6B0el
         i/P6UGqIDYLxBw5wFN3aW8r7FO3WR1vip4z6aX4x9mIJeXFAR/gjuZmQkqS8rou0GSQM
         f0SYsVGIjo3lE2SWlgLmdLwz143a6rY82+4cb2NehN4vsRuY0LItuPtAgX6l8O+sMaWE
         Jl6ah/Ci69zkI/icvYBOySTYHwoaigKLkLrxhV/VUBE9ppwyAK8q3O86NQSo22hEDcIn
         x9dt6x4s2AkBi8CXIMNRLe3bBTL6coYNNaetRP7cVijzbcB0qkxjc+um1Mp70sNQhefj
         BgcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        fh=rM3yDHQ8OWwOS4QsjfB/oAmhAG+xMX1+TNf2jKvyUAk=;
        b=JmiA23kQnSVe1s9yKutU/ptJ/eHtGTOUIn6vuvSssL9/gLmPn8CfLH2a+AWEb8hla0
         HQdKjwdTmvv5UWOM3+XlU7iHKgNXWp/jjeXxFZQeLWk9aGIsHSU/p5cJ72WJbKvM6GCD
         8mXEPqTSrIefRroh8bdJScFU94/+GtgyBmm0DD6VxhIunjDh5AE7j9CquToHlE8ZBJrU
         967IFUd4OXvIuzm7XMIlP382z2hsR+loa6WOc2h5HXJLYo3kzY3aX7Cmjip17b628S78
         e2WMCxNUwkjurVSCN+clLgdwkSjtkWlwY9neQ7EiCO7S3s+2262mkuPv01aROqcvSKct
         GDBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773721848; x=1774326648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        b=dcHz9jWSigF+3BARnPnbKteLX4VaADjtLsdaMyhGyNJV6JIimRYsLO4x7EbK9BzBKm
         mEBNOo5L0VUPl/dip+HXrZAa92QHbbWUxIR33fHYlLzQokFDwQJjBzeRf/caR0pjg2Mo
         34+rdKlPO1pqvYIaUSk19WaF9PSBtDSVR0MEozQlDzToqkl/jokmLSbZZk4UFJtqHEmi
         kXCC+DmS5SZkg30BADq3NkbtYVryfdZAaKXoYS6JLFIzqMyrVPWUXccsrILfv3Xl/Xkd
         r80MwV7t7nyhZxw2K0hrEcQ6qFdzAhEIEtys7scmuZDaSQSy0hx5l9Sk892/mMBb7UNJ
         O8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773721848; x=1774326648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        b=P3xI3gm0rvZjnv9X+phg8O9IqWZ3BeS4OZ8N+iSGcV2Mx5/IWNOOBtv4HReIU2IB8m
         apH3qZZtCOPDqLrRu/dEIHBIQGYOLvDHcqb1P09e98ZgEu+27Z8kbRq9jSUQXgY5N3nO
         DOHKjlQAN6BaJl5Qx7wye4mPURzgXcCoC+DFbKTDIPsZVEwUGizo0pV59pOqUmd5MviF
         ++tChetZbXH3Z8Idk5iwOvHyh+bI6Feu6imsT+a/HJ3o8VXGVXrFwTztWC4xg32kywFv
         RjLrCs4J0S/10SWLt6reewUyeXGwRdSa7ZjqW8bw2Ar7eXczIQfK9125tlCag7Gt6rw1
         LM6w==
X-Forwarded-Encrypted: i=1; AJvYcCUC97pRHo0qoWLEqxqLnwfxadcPrzi9G47v5FGBp/XdJVyBCzm7n1x8mLuc+RSgOX7ccN3zQS07UUCE@vger.kernel.org
X-Gm-Message-State: AOJu0YwP0qwUtsVii8Dn5ZTZT57lSZxXKD/NYMpnnGSIkR5kVAtojaLw
	MspXvvflP03Eh2CzngjCynkRZtfsN+U78Qw5MY6rpGW2myb6sZEuJrW48Ch/3ofaGn1LPzYAfh9
	7X3QCU2W5U4cYwYeGSoCaRliH+W3RMy3fAwxAErGH
X-Gm-Gg: ATEYQzxHoiaciu+FlsejjsoxfFTNlFi80pe6cpZGkjzfYAb7Pv6EWwU+tYhLaDrqU8P
	m6e4FJ9PVvM9556kRQc5OlONfPpZ4OlLVJ8SX5zdEbyDoWDvOIqq/E5yh4nDuEboYxHXMSdn6/6
	gKnoQtHAtfEbDgqu4GJKf8Dp/URoEkTzAsBvbUYjJuVlOtUpNvtIRs9WSyeLIjJrjXfwh3fQMXB
	gjWFIiM1lnEPe39UhOodqcY2W1oU4o+VWTD5xXxs2L/+U9yEmOCEb6noB0j3MxIvtEk+vMX3GUo
	6iLEPg==
X-Received: by 2002:a05:622a:1b92:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50998c190femr8741161cf.2.1773721847648; Mon, 16 Mar 2026
 21:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
In-Reply-To: <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:30:36 -0700
X-Gm-Features: AaiRm50ZCLTl3QDNivnPnY48qRQMsgXcmE9SOEgt_D7vDyjlZ8af9f8bQZf6tcw
Message-ID: <CAJuCfpFdKjix2fEdZ7iSrd_nk4-5e7EUNAoCEgUc5snKzq-3Cg@mail.gmail.com>
Subject: Re: [PATCH v2 07/16] misc: open-dice: replace deprecated mmap hook
 with mmap_prepare
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

On Mon, Mar 16, 2026 at 2:13=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
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
>  drivers/misc/open-dice.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
> index 24c29e0f00ef..45060fb4ea27 100644
> --- a/drivers/misc/open-dice.c
> +++ b/drivers/misc/open-dice.c
> @@ -86,29 +86,32 @@ static ssize_t open_dice_write(struct file *filp, con=
st char __user *ptr,
>  /*
>   * Creates a mapping of the reserved memory region in user address space=
.
>   */
> -static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int open_dice_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *filp =3D desc->file;
>         struct open_dice_drvdata *drvdata =3D to_open_dice_drvdata(filp);
>
> -       if (vma->vm_flags & VM_MAYSHARE) {
> +       if (vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
>                 /* Do not allow userspace to modify the underlying data. =
*/
> -               if (vma->vm_flags & VM_WRITE)
> +               if (vma_desc_test(desc, VMA_WRITE_BIT))
>                         return -EPERM;
>                 /* Ensure userspace cannot acquire VM_WRITE later. */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> +               vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
>         }
>
>         /* Create write-combine mapping so all clients observe a wipe. */
> -       vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
> -       vm_flags_set(vma, VM_DONTCOPY | VM_DONTDUMP);
> -       return vm_iomap_memory(vma, drvdata->rmem->base, drvdata->rmem->s=
ize);
> +       desc->page_prot =3D pgprot_writecombine(desc->page_prot);
> +       vma_desc_set_flags(desc, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT);
> +       mmap_action_simple_ioremap(desc, drvdata->rmem->base,
> +                                  drvdata->rmem->size);
> +       return 0;
>  }
>
>  static const struct file_operations open_dice_fops =3D {
>         .owner =3D THIS_MODULE,
>         .read =3D open_dice_read,
>         .write =3D open_dice_write,
> -       .mmap =3D open_dice_mmap,
> +       .mmap_prepare =3D open_dice_mmap_prepare,
>  };
>
>  static int __init open_dice_probe(struct platform_device *pdev)
> --
> 2.53.0
>
