Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721993806D2
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 16:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780332899; cv=pass; b=Exj00eYX1Sf067xeNVC9EV9LcRdGG8SYx2ds2cN4ojfCZxbd8kN4It+ha+wv0SeCvhqSraBA/p8xSHOjZ84s3yD23Tzik8sGUy1I1LBY3x+BlMkb7JKpmy8JuSn024PTuJ1qHbjh7MB76ifH8vztR/aGYyebhXyir/iMGps9UOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780332899; c=relaxed/simple;
	bh=0e7u8ODv5hGAN3SwrIVi3OVbVFu5joHm/GWqQlQCsiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FZ5ZOEH2eBQe2qH74I1pu/ghfqJBGfUct3NIbFb1GFrQwnS+o4KJ8IS8xbgHNhCFPTUA9FEBrra8hzBWPPtZ5SdEMCrU0QmZWS3+QIV3sho/x/PLOpktqw2IdfzKWU6mR9LHeT0DqXpsVQoRI+VumFALIzeuGr1hECAMqNDIT2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SqAM49f1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=J0HX1AoD; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SqAM49f1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0HX1AoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780332897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e7u8ODv5hGAN3SwrIVi3OVbVFu5joHm/GWqQlQCsiU=;
	b=SqAM49f1CijyAxTLKqCZEa+VFjjHw1wLmdw+PI0W3jQqNEN/p1OecSMCXAc4Zk+PaToqKA
	2UkTIsM7YV5ml5MEry5h8Qiep52q21uJPS+5SH+UGUL8XJbY+4b2ySELFuLZ7LdgL6jIdL
	XCAoqUsKlbP0EFcVs9MqdGAc/dmd+tM=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-iQQ4FP02N6WUsWZLqxKnLA-1; Mon, 01 Jun 2026 12:54:56 -0400
X-MC-Unique: iQQ4FP02N6WUsWZLqxKnLA-1
X-Mimecast-MFC-AGG-ID: iQQ4FP02N6WUsWZLqxKnLA_1780332896
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-6cfc66167c4so723203137.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Jun 2026 09:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780332896; cv=none;
        d=google.com; s=arc-20240605;
        b=gemj3rRt9xW1ZO5dg4HpEbWFTIROUfam8w/SCW//9mRhADfcsvtqXIn2TortxIkD3j
         9Z18QBEi0cg7Cz01e6ttYJOreRNtZ2WYQzC4e8yOZTVUo8FV4diLwl24idphiS6Sd8em
         8fe54JVtqg4rFHlRcfqaltGswOTeD1Sbaxn3sLIe9pQE6lyc3z/r9O/C99Bw037oGn17
         LVCJahWRgeARnY0ekix1vZ38tIiuTPzeNp1yVqeZoD8B9+NA33JaGcezYadf6JCVXB74
         k7zpBjb77o8B5VvS9tdF339oSSl/88LAqB1lY4Nw2pXpHE+9r4opGk7WSGpJRKtiDf6L
         dDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0e7u8ODv5hGAN3SwrIVi3OVbVFu5joHm/GWqQlQCsiU=;
        fh=clhQBx8xQdILd+1QR9g7/RDkR32EhrY9/I+zX2AzuvI=;
        b=X8omUbhmEzSd0plua+zJgcH1bqxyTJEQd4EuCcqStlbP3zBg24Ow3cPWGMLpt1zA2R
         FERCnqZ53C1WEqrqmbsEqAonbiF3zNA+5PuCBtWzASQrOYLms+Ym1y6bXN2ST2QH1Sto
         BeGYzCQ9MfAyPiEbgoJmvnD6JV77tVPMQBRhmsdGjfCKLAbrr5Y81RDhRpvMIjAvKn7G
         C54FJH04M6LE6SfB4eR/BNVJJFE2IWcUIuy8BHvHmjiigffLrg57qYTt0Kgh2xEt3+iY
         mARvoScpEdg3nP1M3d1ii14X45agR1auoCT+hnqjM4VuUb9w9UMruWZgZb1D2CqckXbM
         +AYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780332896; x=1780937696; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0e7u8ODv5hGAN3SwrIVi3OVbVFu5joHm/GWqQlQCsiU=;
        b=J0HX1AoDeVOxNSBiVzNn9uDVmULOqZ90utszohtkv3W5QeQTflsrwgRYlMADl+J/jh
         SmkQw6NMu2Kmk4iABYTjAo+AnSGtm92DUNaU8ITg2lJOlbrDPZsD9lq0yo4YdT0xGtpb
         UfbpyhUBwtDl03On45DaG+0Xa65vlLGh7dS1IfT5cZlSBvh6opHI6bXkfkRVSG8booD7
         HxaKE+79KXmgtNGab6TovSFiK8+J2hROZREYXxUCAX4HAKtIvc4WMEddnhXTDPGVpB7o
         hzxolkMnaUvVR4PBj2gAcV/We8r+SbZcyIl9OINZuYJFnLLYVlUnOXUMQYLd0rjGflqq
         2ICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780332896; x=1780937696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0e7u8ODv5hGAN3SwrIVi3OVbVFu5joHm/GWqQlQCsiU=;
        b=Jnozhyoa2eVigIfOwG9LVISueI75QnbJLGKSgR3N5SRo794iRAEo8BqQ1pGa6+OS2j
         JCZbjZ285EZ5VUtaw6pdm+Vq3kk3Nw5pVzPG/aXRPnIjOLjuWoNa4Kp9w/VYQBdQIprA
         03EJdixZY6bq9QAhAfP277uYw5TrE1VoGNiuYgJjDsEOOXHzJp6VbcTZIppu8cUBm3yL
         +kfBw+bdRnemyXd98wzWOzH5jpeeoSskkI9zLR5hurnE0ZreAxN+9UHUJQrHjjBtbTx0
         p+ig5aoKZvzAR+6gRDruZBXObCytMwWtwuEp+/bCgiuTYqXTWecTQndyLJID0BL2RRJo
         UkAg==
