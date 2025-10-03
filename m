Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CC92DA777
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759516818; cv=none; b=sUQLXvLBLNpex745pKkD28gUYL+zU5MLZEBY/Fc0Pt4C7Poft0SbfDEc0QHWZoaIpgFU6jzl4kjKyjZKf4cM7ygdIg/emFglgtbszlZkc31J2vZV7alBnzmDv9jIIk7YznUaUMZTREpgTrTY8Usc7tCx0JEq7eLwxoP2xY9zUMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759516818; c=relaxed/simple;
	bh=ey/li8C+LOuBbKWsY5bxj4D3ffThH0p2nhqf7x4PB2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cNTVC5IyP369mLn5Is+y4X/nfkaNDmH18soIDvKwxHykslRAMohkYH+twIaLhyRykBSYClX5vQFhUJTrlLKgVuQujLapN/xauxr+d3NwxnaSM7XLOwTxwOGg5DY/nA7H9ttqSMhXT2OnO33tz3sGYCY3LBW7EkufpvN4HQ7HZx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ak4e/idU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ak4e/idU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759516815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQbW8eVjnT8xbPJE/2WXb9nBASDu4yAverRBE/xnjls=;
	b=Ak4e/idUmLUzT7kODyWz+HRfeAmzJd7ALnuAdia301Gy8OAM21FXhoBvQSJx1BQ2Qmfv2r
	CXzJ2NpctqTyGjyKORKZFg+QVWoVWevpp8So9p4HrICAGfGEYr1Rh9A8aVPVLdWvIhLz/w
	0jODXOolfn6PZspHsg7VMVUfPLhERcE=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-8PT5nJ8ONbSAT9NaxJAIiQ-1; Fri, 03 Oct 2025 14:40:14 -0400
X-MC-Unique: 8PT5nJ8ONbSAT9NaxJAIiQ-1
X-Mimecast-MFC-AGG-ID: 8PT5nJ8ONbSAT9NaxJAIiQ_1759516813
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6352fd4c26dso3454843d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2025 11:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759516813; x=1760121613;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IQbW8eVjnT8xbPJE/2WXb9nBASDu4yAverRBE/xnjls=;
        b=H7SmNxGJ9YQbXsGakuEv8WDxJOTNVUAZYHuVr7eCBtkYvOSOBRn+QdJ5msvO1xiQ0s
         VRJwyH48/mjnE3bDbhGxW7pClyL0Dlm7obLAT052rPgsJTKhZ/IdydrEB2R1NzPnDOTW
         gQo2ORDYp6u3sMij7y9BHN3WqZabqf8ez1wM6xon9HuWYPP+5oKZdGrnmOBomdf/0iQf
         zw6c7hjovhd0Y0trixWkHFKU5nqoz8TQcIKtuq5pioG0Lpln0JKnsm6ek5wHdIPtyKXJ
         NQodo/3qn9gEhgsLL1ejGTpuVFNh1zno/Q3GYKhl7T+CIMaX5L1jHkJbEWp+XNej+2+A
         jSOw==
X-Forwarded-Encrypted: i=1; AJvYcCWGbsaw2rcgxMr/sxejQoHPdw19DGFMUpFw1X33+fOK/cHT7C4Um60lZJ9MwWJrAYZwyFbLwMPdKNQh@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Skp6FqGIIJYojFNfwhO3Shkpk5Zt+kZiUdUOzwO5fowZ26FQ
	CgMabIXvyxm9EPCE2Ony+as4Lbfy1YFKccooXNed4AzKBG+4/QoUGjNnCuiYRFiJuiRFRNUfiaY
	qJU/VXUPG6xjM6ngsQKt0B0Xh5Wn9hQanu7diWpYSaWqiujGDhwL2sGQbBbHhaOEGiHiOlvWWFF
	cg9WhlGbk5yt2UljqNho7SXKnugu09i1+FgnW3Jg==
X-Gm-Gg: ASbGncuemupfltx7qzEyOIyH52Yh+QMcslxYIfRyBiCB+eyx8wTfnU5hYZNd9VMG7jb
	2vbfTsN0iRIIith2FexOA6MEV440+mw4WQ0MlfpN/PmTDpRWfVR0fIS3aM4zSr6N+wFOS1KOJRs
	oWVsj2BQlI0/+Hx9hAbid8Bxq6Hsw=
