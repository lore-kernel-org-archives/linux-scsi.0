Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ED417C21C
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740410121; cv=none; b=h7Opderag6R4/DnnDjijOzdPs6tR2NBeQCVSjhAhOlFZost4q8WjZIp0cyFd55cGVcMFecM/3Pau+yKSzZDe0SEOB6Xvpdt/grHjGWlJ1Kt+lM1QIv9a6G5WCwL3pYTG3FfyyMcsFI8Ao2Gv3lAGe/NJolYzzVW5UA81BEMlFRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740410121; c=relaxed/simple;
	bh=68oG1pNw0QVAICSpRO31fGtgeipXtn3M6MIIhHVwxT0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nY/pYD3RZT9SY5iUdPODDiI5lKBZewXPYx4Y6HHgkRvD+O45jwYwwv7nyWpYA1pIbmTRpcGcLQI0rmqIF4b/JNQyHg0ydaIgP9vz3Td3OPOFLDh+HOSgG+KzsvAp6Y0vGaA1eHm953EF4vuKoAQucjdkBgQZbGkHZO42JA2ShD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=Fp2tMbsp; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="Fp2tMbsp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=68oG1pNw0QVAICSpRO31fGtgeipXtn3M6MIIhHVwxT0=;
	b=Fp2tMbspFz+06xDmy41kQYQiJ5HVEnZzCE1VoFCcYHZSqCTCvxXzReSnMqnD2k4MHLVu0IEeQmw/4
	 4Wm5gAfga/cUx/boMLlF58x9Tfr2YcBLeIK5YCDY84l8sVYe+tnNbWVSWvx5HX2LkkzrPnT/zPWnVO
	 u9Brkwv7KxoKf1vs1orq3TJNJ0EUx1UE4unWM1v2nMzsBV1Bwfp6uL/dqYjGmyykF5tMcgGKh5JYwq
	 fW+r886qmmquhG3rAjZ95LUu9+XyIBXAYcEshm64qPJGJJz/FED5Xm88lx3kAnpEC+XbPlwbdUxT5H
	 x5PFyuN95eT+v7sK41ZUEmX4zuE52QA==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id fcb7c899-f2c1-11ef-8389-005056bdd08f;
	Mon, 24 Feb 2025 17:14:06 +0200 (EET)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH v2 0/7] scsi: scsi_debug: Add more tape support
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <yq134g4f2xp.fsf@ca-mkp.ca.oracle.com>
Date: Mon, 24 Feb 2025 17:13:55 +0200
Cc: linux-scsi@vger.kernel.org,
 dgilbert@interlog.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 jmeneghi@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <46401BB6-2688-4E8D-A730-77B7334AFE40@kolumbus.fi>
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
 <yq134g4f2xp.fsf@ca-mkp.ca.oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On 24. Feb 2025, at 5.19, Martin K. Petersen =
<martin.petersen@oracle.com> wrote:
>=20
>=20
> Kai,
>=20
>> Currently, the scsi_debug driver can create tape devices and the st
>> driver attaches to those. Nothing much can be done with the tape
>> devices because scsi_debug does not have support for the =
tape-specific
>> commands and features. These patches add some more tape support to =
the
>> scsi_debug driver. The end result is simulated drives with a tape
>> having one or two partitions (one partition is created initially).
>=20
> Applied to 6.15/scsi-staging, thanks!
>=20
> Unless I'm missing something, you'll need to update the report =
supported
> operation codes bitmasks for the commands that are defined in both SBC
> and SSC (READ(6), WRITE(6), ...).
>=20
I have tried to keep the changes minimal in definitions used by the =
existing
code. The definitions for READ (6), WRITE (6), etc., seemed to be =
permissive
enough not to affect the tape additions.

The command definitions in scsi_debug are common to all devices. This
means that it reports as supported opcodes anything that is defined for
any device. It also tries to execute any command, unless it is =
restricted
for certain device types in the code. (sg_opcodes reports the tape
commands as supported, so this works also in practice.)

(Conceptually, it would be possible to add a device type mask to
struct opcode_info_t. The code already supports lists of definitions
and making list traversal check the device type mask would enable
using different definitions for different device types. This was not
absolutely necessary to add the tape support, and I tried to avoid
changes in the core functionality of scsi_debug.)

Thanks, Kai

