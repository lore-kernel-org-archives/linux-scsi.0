Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63B3332EA2
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 14:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353623; cv=none; b=RfPDbPbtd8IFVuu1PLjK+7vs10olIy6ZVvfbsjdtZNezccNITPC5e0/hjmwgT35OLjc3sCWE/TB7oiO6cD8OUTURkl3Wq5BA23Y4LI9sk3x5kfLohidHwaXe/GXhwd0qvS6N9E32Nsx52SHICGaUzK7AgzTMN/LqEPdodFNeR6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353623; c=relaxed/simple;
	bh=W7wAkKB6JKFWmZfWHlFHCGPPv8/0cJRd8XPq/nwLdmk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=AEr4h7urBxTxobkDf0WNF3DnVeNy/++BkmYnPPErUq4+FBRtSjj4vSHCDKB56aAASu3Icf7+WFHByvzPYpa7SMyTcTOar+OqudkBJYjwjNHDmu3IS/IZLuSpChCXVtFOXb/hebNo/hl+4DMl2qJKlCjdfa31OCpk5k9AbbB7+P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=c7n1N9ua; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="c7n1N9ua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=9ugIWDeiricd4sEt2SMsGgFKN8k9MMPBoqYRU2ig3uk=;
	b=c7n1N9uaOmUJvqs/H6Ar/N6QtgadiCXNMwu8EXf11or1bPlz0fDU04I+kLrtcgmkBUxheyBQRMmEx
	 A9tuJLGFAG+XFAhsXe4OMKuDmh57JxbGzauh1ZCFIoFVXAMKMSLvdFlGzlfIeNg5LEjE9D8e8RFImD
	 HwQIFHZluYL22Bz7EldI2WBvabSeo4NXC1madmkRWuj3UW7Q14GTOVDHO8Sg/Y+L+pXZOqDs3byaQb
	 XOo38OyetZ+LxWgSDXqE3Desrb6bfgBIw2ROkBAsbTVzwNj9MzTNDr+MQ00UQt8unkKqSQptYPmXh4
	 Xm/cotWWt6X9R0o10vVYiMY53ifxXZg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 2fb26b6d-ba55-11f0-a2b6-005056bd6ce9;
	Wed, 05 Nov 2025 16:39:08 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH 1/2] st: separate st-unique ioctl handling from scsi
 common ioctl  handling
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20251104154709.6436-1-djeffery@redhat.com>
Date: Wed, 5 Nov 2025 16:38:58 +0200
Cc: linux-scsi@vger.kernel.org,
 Laurence Oberman <loberman@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <44453D32-5CF0-4485-9F38-01A7367BAD6A@kolumbus.fi>
References: <20251104154709.6436-1-djeffery@redhat.com>
To: David Jeffery <djeffery@redhat.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)



> On 4. Nov 2025, at 17.46, David Jeffery <djeffery@redhat.com> wrote:
>=20
> The st ioctl function currently interleaves code for handling various =
st
> specific ioctls with parts of code needed for handling ioctls common =
to
> all scsi devices. Separate out st's code for the common ioctls into a =
more
> manageable, separate function.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by:     Laurence Oberman <loberman@redhat.com>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi =
<mailto:kai.makisara@kolumbus.fi>>

Thanks for doing this,
Kai

