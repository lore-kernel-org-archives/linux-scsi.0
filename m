Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6E94D957E
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791471176; cv=none; b=tcAI7E81X+jpYgnhWLVIZz/M5GXesHgzdmWk7/7xggq69K0I3EMCBR/Oi1fvCTqHZ5BlX1PMX8ezeQ3w5ApeGcojxiTBu/pAdh6SDpZmxAJdPZnGRMHUEj1uMYRzUELFuenfaXtM7tZLXE840Rf1dRyYw/7Moqnpfn4tB+3xvnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791471176; c=relaxed/simple;
	bh=wVRqlgGyVwEHd6Wz1ViqTNx07Jsht456Uy7wWKDXDPQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pdCtJ/JMs4iSapq8gbZWIj9N5XJDAcXlB079jXXXUNcja8fU7zcpGzlJHp505cutm/RC2TYgqRH3t2TkMQa7R+7X+eRnEzXPEacO7Lj+814VqMsiJDVUTITf6G2/dyzNsby6Tww4g8arTfaU5ioXzp6YABCYWR/JdJYQahMXSao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=FE35haOX; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="FE35haOX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=wVRqlgGyVwEHd6Wz1ViqTNx07Jsht456Uy7wWKDXDPQ=;
	b=FE35haOX37Nzxd2HAWuypH4VrFVVv1xhc/nJxKLbEjX0troiUHwXx82o4jv/ICwz+OetFNt5iin5L
	 k7WkBBaPW50HpbxakdU7uWIm/v+nTAlmnVzX/SDmWEomp99lWy8u76RjXHcvjTRjKNIG2Fug3D/+7a
	 xfj+LGBIjiZSUXGk7KnKwdDdcC15tLNfo4wY1947NMM40+ocNvCQsBjfPZKR19NNS1cPjGaUtNo3d6
	 prqba0SaiezxzsZCKP8Q2XR8vesU5fBK+lvXf8988IOUFD8whbF2229WDEknpYm2unettSquSBRdIo
	 dhZgNdwkIQH1ipTCXGI+KrYhhboitig==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id c01d29a5-c327-11f1-8eb4-005056bdf889;
	Thu, 08 Oct 2026 17:51:32 +0300 (EEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] scsi: st: Save the visited block for the partition the
 drive is in
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20261006164250.773840-1-loberman@redhat.com>
Date: Thu, 8 Oct 2026 17:51:21 +0300
Cc: linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 John Meneghini <jmeneghi@redhat.com>,
 emilne@redhat.com,
 bgurney@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5EC8096D-D4C7-42C7-B76C-D60003FA571E@kolumbus.fi>
References: <20261006164250.773840-1-loberman@redhat.com>
To: Laurence Oberman <loberman@redhat.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)


> On 6. Oct 2026, at 19.42, Laurence Oberman <loberman@redhat.com> =
wrote:
>=20
> set_location() saves the current tape location before switching
> partitions, so that switch_partition() can return to it later. It =
reads
> the location with READ POSITION but stores it in the st_partstat of
> STp->partition, ignoring the partition the drive reports.
>=20
> The two differ after a device reset. When the reset is recovered with
> MTREW, MTSEEK or MTEOM, st_ioctl() sets STp->partition =3D 0 and calls
> switch_partition() to return to STp->new_partition. A drive that was =
in
> partition 1 is still there, so set_location() files the partition 1
> position under partition 0. The next switch to partition 0 locates to
> that block: if partition 0 holds less data, MTSETPART fails with EIO
> (BLANK CHECK), otherwise the tape is silently positioned at the wrong
> block.

The analysis is correct. The elegant fix makes sure that the saved =
position
is a real position and does not cause an error in future.

Whether it makes sense to the user is another thing. The behaviour after
depends on the drive, its firmware, some mode settings and maybe on what
commands have been sent to the drive before reset. For instance,
the IBM LTO SCSI Reference says enigmatically:

"A logical position is established that may or may not be the same as
the position prior to the reset. Where possible, the logical position =
prior
to reset is maintained."

But this is one of the problems with resets that the driver can't solve
(at least not with reasonable amount of work).

Reviewed-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.f =
<mailto:kai.makisara@kolumbus.f>>

Thanks,
Kai

