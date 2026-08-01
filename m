Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8093955C0
	for <linux-scsi@vger.kernel.org>; Sat,  1 Aug 2026 03:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785554030; cv=pass; b=TKZQK9ZEWbDywv42aqWk6WX3bgtkeJN89Elgm7u04Y5G0/Rq8F+wbpdWzOxi+Xt8tYNX7iV4w/pit5utzSG2agpd+PRxo1IZpEYMzbblw1f1HL2jod5y4nBeim74oXjnmqtsSemv9yAUU6EibVUdjOG6MVKJRVCzPCrQQpzxKXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785554030; c=relaxed/simple;
	bh=95QCJbuFW0DJ4I2GQ9WngTVOHrimeZjlLTACZfyrPGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U0bBq7LA+DtjUf5eTZfH0teNNFi5JxflzhO2FpbQK9QmFXYQpcwqHaVNqs4PFJVVq/7LJ+qMw061oUCfEsRe2ISGN6nTJxoV8V/Xu5D++zNcMkeDnausDj7zIRJG6lGSruBHrWcL1Pr9QX5MPzYRNF2ahtf06xl8lfCeQFk3hyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=debian.or.jp; spf=pass smtp.mailfrom=gmail.com; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=debian.or.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7dbcb505578so15477087b3.3
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 20:13:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785554027; cv=none;
        d=google.com; s=arc-20260327;
        b=MZQcnVlV7U9nZEDJOSJBJzleTlDYlwdYbDssCP8BwIjl8oyLF2gE+aIeLyotH6manD
         4g1GBrstfkx1XehIPbyFXIrgRWKXgOFrpR9qMULitqODxiqJiJPBF9Xv77PX12fS8wMG
         q2cPEApHl/opN3smTdlqVIQLrbJ6EU8EFLculWikkqHx4BFNRSMKREvsfb8QTz7RqDsw
         iKBEQoH9yYVCYW6UaN332Uk0vHdMjxhodL381cYofLdBPGUht3dMdsJq6fzkJoTT0oLv
         5vGTiBKWtfXEhaU0lfnRpiJIcv8sNnwKNxmTF4kvTPYXrYlnCcRFNv7P51NcbWqydka7
         VruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=SeAZ9LnHsy3/NLwDMK5sclw7WS1BzURw2kr/GeL6nEM=;
        fh=zhmHRkzMRp5hsYMxMRQaY5DPhKBrq/764ze2iai/V+M=;
        b=RNv3WWzUvzNprVCa9G1R0K+3qc2SntUr4RGhol4qRZVuaSv8T7CiFuyqUo8V20aiUn
         trVdsTfaFcD7Iaj7xiUYQBNWECtO6bjSio14R7MLMmpM0AF8b+Dvejg4eHdiOHO23rsE
         F1jyC1QhpNLDnfKPQWkcu3ptZ1JxVyxceBiUzyAtJf7kFcqDaIFFesexpZt7LiMeTrUO
         z/ibDrh+aQ9aR6ogtuKDgLdnXej7qGrN1ZPaAvdg2qMn0eZveldM3vJcx8+xDPe01yCl
         xvFGfKdOiUtrC0rbPXGXuIPGKHQMky1Xp/wILc9LOcAWljN83IfGscH7xL41kK0JwCFU
         6Diw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785554027; x=1786158827;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SeAZ9LnHsy3/NLwDMK5sclw7WS1BzURw2kr/GeL6nEM=;
        b=DcxqVk4Eqgoswqq9LDnn63BA7F67QyQIaD2/6eOK5ILJgNLaPGGVeTV1S/i90NcauN
         JLWoxy0GrIt+BN5OkQhkvFxv7/wGecCkx60TwUPxbaIFshLg6+XhVF0B691bnbfUDakt
         KkVIe0LF2bo749RhSltRqNY2O8L0uPyDpQxWokkSEn1mypEBwGrckU6oHVbL1urkty5U
         sX7FGXZoMseK2OOJuNCo9wNNWIYzl2q0qyIfBSGiLDD5C9925dClt2LE1yjm0mYCv9WV
         YpsKUtS1fGERWqT5bsw+ppEgRbLMKrm085iLnoEPusZgvSUwqt92YXUO/4tqngdLHQSi
         SiQQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro9fgopNUH9RZMl77q18tfQbQPjALKw2LzLZdIXjS/4HRXlhIauoA4LbHuh+uIzkqSurHG0a0JUtNlx@vger.kernel.org
