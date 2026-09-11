Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7230B32B99F
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093306; cv=none; b=Zcgb6h4L3tMXFRtjos88TYVPfgRIBEj5UUWSbl2bPeXOQt2t5UkmL3+0iA6n9Gxlifb7UaEcauY+kSUEfHQ4pupGdR6s7v2Yer2XrfmTu+l1MZ2FL0Ryx56tdDzO/xcppEMJUoeX3fPiX17hE+1XNp3FDpXhIHmWTXl/vSVOEsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093306; c=relaxed/simple;
	bh=xuPLY8hdOXDcoc+PLW4L3Z//aBc/SQ2ynFe/LE8FAL8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CYTuilPs+j+lLMdyB+km3D1GC1f6cVdMwMa97tX0F+fNqyY8lVUJRNcrqJDCcgQkvGECG2TDW5dG5jc7oGqjtQU6s9/xyh1/JZIUvoxsAeaw2IISPmW5LMso8mQIjPaxoKYFCm7xNfIW/W3jfd9A/gcRnUCGJg4ZLB2ukFbsY6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GL3Dnces; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GL3Dnces"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E62B1F000FF;
	Fri, 11 Sep 2026 02:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093305;
	bh=6WJ6muFmhQ0tJcL642EBf2wxXYXMDrD12GygUhULCEg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GL3DncesI1bV0CXxGJVpyhPzB7Qw4BIy/n6mVJ3GeOjz9yf1mLC7ukaHVdxZHSJju
	 c4LG9o62gwBwQHp6KzAmGaJl2PlS99ch+fTs70Bk95mZBZ9qaLDBLzf1bkCBmdmDaD
	 P2RKqCe/SIaKmQkUE2JvHaOUNwoMRkjyS7kYmXic63Ms8I+/wecCDh4+m3NZItGW93
	 KR/BCzX+RUmQkH5hKPmslHMIDJHrloYQ2rXwjkk3Tw4Qic7KxHqJfSz1UnYDloFcKZ
	 03+366Eyn5ngiaknj+mbstu9zgChT1z8MuZ6/oXd/Ghcy0q+lQzpUIG8d9PbbHtmSt
	 WE1gz5DTQXDxQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/9] scsi: ibmvfc: add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-2-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:21:44 +0000
Message-Id: <20260911022145.2E62B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `ibmvfc_handle_scrq` function dereferences the untrusted `evt`=
 pointer to access `evt->queue` before validating it, which will trigger a =
kernel panic if the hypervisor provides a non-NULL invalid correlation toke=
n.
--

commit e6c05534301788d9c2d48c5e067192600cb0bcda
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add NOOP command support

Adds support for handling IBMVFC_NOOP format CRQ messages from the VIOS
partner and advertises the client capability. It also attempts to harden
message handling in ibmvfc_handle_scrq() by guarding against null events.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -4225,7 +4235,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
crq, struct ibmvfc_host *vhost
>  	case IBMVFC_CRQ_XPORT_EVENT:
>  		return;
>  	default:
> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->vali=
d);
> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid=
);
> +		return;
> +	}
> +
> +	if (crq->format =3D=3D IBMVFC_NOOP) {
> +		if (vhost->state =3D=3D IBMVFC_ACTIVE &&
> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
> +			dev_err_ratelimited(vhost->dev,
> +					    "Received unexpected NOOP command from partner\n");
> +		return;
> +	}
> +
> +	if (unlikely(!evt)) {
> +		dev_err(vhost->dev, "Received null event\n");
>  		return;
>  	}

[Severity: High]
This is a pre-existing issue, but this patch attempts to fix token validati=
on
by adding an if (!evt) check, which still leaves the kernel vulnerable to
malformed non-NULL tokens.

Because the event pointer is directly cast from an untrusted 64-bit value s=
ent
over the channel, if the hypervisor provides a non-NULL, invalid correlation
token, doesn't ibmvfc_handle_scrq() still dereference the untrusted pointer
before validating it?

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_scrq() {
    ...
    if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
    ...
}

Could this dereference of evt->queue trigger a kernel panic before the event
is proven valid?

To fix this safely, should ibmvfc_handle_scrq() accept the scrq instance fr=
om
its caller and validate against &scrq->evt_pool without dereferencing evt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D2
