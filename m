Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFD81D555
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767924; cv=none; b=SseYc7VIOA/y9CCjmPPNsCY4QVHhmijeM/mDI1Xote/ZST0golRWmPPFLbxsqnOP3divnuAsJ5yBfGbwHdrspFQYtJBymKDcJ2RZjeYPNShcx0oCemTwLfh+eWLmzFygflpV0i2oWIkceEDBVX0VNU/lL95zGPuxcyuu6i4H/+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767924; c=relaxed/simple;
	bh=4vh6+I82N+Gx9qa8FAK6CCHKQdt0zZCBhGmfwvcYhyA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O6e6sSaO/R8k9HazBbz1/6CnQfIRaEXWLTGjio6P23WaA4usP2vOZT7U6EiccH1wcF/tCbDGfHYIWZhY/6WPsod4PnYHxqyD4k3sr7ovmqV4Yn1vlopthXkgkRZDXOlQhpmhlknqKUzyDlWO8zfuFTfjPHtxDo1wQrFrl9lZWz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqDXIbzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqDXIbzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBFD1F000E9;
	Thu, 23 Jul 2026 00:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767923;
	bh=rYAGBcQ80wJE7a507iIKFDGXAMjUS3D3baZnMC9KsP4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jqDXIbzGpThQJT+Sr9yNVkYRmSh89rbPr2CtCfBsCtha4XTQxqArww8KQUysgr73i
	 NY0e4SjQgFdOJA2lIKJvwxHci8DwxEzZIFFJObhLCFuuVOOyoejDzFvxNvcfCTcKGx
	 HyZaP2bAE+0d4YZwqTpNK6ntuvYCbraVkdxWyaWwV/uM6fRB8knaDbKpUVrFPAv+6d
	 ZNZFa+a/QSZClDOP+ralTjcasncF0mhNAD06oQTvuRlrwaai3rEHSkaPioxKfvqF2f
	 7vNV/vXLsGpvVDC26t89FNK53e6BmuCefsHV0ZdvgpuzvmNSiAQ94xWykaX0vyBrv2
	 zcQcQrFl08eYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/33] ibmvfc: delete NVMe/FC targets as well as SCSI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-22-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-22-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:52:02 +0000
Message-Id: <20260723005202.DCBFD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] NVMe targets marked for deletion are never processed by the host's=
 worker thread, leading to a stalled state machine and memory leaks.
--

--- Patch [21]: [PATCH v2 21/33] ibmvfc: delete NVMe/FC targets as well as =
SCSI ---
commit a374ffc0e25726714a6472bd16a2cbadb3641666
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: delete NVMe/FC targets as well as SCSI

This commit extends target deletion paths to process NVMe targets as well
as SCSI targets. Link-down and host reinitialization flows are updated to
walk both the SCSI and NVMe target lists when marking targets for deletion
to ensure protocol-specific target state stays consistent.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 92c286cfc69c6..1185d72a8a734 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -714,6 +714,8 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhos=
t,
>  	scsi_block_requests(vhost->host);
>  	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
>  		ibmvfc_del_tgt(tgt);
> +	list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
> +		ibmvfc_del_tgt(tgt);

[Severity: High]
When ibmvfc_del_tgt() is called here for NVMe targets, it sets the target
action and wakes the host's background worker thread (via work_wait_q). Will
these NVMe targets actually get processed by the worker thread?

Looking at the worker thread execution in ibmvfc_do_work():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_do_work() {
    ...
    case IBMVFC_HOST_ACTION_TGT_DEL:
    case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
        list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
            if (tgt->action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
                tgt->job_step(tgt);
                break;
            }
        }
    ...
}

And similarly in the helper function:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_dev_logo_to_do() {
    ...
    list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
    ...
}

Both functions strictly iterate over vhost->scsi_scrqs.targets and complete=
ly
ignore vhost->nvme_scrqs.targets. Does this leave the NVMe targets stranded
in a pending logout state, resulting in a stalled state machine and memory
leak for the target structures?

>  	ibmvfc_set_host_state(vhost, state);
>  	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_TGT_DEL);
>  	vhost->events_to_log |=3D IBMVFC_AE_LINKDOWN;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D21
