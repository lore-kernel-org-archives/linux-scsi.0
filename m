Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD17269832;
	Tue, 18 Feb 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739885531; cv=none; b=G305xntXDNtfRVuj4v9t6Pmr6jKPy6mraWrFCmdcjamFyW2wJDJmltyRN8zogt+s3qoesDoR8ATgPLKsJR44z4nBdP2Nz2Bh1NmNJ/3rbHOe1ZLnpSbaO7uRm8ilHuQ4zodw0l5H+SlbBLjao7Xy5RVR4CBkIUR+8oA0Yn2vBXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739885531; c=relaxed/simple;
	bh=hIQasav/EVsij63YNW6pxUsI8bpow5Voqr03E9iNw5w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NxktJZsal4BK6XXsy20zNY3aHCkxHISFwl/TgANn5VwB9lNZLwhSRkUOhKHEJrDOYRMgVfJ3YvMoN38o0YpLdtWEErJNNWeQvn+ok1nb0CygZaCDBHOmqopUPxWbwaebfXu1aNR015BzRiV9NluhqCO+6Ew2BkfsvnPf34RWxNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jqihlOby; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jqihlOby"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43962f7b0e4so33575545e9.3;
        Tue, 18 Feb 2025 05:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739885528; x=1740490328; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=avPbmjgUe7sfO2KsivqtoZl1exD87jlIOkQM5FCvk6c=;
        b=jqihlObyQig4+ldLO2UFkX2qQqwhBWCczYxTd2i8xgBpI+NM1gC9cl4cP2WfJS7+Gj
         f1V0AuoSQ4D8IjhdJYaci/I7xHOpdapcdzgY8AE02wxIqxJIpk4zl5FNHaIlFsqZALSp
         r8GuTTKwkQ2VdYUeZlHMeHCPWYG+3/2C88c5+5pSu23ja9gS2LackuIQ6Gr9pBSxmGJL
         fPrygUeJYuDZlBw6waY7BRL+XYgjPTGAwDhAUNksIusnSw/BVoIEhBfxQ/YHQJ4KUzeA
         VATD6aUyYQsHtDvzQnKzf2W0F2zCKdmrCUGHDyFYN0Y+N0WISeE8XtxUqjXYrYOZWthA
         0E5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739885528; x=1740490328;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avPbmjgUe7sfO2KsivqtoZl1exD87jlIOkQM5FCvk6c=;
        b=sxzbuNqZmdGeKLTZMK/A+eOoBnlQNW7V+r7XGNljm9Uo4PzwW4/3c6t3uvmkNq1dYD
         DYGldluqD/e+OgeypATIdMasLgGK5Q1951HANF6MYPXpC23Az7QifuA9QtosIgnX/6ku
         DLxIkf9UAXV+9gwcaFRx5ItDPS+MFI8p+kL4P4k2gtEJzP/YbrH0ku7azIwgzPqdbW1f
         HWj9Cdqum2FuW/F5RwkW9tq5G5W/LqgFi+gYKEov85yVCQiq3CE22N6Vi/pHWzySwuW9
         2SJrlc1n6y6cj9HvD2DJBlwtgHNNmE6ha3rxJ0KpcbhtQrCTd6O/uvNlG1hj1VXz0Z2W
         o5tA==
X-Forwarded-Encrypted: i=1; AJvYcCVGZvpT3Jdss2EbrZLRKMEJLfA1LEIEEqnwkbUu/fTQxtjKc6MSmxxC+AhTjxRw+O07QpmVasQlsjWZGg==@vger.kernel.org, AJvYcCVWL8Cq+FmlsfHF9/Nvt+Px/3UrgCqxuL9sgGk1A+qU3Ut4otrFnFI0OGLU5r6JuponmNMYoFyA@vger.kernel.org, AJvYcCX9/WXOgOLgQAQsW2E2bLHbRX+QOpKbBAxW0tu9apzbIp9ZC/G7u4/DcU76gYqIQI8ZxskwVXfddhLA/NU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGRnCpkoIzPVWqmMfR1lWHvN8xIbowert5KOyIhBxjoTRrsY1H
	elKfcc7XbqMl1yYskh6fQ6sUPPlUvSOmG18VG9/fpIPAx8DzyNY4
X-Gm-Gg: ASbGncvvA5q83XhM2Ljtte83mOx1x0HJiHk9ZMIaPlb+H2Pyu0j9raapPD3Ff2zhcLL
	x5n82s5lgsSdw/waV80VMFnks5K6kybWpLGsk0/sPoZux9GDD+U4in6z8MIrM4IvnWF5pPHvIN7
	mPi+GjFd5+ovfPU7w9prI56hFrAo2Gp8nBb+p4MpqaLxPE533k4kMSHW4FnXRlxlNlWUrTUiDR5
	XAiLEC26rJGX/mF0vs4sW3a7RTiFNMComLuhP3F9OMGANGaXKbkkRPLIiKR2qu1f/izdwXiDQj0
	1EfqZyzjvqkLKz0C5Q==
