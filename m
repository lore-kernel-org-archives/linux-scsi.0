Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE2337BE7F
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179711; cv=none; b=I/271bKFQmidY9PjFzMzRLVoxIpI81ehcBTtVJMetu8fOFf2PZnKG9oLmHBxWFRPMtMdHLj/AN5okWpzekgB41FWOzTVUrOZ5nancs6QQSacxzQ38KDEVUgX/TIOnqNfbV6ANTGs+cL87CeJ+pj2tKXpZ6GHeBTovSU3Ar91Ui0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179711; c=relaxed/simple;
	bh=BMwNMoVi/k2CB2ySKLi1OS6d5GZp4hyu1QkmQeZtN2o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C9XrEPXNqeM40w6N4F4m68bE5HCGgHA+pAYMEL2qzC7Jq2QUYyFne/r727dwqP2ZYkdfqsy6PK0oNOCVKgU584u2RlPWyzMYxJdxVKIkzd83/+NUu10fP1tJp336e6xXLrowJNORexMjRlbLovybdoDX98KjEnMeiwEZM1usOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3Q7zSsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3Q7zSsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545B11F000E9;
	Tue, 23 Jun 2026 01:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179710;
	bh=hkw5cJSYTQka8NVYxSBavUj9s7bSVbBre72ZbDylKFo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z3Q7zSsTRZtzBWRowblnwARlbgL7vPnvF3LRvf7qZvUYlJv1cWNyA4CUzXpkSaiCT
	 Hf9IENdrMQTcx3hpxd58CgwDc+MWyCoC+0SOYHkfYMBR3THAYMtp51b5A8f9wHrrFq
	 QJpkZvIjwVG1Qf931GLOBij/+I/0n/JH6MuJgQZlh67+c8+L2qdnObO+CArXCNrTRh
	 ggOrFAOeE16cUk1t/MqQMv45eYZbDRCcGKaf6H8kInDFSH3POqR0Y0K7wL8rg63zdF
	 94ppM5ca19Ks/z1a5Bq5Smn1zUMf8G1Z0u/vNHewJRAPtlft4P8498jhvXdvOpTiBs
	 7Pp2EY5zsbcjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/29] ibmvfc: update state machine to process NVMe/FC
 targets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-19-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-19-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:55:09 +0000
Message-Id: <20260623015510.545B11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] NVMe targets leak memory and become permanently stranded because t=
heir cleanup logic is omitted from the target deletion phase in ibmvfc_do_w=
ork().
- [High] Asynchronous ELS events (LOGO, PRLO, PLOGI) from NVMe targets are =
ignored because the event handler only loops over the SCSI target list.
--

commit 2221ef8b59f01b903ca3e2cc56b9bd27be8a9dc1
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: update state machine to process NVMe/FC targets

Update the host work loop and target state-machine helpers to process
NVMe targets in addition to SCSI targets.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 13e513bfd0a86..9a6a885aa57ed 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -5962,6 +5992,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vho=
st)
>  				break;
>  			}
>  		}
> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
> +			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
> +				tgt->job_step(tgt);
> +				break;
> +			}
> +		}
> =20
>  		if (ibmvfc_dev_logo_to_do(vhost)) {
>  			spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: High]
Does this code also need to loop over nvme_scrqs.targets for final target
deletion?

Looking further down in ibmvfc_do_work(), there is a loop handling
IBMVFC_TGT_ACTION_DEL_RPORT and IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT:

		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
				tgt_dbg(tgt, "Deleting rport\n");
				rport =3D tgt->rport;
				tgt->rport =3D NULL;
				list_del(&tgt->queue);
				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
				...

Since this loop only processes scsi_scrqs.targets, wouldn't NVMe targets in
the DEL_RPORT state be leaked and stranded?

[ ... ]

[Severity: High]
Are asynchronous ELS events from NVMe targets being ignored?

Looking at ibmvfc_handle_async(), which processes events like LOGO, PRLO,
and PLOGI, the loop only iterates over the SCSI targets:

	case IBMVFC_AE_ELS_LOGO:
	case IBMVFC_AE_ELS_PRLO:
	case IBMVFC_AE_ELS_PLOGI:
		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {

Since the NVMe targets are now in a separate nvme_scrqs.targets list,
wouldn't an explicit logout or state change from an NVMe target be dropped,
leaving the driver with stale state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D18
