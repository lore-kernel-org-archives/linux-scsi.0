Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7745563F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602084; cv=none; b=oWgToFAh5NtgVhf8B4VROSmkVI+5VHC0JNQSxNhBvCNhTvpdnSVcc5YbxcQ9r6zD81a1Sdug/luFDuQTaZ1N+r7BEYf2mEP7oaN4+IOxSqIB2Dv8hYk49m/k5KpiQuDf4mdYmb49yaq7vTb7LI6DxJZl4Mwseo5UyVub7n/YzNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602084; c=relaxed/simple;
	bh=1//Q3JYlOQZgdMTAfjtlbNs97vItsDK9prVtTlA7j9k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cC5ctBMXjghkFJ+pz9SA5UMmFJFNclbzWmZ3cAW9nqXrUyg6KkY4Qtc8Ddn+Lox5pk7M9/UVLc9B1ef9UHsvHbZpab4XTWlc3erUxLJS+qogo8fN72wdy4PR66r6kB9zBs2iRl38lr+kxOLD6O2JBTzCPWAH1ygOIRN3DIuGGqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H05K3uuq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H05K3uuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6801F000FF;
	Wed, 16 Sep 2026 23:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789602082;
	bh=95IMB08NbLAooURIgHLA16F7SiMwB1GOEak63i7zioc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H05K3uuq6DfdUlJCg8+7M5brWXi/Q44bplJerJrN11ziDIQb2DnXgZ5/Noq7czyZG
	 sWGapfcu+mcrTYXaRUvlwsKtf5SSReVUUHajZ2G197cyNH2JvaDeX5jqFp1P5jftkl
	 QqC+8Fn342POk48drSwBaj/cJ2piMtSdq5n1Rqte8jPecfEcySCLcis3idgWYvjHAL
	 WSmIVfQI+YNjBk/FbkM6k8yarm/FGlLPY2qaat9ZkQhgSp76pB9rcrvSn9LCe9qVqD
	 coruf35PEA5M6n5DYdfipbdCcfVkevZ3T+RPi/jK7tXnOZKC6eT9aaq0Fm6kzm1ZPD
	 G6o29X8/EfusA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/20] scsi: ibmvfc: fix concurrent SCSI and NVMe
 discover-targets race dropping targets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-20-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-20-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:41:21 +0000
Message-Id: <20260916234122.0A6801F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: state machine race via orphaned discovery MADs
--

commit 6d8009c8fd10f57d31447688423fb6783763f7d1
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix concurrent SCSI and NVMe discover-targets race dropping t=
argets

This commit introduces a pending_disc counter to ensure both SCSI and NVMe
discovery-targets MADs complete before proceeding to target allocation. It
increments the counter for each sent MAD and decrements it upon completion,
transitioning to the allocation state only when the counter reaches zero.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index d79a6ae278a2c..b0d9000b4a0d4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -5156,7 +5156,8 @@ static void ibmvfc_discover_targets_done(struct ibm=
vfc_event *evt)
>  					      max_targets);
>  		ibmvfc_dbg(vhost, "%d %s targets found\n", channels->num_targets,
>  			   proto_type[channels->protocol]);
> -		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
> +		if (!--vhost->pending_disc)
> +			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
>  		break;

[Severity: High]
Does this blind decrement safely handle orphaned discovery MADs from a
previous initialization cycle?

If a MAD fails, such as from a transport timeout, it calls
ibmvfc_retry_host_init(). This schedules a retry without canceling other
in-flight MADs:

ibmvfc_retry_host_init()
    if (vhost->action =3D=3D IBMVFC_HOST_ACTION_INIT_WAIT) {
        ...
        else {
            ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
            retry =3D 1;
        }

When the work thread runs the retry, it executes ibmvfc_discover_targets()
again. This overwrites the pending_disc counter for the new cycle:

ibmvfc_discover_targets()
    ...
    ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
    vhost->pending_disc =3D 1;
    ...

Could the original in-flight MAD from the first cycle then complete
successfully, prematurely decrement pending_disc for the new cycle, and
trigger ALLOC_TGTS before all current-cycle MADs finish?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D19
