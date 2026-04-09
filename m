Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDC315D3B
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 20:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775767028; cv=pass; b=nMoOqR49DJzbsND5yvnMzLJl5nV4ISVf5q9d6br3Uz8KnkG5iJtr97SW0X1FKtPHN9VVQEZuwGAgpr2w+1zERR0AaZ11PRXAW5A0vX7+u/LhBmw0/hKPYCs93kbtmQ0gtzQealEd2Un6AEpqVAc42io2P5k3aaZM+EQ5Mm5ShXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775767028; c=relaxed/simple;
	bh=9GON4HqrWMN21HWEXWy1UigIACbH1qvKcO/t8RyCEB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kff32T4m8H56lT6ysJPYV8YnCGP+WbNlVN8UOqFcbkg5xrx5LU5+mogW7oLlYbQkKq6HBfbMnmhuEg5zSieWPT0KsariZaKt9DzCAWJvZn6GnJ8LtsuRR2JCGSMxIJ4NwR/GSMQIRbwMisyNphPrZ4NZUFakTMLHxwO8fRmDhBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJpfVwO8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YdzkUFB7; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJpfVwO8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YdzkUFB7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775767026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9GON4HqrWMN21HWEXWy1UigIACbH1qvKcO/t8RyCEB0=;
	b=CJpfVwO8C7Ni3xuKmN2QTWMuOxD0vTW8wg/5VvOmnzvVpHjHakksZTcW+QCEyfP+iU+gBZ
	zQZ+UQzx8MUCmeRbY1WjX0K23CtsgeLMzRn1gaQQIfFUVeGE6qrNh0BNCViUvTcX0nZ2CS
	QglY3dgMr5Eoj3hd44j8v9FqsknwZFE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-5MrNt4wxOgC1YyRCWv0jdw-1; Thu, 09 Apr 2026 16:37:04 -0400
X-MC-Unique: 5MrNt4wxOgC1YyRCWv0jdw-1
X-Mimecast-MFC-AGG-ID: 5MrNt4wxOgC1YyRCWv0jdw_1775767023
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-38e16f6fbceso6154361fa.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 13:37:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775767023; cv=none;
        d=google.com; s=arc-20240605;
        b=L2EC5f1PXuES8an4ycb9iViq7sqRQUpD6Mximg8ZYLLEN21ba97eqzi5LWeEY82Nh0
         ZksKINkc87hxuxRBMwg54i2vjZv+NqrFLKAgZ7Jr7xk/nvRh/7FIFPIgr6zx1w4TyFF8
         +Nab8u1dAJXPGWTGopApSx1qxO1zqX9iz1Gg078cPepRgOjrlqzSdxv1FKvLgBmAOQF9
         eWB5uz2nAknd9d9r2CKiYAHea+4bmBudjyu29ZoBWa0bJFG/0OHmndjqEE+gr72v4Yla
         ntviS3MxHJJkD9fECz6bMn3ZW9V96mkvpe44et0Q+6O8KWLFEauHSgxNMMf1EXeGNR+7
         lwlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9GON4HqrWMN21HWEXWy1UigIACbH1qvKcO/t8RyCEB0=;
        fh=nDTAa5W2UPfEmkh0xpVDWZw/SHTNz5o3jMqdh67O/GM=;
        b=OJ9JkDtqIFiqPiIEq3W1YP/oZ+oWtzj58eaSp3zuEywzv/a2WrlJKCqeDgEnwpvKLA
         Alh8bBTDvqDQWsdCwyPTfOo42lHbs9mbxnOOpWB6J8NENHjGfEu2tRo173y1wYeoa9Q2
         iSnp5RZfc//PCSA8+3Odvu0uppMcOpLnn50oHSGbVV3pfVCl+UY1w6pv1qFpwF/Giime
         +X1WoiYIEyTaCVBdczYbE9DkCb9/JWIVSjn0fcL6uer2TJ7OpaIis3AwMYhSZqE7YCPw
         QrkjIltff+DT7KVwZPNOYwlolhetzBovlZhSjB43MdJ5jG31JGoFs3wyQ+PXcaKrG2Zf
         H/hQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775767023; x=1776371823; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9GON4HqrWMN21HWEXWy1UigIACbH1qvKcO/t8RyCEB0=;
        b=YdzkUFB7wUFja+EhKAHF6zmTzA21H/mtWFp5DyvMtsKqktAR3DKvb/WKQvjF9ftiwy
         9bgbycl/uhHTNsESm1f7ClDwRaTz1h8YGg7cNJNnFtlcNtpHniHZ5aDOURnoX3YnbN0m
         VGCyoymORA+KN8vaZEyYs8W7Ikd49SFMQ3KhuqdpEBnubazx33ljvRUpVa9uxtkZfmEH
         XvnOxhsXhDRcL6ohiOWz5k+WNNC8IdFhiJGZ8FX0KecnSNSCt8oq53lA6gy2wsFavDA7
         0d8+269MvySqtVzHTSGVPczzsJYeEuhJiLySn5UjhCnIQtgMgNJl5D3bM3Gq60/RG8Kv
         8tdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775767023; x=1776371823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9GON4HqrWMN21HWEXWy1UigIACbH1qvKcO/t8RyCEB0=;
        b=VIWhJJzIcN7S80PYBgXKM5PpRb6JAGh+cqVBsJgKoyhifQvw0vblZmrUoke1KZhM0g
         33jzlgStaYEUCH7XWn1naagpxFPVmAc3Utkp//m11zIRziI/yAg1yQ+S4Wiwp5agbQ6/
         QL1Qzju7FKY2ysw/1g07m+QHc6n0yj+Ln6F8Yxtn/vZ8Abluuswf6B/qt4rVi2KvdQHg
         CIYdW5ilTFWdVjgh1Tgh5Rcjf0SboWySaV8BbtpprLHfI1f69Q2rtdxIMTAsd00qZ17K
         4MEtVf2NObNNwkpiRrYUN+xfPPYm+cAMDXyqmSRQVrHUVXaa8UqJksCzSXfxSquCVQqh
         YArg==
