Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439A949A3CA
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601626; cv=none; b=DNn9lpGf42tR3UBqeyuFairaCUa5iYgrJbh33SXdWFhM+SrlZ29gB66Alin3fhmqKD6s8/pUvXT8X0thHuTrUYUmPoN17FVyDtdK6hU1FxetenBs/Ei/5FA9Hp9O8IEqQJFIwTnjFDPSfPsfYMeLnWkinKHdiyL+ZGgxFND5GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601626; c=relaxed/simple;
	bh=WVEpkeZDkUvGZyGT6/l1Pg2kqxpkeCJpNBTcIA41GWo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZYgtPinTUSBzD/nACkvvG9ahNoOVzjLAbVWJ3gIYmWzqgr/HPNPNzE1JCeV5TF8PXkc8J3OPU02yz2HuriGopoKCVWwRU5VI8eLOo8xwq1jxQ3SrpYYn7XiFlMmIqTA0T5Qluxh0bi/VKZtbw61uAfF4ESzaT9TSGCkOOKyHh+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ie/N8IXZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ie/N8IXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37991F000FF;
	Wed, 16 Sep 2026 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601624;
	bh=wwPd7FYUJyh6u8oenfUQ0rrcCowV6Es2g687GMumPRw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ie/N8IXZjbOC2MJbXwfOFaVbo7qG6DPZoX7JRqwZeNAq8J/JDluQvwrCKPpPt7eLX
	 Z8H2q3MNafMg4b5zNiqOxGg8VSgcZtcjauVRRvxYTnQzIDP7Ip1FYjX16Dmz9BngM2
	 /MAIC1QaDsPS2pKPkFLjAIs0GMzOUhhM9MD8AiZz3SDnpjcSXZz7ZJgn0zGDX9i5rB
	 56Nwpx3+nGwKzLCfKyWpzKnxjK0tNrETCNCO26iMgPIVeHSqJThuGQlF/GW87ihYjl
	 NjnjVw9RhWNF5trRxxd0Yfnh3n03mIcvMelWeGoEAMgkmDtUTlZ/7ewGc52WiAmoHV
	 0d6Sz/Z7kW8dA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/20] scsi: ibmvfc: fix uninitialized _done dereference
 for TMF events on send failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-6-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:33:44 +0000
Message-Id: <20260916233344.A37991F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: FCP TMF send failures silently report false success
--

commit c0038842ca930b0a5898cd284c6625f6e31cea8f
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix uninitialized _done dereference for TMF events on send fa=
ilure

This commit fixes a wild function-pointer dereference in ibmvfc_send_event()
by restricting the _done reassignment to IBMVFC_MAD_FORMAT events only. FCP
Task Management Function (TMF) events will no longer reach this branch.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -1859,7 +1859,7 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,
>  			evt->done =3D ibmvfc_vfc_eh_done;
>  		} else if (evt->fcp_req || evt->ls_req) {
>  			evt->done =3D ibmvfc_vfc_eh_done;
> -		} else {
> +		} else if (evt->crq.format =3D=3D IBMVFC_MAD_FORMAT) {
>  			evt->xfer_iu->mad_common.status =3D cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
>  			evt->done =3D evt->_done;
>  		}

[Severity: High]
Does skipping this branch for FCP TMF events (which use IBMVFC_CMD_FORMAT)
inadvertently cause send failures to be reported as successes?

If ibmvfc_send_event() fails and we bypass this assignment, the
zero-initialized FCP command status in evt->xfer_iu->cmd.status remains
unmodified before evt->done(evt) is called.

Callers like ibmvfc_reset_device() appear to check this zero status and
falsely assume the operation succeeded:

ibmvfc_reset_device()
    ...
    if (rsp_iu.cmd.status)
        rsp_code =3D ibmvfc_get_err_result(vhost, &rsp_iu.cmd);

The same pattern appears in ibmvfc_eh_abort_handler(), which also checks
the unmodified status:

ibmvfc_eh_abort_handler()
    ...
    if (rsp_iu.cmd.status)
        rsp_code =3D ibmvfc_get_err_result(vhost, &rsp_iu.cmd);

Will this lead to the SCSI midlayer receiving false success reports when
TMF resets or aborts fail to send during SAN error conditions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D5
