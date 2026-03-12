Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4292E03F2
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773324110; cv=pass; b=RrfChVvb9UcZneU6E3BeLbKTHsSokIxq+mmnpd9+Y1bl54uepeWQs/Vmb79cd9jp4acuts5a7bjb8NHmPzX5VrtRbJ/bXwJOuS4Sa+KppIsMb4QqaAa3UkQ8PNjccSCG4nqGCSSK46mlvvFgPlloSg+tF9Hr5fL36/QkHhYJg9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773324110; c=relaxed/simple;
	bh=h7HyxgIgdaXVa7GaIMk60Eou7grQ16jf0HfHA3SBWAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQTfV0Gt4+qucHQ+ybvsJE0v4LifBDpRUorGx6eI4rjLMVUNGtszO0a9rEZESkliREeqc2IHfx3PoPUn7unEctMP1iqQWCNrYZPAMZoqRqZb9CbMfmGD6xhHGaD11tp2bCxfGHITLkjQ0c/5cN6DqI7JT1PTyzPSSRf8tuQNqZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLl1MxzJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nsWHhxRo; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLl1MxzJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nsWHhxRo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773324108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=svCptW0MF+j8ogyjRJzY7kaL3jUF3IX/ZurOettGWWg=;
	b=NLl1MxzJaLyr3uMRXSUrQZGCgxJEqgXWpVQmd4O7V7pSGMsNP6bUH+6Cwf7Wq8Ka2eSgx5
	Iff2l8nrU8mClXnwY+anhBwWGncG/KZB7M5R9BspOBQDFJ/rVTwtnnz5xQj/do5gyVDlRH
	Anukc87Bb0RqiNoJ/YpV6XMKhk6eenw=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-17Ge-bjCNIaB7uU9Hb_rOQ-1; Thu, 12 Mar 2026 10:01:45 -0400
X-MC-Unique: 17Ge-bjCNIaB7uU9Hb_rOQ-1
X-Mimecast-MFC-AGG-ID: 17Ge-bjCNIaB7uU9Hb_rOQ_1773324105
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-417323e3806so10116873fac.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 07:01:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773324105; cv=none;
        d=google.com; s=arc-20240605;
        b=Nyu1rHJ78XV9ZTo8iGn0LEtQwfU6NDjfUi44WQU4jGJKS6br+i39GPc+jiJXGa1XiH
         Np8aJiDXorCdYc0Mx1J/EHLL+kfcEaHY7VHPpRq4ruoLz/7uHez6tyd75xcIF2CTh3J8
         fRdwLo+JS2l4etIAnONavdtOg94NiYPrRBAIhWr0ofwuH1fFHCBxOZDe6eE0N0IYkZCm
         XXIb5d4h4Zr70H0Fu2jXqtfpu41dcCRX0Sm8ND8so9VVRJYSlUZw2GKcRhWB7aYATage
         VdGCObyLtyDlay88ZWPvuSnM5MUzPCYNgybtqEcX2VgGn2hXEOP+j9WRwaXEMJ9DzPsX
         y/kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=svCptW0MF+j8ogyjRJzY7kaL3jUF3IX/ZurOettGWWg=;
        fh=Xz/ukVCqdpq8zVNxvkHXF+AkOuglDjLR9ea5wPfekkQ=;
        b=SBrRX5WXdLIIjkleGD0rTFlT7KTW0chKj+d/HZbV7ZJ0+VFKWYKC/IDgMabs52NPbu
         oGpPmlWH0qNoyb2OjGMdvlrwJOyPDf6T/nTRf6mjHCj/qQ1GU1W5y7OmOksOAEi6xfK/
         XUar11SlbVCqUzXIKL9Om0ysouwpTK/nojM++ApzPZ3ZgzmYzlGDr5Vmq8EuWO2BudbU
         xaY5Q+MQqB2580wfDRFSvdVpNwe0fngpxiPBI2qUvcikkAhHJomm/6zfVU35y/NHCuCD
         FCUh2IsxD/mFGALG6W3P2TBKX5sfv8lUNmRECPoCBb+KlhlvOI0qqsbAdhWSajg57n1k
         bnGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773324105; x=1773928905; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svCptW0MF+j8ogyjRJzY7kaL3jUF3IX/ZurOettGWWg=;
        b=nsWHhxRozn7OrFsuD2ufuJNUcCBVYQ7g5gWFQAPzTFv3hh7nCuDHdLSezenGZogucf
         TA3uJGw4E1MH1jB4shBdmJxQiU9suYwleO5H3QqI8Z53ASAkGys23bVAcb+5m0PLXpjc
         vCe2ckdOdj9DyNBP8zaVAcQe9LyJui2Ds/IhEG2uxBMtXkvHCTlCdljgZKD8zc2P2H/L
         mKSkW1PDk7vK+seGnCOaKoh5a1Q9rpUWWhDBUmPd8ZCIQmQ0FvW1+CiXzatHWYpgBDeC
         RnOTgw5vdma9IMTshT5rNPEqsugHdqrjCHxukFnjWNvSj6tfBezUUnycSmm4IEcnpGE2
         ZHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773324105; x=1773928905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=svCptW0MF+j8ogyjRJzY7kaL3jUF3IX/ZurOettGWWg=;
        b=u9mhXNB19fNNYhRRB8pK8bLnT3FW3qF7c+5TgfFho7Va+H1MS+E8ck0cHBt/OKUiAw
         fxHe5af8BFaofR05IM1Bd1le2UPDTHicmHiQ30QpZgFhu+0QmmdfWPkvEjnFQ/pVReux
         xk+5ql+yG+zVHOTF9OAPv88/rkJYQZIYqVl6LAv8rLrnBUln2UskqyeH6sT0Aeb7GMTo
         UbZixZ+AKu6vr+Mlvvo6Di3TyIDXUJhMpM0Ihkc9F1EmCITJrFx5S6nzhAIBMMi/ISFy
         cIvgZvuwX6Q34hR8BjVN7Ros34bdRtFXBk41lsQ/jqGsn7hFxtc8Ok8C0FwtKljzp8Hy
         cpUw==