X-Forwarded-Encrypted: i=1; AJvYcCVARgCQDyrVq75+8qUV68MJ3c8p+0hIFMEldP9eUH77zlF2BOE7KncCc5wibnvoga9SBzyEORBtVnX9@vger.kernel.org
X-Gm-Message-State: AOJu0YxV8JDV9Dlf1QfQj5eFBFUH5F7X3n0NwZ6a+zTecJ3Pwfz7Uw5/
	6jcfEZqq1rq8AcimOKgJadPhA534swUZOALLFamVE05qmioRw+xTgzrZ49r4gZmoWVVnqlOFl/W
	otsku7VJYZ7WBCtt2SBHnQP4683D/TtPmoBCE1uSUv0s+Z4CgOgJ6bbI57bx70K4CbOlZkGfX1+
	MLfbyFwR80+CsU6xSp+8+rwWYSCNp/dkUyTd4mPA==
X-Gm-Gg: AeBDietfci+/6zm2yPfpJhl8g5OvCxOKHWP8BqzImNqv1ao3z9aBjdTPAy5RdIPeIl/
	KdfhxISpCEs8fEOwueJUJsIg8jOa4jSM0RktANR985MwKT82PyRpqAasspSmJs+iUrjfXccQUdE
	GIpLaRWSxsQjvs4NAAxDP/gIvwO5h6lLygHx+Ud+NAT5V5qgSzCWzgeXsgbOkFOMlI6bHTp9KAk
	x2Z
X-Received: by 2002:a2e:b8d1:0:b0:38a:4dd3:6a48 with SMTP id 38308e7fff4ca-38e4bf6873bmr720041fa.26.1775767023268;
        Thu, 09 Apr 2026 13:37:03 -0700 (PDT)
X-Received: by 2002:a2e:b8d1:0:b0:38a:4dd3:6a48 with SMTP id
 38308e7fff4ca-38e4bf6873bmr719981fa.26.1775767022741; Thu, 09 Apr 2026
 13:37:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260407153532.6395-1-djeffery@redhat.com> <20260407153532.6395-6-djeffery@redhat.com>
 <c5cb8cf0-9beb-4bc4-8ce6-83b4544beede@oracle.com> <CA+-xHTG9tMCCf11NZwKfvE5xvCfjXrttDXhFsyz=SCofAc9Mgw@mail.gmail.com>
 <069f3f1b-8150-41e8-a760-f85a0b1b0ce4@oracle.com> <CA+-xHTFdKaCCwkytXpWdvp6vZ4ZCh+Pp8wzkoVZYPOy--CjiSw@mail.gmail.com>
 <c9af1723-550c-4f2b-aa04-3ce769bb4a84@oracle.com>
In-Reply-To: <c9af1723-550c-4f2b-aa04-3ce769bb4a84@oracle.com>
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 9 Apr 2026 16:36:50 -0400
X-Gm-Features: AQROBzCNo2zD09xUDoJkeee-Ps33E2lSudGCsUOC7vsRfjmkn3a0hz8Fbj91pfc
Message-ID: <CA+-xHTEGpmM7Kvpip1C4QjMPU8u9MoP9=bMyukEWtgwK6VdShw@mail.gmail.com>
Subject: Re: [PATCH 5/5] scsi: enable async shutdown support
To: John Garry <john.g.garry@oracle.com>
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tarun Sahu <tarunsahu@google.com>, 
	Pasha Tatashin <tatashin@google.com>, =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jordan Richards <jordanrichards@google.com>, Ewan Milne <emilne@redhat.com>, 
	John Meneghini <jmeneghi@redhat.com>, "Lombardi, Maurizio" <mlombard@redhat.com>, 
	Stuart Hayes <stuart.w.hayes@gmail.com>, Laurence Oberman <loberman@redhat.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 8:18=E2=80=AFAM John Garry <john.g.garry@oracle.com>=
 wrote:
>
> On 08/04/2026 20:35, David Jeffery wrote:
> >> Well it is not exactly like that. We have the following:
> >>
> >> scsi_sysfs_add_sdev() -> device_enable_async_suspend(&sdev->sdev_gende=
v)
> >>
> >> and
> >>
> >> scsi_sysfs_device_initialize() ->
> >> scsi_enable_async_suspend(&sdev->sdev_gendev) ->
> >> device_enable_async_suspend(&sdev->sdev_gendev) when not async
> >>
> >> Maybe similar needs to be done for this shutdown feature. AFICS, Bart,
> >> added scsi_enable_async_suspend(), so maybe he can comment.
> >>
> > My inclination is to drop adding device_enable_async_shutdown into
> > scsi_sysfs_device_initialize. The intent is for normal scsi devices,
> > and I see little value in setting the flag so early to flag partially
> > initialized or pseudo devices.
>
> That seems reasonable, but, again I am not so familiar with this async
> suspend and shutdown.
>

There also appears to be similar duplication with flagging scsi hosts
and targets for async shutdown. I'll see about consolidating those as
well.

