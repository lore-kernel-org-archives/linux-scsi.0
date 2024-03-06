Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D57F140383
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 18:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750014; cv=none; b=HpMr3gTEMMxVYv4fkg7gNPT1wgjV8WC7NblvB8MYy9UlT0hJcbw503wzrWf3fbaqsNHezbXDYLNsZ0H5ufuar7BoonSW3la0ORxSBd8otA3cFJtrvZfOPOwzqU0DlgcMb4Ue048LKSR3MqURrkU2YQ1Ymb5vuNFTDUHKr5wuO+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750014; c=relaxed/simple;
	bh=77JE9whOjmq8e6QHGc2OLNU+Itd7sw4MTNx7FsuK8Cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E77i06KqUneoRsTSjQuHR43PlUwDbTX7MTrmnQ2ebNtrAXMlbkSmctd5D1TOuvxqWjuyJ2uLI3pCmJu2jrbXMTK8+7mtXUaj1JeCPNglCChPjkJw9wuvBCNyTMuFcnG1zS1AZYo235LCWx22F4kgwYQu3WR7qrHO3b3OHAfHIDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=COJWi66S; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="COJWi66S"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TqgsS2jZ9z6ClSqV;
	Wed,  6 Mar 2024 18:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1709749672; x=1712341673; bh=bEEXFG4vhdJKrJoL9iO0f87L
	CcG0N+Vs9i3My6y61Mg=; b=COJWi66SJXVpRW4YXhlojkasNqMmEeFpU+Cu8j1c
	a1CpU86+g5ghJcyoB/xd5YKFcnvzCTzwkALwEy8hGo4Cnt7WQfRoGE9JCZVnljT0
	cY5MvXtdNFOvoFlM3qb/CE05UBiP1MemzYMwpXqZutE9cFBcQ+KjjoS6sXRsLW2E
	zLcQK6lf7cAvDmrwxifs0FVaQDSBV12uGhTuwZ+cFjoGf1EDvpQ/mrPIbVJPB5P3
	ekvPblQurgK/ikzhXkEVzkwbJodohqGvXVDBB1ksIDcKlr7pZqwXdoal69jVh76/
	ID1EYiWo388RkoPcPzKKhaNXrLt3aaD7yl4TJYx1MtN97Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8xZJyFlNa_Qw; Wed,  6 Mar 2024 18:27:52 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TqgsL6F2xz6ClSqL;
	Wed,  6 Mar 2024 18:27:50 +0000 (UTC)
Message-ID: <4fbd2106-1e39-4fd9-b0e0-411105e80bb7@acm.org>
Date: Wed, 6 Mar 2024 10:27:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240305222612.37383-1-bvanassche@acm.org>
 <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cd54668a-8f01-46d8-a597-3dc25ad1ad00@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/6/24 05:19, John Garry wrote:
> On 05/03/2024 22:25, Bart Van Assche wrote:
>> =C2=A0 drivers/scsi/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
>> =C2=A0 drivers/scsi/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
>> =C2=A0 drivers/scsi/scsi_debug-dif.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 65 +=
++++
>> =C2=A0 drivers/scsi/scsi_debug_dif.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 224 ++++++=
+++++++++
>=20
> inconsistent filename format: scsi_debug-dif.c vs scsi_debug_dif.h - is=
=20
> that intentional?

That should be fixed. Do you perhaps have a preference?

>> =C2=A0 .../scsi/{scsi_debug.c =3D> scsi_debug_main.c}=C2=A0 | 257 ++--=
--------------
>> =C2=A0 5 files changed, 308 insertions(+), 242 deletions(-)
>> =C2=A0 create mode 100644 drivers/scsi/scsi_debug-dif.h
>> =C2=A0 create mode 100644 drivers/scsi/scsi_debug_dif.c
>> =C2=A0 rename drivers/scsi/{scsi_debug.c =3D> scsi_debug_main.c} (97%)
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 3328052c8715..b7c92d7af73d 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1227,7 +1227,7 @@ config SCSI_WD719X
>> =C2=A0 config SCSI_DEBUG
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tristate "SCSI debugging host and devic=
e simulator"
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on SCSI
>> -=C2=A0=C2=A0=C2=A0 select CRC_T10DIF
>> +=C2=A0=C2=A0=C2=A0 select CRC_T10DIF if SCSI_DEBUG =3D y
>=20
> Do we really need to select at all now? What does this buy us?=20
> Preference is generally not to use select.

I want to exclude the CRC_T10DIF =3D m and SCSI_DEBUG =3D y combination
because it causes the build to fail. I will leave out the select
statement and will change "depends on SCSI" into the following:

	depends on SCSI && (m || CRC_T10DIF =3D y)

>> --- /dev/null
>> +++ b/drivers/scsi/scsi_debug-dif.h
>> @@ -0,0 +1,65 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _SCSI_DEBUG_DIF_H
>> +#define _SCSI_DEBUG_DIF_H
>> +
>> +#include <linux/kconfig.h>
>> +#include <linux/types.h>
>> +#include <linux/spinlock_types.h>
>> +
>> +struct scsi_cmnd;
>=20
> Do you really need to have a prototype for this? I'm a bit in shock=20
> seeing this in a scsi low-level driver.

I will leave the above out and add "#include <scsi/scsi_cmnd.h>"
instead.

> dix_writes is defined in main.c, so surely this extern needs to be in=20
> scsi_debug_dif.c or a common header

The scsi_debug-dif.h header file is included from two .c files. Without
this header file, the compiler wouldn't be able to check the consistency
of the declarations in scsi_debug-dif.h with the definitions in the two
scsi_debug .c files.

> For me, I would actually just declare this in scsi_debug_dif.c and have=
=20
> scsi_debug_dif_get_dix_writes() or similar to return this value. This=20
> function would be stubbed for CONFIG_CRC_T10DIF=3Dn

My goal is to minimize changes while splitting the scsi_debug source
code. Hence the "extern" declaration.

>> +extern int dix_reads;
>> +extern int dif_errors;
>> +extern struct xarray *const per_store_ap;
>> +extern int sdebug_dif;
>> +extern int sdebug_dix;
>> +extern unsigned int sdebug_guard;
>> +extern int sdebug_sector_size;
>> +extern unsigned int sdebug_store_sectors;
>=20
> I doubt why all these are here

All the variables declared above are used in both scsi_debug_dif.c and
scsi_debug_main.c.

>> +int dif_verify(struct t10_pi_tuple *sdt, const void *data, sector_t=20
>> sector,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 ei_l=
ba);
>=20
> Is this actually used in main.c?

It is not. I will remove it.

> I do also notice that we have chunks of code in main.c that does PI=20
> checking, like in resp_write_scat() - surely dif stuff should be in=20
> dif.c now

I'm concerned that moving that code would make resp_write_scat() much
less readable. Please note that the code in resp_write_scat() that does
PI checking is guarded by an 'if (have_dif_prot)' check and that
have_dif_prot =3D false if CONFIG_CRC_T10DIF=3Dn.

>> --- /dev/null
>> +++ b/drivers/scsi/scsi_debug_dif.c
>> @@ -0,0 +1,224 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +#include "scsi_debug-dif.h"
>=20
> I always find it is strange to include driver proprietary header files=20
> before common header files - I guess that is why the scsi_cmnd prototyp=
e=20
> is declared, above

Including driver-private header files first is required by some coding
style guides because it causes the build to fail if the driver-private
header file does not include all include files it should include. See
also
https://google.github.io/styleguide/cppguide.html#Names_and_Order_of_Incl=
udes
(I am aware that this style guide does not apply to Linux kernel code).

Thanks,

Bart.