X-Forwarded-Encrypted: i=1; AFNElJ8AO2M/FpWaJ28SLuOlG9tdhKOTFtbOZeFOauWWQTaK7D5ZppUpOqstGyclgcq7sJpm9u9/GYfJfFN7@vger.kernel.org
X-Gm-Message-State: AOJu0YziTVU0h0gjvRKLWOlFE4g3EBfzonqYzZUX5m7+ydPaqFHUSYFW
	VKEVlG7I71zTCOJY1E4nwCQmhxADfhlEDpfsPQ6tUUSR9pxey+XJAVa9JY8XXXeHIY4ArhT/7nA
	/xi0R4jQxUTt4qtwNzuGFluwrIBcQZex5KSmJSYxi+jd7q+GmyU1uLPr4bPXpfkX/HOaYXlzXvx
	ZedD27EXteZgH2qumy6m3Kt0a5gg1IYR4cwL84oQ==
X-Gm-Gg: Acq92OHhX9+b7u+p1XIDdFg5Ie8RgDtMuvf6qG3hT/xesSqWoIVJE9cCV5ijpiEe1Hs
	Zeru1sjQA5HwLrgLv/35D/duf/FLs4GleTmcMYEbqlVNCbRL1ZgC8arLvLOia8Rl5dZ0B3u20Q4
	FNXn/CVZCbiX2s/BS4PzwUaqqUsuO4Kq3DRAATUTPaCuaEmHuTiIqDcqyf78SwaBY604BhWnfX0
	MdNx4lTXJXwM4/IdnuW4QgO8sBT6BUz9mugMGQDr/i9+Xx5tP9fqUboMRzPm0EqVYuBg/A=
X-Received: by 2002:a05:6102:41c1:b0:6d3:aad5:6d2d with SMTP id ada2fe7eead31-6d3aad571d5mr1975299137.18.1780332895723;
        Mon, 01 Jun 2026 09:54:55 -0700 (PDT)
X-Received: by 2002:a05:6102:41c1:b0:6d3:aad5:6d2d with SMTP id
 ada2fe7eead31-6d3aad571d5mr1975273137.18.1780332895334; Mon, 01 Jun 2026
 09:54:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518193204.14273-1-djeffery@redhat.com> <DIXT3WV9XAWK.3E0JOPV2K6NC1@kernel.org>
In-Reply-To: <DIXT3WV9XAWK.3E0JOPV2K6NC1@kernel.org>
From: David Jeffery <djeffery@redhat.com>
Date: Mon, 1 Jun 2026 12:54:42 -0400
X-Gm-Features: AVHnY4JlEP4O7SvjLzcCS-aNG7BrnY8TX1LnwVykV7UvnzLu5Qi3VLZ62Fw9ZAA
Message-ID: <CA+-xHTGSuo-i872=-SG5pf+xGAN71TDQ=5f-H0kuv9g8G3uqZA@mail.gmail.com>
Subject: Re: [PATCH v16 0/5] shut down devices asynchronously
To: Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <tatashin@google.com>, 
	=?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Helgaas <helgaas@kernel.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>, 
	kexec@lists.infradead.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 1, 2026 at 11:10=E2=80=AFAM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> On Mon May 18, 2026 at 9:31 PM CEST, David Jeffery wrote:
> > These patches are now rebased against the driver-core tree's driver-cor=
e-next
> > branch.
>
> [...]
>
> > Changes from V15:
> >
> > The async_shutdown bit field is converted to a device flags bit Convert=
 all
> > patches to use the flag bit accessor macros to set or check if async sh=
utdown
> > should be used Added documentation on the kernel parameter to control u=
se of
> > async shutdown
>
> Did you have a look at the Sashiko report from v15 [1]? Some of the conce=
rns
> raised seem valid at a quick glance.
>
> (It seems that this version has not been picked up by Sashiko (despite yo=
u
> mentioning they are based on driver-core-next). I'd assume it doesn't lik=
e that
> the series was not sent with '--base'.)
>
> Can you have a look at [1] please?
>
> Thanks,
> Danilo
>
> [1] https://sashiko.dev/#/patchset/20260429175016.7915-1-djeffery%40redha=
t.com

This does look to have found some legitimate issues in need of
correction. I'll get them fixed.

Thanks,
David Jeffery