X-Forwarded-Encrypted: i=1; AJvYcCWYE9kMfvvnSHxdMMAJkoGZeAkHIknrisLt3K9+vUG5JJ9CqCbte0P/9JtIbqjtnVFkdBWsVnfkY+G1@vger.kernel.org
X-Gm-Message-State: AOJu0YxMBdgKQCK2dCgFFxHMV2eKoAux64QC0SgXe+J81SNgzq7zznAe
	c2JXs19t1rLqd/pmUMX+UNEF+kEl1kb3DIcT76zWTBHrsDKiPCzkpjZdfZqFhgtocK8x8VOOmpR
	1aSnbzlZTLLpXHf2oqm3CvR2xii8cYOs8bA7Rd3JdNEFzjL62KAuGI/sk+htqM14R4PhwuRQ8OA
	Gy8F12032AnZkrCVnYUOA+Y+8cDklsnOUOdVNaug==
X-Gm-Gg: ATEYQzy+3b/SKReQv2Pw+pooCPr3SGmHoBmpPTrQkTbPw7O630W/S048jkl9eRkGGJv
	FCyMtewluFlZQJ1amHLyLRUPi7YF5xu1DZLpcnxuMV6Xuxi1xZCvOSDkNaI3SC48UeXA6Ei+HcF
	lr0GcADG1shEOhK0kDL9OVKkuHv0HEqSxYBdXmByfVMjMFdzRmY1+0/7lmtSB6y2KfxTw4MuEpd
	rvX
X-Received: by 2002:a05:6870:d626:b0:417:5b7a:704b with SMTP id 586e51a60fabf-4177c8bd782mr3791138fac.31.1773324104853;
        Thu, 12 Mar 2026 07:01:44 -0700 (PDT)
X-Received: by 2002:a05:6870:d626:b0:417:5b7a:704b with SMTP id
 586e51a60fabf-4177c8bd782mr3791060fac.31.1773324104254; Thu, 12 Mar 2026
 07:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311171209.9205-3-djeffery@redhat.com> <20260311230523.GA1066455@bhelgaas>
In-Reply-To: <20260311230523.GA1066455@bhelgaas>
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 12 Mar 2026 10:01:28 -0400
X-Gm-Features: AaiRm520iVQTqV1-hjp19cjbWN8oiME0iudO3mEzYMJHW6uBnWcs_r1tMTE9dMI
Message-ID: <CA+-xHTHP2QY7T_mTFbN7XN4gbtPo06-EsovuMWuJ5u1A0HXEFQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] driver core: async device shutdown infrastructure
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 7:05=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> On Wed, Mar 11, 2026 at 01:12:07PM -0400, David Jeffery wrote:
> > Patterned after async suspend, allow devices to mark themselves as want=
ing
> > to perform async shutdown. Devices using async shutdown wait only for t=
heir
> > dependencies to shutdown before executing their shutdown routine.
>
> I'm not an expert on dependencies.  Is it obvious to everybody else
> how these dependencies are expressed?  What would I look at to verify
> that, for example, PCI devices are dependencies of the PCI bridges
> leading to them?  I suppose it's the same dependencies used for
> suspend?

Yes, it uses the same dependencies as async suspend does.

> From wait_for_shutdown_dependencies() below, it looks like we'll wait
> for each child of dev and then wait for each consumer of dev before
> shutting down dev itself.

Right, just like async suspend, all children and consumers need to
shut down first for async shutdown.

>
> > Sync shutdown devices are shut down one at a time and will only wait fo=
r an
> > async shutdown device if the async device is a dependency.
>
> > @@ -132,6 +133,7 @@ struct device_private {
> >  #ifdef CONFIG_RUST
> >       struct driver_type driver_type;
> >  #endif
> > +     struct completion complete;
>
> I thought "complete" might be a little too generic, but I guess async
> suspend uses "dev->power.completion" :)

I am open to a better name, but anything I came up with ended up
excessively long in my opinion, so I settled on the current and boring
"complete".

>
> > +static void wait_for_shutdown_dependencies(struct device *dev, bool as=
ync)
> > +{
> > +     struct device_link *link;
> > +     int idx;
> > +
> > +     device_for_each_child(dev, &async, wait_for_device_shutdown);
> > +
> > +     idx =3D device_links_read_lock();
> > +
> > +     dev_for_each_link_to_consumer(link, dev)
> > +             if (!device_link_flag_is_sync_state_only(link->flags))
> > +                     wait_for_device_shutdown(link->consumer, &async);
> > +
> > +     device_links_read_unlock(idx);
> > +}
>
> > @@ -4828,6 +4919,12 @@ void device_shutdown(void)
> >
> >       cpufreq_suspend();
> >
> > +     /*
> > +      * Start async device threads where possible to maximize potentia=
l
> > +      * paralellism and minimize false dependency on unrelated sync de=
vices
>
> s/paralellism/parallelism/
>

Gah, I will correct it.

David Jeffery

