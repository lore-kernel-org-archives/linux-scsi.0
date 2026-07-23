Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FDC418A21
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798788; cv=none; b=S643Zfw+jpSlIzBxGpa9N3GrBSoV5fhP3xhICgoGUQUPIhQyBG6NecO2UiE2SjifAItu3ovdOhMRDoTb/IuVZJ3uNxC7qQR+z96RS1DpW8S8S4XcMOhzruQW0zHGHjHeArRXW5ntHlilgbhBlK/vgrA9RgonwEkIb85rZ2lG0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798788; c=relaxed/simple;
	bh=XZLK0W1CdoEEAa2ND2ndTNbqj6BC5tTyv+m58HdvdEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kx9quuYp4DHYczIhbgfWJOqRsWuiW3ztjJDdn52jbBb5YHCqnUQcpsuS0CppnN4jfFdy1sjbzR8z2pyjNYjgVMdFOd3yfZB2WqAlGlxJ335jXA0RJh31oZGQnhZ1s3i54mDskIpU8ktu70z7zeC+aK7T+AnAajzS+MpQUX41+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ECA1F00A3A;
	Thu, 23 Jul 2026 09:26:26 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/56] scsi: qla2xxx: Extend execute_fw mailbox to
 include 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-16-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-16-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:26:23 +0000
Message-Id: <20260723092626.54ECA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `port_speed` sysfs setter fails unconditionally for QLA29XX =
adapters and lacks support for configuring 64Gps and 128Gps speeds.
--

--- Patch [15]: [PATCH v6 15/56] scsi: qla2xxx: Extend execute_fw mailbox t=
o include 29xx ---
commit f710a272666aaab612a05e252367e3da5901939a
Author: Nilesh Javali <njavali@marvell.com>

    scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
   =20
    Add IS_QLA29XX() to the BPM capability macros and to the
    execute-firmware mailbox command so that NVMe enable, minimum
    speed negotiation, 128 Gbps speed reporting, EDIF hardware
    detection, and FW-semaphore retry logic all apply to 29xx
    adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
[ ... ]
> @@ -1803,10 +1804,11 @@ qla2x00_max_supported_speed_show(struct device *d=
ev,
>  	scsi_qla_host_t *vha =3D shost_priv(class_to_shost(dev));
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
> -	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
> +	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha) && !IS_QLA29XX(ha))
>  		return scnprintf(buf, PAGE_SIZE, "\n");

[Severity: Medium]
Since IS_QLA29XX was added here, does qla2x00_port_speed_store() also need=
=20
to be updated?

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_port_speed_store() {
	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha)) {
		ql_log(ql_log_warn, vha, 0x70d8,
		    "Speed setting not supported \n");
		return -EINVAL;
	}
	...
}

Otherwise, the setter will unconditionally return -EINVAL for QLA29XX adapt=
ers.

[ ... ]
> @@ -1887,6 +1889,7 @@ static const struct {
>  	{ PORT_SPEED_16GB, "16" },
>  	{ PORT_SPEED_32GB, "32" },
>  	{ PORT_SPEED_64GB, "64" },
> +	{ PORT_SPEED_128GB, "128" },
>  	{ PORT_SPEED_10GB, "10" },
>  };

[Severity: Medium]
Does qla2x00_port_speed_store() need to support 64 and 128 Gbps speeds?=20
Currently, its switch statement lacks cases for 64Gps and 128Gps, causing=20
them to fall back to Autoneg:

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_port_speed_store() {
	...
	default:
		ql_log(ql_log_warn, vha, 0x1199,
		    "Unrecognized speed setting:%lx. Setting Autoneg\n",
		    speed);
		ha->set_data_rate =3D PORT_SPEED_AUTO;
	...
}

It appears a similar switch in qla2x00_set_data_rate() in qla_mbx.c is also=
=20
missing these cases.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -727,14 +728,13 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t r=
isc_addr)
>  				    ha->lr_distance << LR_DIST_FW_POS;
>  		}
> =20
> -		if (ql2xnvmeenable && (IS_QLA27XX(ha) || IS_QLA28XX(ha)))
> +		if (ql2xnvmeenable && (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(=
ha)))
>  			mcp->mb[4] |=3D NVME_ENABLE_FLAG;

[Severity: Medium]
Should IS_QLA29XX(ha) be added to the mailbox command setup in=20
qla2x00_set_data_rate() as well?=20

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_set_data_rate() {
	...
	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
		mcp->in_mb |=3D MBX_4|MBX_3;
	...
}

Without it, the function might fail to correctly populate the in_mb mask fo=
r=20
the new adapters.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D15
