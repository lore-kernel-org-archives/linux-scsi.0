Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EF347F5F
	for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713515278; cv=none; b=YamoOF5gidJYDKK5zvYu4D/Xjz5mkvB75j0OHb8gk3NbGu0hqnf6kzW7bFkIq+SXyCm90DQpRIT2jLGibPF7+WNNw51OzaC7MtpFiXfYWCWfRJCOYX/LiQqA1aRYYfPdIw4u3bzTKaAMnMwf2qHFz0RV/2WuibfwQFJCfYIluoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713515278; c=relaxed/simple;
	bh=J09rxLxi86It4PgjVv38Qpy/ZjIJKNE3voqadxsgfgk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RzulVlt7aPactAekkFJ/wc46xKrNaAmacRtzzGIzyYu2HdHkbw6rAsoV8uSns7Omp5+2OlRXr+ulWAC6SZE4m0KKOZ/fkWnk4YjnD0xOUKS8muzksrG0v1iTkdHfXV5DK9H0Bspmp0RfVrjtAL6LGPfVP+WXO+7LD3XJfEDxJ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EeKryxff; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EeKryxff"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a51ddc783e3so205389966b.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 01:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713515275; x=1714120075; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J09rxLxi86It4PgjVv38Qpy/ZjIJKNE3voqadxsgfgk=;
        b=EeKryxffGH0XsN/JVPT1F3VKlso5KU64Dv/djQ+U/QlbpTbnyrh/T28F7L/52UDmqQ
         fDPHgQavHQpJyAHj5Ghf8RDFuY/VSFW16Cs7FpmMRZdpIG+nAt0bxRN9pu+lOaCXMB65
         Q0evXSTg/Ul1wUjU4KlDWosD+guMPnbJJ0IAFyz4WSHs5PuiWqPVpC1tOJe0Qg38jx1T
         UQf7FEIak97/jwgH03+eZz9DATX/6FkeGNVO1JSsOb58UqDDkTY2fOD4B+Zh5pOiM5Zm
         YXEEHfX77CbUtjHERN4Qb38CehnsPwhcB7Uy9ahCqsbcfJuEZlm/eWD7n7N6XQnroUW6
         d5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713515275; x=1714120075;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J09rxLxi86It4PgjVv38Qpy/ZjIJKNE3voqadxsgfgk=;
        b=GWNqdr7nQJTSiE6c3tjV00Q7r8y1FhCUDXqFNJ0Zyb48S22aqpL+z3I3rBLr6cKPee
         dBMl/paGuoyirYm5RWA0NvwrkjXOjS/YhMkKFP4xX8j7fFee6x67tl1ASUUyeHMRuRt4
         4zzeb0cmebaV3aKE922ukbQTM0cYqc+ryZHI22IBmdUbyDRwSvSbFBlH39K/PZXKvvSR
         KZDrFwua6LtKp+yvkSZwUvMEvQXpy4Eg8Zkv4ajC6+lFwjNUTXfeH5+MSzkACct0b19W
         N9mfg6+14t8oL/SIIhWWwKPp11wk4TzzIf1g9rp1YrNC+qkGezV62GOq+pvpjz1twX2C
         gtpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMW90ny8LIPIn88RBvh9/dfxU06m29CzDeuimY9jgBrYPqX7s4k84BUACr/cSzuuVFPTeNItHnjDPRmf3NhQjoDpdUhLHGaTbxJQ==
X-Gm-Message-State: AOJu0YyWSOV0OIrLu+Zk5AQrTtxfxKPhSh/GNmJ3xD3EW4mgFPRZAMJm
	mti1wt0nALdoZWD81d/FqcW7oL0xJFxVYmFtPMVosKHA6Dqxh9xoYDyt3Za2PZE=
X-Google-Smtp-Source: AGHT+IFd/M68aCOdOc4f0YW+896oGJ2oH2Hi/l6QeGg8t6WJC3z2Sk/Z9e2fiIIivBKEHLgzLuEvWQ==
X-Received: by 2002:a17:906:3403:b0:a52:2d83:1483 with SMTP id c3-20020a170906340300b00a522d831483mr885477ejb.53.1713515274769;
        Fri, 19 Apr 2024 01:27:54 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id jr13-20020a170906a98d00b00a4e03823107sm1882121ejb.210.2024.04.19.01.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 01:27:54 -0700 (PDT)
Message-ID: <be267b46dd6bea6d82334d9d591c9a5054ff3b17.camel@suse.com>
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
From: Martin Wilck <martin.wilck@suse.com>
To: Christoph Hellwig <hch@lst.de>, Benjamin Marzinski
 <bmarzins@redhat.com>,  Hannes Reinecke <hare@kernel.org>, Mike Snitzer
 <snitzer@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, James Bottomley
	 <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	dm-devel@lists.linux.dev
Date: Fri, 19 Apr 2024 10:27:53 +0200
In-Reply-To: <20240419062035.GA12480@lst.de>
References: <20240418070015.27781-1-hare@kernel.org>
	 <20240418070304.GA26607@lst.de>
	 <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
	 <20240418145129.GA32025@lst.de>
	 <410750a52af76fdc3bcf6265c9036037cb8141da.camel@suse.com>
	 <20240419062035.GA12480@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

(added Mike, Ben, and dm-devel)

On Fri, 2024-04-19 at 08:20 +0200, Christoph Hellwig wrote:
> On Thu, Apr 18, 2024 at 06:46:06PM +0200, Martin Wilck wrote:
> > > Why would we?=C2=A0 It makes absolutly no sense to inherit these
> > > limits,
> > > the lower device will split anyway which is very much the point
> > > of
> > > the immutable bio_vec work.
> > >=20
> >=20
> > Sorry, I don't follow. With (request-based) dm-multipath on top of
> > SCSI, we hit the "over max size limit" condition in
> > blk_insert_cloned_request() [1], which will cause IO to fail at the
> > dm
> > level. So at least in this configuration, it's crucial that the
> > upper
> > device inherit the lower device's limits.
>=20
> Oh, indeed.=C2=A0 Request based multipath is different from everyone else=
.
> I really wish we could spend the effort to convert it to bio based
> and remove this special case..
>=20

Well, it's just a matter of setting "queue_mode" in the multipath
configuration. But request-based has been the default since kernel v3.0
(f40c67f0f7e2 ("dm mpath: change to be request based")). While we
got bio-based dm-multipath back in v4.8 (76e33fe4e2c4 ("dm mpath:
reinstate bio-based support")), making it the default or even
removing request-based dm (in order to free the block layer from limit-
stacking requirements) will obviously require a broad discussion.

Mike has pointed out in 76e33fe4e2c4 that many of the original reasons
for introducing request-based dm-multipath have been obsoleted by
faster hardware and improvements in the generic block layer.=C2=A0

I am open for discussion on this subject, but with my distribution=20
maintainer hat on, I don't expect the default being changed for end
customers soon. Actually,=C2=A0with NVMe rising, I wonder if a major
technology switch for dm-multipath (which is effectively SCSI multipath
these days) makes sense at this point in time.

Thanks,
Martin

