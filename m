Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3D929ACFD
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 22:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216363; cv=none; b=NcH+BHn4IQWW+d4Te+fJkt8S28TrZ313yMFbEB793iylQmJsPB4FO2+pqWJEbRDuBoMJ4VlRfqkyEYLSB3RVD1nTmgUJWVeeOYJ0ybo54rSIJih37BH+yRnXyQhJOv0Ya5o9yQGqCFUjfKCRL12B+VObQBXIWYwyK9GwG1tru+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216363; c=relaxed/simple;
	bh=MuUbw6ig6t9X6rTCsrbGs0kds6YzzYa0JaWcdQPQtGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WXwFDnHY7HG2U3jdrOdstUgod3QOhz6bbGDa6redwNOQHj/4gkRIb50A81FxE2/H2vpD+AmbAtLX30bbvhshSbRTT4mebY55luyviMWahZEsr1Iky2V8DTZhh1Ce0qq+3cUPdNxUzm+dkkYsZNZKMXq0Y9DBIQKFLfEVGtPIvcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFIoaE7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFIoaE7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23911F000E9;
	Mon, 31 Aug 2026 22:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788216361;
	bh=XSly9omuXVNgEMaxW8em4gu4I3pboDPcBpK9PIkcOHY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QFIoaE7pSpXEWObsgcSbCqpenVkKldjfeR3FOsHkSj/hEW76L+OOQR3uXXKLd0akv
	 UBhBG57qmn1HrquMITEg7Wglq2c94eKvm7jlDjG1nmgoMOO+jLIEFNoXHf6cqU69yq
	 1ZsjpscotIfnsufTnUJpSByZDNTJEHs/45AlMivP8nzAseCjny2wYfujn6TOXV8ZRz
	 2JANU7MdxwmtXEBV2xQMroOIh85q/rkeWu+bgGFwWEybJO950qJMw8BrYL/AZXnzmt
	 D/wLfscLWFUt0B7tZ/tasc98D91fQxkoV7krSfQP07CPsmlpoRbi+L5mK8VSl2rh5s
	 AdEhBnY9fgQmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 7/8] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-7-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
 <20260831-ibmvfc-fpin-support-v7-7-77d0b9809080@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:46:01 +0000
Message-Id: <20260831224601.C23911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unconditional deregistration of the uninitialized async sub-CRQ ca=
uses a NULL pointer dereference.

Pre-existing issues:
- [High] Buffer overflow due to out-of-bounds array writes and reads when p=
rocessing unvalidated queue counts from the VIOS.
--

commit 908a7af2b04b0b17f4fc0a40814f0dacec88332a
Author: Dave Marquardt <davemarq@linux.ibm.com>
scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the asynchronous sub-CRQ into the sub-CRQ lifecycle so it=
 is
allocated, registered, and freed alongside the SCSI channel queues. It modi=
fies
multi-queue initialization and teardown paths to accommodate the new queue =
and
advertises relevant capabilities to the VIOS.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index cc1ef82580608..adc730af67d2b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -5800,6 +5808,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		for (i =3D 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =3D
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
> +		vhost->async_sub_crq.vios_cookie =3D be64_to_cpu(setup->async_sub_crq_=
handle);
> =20
>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",

[Severity: High]
This is a pre-existing issue, but can this out-of-bounds write occur if the
VIOS returns untrusted queue counts?

In ibmvfc_channel_setup_done(), the driver reads num_scsi_subq_channels and
num_nvme_subq_channels from the VIOS response into active_queues without
validating them against the dynamically allocated max_queues array size:

ibmvfc_channel_setup_done() {
    scsi->active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
    nvme->active_queues =3D be32_to_cpu(setup->num_nvme_subq_channels);
    ...
}

The loop just above this patch hunk then directly uses this unvalidated val=
ue
to write to the scrqs array:

ibmvfc_channel_setup_done() {
    ...
    for (i =3D 0; i < scsi->active_queues; i++)
        scsi->scrqs[i].vios_cookie =3D
            be64_to_cpu(setup->channel_handles[i]);
    ...
}

Could a compromised or malfunctioning VIOS provide values that exceed the
locally allocated array size and cause a buffer overflow here?

[ ... ]

> @@ -7055,6 +7087,9 @@ static void ibmvfc_release_channels(struct ibmvfc_h=
ost *vhost,
>  static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +
>  	if (!vhost->scsi_scrqs.scrqs)
>  		return;

[Severity: High]
Does this unconditional teardown cause a NULL pointer dereference when
multi-queue is disabled?

During module unload or reset, if multi-queue was disabled (mq_enabled=3D0)=
 or
initialization failed, vhost->async_sub_crq is left zero-initialized.

Unconditionally calling ibmvfc_deregister_channel() routes to a cleanup path
that behaves as follows:

ibmvfc_deregister_channel() {
    ...
    /* Clean out the queue */
    memset(scrq->msgs.crq, 0, PAGE_SIZE);
    ...
}

Since msgs.crq aliases the unallocated msgs.handle (which is NULL), will th=
is
memset() write 4KB of zeroes to a NULL pointer and cause a deterministic
kernel panic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831-ibmvfc-fpi=
n-support-v7-0-77d0b9809080@linux.ibm.com?part=3D7
