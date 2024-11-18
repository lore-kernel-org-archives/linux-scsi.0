Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946651C07F5
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2024 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731949869; cv=none; b=KZB4E8pTdM1E0dvXAMehr+yQNJs34i/fy9hPApOPufOV9I7UTi0FiOIjZaMJLfzH/s21m4wJHzNry1Pz3FrE0bsrKr9UdRBxSwPvhnkdoKTNXF201F7Kzgn9n5zGc87PbGGe8X30mY4184g4BMKPPlYSZAAlLsW7rX1SN+2JK6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731949869; c=relaxed/simple;
	bh=uRqITfdIDYaygG9EGIlz7LE2Qw5MeKKlQzY80u/y+sI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nzt4iw8ZP2Iy6KGO9EAHgNwD7SIGITNc0pmaNT/qcFEpwaKXCUN3fIYi2ZAERYnUMO9YMIakT0CpH8DKAjDcRTaXEAi2nZYRE4+mZI239zNvD89pryQ7ZqtRt9NJOWO89l8Ny30NICSa6Mrmji2E15GusomBCVPIS/PfZg0DAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=KZMudU/y; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="KZMudU/y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=IN1U5dyDv4JIvSdWJbNYvwWqFa88l+giopRObJrf0co=;
	b=KZMudU/yiCRJP6nwb0lFudTXbmvtYX7fAwvxAIryHd0e0NditKg6FXLhhShtm2ATsQrqbGflGA/Qr
	 sPSdxDg6ZOAF+gYX50p94BjQgkOTde28R9rpzXYWgEy1yQiX+uK4Rme9n5HzopNladt97qLfHTX+bx
	 OiP3hm+vvLdEomN40CjWiAdmZ3FFhIGkVBdjUsBFr2sl8hHbsfJRtNnx4f1raoOJ37kn+B+zRxJiak
	 9+VzWSzHkHuxPJYildCBbMdC0qn7jNgTr06NoHGE5YezGlzE5+Q2cQhGPnVqQAbO2E048wBb6NEtwV
	 oIf68Nzl1/hRA0H+JpTSqcjuyxQ3A7Q==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id 12c14586-a5d0-11ef-9b59-005056bd6ce9;
	Mon, 18 Nov 2024 19:10:55 +0200 (EET)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 2/3] scsi: st: clear was_reset when CHKRES_NEW_SESSION
From: =?utf-8?Q?Kai_M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
In-Reply-To: <c1ac0724-df0f-44e8-a447-8186da6289a8@redhat.com>
Date: Mon, 18 Nov 2024 19:10:45 +0200
Cc: linux-scsi@vger.kernel.org,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <9859F83C-428D-4302-BEBD-1D3776AE06F2@kolumbus.fi>
References: <20241031010032.117296-1-jmeneghi@redhat.com>
 <20241031010032.117296-3-jmeneghi@redhat.com>
 <5046E716-BB3D-45A6-B320-6810F5C792EC@kolumbus.fi>
 <67da1859-cfd2-45f0-951b-258ebdf6fd5f@redhat.com>
 <01385357-3D40-4720-82ED-AF8EEAFE7351@kolumbus.fi>
 <c1ac0724-df0f-44e8-a447-8186da6289a8@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.200.121)



> On 15. Nov 2024, at 17.34, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
...
>> Now, st does allow zero retries. In addition to this, the requests =
use either REQ_OP_DRV_IN
>> or REQ_OP_DRV_OUT and these requests are not retried. So, now POR UAs =
reach
>> st (as the experiments have indicated).
>=20
> Yes, the only time I've see the POR UA not get passed to the st driver =
is with scsi_debug, when
> the driver first loads.
>=20
> [tape_tests]# modprobe -r scsi_debug
> [tape_tests]# modprobe scsi_debug  ptype=3D1  max_luns=3D1 =
dev_size_mb=3D10000
> [Fri Nov 15 09:28:51 2024] scsi_debug:sdebug_driver_probe: scsi_debug: =
trim poll_queues to 0. poll_q/nr_hw =3D (0/1)
> [Fri Nov 15 09:28:51 2024] scsi host8: scsi_debug: version 0191 =
[20210520]
>                             dev_size_mb=3D10000, opts=3D0x0, =
submit_queues=3D1, statistics=3D0
> [Fri Nov 15 09:28:51 2024] scsi 8:0:0:0: Sequential-Access Linux    =
scsi_debug       0191 PQ: 0 ANSI: 7
> [Fri Nov 15 09:28:51 2024] scsi 8:0:0:0: Power-on or device reset =
occurred
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The sg driver is clearing the UA here.

I enabled some SCSI debug logging (0x3001). It shows that the UA is =
received as response to
a 'Report supported operation codes' command. I looked at the code and =
it seems that scsi_add_lun()
in scsi_scan.c uses this operation. So, the UA is not cleared by any =
ULD.

...

> I have no idea whey the scsi_debug driver doesn't support READ BLOCK =
LIMITS.
>=20
scsi_debug does not support any "tape-specific" commands. This includes =
READ BLOCK LIMITS,
WRITE FILEMARKS, REWIND, etc. Additionally the CDB definition for tapes =
is special for reads and
writes.

REWIND is implemented in scsi_debug, but it is buggy. MODE SENSE and =
MODE SELECT without
any page (i.e., interested only in block descriptor) are not allowed in =
scsi_debug.

St is designed to work with minimal command support. READ BLOCK LIMITS =
is not needed. I have
fixed REWIND and MODE SENSE/SELECT for my tests. Using fake_rw I can =
"read" tape, but
writing does not work because WRITE FILEMARKS is missing.

...
> Another problem with using scsi_debug is:
>=20
> [tape_tests]# sg_reset --target /dev/sg3
>=20
> This does nothing.  I have to use the /dev/st device to reset.  This =
is not true if you have a real tape device.

In my tests, resets using both /dev/nstx and /dev/sgx have been working. =
However, you should note that
when using /dev/nstx, the device is opened using st driver, whereas if =
/dev/sgx is used, it is opened
using the sg driver. Digging deeper reveals that SG_SCSI_RESET through =
st does not go through
sg at all. (Both end up to scsi_ioctl_reset() in scsi_error.c, but in a =
different way.) (And if you use,
/dev/stx, the tape is rewound.)

> [tape_tests]# sg_reset --target /dev/nst1
> [Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] check_tape: 1064: =
pos_unknown 0 was_reset 1 ready 0
> [Fri Nov 15 09:37:18 2024] st 8:0:0:0: Power-on or device reset =
occurred
> [Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] Error: 2, cmd: 0 0 0 0 0 =
0
> [Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] Sense Key : Unit =
Attention [current]
> [Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] Add. Sense: Scsi bus =
reset occurred
> [Fri Nov 15 09:37:18 2024] st 8:0:0:0: [st1] st_chk_result: 421: =
pos_unknown 1 was_reset 1 ready 0, result 2
> ^^^^^^^^^^^^^^^^^^
> Now we've set pos_unkown.

If you use /dev/sgx, you are not supposed to see any output. The next =
operation sent to /dev/nstx
(e.g., mt status) sets pos_unknown. In the example above, you probably =
have used sg_reset -target
/dev/sg1 previously and it is opening /dev/nst1 the the next sg_reset =
that catches the previous reset.

...
>=20
> Please try my latest version of the tape_reset_debug.sh script.

I looked at the script. It tries to write to tape and that is not =
implemented in the scsi_debug I have

