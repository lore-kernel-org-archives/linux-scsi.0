Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9CBEB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 06:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjG1Gry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 02:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbjG1Grs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 02:47:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B4935A6
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 23:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690526821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pu1kSSZAkGxEGcZAMDwWgOfvApASHgACyHcUajJW3V4=;
        b=LT7ZqkYHCaBn8pLH+j+I44VKIImlZ+0tBDhH/jEZh+jmuD9y3pbuPRxgsS81CPIBIa+z2A
        rrMighSUA4ns+0INc7+C1gd5c1juJUBGWbBjFBeT03hbB/WZe2Yb4OmlUhTM4IazZnQDDY
        UdsbcMrpZYU9FXfK0mmOjaLtONpQdsM=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-of3_36rqMWuKfTxB_36tCQ-1; Fri, 28 Jul 2023 02:46:57 -0400
X-MC-Unique: of3_36rqMWuKfTxB_36tCQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23B323C0C4B5;
        Fri, 28 Jul 2023 06:46:57 +0000 (UTC)
Received: from butterfly.localnet (unknown [10.45.224.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84C6740C2063;
        Fri, 28 Jul 2023 06:46:56 +0000 (UTC)
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     martin.petersen@oracle.com, Saurav Kashyap <skashyap@marvell.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qedf: Changed string copy method for "stop_io_on_error" from
 sprintf to put_user
Date:   Fri, 28 Jul 2023 08:46:50 +0200
Message-ID: <2150398.irdbgypaU6@redhat.com>
Organization: Red Hat
In-Reply-To: <20230726101236.11922-1-skashyap@marvell.com>
References: <20230726101236.11922-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart13313568.uLZWGnKmhe";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--nextPart13313568.uLZWGnKmhe
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@redhat.com>
To: martin.petersen@oracle.com, Saurav Kashyap <skashyap@marvell.com>
Cc: linux-scsi@vger.kernel.org
Date: Fri, 28 Jul 2023 08:46:50 +0200
Message-ID: <2150398.irdbgypaU6@redhat.com>
Organization: Red Hat
In-Reply-To: <20230726101236.11922-1-skashyap@marvell.com>
References: <20230726101236.11922-1-skashyap@marvell.com>
MIME-Version: 1.0

On st=C5=99eda 26. =C4=8Dervence 2023 12:12:36 CEST Saurav Kashyap wrote:
> From: Javed Hasan <jhasan@marvell.com>
>=20
> Changed string copy method for "stop_io_on_error" from sprintf to put_user
>=20
> [ 5023.463399] BUG: unable to handle kernel paging request at 00007f6ad55=
4c000
> [ 5023.463404] PGD 8433e5067 P4D 8433e5067 PUD 87e36c067 PMD 87ef03067 PT=
E 0
> [ 5023.463409] Oops: 0002 [#1] SMP NOPTI
> [ 5023.463412] CPU: 56 PID: 12121 Comm: cat Kdump: loaded Not tainted 4.1=
8.0-372.9.1.el8.x86_64 #1
> [ 5023.463414] Hardware name: HPE ProLiant DL560 Gen10/ProLiant DL560 Gen=
10, BIOS U34 10/26/2020
> [ 5023.463415] RIP: 0010:string_nocheck+0x3f/0x70
> [ 5023.463423] Code: 0a 45 84 c9 74 46 83 ee 01 41 b8 01 00 00 00 48 8d 7=
c 37 01 eb 0f 49 83 c0 01 46 0f b6 4c 02 ff 45 84 c9 74 1c 49 39 c2 76 03 <=
44> 88 08 48 83 c0 01 44 89 c6 48 39 f8 75 dd 4c 89 d2 e9 1a ff ff
> [ 5023.463425] RSP: 0018:ffffb6034770fd88 EFLAGS: 00010206
> [ 5023.463427] RAX: 00007f6ad554c000 RBX: 00007f6b5554bfff RCX: ffff0a00f=
fffff04
> [ 5023.463429] RDX: ffffffffc06a5d3f RSI: 00000000fffffffe RDI: 00007f6bd=
554bfff
> [ 5023.463430] RBP: ffffffffc06a5d3f R08: 0000000000000001 R09: 000000000=
0000066
> [ 5023.463432] R10: 00007f6b5554bfff R11: 0000000000000001 R12: ffff0a00f=
fffff04
> [ 5023.463433] R13: ffffffffc06a5d50 R14: 000000007fffffff R15: ffffffffc=
06a5d50
> [ 5023.463434] FS:  00007f6ad557d680(0000) GS:ffff8b9d9fc00000(0000) knlG=
S:0000000000000000
> [ 5023.463436] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5023.463437] CR2: 00007f6ad554c000 CR3: 0000000882d24004 CR4: 000000000=
07706e0
> [ 5023.463439] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [ 5023.463440] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [ 5023.463441] PKRU: 55555554
> [ 5023.463442] Call Trace:
> [ 5023.463445]  string+0x40/0x50
> [ 5023.463449]  vsnprintf+0x33c/0x520
> [ 5023.463452]  sprintf+0x56/0x70
> [ 5023.463456]  qedf_dbg_stop_io_on_error_cmd_read+0x65/0x80 [qedf]
> [ 5023.463466]  full_proxy_read+0x53/0x80
> [ 5023.463474]  vfs_read+0x91/0x140
> [ 5023.463481]  ksys_read+0x4f/0xb0
> [ 5023.463483]  do_syscall_64+0x5b/0x1a0
> [ 5023.463490]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 5023.463494] RIP: 0033:0x7f6ad50ac525
> [ 5023.463496] Code: fe ff ff 50 48 8d 3d 02 ca 06 00 e8 25 ee 01 00 0f 1=
f 44 00 00 f3 0f 1e fa 48 8d 05 75 40 2a 00 8b 00 85 c0 75 0f 31 c0 0f 05 <=
48> 3d 00 f0 ff ff 77 53 c3 66 90 41 54 49 89 d4 55 48 89 f5 53 89
> [ 5023.463497] RSP: 002b:00007ffd29ed3b38 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000000
> [ 5023.463499] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f6ad=
50ac525
> [ 5023.463501] RDX: 0000000000020000 RSI: 00007f6ad554c000 RDI: 000000000=
0000003
> [ 5023.463502] RBP: 00007f6ad554c000 R08: 00000000ffffffff R09: 000000000=
0000000
> [ 5023.463503] R10: 0000000000000022 R11: 0000000000000246 R12: 00007f6ad=
554c000
> [ 5023.463504] R13: 0000000000000003 R14: 0000000000000fff R15: 000000000=
0020000
> [ 5023.463505] Modules linked in: xt_CHECKSUM ipt_MASQUERADE xt_conntrack=
 ipt_REJECT nf_reject_ipv4 nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6=
 nf_defrag_ipv4 bridge stp llc nft_compat nft_counter nf_tables nfnetlink b=
nx2fc cnic sunrpc vfat fat dm_service_time dm_multipath intel_rapl_msr inte=
l_rapl_common isst_if_common nfit libnvdimm x86_pkg_temp_thermal intel_powe=
rclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul qedi crc32_pclmul =
iscsi_boot_sysfs libiscsi ghash_clmulni_intel scsi_transport_iscsi rapl mei=
_me uio intel_cstate pcspkr mei intel_uncore joydev ipmi_ssif ses enclosure=
 hpwdt hpilo acpi_tad acpi_ipmi wmi lpc_ich ioatdma dca ipmi_si acpi_power_=
meter xfs libcrc32c sd_mod t10_pi sg qedf mgag200 qede drm_kms_helper qed l=
ibfcoe syscopyarea crc32c_intel sysfillrect i40e sysimgblt libfc fb_sys_fop=
s smartpqi drm tg3 scsi_transport_sas scsi_transport_fc uas crc8 usb_storag=
e i2c_algo_bit dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msg=
handler fuse
> [ 5023.463585] CR2: 00007f6ad554c000
>=20
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
>  drivers/scsi/qedf/qedf_debugfs.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_de=
bugfs.c
> index a3ed681c8ce3..8b9c4cf2953f 100644
> --- a/drivers/scsi/qedf/qedf_debugfs.c
> +++ b/drivers/scsi/qedf/qedf_debugfs.c
> @@ -185,15 +185,23 @@ qedf_dbg_stop_io_on_error_cmd_read(struct file *fil=
p, char __user *buffer,
>  				   size_t count, loff_t *ppos)
>  {
>  	int cnt;
> +	char *q_true =3D "true\n";
> +	char *q_false =3D "false\n";
>  	struct qedf_dbg_ctx *qedf_dbg =3D
>  				(struct qedf_dbg_ctx *)filp->private_data;
>  	struct qedf_ctx *qedf =3D container_of(qedf_dbg,
>  	    struct qedf_ctx, dbg_ctx);
> =20
>  	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "entered\n");
> -	cnt =3D sprintf(buffer, "%s\n",
> -	    qedf->stop_io_on_error ? "true" : "false");
> =20
> +	if (qedf->stop_io_on_error)
> +		for (cnt =3D 0; cnt < sizeof(q_true); cnt++)
> +			put_user(*(q_true++), buffer++);
> +	else
> +		for (cnt =3D 0; cnt < sizeof(q_true); cnt++)
> +			put_user(*(q_false++), buffer++);
> +
> +	cnt--;
>  	cnt =3D min_t(int, count, cnt - *ppos);
>  	*ppos +=3D cnt;
>  	return cnt;
>=20

As agreed,

Nacked-by: Oleksandr Natalenko <oleksandr@redhat.com>

=2D-=20
Oleksandr Natalenko (post-factum)
Principal Software Maintenance Engineer
--nextPart13313568.uLZWGnKmhe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEENQb0bxzeq+SMr0+vn464/xkP+AUFAmTDZFoACgkQn464/xkP
+AUFFhAAnUP44SfpjqSq7j2Xte+lxfrm/1Vm9G/RMEFaBS3EUbwyMFTiS1XcTGLY
Uw3BnEUq+mejN3JISx1Qdsaf8jui17APYAqe6X4iomBqYxrlxNIF33lDaXd1AiZ6
goOjvYmx5E2I0fXPaxXW67jHe4YN6TbhOmXtS4V07zmyEjnAw6oeW1N+zpmYe5sD
NlEwP5+A5JDRhRbpmNaVig8BnVrXGlnsyaigZfn2jQtEjPl/Y7x041V6JClmejBG
yO7WOdnzGdLmdAXsxw/UqbI3Q83C+Y4sYDIUWkcqTa2CTz50uIAnpLH5P7AXPh4h
Of8qhi0uEvYDGfTNYDm0pyLRtn+GarXwpmKsIU2mOGwRuRwZ9pOMf7yl7Z7/T3l1
wX9RBQRg8KIQU/iq3e3zJSDYSGZuQUwApEPF9eDnMBjRuB8bKfKgHvvd5/CuXHTM
8EmlAX5Pd0i/vJ9oiBVQLBuWJtwpyUX/4yXd2q9eMZlovaPTiXsdG+Kp5pqhbnfY
OANQD+nZdraUd2uX545OWElUx5eu/K20aUJkM9tXRRIohIzeF4dxBHFtlud2Fc6V
mfYSQO3gVkssIUVEXSmS3nRGo+L423e+zPZubO4sIwQlzVBeu+kjw5QHCc8A/sGV
LctniuYWoZr8YK3+NOQwxo/kmXS8TbK1oIvWTBDJVnyMMZpKDrg=
=pxPm
-----END PGP SIGNATURE-----

--nextPart13313568.uLZWGnKmhe--



