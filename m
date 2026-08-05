Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1FB41B8C7
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930031; cv=none; b=PM2zVI9OlUNyQS9rj8dayT4iTxDN0HdHS2WYQJL6yR1Vnjlxx+NOQyz3saKvmN9ZWnz//GUlrdNdr8WQlHr8nNwWhXy7dSGPz0e8M1/oeBWua90nw1ZLHitAAsSKXi4g/Gnk9W4FjmlHWLRvIxHuLDJvdQClG2Zb7njckLaFaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930031; c=relaxed/simple;
	bh=J2Nsu6UMmMQMofVz6jbISFu7iNqamSw7hAeSC+Waa6I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RXjDVS5WY8e8mtrTrnVzbIB/UpVRieZf5LwhFK2tGjMqizLsDv6R1t5yx51/H2/d2e7bZtNYHDOBHpadc0K/7sizElIKfdVDczRNUUa1cPuhEXBd2qlDW458dLjotfqKWoNijVc+gsUzEuAPZddZoqhUpmJ+zIqpXCrj+0G5r1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGT8mAjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGT8mAjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25AD1F00A3E;
	Wed,  5 Aug 2026 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785930029;
	bh=P+L8dKHfqrxvI5kQSEK+hNmkTmZneDbrzb5AYToARfA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HGT8mAjVrrqMkrhL69SZ86Qu10qzPoYQa68aYqYzedHc2G9sFoEGfwCN5b+0zMcuz
	 R5zqcvtoCFAONPI2AJjLcCl7kBc6zcbmz32UyYUPXEjaM0jKet1S2XJNVrNgTFpCKd
	 T3XPrBUQCX+hX2BmEpj5jRf+lhFq80b6ZUNWs4zSdUsa8Ls9B4j9iDKt/M2RJGv1TR
	 YIV++PMMhrDCXM+ybNlbaVuHLoeOzOwfH1SXAjFZzTAnEd/HmPQ5aWvzM33nJ/rheg
	 l7bj6CJNY5+VjsWdyCPmpciJzww7bxJ4KbDrTLIn/QNMheUNRsYzOCVPmbUCsHYSIy
	 IOsGP5h8azhjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/10] mpi3mr: Fix SAS port allocation and
 registration error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260805110634.346670-9-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
 <20260805110634.346670-9-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Aug 2026 11:40:28 +0000
Message-Id: <20260805114029.A25AD1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Skipping `sas_port_delete` and `sas_port_delete_phy` during a =
controller reset causes permanent memory leaks of SAS transport objects and=
 triggers a kernel `BUG()` on subsequent device discovery.
--

--- Patch [8]: [PATCH v4 08/10] mpi3mr: Fix SAS port allocation and registr=
ation error handling ---
commit 2a61369a5f802bef404aa18e7c7a2583f37c4fc7
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix SAS port allocation and registration error handling

This commit adds NULL checks after SAS port and rphy allocations to prevent
NULL pointer dereferences. It cleans up memory and state if registration
fails, resolving memory leaks and dangling pointers. Finally, it prevents
deadlocks in the SCSI mid-layer by checking for resets or driver stops.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index b309cfdf66873..db9cb0b03b9ff 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
[ ... ]
> @@ -1600,12 +1644,12 @@ static void mpi3mr_sas_port_remove(struct mpi3mr_=
ioc *mrioc, u64 sas_address,
>  			    mr_sas_port->remote_identify.sas_address,
>  			    mr_sas_phy->phy_id);
>  		mr_sas_phy->phy_belongs_to_port =3D 0;
> -		if (!mrioc->stop_drv_processing)
> +		if (!mrioc->stop_drv_processing && !mrioc->reset_in_progress)
>  			sas_port_delete_phy(mr_sas_port->port,
>  			    mr_sas_phy->phy);
>  		list_del(&mr_sas_phy->port_siblings);
>  	}
> -	if (!mrioc->stop_drv_processing)
> +	if (!mrioc->stop_drv_processing && !mrioc->reset_in_progress)
>  		sas_port_delete(mr_sas_port->port);

[Severity: Critical]
Does skipping sas_port_delete() and sas_port_delete_phy() during a reset ca=
use
a memory leak and a kernel BUG() during rediscovery?

Because mr_sas_port is unconditionally freed at the end of
mpi3mr_sas_port_remove(), the transport objects (sas_port and sas_rphy) are
leaked when their delete functions are bypassed.

Additionally, the sas_phy remains linked to the leaked port's phy_list. When
the reset completes and the device comes back online, mpi3mr_sas_port_add()
will create a new port and call sas_port_add_phy() on the same sas_phy.

The SAS transport layer detects the phy is already linked to another port a=
nd
intentionally triggers a BUG().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260805110634.3466=
70-1-ranjan.kumar@broadcom.com?part=3D8
