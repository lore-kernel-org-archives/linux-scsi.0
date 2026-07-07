Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5B223DD4
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783410369; cv=none; b=Fpn1Q7RHmielKWg0MACVOpftNZQvPb+F8p4yrBg58FaSFM/0EQ9D3jqKXM8OLz7TKrGdX7AqEcKHUch3wRDafDc/U1c0qf3TTx7Ac9waJsrfMmJmFzBYMPGAJY6lZuEqteYFlXaxeqLHToXgW3XCdJJv7ko3KgWR1a4fu9VioYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783410369; c=relaxed/simple;
	bh=dO5ssyaTjZuuiu2jSMjlE3nirhhq/UMeA6T60KEG8Ew=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JCTVtqFkBAT8KQpacQxSbF6Lye0Khg92vA5sTRAzNgsw5Lzc41v6v+Mh+0Y7cCW65e928pVjJzKJE2RQb6ZZOkUlEGzNzyahGVgPnDnui2fwpBNUu6AxCv9PIgf/GIcpoTZp02BrLKAWawPMLGDJXlAALG9uuYX/SPk0NdjbrQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FpMGix8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpMGix8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4FD1F000E9;
	Tue,  7 Jul 2026 07:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783410368;
	bh=ZFooEIvJGc6zoeiEgtoOtNO0rRA62eqdqEeyImMd9+M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FpMGix8w/9uElB1F+DHpDU6Sg3nksKvs0nqGs/T3Gqia9JFIXMy+dMJNYZ6TWgO0N
	 S2c37Zy1wZktxir814UXYShAKXedoDL6NsK3VuFr0QRUgobaJKl+rZiIcuHWsc6r7O
	 /KrwdLmqcqnZCvtoO92G9TBDUYHz9MZj2pHvn0HwZruvNkGmDMVZ4bw8glrRoND09k
	 SrRSVkkbhZuM+a6+danf49Pm1EoXwowBCeZVvrhIDyBO5ihA7dIs7snolT/QHqBo/+
	 NSi6zLwySXzVxvxW4KkKNThwiwB7u9OtdsCuH6RGaMLMwTObMRlHDEq3UPcU7D91vj
	 izy/UhaAG+1hQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 85/88] scsi: qla2xxx: Validate BSG request_len before
 reading vendor_cmd[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-86-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-86-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:46:07 +0000
Message-Id: <20260707074607.DA4FD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Critical] The newly added bounds checks incorrectly use `sizeof(struct f=
c_bsg_request)` to calculate the required payload size, artificially reject=
ing valid, properly sized userspace requests and breaking the UAPI.

Pre-existing issues:
- [High] The patch fails to add `request_len` validation to `qla84xx_mgmt_c=
md` and `qla24xx_iidma`, leaving them vulnerable to out-of-bounds heap read=
s.
- [High] The transport layer `fc_bsg_host_dispatch()` does not actually gua=
rantee that `request_len` covers `vendor_id`, leading to a heap out-of-boun=
ds read before reaching the driver.
- [High] Leaked `vha` and `qpair` busy reference counters in the `qlafx00_m=
gmt_cmd` error path.
- [High] Concurrent BSG requests to QLFC_FCP_PRIO_SET_CONFIG and QLFC_FCP_P=
RIO_GET_CONFIG can race on the unprotected `ha->fcp_prio_cfg` pointer, lead=
ing to memory leaks, data corruption, Use-After-Free, or NULL pointer deref=
erences.
- [High] Concurrent loopback BSG requests can cause a TOCTOU race on the lo=
opback state and wait incorrectly on a shared completion variable.
--

--- Patch [85]: [PATCH v3 85/88] scsi: qla2xxx: Validate BSG request_len be=
fore reading vendor_cmd[] ---
commit a39aea7848cc6caa6a7176a258e927c5587f88e5
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]

This commit attempts to fix out-of-bounds reads in the transport handlers
by adding a central length guard in qla2x00_process_vendor_specific and
additional request length checks in various sub-handlers.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index cb7227298b24b..e671c3de8c058 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -160,6 +160,12 @@ qla24xx_proc_fcp_prio_cfg_cmd(struct bsg_job *bsg_jo=
b)
>  		goto exit_fcp_prio_cfg;
>  	}
> =20
> +	if (bsg_job->request_len <
> +	    sizeof(struct fc_bsg_request) + 2 * sizeof(uint32_t)) {
> +		ret =3D -EINVAL;
> +		goto exit_fcp_prio_cfg;
> +	}
> +

[Severity: Critical]
Does this inflate the requirement to 28 bytes when only 20 bytes are actual=
ly
needed to safely read vendor_cmd[1]?