X-Gm-Message-State: AOJu0YwIn+rrjHbA4ZoAjb8JpMB81WEAdYH+/BKlPsAUZJSycD0sgT4E
	12grlU6cYUqZyGP7f4aU8zZBamZQh5VIytO/rEtcJ81Ka45+/3chaGWTEHvKIe1fGfRA6cAidUc
	axfs4eDnJQ6QvYmv3LmozsIRT0dODq6A=
X-Gm-Gg: AR+sD10aBz32XIZfLLBqiz/dUW243X1Ey+poU8D8PvyyaLPPRqBBHZgvpdGkCIRhgoI
	vYj+OMZR/NTvyuBOOWEzsbpmhyy+xc0jqtp/q/9j8UM4G4oOXy6lMqwGDy79E+NTUv7JM3E6x27
	TgmRO3Kl7xY2utNfjLnYrDr+TmPYuxz/iRD5ZfJStrY+eh/HelR5YCkAL7b0RHTYN9AfHPUrWym
	9NJEytxTNRvaKLefeYnlxF+3wBFnq8W7/n8KTzq3D8bJi+TH7+1ZQvjOuJk8xcsfxSRABmwP+rY
	bkNW+ezEly4sQ8Pjsb+7Ayj9vx5xZxQWrb3rWOmq9lRR3aIumhnJKvjd34DEirQvyl9z4prvD8W
	HiA==
X-Received: by 2002:a05:690c:278a:b0:81c:b865:2231 with SMTP id
 00721157ae682-81fd4bf88ecmr32651387b3.33.1785554025363; Fri, 31 Jul 2026
 20:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net> <20260728162538.GA1325438@bhelgaas>
In-Reply-To: <20260728162538.GA1325438@bhelgaas>
From: Masanori Goto <gotom@debian.or.jp>
Date: Sat, 1 Aug 2026 12:13:18 +0900
X-Gm-Features: AUfX_mz7siEIuZSDLGecSdNp4xhgCzEOOClyi0oT7r0lmGspOzwc1eUhhS3W20M
Message-ID: <CALZLnaEmm5Zi=30n4i7ioX9ii4KMAePnZTAhAcNScSZFSNB7UA@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] PCI: Fix UAF and TOCTOU related to dynamic ID
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Bjorn Helgaas <bhelgaas@google.com>, 
	Zhenzhong Duan <zhenzhong.duan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Niklas Cassel <cassel@kernel.org>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Vaibhav Gupta <vaibhavgupta40@gmail.com>, 
	Jens Taprogge <jens.taprogge@taprogge.org>, Ido Schimmel <idosch@nvidia.com>, 
	Petr Machata <petrm@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, David Airlie <airlied@redhat.com>, 
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, industrypack-devel@lists.sourceforge.net, 
	netdev@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm a "nsp32 folk", which patch version should I take a look at?

Best regards,
Masanori


2026=E5=B9=B47=E6=9C=8829=E6=97=A5(=E6=B0=B4) 1:27 Bjorn Helgaas <helgaas@k=
ernel.org>:
>
> On Thu, Jul 23, 2026 at 11:00:39PM +0100, Gary Guo wrote:
> > While working on improving the Rust abstractions [1], Sashiko reported =
that
> > an existing UAF issue related to dynamic ID, which I find to be genuine=
.
> > When taking a look at the code I also find a TOCTOU issue where the
> > existence check of dynamic ID happens in a separate critical section as=
 the
> > actual insertion. This series fix both issues.
> >
> > There are two exported functions pci_match_id() and pci_add_dynid() whi=
ch I
> > have to tweak to implement this cleanly; I created separate "do_xxx"
> > functions to keep the existing APIs because they all have multiple user=
s.
> >
> > There're a few existing users which stores their pci_device_id argument=
 in
