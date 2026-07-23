Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB583A48E3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830653; cv=none; b=r9AqmOMmbsLlURtOkJMMzvaWvUZFljopN7lnktsPhOErhn43+snHmyh1QwsJ+NYzuOETRIwmUkBfvJjMaQfcB8iKhAiM6YLzTw2qXOC+LPO9PsWpjRp1NIGajRCbR0VEpZV4bjHVWgaoV4Yvf9mEAwzftuuwRUVbxTCFi+elHGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830653; c=relaxed/simple;
	bh=rN8cho7RPquSnmQS1pp8jziW0rkTKXyfv+G2ax+BavA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ErqGlEEvYXfwjOxwNkfnV+8pm/meXVutdA6GYcbMWE+v1eUlXqwn8dWtuVRDpboAco9Vb4emzrSWws9vxAsGz1t2MNF1RXqJiQGgQlX+d8sCqz2iK2xJ32jzTHNsCScq8AAW0ozLtmqCjbSGrUFLMAxpJ3u21zLm/FyU4Sm8Xjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA01F000E9;
	Thu, 23 Jul 2026 18:17:28 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 45/56] scsi: qla2xxx: Fix 64G link speed reporting in
 get_data_rate
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-46-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-46-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 18:17:27 +0000
Message-Id: <20260723181729.08DA01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete removal of the `0x7` legacy sentinel filter in `qla2x00_=
set_data_rate()`, causing the success debug log to be skipped when setting =
a 64G port speed.
--

--- Patch [45]: [PATCH v6 45/56] scsi: qla2xxx: Fix 64G link speed reportin=
g in get_data_rate ---
commit 052c747978461ea82dcccd377a664fbb8431d087
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate

qla2x00_get_data_rate() skips updating ha->link_data_rate when the
firmware returns mcp->mb[1] =3D=3D 0x7. This updates the check to allow
0x07 on 64G-capable adapters while keeping the legacy filter for older ones.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index ba822c196894b..b32ca8ed274d6 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -5785,10 +5785,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
>  		ql_dbg(ql_dbg_mbx, vha, 0x1107,
>  		    "Failed=3D%x mb[0]=3D%x.\n", rval, mcp->mb[0]);
>  	} else {
> -		if (mcp->mb[1] !=3D 0x7)
> +		if (mcp->mb[1] !=3D 0x7 || IS_QLA28XX(ha) || IS_QLA29XX(ha))
>  			ha->link_data_rate =3D mcp->mb[1];

[Severity: Low]
Since the legacy filter was updated here to allow 0x7 for 64G-capable
adapters, should the same check be updated in qla2x00_set_data_rate()?

It looks like qla2x00_set_data_rate() still retains the legacy check:

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_set_data_rate() {
    ...
	} else {
		if (mcp->mb[1] !=3D 0x7)
			ql_dbg(ql_dbg_mbx, vha, 0x1179,
				"Speed set:0x%x\n", mcp->mb[1]);
    ...
}

Will this skip the success debug log when a 64G speed is successfully
applied on a 64G-capable adapter?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D45