X-Received: by 2002:a05:690e:1549:10b0:636:d7de:8c61 with SMTP id 956f58d0204a3-63b9a077cc7mr3436741d50.17.1759516813553;
        Fri, 03 Oct 2025 11:40:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH01Kn6Fe4bIMQ6xxGJ6y5emRpxFxFP3nxR1sxiKvdKcHH10vTx1TXEk+wLYSOaq/4lOErtRB2Viq7YLlqs8mI=
X-Received: by 2002:a05:690e:1549:10b0:636:d7de:8c61 with SMTP id
 956f58d0204a3-63b9a077cc7mr3436707d50.17.1759516813100; Fri, 03 Oct 2025
 11:40:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251002192510.1922731-1-emilne@redhat.com> <20251002192510.1922731-3-emilne@redhat.com>
 <8f250e77-5069-416d-9389-9c3e99535dbc@kernel.org> <CAGtn9rkZX-C7DgaMCABsF66RVGomQeK1RyRW5knLPsPEzvajOA@mail.gmail.com>
 <4a5394d5-6608-4a81-8f8d-006ea2bdcd61@acm.org>
In-Reply-To: <4a5394d5-6608-4a81-8f8d-006ea2bdcd61@acm.org>
From: Ewan Milne <emilne@redhat.com>
Date: Fri, 3 Oct 2025 14:40:02 -0400
X-Gm-Features: AS18NWAFXfjtmp2yicHuAjyij1_Evx97xDOJVkTn4RwC81Xc966BQlS_-td-gL0
Message-ID: <CAGtn9rkS9v=Y2x2Pt6ex-kM4iShGNe-jJHRk1zFOTHWKonwoFQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/9] scsi: sd: Do not retry ASC 0x3a in
 read_capacity_10() with any ASCQ
To: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org, 
	michael.christie@oracle.com, dgilbert@interlog.com, hare@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 3, 2025 at 11:45=E2=80=AFAM Bart Van Assche <bvanassche@acm.org=
> wrote:
>
> On 10/3/25 7:40 AM, Ewan Milne wrote:
> > On Fri, Oct 3, 2025 at 12:24=E2=80=AFAM Damien Le Moal <dlemoal@kernel.=
org> wrote:
> >>
> >> On 10/3/25 04:25, Ewan D. Milne wrote:
> >>> This makes the handling in read_capacity_10() consistent with other
> >>> cases, e.g. sd_spinup_disk().  Omitting .ascq in scsi_failure did not
> >>> result in wildcard matching, it only handled ASCQ 0x00.  This patch
> >>> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> >>> if a nonzero ASCQ is ever returned.
> >>>
> >>> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> >>
> >> Doesn't this need a Fixes tag ?
> >
> > I don't normally add a Fixes: tag for things like this, since I don't k=
now
> > if any device actually returns a nonzero ASCQ.  (I think either you or
> > Bart asked for this change in an earlier patch series, which is fine.)
>
> I think that I asked for this change. From
> https://www.t10.org/lists/asc-num.htm:
>
> 3Ah/00h  DZT ROM  BK    MEDIUM NOT PRESENT
> 3Ah/01h  DZT ROM  BK    MEDIUM NOT PRESENT - TRAY CLOSED
> 3Ah/02h  DZT ROM  BK    MEDIUM NOT PRESENT - TRAY OPEN
> 3Ah/03h  DZT ROM  B     MEDIUM NOT PRESENT - LOADABLE
> 3Ah/04h  DZT RO   B     MEDIUM NOT PRESENT - MEDIUM AUXILIARY MEMORY
> ACCESSIBLE
>
> In other words, a Fixes: tag is probably appropriate.
>
> Thanks,
>
> Bart.
>

Given that c1acf38cd11ef ("scsi: sd: Have midlayer retry
sd_spinup_disk() errors")
set .ascq =3D SCMD_FAILURE_ASCQ_ANY for .asc =3D 0x3A and 0f11328f2f466
("scsi: sd: Have midlayer retry read_capacity_10() errors") didn't,
this does look
like the right change to make.  However, prior to 0f11328f2f466 there
was were retries
which Mike's patch took out, I concede it's unlikely that it
intentionally left the default
3 retries for sub-cases of ASC 0x3A.  MIke, feel free to correct me.

Martin, please add:

Fixes: 0f11328f2f466 ("scsi: sd: Have midlayer retry read_capacity_10() err=
ors")

-Ewan

