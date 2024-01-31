Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE0538FA4
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706737507; cv=none; b=AnnFgZcEAvruT9W1H0RjzFAPgGtCPKSl32kbN9PtfPsi94W5WQH0iSURWsHejGEROV2yJH64AX0ZuXdSt2y+nJQVJDz16STzvnzKezZ2nPqvvfYa+gHzY69bDxxUYE2NqOcH4zhvsbCIwa2dn5TD3yzMCvJSmGA+PQiFmhtQvrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706737507; c=relaxed/simple;
	bh=RNO5W0OP+zOfgTSimLFGWc0A4ecEarSa4TiMbXZZvIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yd99Ay2KAOZ0nV/1konYFk3Oo7isfKwL/+CmIvjicCsYDEq9WZeeur+FPEr2M9RizGLcXE8AGcS4oYOkkWb9cSs/JxC2BGp8C0eUrY7r9U4aB4dOzm7F85YLtCpaqcid1JLFZVmRTmozG7qZ+eD/9wgpn1BAazTGa8NjkV6Lwkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Js+jWczE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Js+jWczE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706737504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7dbCchYRiPga9CCVNutbEbzEx6jSnpAXwCYBNUJ7928=;
	b=Js+jWczETqQoeg5wYTgWpRaw58kpGhPw4F/m0ZBKLfoyw3y5Pl41hTTR0FVFmVbew0h+6h
	HKZqryaaa/E/eoVsRt24taK0LEPz+rO3qT1flYpI3gXaAAOMyh06h1UeBlg673KUdwZj19
	PHeivvErr7Wcd0/Y3u1E4RGu3dmEUwc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-Q_oOJE6ANmKtdDqLHVB-Zw-1; Wed, 31 Jan 2024 16:45:03 -0500
X-MC-Unique: Q_oOJE6ANmKtdDqLHVB-Zw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2cf51cafaf9so2726401fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 13:45:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706737501; x=1707342301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dbCchYRiPga9CCVNutbEbzEx6jSnpAXwCYBNUJ7928=;
        b=S/YXcJq6w0HHTwzsZy/SU6DVYv9VxyN6bPycGzlkl6s6QW0cFXm4absd4TeTIivAAK
         EiOpB1vp8xgCHQ8bFZRrAzcdBnsbcTxha1Xj7CHpTJwcvzujpuvHUQMPy56CX3YzWhsq
         Lvp7+eWPEwerWCCVrS3OedkPChiDZRChhVCPQI+BjsBkdic5YVV0sG6LFa9ub5p0MxW/
         JfsxyqXRD79cxn+newh66GqwSoLNTK5NkzHHRLo3keExL1EIDcEZW0GHd9E3RzhX2Adk
         gMjO9fKyWIokDhnMO/B6/5zstwk3Kf+kQ4oI5QJhBCjsg/m7x69fxw+O9nA7E0wXjntH
         Ggbg==
X-Gm-Message-State: AOJu0Yz2U9aA+gizHwlIjQ/y3MvWHHYIFNO1U6F5paDym9aiS4yPgEEm
	zvnnSAOqR+yhihyhpmlY6oycjot/jvPD5KKqSgWxiM2xXu/0uTstkNs18Z7uq2+hvGhUh1KhVtT
	q8bnt7LR3pLfnLEc4JIEvdg1Bhjq7vv+IwIYhkq+NtSCl70MYrfjGRJd7tp8DrWvYu+CcsH0IpL
	4PaKQ3uDXHwiGiEbpaAY7D1msItC0XtMom1w==
X-Received: by 2002:a2e:8553:0:b0:2cf:3324:cedd with SMTP id u19-20020a2e8553000000b002cf3324ceddmr2282119ljj.24.1706737501763;
        Wed, 31 Jan 2024 13:45:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF4WSR9c2pT9GcR96S25SGMyV9IZm76XurE8FEjz5Uxf6I4GCo5Gdvvm8H5SrOpe9xqbYz5TXh0mtvDtkpATcA=
X-Received: by 2002:a2e:8553:0:b0:2cf:3324:cedd with SMTP id
 u19-20020a2e8553000000b002cf3324ceddmr2282099ljj.24.1706737501453; Wed, 31
 Jan 2024 13:45:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131191732.3247996-1-cleech@redhat.com> <20240131191732.3247996-2-cleech@redhat.com>
 <2024013110-greasily-juvenile-73fc@gregkh>
In-Reply-To: <2024013110-greasily-juvenile-73fc@gregkh>
From: Chris Leech <cleech@redhat.com>
Date: Wed, 31 Jan 2024 13:44:50 -0800
Message-ID: <CAPnfmX+c_TECfVgbAgphFgkCOr-=tKEvHmcxPg_vSY-qJRqaQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] uio: introduce UIO_MEM_DMA_COHERENT type
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nilesh Javali <njavali@marvell.com>, Christoph Hellwig <hch@lst.de>, 
	John Meneghini <jmeneghi@redhat.com>, Lee Duncan <lduncan@suse.com>, 
	Mike Christie <michael.christie@oracle.com>, Hannes Reinecke <hare@kernel.org>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	GR-QLogic-Storage-Upstream@marvell.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 1:29=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jan 31, 2024 at 11:17:31AM -0800, Chris Leech wrote:
> > Add a UIO memtype specifically for sharing dma_alloc_coherent
> > memory with userspace, backed by dma_mmap_coherent.
> >
> > This is mainly for the bnx2/bnx2x/bnx2i "cnic" interface, although ther=
e
> > are a few other uio drivers which map dma_alloc_coherent memory and
> > could be converted to use dma_mmap_coherent as well.
>
> What other drivers could use this?  Patches doing the conversion would
> be welcome, otherwise, again, I am very loath to take this
> one-off-change for just a single driver that shouldn't be doing this in
> the first place :)

uio_pruss and uio_dmem_genirq both appear to mmap dma_alloc_coherent
memory as UIO_MEM_PHYS.  It might not be an issue on that platforms
where those are used, but I'd be happy to include untested patches to
convert them for better adherence to the DMA APIs.

(sorry for the double send on this Greg, missed the reply-all)

- Chris