[Severity: High]
This is a pre-existing issue, but looking at the rest of this function,
can concurrent requests race on the unprotected ha->fcp_prio_cfg pointer?

If two concurrent requests execute the set config and get config operations,
could one thread free the pointer and set it to null while the other is
copying from it to userspace, leading to a null pointer dereference or
use-after-free?

[ ... ]

> @@ -758,6 +764,10 @@ qla2x00_process_loopback(struct bsg_job *bsg_job)
>  		return -EIO;
>  	}
> =20
> +	if (bsg_job->request_len <
> +	    sizeof(struct fc_bsg_request) + 3 * sizeof(uint32_t))
> +		return -EINVAL;
> +
>  	memset(&elreq, 0, sizeof(elreq));

[Severity: High]
This isn't a bug introduced by this patch, but further down in this functio=
n,
concurrent loopback requests perform a lockless read of the loopback state.

Can multiple threads bypass the check, issue hardware commands, and wait on
the same shared ha->dcbx_comp completion variable? Since complete() only wa=
kes
one thread, wouldn't the other time out and trigger an unjustified abort of
the hardware?

[ ... ]

> @@ -2397,6 +2427,11 @@ qlafx00_mgmt_cmd(struct bsg_job *bsg_job)
>  	struct fc_port *fcport;
>  	char  *type =3D "FC_BSG_HST_FX_MGMT";
> =20
> +	if (bsg_job->request_len <
> +	    sizeof(struct fc_bsg_request) + sizeof(uint32_t) +
> +	    sizeof(struct qla_mt_iocb_rqst_fx00))
> +		return -EINVAL;
> +
>  	/* Copy the IOCB specific information */

[Severity: High]
This isn't a bug introduced by this patch, but looking at the error path for
qla2x00_start_sp() in this function, the code manually calls mempool_free()
instead of qla2x00_rel_sp().

Does this skip decrementing the busy reference counters for the hardware st=
ate
and queue pair, permanently leaking them and preventing the adapter from be=
ing
safely unloaded?

[ ... ]

> @@ -3318,6 +3353,13 @@ qla2x00_process_vendor_specific(struct scsi_qla_ho=
st *vha, struct bsg_job *bsg_j
>  {
>  	struct fc_bsg_request *bsg_request =3D bsg_job->request;
> =20
> +	if (bsg_job->request_len <
> +	    sizeof(struct fc_bsg_request) + sizeof(uint32_t)) {
> +		ql_log(ql_log_warn, vha, 0x7000,
> +		       "BSG request too small for vendor cmd.\n");
> +		return -EINVAL;
> +	}
> +

[Severity: Critical]
Does this central check mathematically overcalculate the required payload s=
ize
and artificially reject legacy tools?

The size of struct fc_bsg_request is 20 bytes due to the union, but the
vendor_cmd flexible array starts at offset 12. Wouldn't a 16-byte payload
safely cover vendor_cmd[0]? It appears enforcing a minimum of 24 bytes here
will break backwards compatibility for legitimate userspace tools sending
valid 16-byte requests.

[Severity: High]
This is a pre-existing issue, but while we are adding bounds checks, it loo=
ks
like qla84xx_mgmt_cmd() and qla24xx_iidma() might also need validation.

They cast the payload starting at offset 20 to structs like qla_bsg_a84_mgmt
or qla_port_param and access fields up to offset 39 without verifying if the
request length is sufficiently large. Could this lead to out-of-bounds heap
reads?

[Severity: High]
This is also a pre-existing issue, but looking further up the stack in the
generic transport layer, does fc_bsg_host_dispatch() in
drivers/scsi/scsi_transport_fc.c actually guarantee that the request length
covers the vendor_id field?

It increments cmdlen but accesses vendor_id immediately without verifying if
the user supplied at least 8 bytes, which seems to allow an out-of-bounds r=
ead
before the request even reaches the driver.

[ ... ]

> @@ -3461,8 +3503,11 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
>  	}
> =20
>  	/* Disable port will bring down the chip, allow enable command */
> -	if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MANAGE_=
HOST_PORT ||
> -	    bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET_HOS=
T_STATS)
> +	if (bsg_request->msgcode =3D=3D FC_BSG_HST_VENDOR &&
> +	    bsg_job->request_len >=3D
> +		sizeof(struct fc_bsg_request) + sizeof(uint32_t) &&
> +	    (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MANAGE=
_HOST_PORT ||
> +	     bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET_HO=
ST_STATS))
>  		goto skip_chip_chk;

[Severity: Critical]
Similar to the check in qla2x00_process_vendor_specific(), does this fail to
bypass the chip checks for valid, tightly-packed 16-byte requests because it
inflates the required length to 24 bytes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D85