X-Google-Smtp-Source: AGHT+IFy5qdzVuQuQWgFLxME27a9mJVwnnVdbQjXmJBKGs/lC6z4m+HmRzk3BBLcY+Iiovj+NFHxUw==
X-Received: by 2002:a05:600c:3107:b0:439:98ca:e390 with SMTP id 5b1f17b1804b1-43998cae421mr4242255e9.27.1739885527422;
        Tue, 18 Feb 2025 05:32:07 -0800 (PST)
Received: from [10.176.235.56] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258f5fb6sm14810710f8f.44.2025.02.18.05.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 05:32:06 -0800 (PST)
Message-ID: <9e7cc353d2407cbde723fbbb41db5ac6cf83ef63.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: bsg: Fix memory crash in case arpmb
 command failed
From: Bean Huo <huobean@gmail.com>
To: Arthur Simchaev <Arthur.Simchaev@sandisk.com>, 
	"martin.petersen@oracle.com"
	 <martin.petersen@oracle.com>
Cc: Avri Altman <Avri.Altman@sandisk.com>, Avi Shchislowski
 <Avi.Shchislowski@sandisk.com>, "beanhuo@micron.com" <beanhuo@micron.com>, 
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "bvanassche@acm.org" <bvanassche@acm.org>,  "stable@vger.kernel.org"
 <stable@vger.kernel.org>
Date: Tue, 18 Feb 2025 14:32:05 +0100
In-Reply-To: <PH0PR16MB4245909AD2A1DE0EC2C26E92F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
References: <20250218111527.246506-1-arthur.simchaev@sandisk.com>
	 <8be8c9c45d627e40e4ce3dc87c1ac83f32717e2b.camel@gmail.com>
	 <PH0PR16MB4245909AD2A1DE0EC2C26E92F4FA2@PH0PR16MB4245.namprd16.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-02-18 at 13:08 +0000, Arthur Simchaev wrote:
