Received: from mx2.usergate.com (mx2.usergate.com [46.229.79.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08B2757F3;
	Mon, 28 Apr 2025 04:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745814784; cv=none; b=Q2Fac1FxCGeYUiyeHC79J/Gs4z2HNpgQ6icC+TcmaGWw1s2eJfCdYGqgEBOvZyk3uAiYqPjPTSEJJtijRf0OA6dlAZSRrK6iE6C8J5KLvXG0917ALYfLE3Z69FdfPzw+pxpwArmwiIE/8XrelZwnR6rmYVDksLvBru2eYwsJq/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745814784; c=relaxed/simple;
	bh=65dGDQ7KC5gb8ZN/yVTlS/mI09vk4NvThUv7Np+mOJw=;
	h=Content-Type:Date:Message-ID:To:CC:Subject:From:MIME-Version:
	 References:In-Reply-To; b=sKgx5GoJtH/4nAgvwwirw12E0Di2hOdYDokCstAqvNlGHXXUNfUazfA8NQYasvaCfoA5/HoEiQUVYf+cpaYbkEcuEjOc0CmIrfs1Z2AgC3Dmr2iSk2AxVA4jezOSIjlOcW2/7j4brpeVzj8EH1+hrGtRKW7+hLwsu/qbb5q9o+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 6859182994DC439CA71E760988FD0AB9; Mon, 28 Apr 2025 11:32:45 +0700
Content-Type: text/plain;
	charset="UTF-8"
Date: Mon, 28 Apr 2025 11:32:44 +0700
Message-ID: <D9HZOMWGZGA4.2IADJWTQC9M6W@usergate.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	<hare@suse.com>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,<lvc-project@linuxtesting.org>
Subject: Re: [PATCH 6.1 v2 0/3] aic79xx: Add some non-NULL checks
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.17.0
References: <20250421081604.655282-1-bbelyavtsev@usergate.com>
	 <c3fc938af6662c00b57e93f2cc7e48d62e6572df.camel@HansenPartnership.com>
In-Reply-To: <c3fc938af6662c00b57e93f2cc7e48d62e6572df.camel@HansenPartnership.com>
X-ClientProxiedBy: ESLSRV-EXCH-01.esafeline.com (192.168.90.36) To
 nsk02-mbx01.esafeline.com (10.10.1.35)
X-Message-Id: C3BEA80AD9E449F2A7E742BF26EE67DC
X-MailFileId: 235BC18B4214412BBA7A43901242D84E

On Mon Apr 21, 2025 at 7:12 PM +07, James Bottomley wrote:
> On Mon, 2025-04-21 at 15:16 +0700, Boris Belyavtsev wrote:
> > Add non-NULL checks for ahd_lookup_scb return value.
> >
> > scb could be NULL if faulty hardware return certain incorrect values
> > to the driver.
>
> It's a general principle that we trust values coming from the card ...
> you are, after all, trusting it with your data.  If there's a fault in
> the way the card is operating, we can work around that, so if you have
> a card which is producing these NULLs, can you provide details so we
> can investigate?
>
> Regards,
>
> James

Well, to be honest, I do not have such a device/card which would
represent the problem. These checks are more about defensive programming
(in case of an accident fault in a card for example).

I agree this checks could be excessive, especially in ahd_linux_queue_abort=
_cmd()
at aic_79xx_osm.c NULL value is unexpected.

What do you think about that?

Anyways it is up to maintainer if this checks could be valuable here or
not.
