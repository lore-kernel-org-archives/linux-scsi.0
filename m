Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E66F1891A9
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 14:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691398; cv=none; b=cdN8O01jB9QufNboBkUUbYuKlm8IXoQJBF+RciXFaj+eU2bEdScdhl1HKDr3qrOLUnwYm5vvcsBlbRwCvfb1a+M0I3jXSY0AgoZcpPbRsteeb2a8M2VFTY6CUYlEvcvnLB0yGMONa7tgZHvrPmJ1AE3Nt0z3OOB94M2b/2pl0Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691398; c=relaxed/simple;
	bh=nLlebNhMpmgF6mtbEV6iJ2Fz0XQ1EGx/3Y0LLOolihw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oqd3x/8wyXvKeD2tVEKzvpSonc5mc9Ov0s2jP0phq3elXfjF7FMj24c0sZFvMA8E1h9Qaq9ug1du0hLlS1FxgFDgHE5Ow3FBVCT423slvVWkp9SjZbK617vvrPVRSXX6SGLs6RVAiTibpUpPQaAryNc6Ot8DEgF6NuegQe/TipI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=fxHqy20K; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="fxHqy20K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=M6NxeG2A+/eETfx7hU++sN6LXelkVA7gNeSxobGN7B8=;
	b=fxHqy20KUEpGtfIpufRSfDGKc9Cx4Vm3BrjCwF4os4Hk9Jm+cqqj5xZrsDQYyqEQcPaUCdngvAu05
	 vmyTFc7YY565TdLo1lPvPeP5yVI+xMeijazxlL6FCFcPbEg06+cOGwEgOc2IFVTuMA/ON0XDAF0W99
	 RhAjLCqxI8AH5C57aqBwBL/PGe2+OdknAoP6MJbIoxBCh+yIqw/7WPrSVcldsA38+WL27rs5KpmM60
	 xHlcU3e/P7dKqeH2Oru9yxG40fBNyK88ug/kUrj2SJhf/IxiQFpaI8B5FJdspoZ4v0WFwq03l26daS
	 8SQ0Itkz8+mhxC1AUgra8YQBKLMhukA==
Received: from smtpclient.apple (91-158-174-119.elisa-laajakaista.fi [91.158.174.119])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 35a5b6b3-bc10-11f1-8e9b-005056bdf889;
	Tue, 29 Sep 2026 17:15:23 +0300 (EEST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/2] scsi: st: Restore changed drive settings after
 reset also for MTLOAD and MTRETEN
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <20260928132539.56876-2-loberman@redhat.com>
Date: Tue, 29 Sep 2026 17:15:12 +0300
Cc: linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 John Meneghini <jmeneghi@redhat.com>,
 emilne@redhat.com,
 bgurney@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2ABF6AD2-97F0-4373-A47D-1444B27A9593@kolumbus.fi>
References: <20260928132539.56876-1-loberman@redhat.com>
 <20260928132539.56876-2-loberman@redhat.com>
To: Laurence Oberman <loberman@redhat.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On 28. Sep 2026, at 16.25, Laurence Oberman <loberman@redhat.com> =
wrote:
>=20
> A device reset returns the drive's density and block size to their
> defaults.  Commit 7081dc75df79 ("scsi: st: Restore some drive settings
> after reset") re-applies values changed by the user when the position =
is
> recovered with MTREW, MTSEEK or MTEOM.  MTLOAD and MTRETEN are also
> allowed to clear the reset condition and also leave the same medium at
> BOT, but they restore nothing.
>=20
> Because check_tape() reads the drive's block size with MODE SENSE on
> every open, the driver silently switches to the drive default after =
the
> reset.  An application that set fixed-block mode with MTSETBLK and
> recovers with MTLOAD or MTRETEN keeps writing, but variable-length
> blocks, without any error.

Reset also returns the drive buffering mode (STp->drv_buffer) to the =
default.
This should also be restored. It might be possible to use the same logic =
than
with density and block size. check_tape() reads the possibly damaged =
drv_buffer
value. So the old value should be saved before check_tape() and restored =
if
the value after check_tape() differs from the saved value (and the saved
value !=3D 1). (I may have overlooked somthing.)

Another thing is the auto_lock mode. It should be enough to set
STp->door_locked =3D ST_UNLOCKED when reset is recognized. The door wiil
then be locked at first read or write.

Otherwise I did not find any issues.

Thanks, Kai