> Hi Bean
>=20
> The issue 100 % reproducible on the platform where the UFS device is
> secondary device.=20
> Device is UFS 4.0 configured to support RPMB.
> I am using ufs-utils tool with your committed arpmb code.=C2=A0 For
> example. run get write arpmb counter command:
> ./ufs-utils arpmb -t 1 -p /dev/ufs-bsg.=20
> After the change, the crash doesn't occur.=C2=A0 See the full kernel cras=
h
> before the fix:
> Let me know if you need more details
>=20
> 3,1290,531166405,-;ufshcd 0000:00:12.5: ARPMB OP failed: error code -
> 22
>=20
> SUBSYSTEM=3Dpci
>=20
> DEVICE=3D+pci:0000:00:12.5
>=20
> 0,1291,531166433,-;usercopy: Kernel memory exposure attempt detected
> from SLUB object 'kmalloc-96' (offset 0, size 104)!
>=20
> 4,1292,531166452,-;------------[ cut here ]------------
>=20
> 2,1293,531166455,-;kernel BUG at mm/usercopy.c:102!
>=20
> 4,1294,531166467,-;invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>=20
> 4,1295,531166475,-;CPU: 4 PID: 3321 Comm: ufs-utils-micro Not tainted
> 6.4.0-060400-generic #202306271339
>=20
> 4,1296,531166483,-;Hardware name: SAMSUNG ELECTRONICS CO., LTD.
> 767XCL/NT767XCL-KLTES, BIOS P07AJD.053.200820.KS 08/20/2020
>=20
> 4,1297,531166487,-;RIP: 0010:usercopy_abort+0x6c/0x80
>=20
> 4,1298,531166504,-;Code: 75 86 51 48 c7 c2 4f a3 7a 86 41 52 48 c7 c7
> 38 1f 77 86 48 0f 45 d6 48 c7 c6 fb 2c 75 86 48 89 c1 49 0f 45 f3 e8
> c4 9e d0 ff <0f> 0b 49 c7 c1 b8 e1 74 86 4d 89 ca 4d 89 c8 eb a8 0f
> 1f 00 90 90
>=20
> 4,1299,531166511,-;RSP: 0018:ffffb1d2c217bc10 EFLAGS: 00010246
>=20
> 4,1300,531166520,-;RAX: 0000000000000065 RBX: 0000000000000000 RCX:
> 0000000000000000
>=20
> 4,1301,531166524,-;RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000000000000000
>=20
> 4,1302,531166528,-;RBP: ffffb1d2c217bc28 R08: 0000000000000000 R09:
> 0000000000000000
>=20
> 4,1303,531166531,-;R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000068
>=20
> 4,1304,531166535,-;R13: ffff911d40042600 R14: 0000000000000001 R15:
> 00007ffe9126ede0
>=20
> 4,1305,531166539,-;FS: 000000000071b3c0(0000)
> GS:ffff911ea7600000(0000) knlGS:0000000000000000
>=20
> 4,1306,531166545,-;CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>=20
> 4,1307,531166550,-;CR2: 00007ffe9126eff8 CR3: 00000001856e0000 CR4:
> 0000000000350ee0
>=20
> 4,1308,531166555,-;Call Trace:
>=20
> 4,1309,531166559,-; <TASK>
>=20
> 4,1310,531166565,-; ? show_regs+0x6d/0x80
>=20
> 4,1311,531166575,-; ? die+0x37/0xa0
>=20
> 4,1312,531166583,-; ? do_trap+0xd4/0xf0
>=20
> 4,1313,531166593,-; ? do_error_trap+0x71/0xb0
>=20
> 4,1314,531166601,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1315,531166610,-; ? exc_invalid_op+0x52/0x80
>=20
> 4,1316,531166622,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1317,531166630,-; ? asm_exc_invalid_op+0x1b/0x20
>=20
> 4,1318,531166643,-; ? usercopy_abort+0x6c/0x80
>=20
> 4,1319,531166652,-; __check_heap_object+0xe3/0x120
>=20
> 4,1320,531166661,-; check_heap_object+0x185/0x1d0
>=20
> 4,1321,531166670,-; __check_object_size.part.0+0x72/0x150
>=20
> 4,1322,531166679,-; __check_object_size+0x23/0x30
>=20
> 4,1323,531166688,-; bsg_transport_sg_io_fn+0x314/0x3b0
>=20
> 4,1324,531166699,-; ? __pfx_bsg_transport_sg_io_fn+0x10/0x10
>=20
> 4,1325,531166707,-; bsg_sg_io+0x9e/0x120
>=20
> 4,1326,531166717,-; bsg_ioctl+0x1f4/0x240
>=20
> 4,1327,531166723,-; __x64_sys_ioctl+0x9d/0xe0
>=20
> 4,1328,531166734,-; do_syscall_64+0x58/0x90
>=20
> 4,1329,531166743,-; ? putname+0x5d/0x80
>=20
> 4,1330,531166752,-; ? do_sys_openat2+0xab/0x180
>=20
> 4,1331,531166761,-; ? exit_to_user_mode_prepare+0x30/0xb0
>=20
> 4,1332,531166771,-; ? syscall_exit_to_user_mode+0x29/0x50
>=20
> 4,1333,531166781,-; ? do_syscall_64+0x67/0x90
>=20
> 4,1334,531166788,-; ? irqentry_exit_to_user_mode+0x9/0x20
>=20
> 4,1335,531166798,-; ? irqentry_exit+0x43/0x50
>=20
> 4,1336,531166806,-; ? exc_page_fault+0x94/0x1b0
>=20
> 4,1337,531166815,-; entry_SYSCALL_64_after_hwframe+0x72/0xdc
>=20
> 4,1338,531166824,-;RIP: 0033:0x45759f
>=20
> 4,1339,531166871,-;Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04
> 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00
> 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b
> 04 25 28 00
>=20
> 4,1340,531166877,-;RSP: 002b:00007ffe9126eba0 EFLAGS: 00000246
> ORIG_RAX: 0000000000000010
>=20
>=20

very strange,  I didn't reproduce this issue with the same command, but
I saw the problem job->result was not updated.


it should not be job->reply_len issue, since we initiated the
max_response_len, then:

int len =3D min(hdr->max_response_len, job->reply_len);


could you check if this works:


diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 8d4ad0a3f2cf..943382b142ca 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -195,9 +195,9 @@ static int ufs_bsg_request(struct bsg_job *job)
        kfree(buff);
        bsg_reply->result =3D ret;
        job->reply_len =3D !rpmb ? sizeof(struct ufs_bsg_reply) :
sizeof(struct ufs_rpmb_reply);
-       /* complete the job here only if no error */
-       if (ret =3D=3D 0)
-               bsg_job_done(job, ret, bsg_reply-
>reply_payload_rcv_len);
+
+       /* complete the job here */
+       bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
=20
        return ret;
 }


Kind regards,
Bean