> > probe callback. This is a bad pattern because nothing except driver_dat=
a
> > inside pci_device_id is what they want; actual ID information can be
> > retrieved from pci_dev instead.
> >
> > There are two users that performs pointer arithmetic on the pci_device_=
id;
> > these are also problematic with dynamic ID and driver_override, so fix =
them
> > as well.
> >
> > I've used the following coccinelle script to flag all cases where the
> > pci_device_id is used other than reading its fields.
> >
> > @usage@
> > identifier fn, id;
> > position p;
> > @@
> >   fn(..., struct pci_device_id *id, ...)
> >   {
> >     ...
> >     id@p
> >     ...
> >   }
> >
> > // Due to cocci isomorphism this needs to be explicit
> > @bad@
> > identifier fn, id;
> > type T;
> > position usage.p;
> > @@
> >   fn(..., struct pci_device_id *id, ...)
> >   {
> >     ...
> >     (T*)id@p
> >     ...
> >   }
> >
> > // Good use cases
> > @good@
> > identifier fn, id, fld;
> > expression E;
> > position usage.p;
> > @@
> >   fn(..., struct pci_device_id *id, ...)
> >   {
> >     ...
> > (
> >     id@p->fld
> > |
> >     E(..., id@p, ...)
> > |
> > // Redundant checks, but ignore
> >     !id@p
> > |
> > // Redundant checks, but ignore
> >     id ? ... : ...
> > )
> >     ...
> >   }
> >
> > @script:python depends on usage && (bad || !good)@
> > p << usage.p;
> > @@
> > coccilib.report.print_report(p[0], "suspicious use of pci_device_id")
> >
> > Link: https://lore.kernel.org/all/20260618-id_info-v1-0-96af1e559ef9@ga=
ryguo.net/ [1]
> > Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kern=
el.org/ [2]
> >
> > ---
> > Changes in v4:
> > - Code and commit message style fixes (Bjorn)
> > - Link to v3: https://patch.msgid.link/20260706-pci_id_fix-v3-0-2d48fc0=
25acc@garyguo.net
> >
> > Changes in v3:
> > - Fix users which uses pci_device_id for pointer arithmetic. (Sashiko)
> > - Convert to scoped_guard. (Danilo)
> > - For static IDs, still give out static pointers and avoid making a cop=
y.
> > - Link to v2: https://patch.msgid.link/20260630-pci_id_fix-v2-0-b834a98=
c0af2@garyguo.net
> >
> > Changes in v2:
> > - Fix users which store pci_device_id.
> > - Clarify in probe documentation about the lifetime of pci_device_id
> >   parameter.
> > - Dynamic ID conflict check now ignores override_only. (Sashiko)
> > - Link to v1: https://patch.msgid.link/20260626-pci_id_fix-v1-0-a35c803=
f1b95@garyguo.net
> >
> > ---
> > Gary Guo (9):
> >       ata: ata_generic: don't store pci_device_id
> >       scsi: nsp32: don't store pci_device_id
> >       ipack: tpci200: don't store pci_device_id
> >       mlxsw: pci: don't store pci_device_id
> >       agp/via: Don't rely on address of pci_device_id
> >       agp/amd-k7: Don't rely on address of pci_device_id
> >       PCI: Make pci_match_one_device() match on ID instead of device
> >       PCI: Fix dyn_id add TOCTOU
> >       PCI: Fix UAF when probe runs concurrent to dyn ID removal
> >
> >  drivers/ata/ata_generic.c                 |   6 +-
> >  drivers/char/agp/amd-k7-agp.c             |  26 +--
> >  drivers/char/agp/via-agp.c                | 308 +++++++---------------=
--------
> >  drivers/ipack/carriers/tpci200.c          |   1 -
> >  drivers/ipack/carriers/tpci200.h          |   1 -
> >  drivers/net/ethernet/mellanox/mlxsw/pci.c |  11 +-
> >  drivers/pci/pci-driver.c                  | 194 ++++++++++---------
> >  drivers/pci/pci.h                         |  43 +++--
> >  drivers/pci/search.c                      |   8 +-
> >  drivers/scsi/nsp32.c                      |   8 +-
> >  drivers/scsi/nsp32.h                      |   8 +-
> >  include/linux/pci.h                       |   1 +
> >  12 files changed, 237 insertions(+), 378 deletions(-)
>
> I put this on pci/enumeration and plan it for v7.3, hopefully with
> acks from the AGP, tpci200, and nsp32 folks.
