Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A1A25F7A9
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766805; cv=none; b=Pay+jugUej6qCEoUDHJatpbsc8RUNlEhcq7k6gK+07NmgUf1IPqiuSOfdEtbn7u8P0qmX/UTSLjHBiFI4gcfoZ7U7StJzcL3ZE9CwlnGPyMSyqUgBgj4p6wH9yjkyhDeaB7hwqihWRNM7cPc1zsrE1jwVpw94F68MCjQxht3Z+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766805; c=relaxed/simple;
	bh=PKYTX34z5eua884L8ub5LK/jTraaYuMDcCjh0vaJyRQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FMRLKfHCqI9ZdoKTq1oDf2ddDaZ+axQtWeQ4jU0PzPSKbBMKqptvgYVX0//q3+Fn5BcAH5GmWPKpmRTwl2Dx3gZBHWi0ynV+W6guKYEKwIC0mGI9u23TlJimSPZ8O+hhyP/LVJRCr2rfrO/7LMxEPn1FrzeTP+qLuUvanap9Fwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzncW36U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzncW36U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0864E1F00A3A;
	Thu, 23 Jul 2026 00:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766804;
	bh=1XhyYkCmkji0sDVEqPs8S1FHdC2RYF6dD/6dIQCNxKM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bzncW36UJujbwD91dbbZqAK9iMFk3iFDdMV2/sDVDyAQvgPrdJ5Uw3AP1Sru0w007
	 Lj+AF1lRrYOfETv6mMCB5zVV2yuj2Lb61dH6Zskv3kp5OcSqD15jKaSQxBohlTpPDr
	 Itppcokg1Zmo0wdHG8b4fnpv8hz9+zkHnFFpPc7flw7MWz3U0cuzCN0xmY6xrmEWyb
	 zRlKg4RDTNEsGH2rf9iE+IXl/e/SCdx5IDM7H88FK96S+IlF4nh7OjUqPz9PtKulze
	 sC5n6lQX0eoMG9hbJMQ87+Hno98/rdVgVUdsRBmp4jahuXeyEw/kNnJQ7xXtXI0rOA
	 y4tgOqiC3yanA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/33] ibmvfc: alloc/dealloc sub-queues for nvme
 channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-10-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-10-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:33:23 +0000
Message-Id: <20260723003324.0864E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] NVMe sub-queue registration failure unintentionally disables SCSI =
multiqueue support.
- [Medium] Incomplete integration of NVMe sub-CRQs and targets in host life=
cycle and work scheduling routines.
--

--- Patch [9]: [PATCH v2 09/33] ibmvfc: alloc/dealloc sub-queues for nvme c=
hannels ---
commit bf86ac3ca0d20bb114b63c6bb20bb9e08b7ed641
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: alloc/dealloc sub-queues for nvme channels

This commit updates the ibmvfc driver to allocate, register, deregister, and
release NVMe subordinate CRQs alongside the existing SCSI sub-CRQs. It
extends the CRQ reset and re-enable paths to handle NVMe channels during
adapter setup and teardown.

> This keeps the NVMe queue lifecycle aligned with the existing SCSI queue
> lifecycle so both protocols are reset consistently across probe, remove,
> and connection recovery.

[Severity: Medium]
Is this alignment complete? Looking at the rest of the host lifecycle,
several routines like ibmvfc_purge_requests() only iterate over the SCSI
queues:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_purge_requests() {
    ...
	struct ibmvfc_queue *queues =3D vhost->scsi_scrqs.scrqs;
    ...
}

Similarly, ibmvfc_link_down() and ibmvfc_dev_init_to_do() appear to abandon
NVMe targets by only checking scsi_scrqs:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_link_down() {
    ...
	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
		ibmvfc_del_tgt(tgt);
    ...
}

Will this cause pending I/O or targets on nvme_scrqs to be missed during
connection recovery or adapter teardown events?

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 5b6570232df36..d8c2b56258eeb 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6119,6 +6123,13 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_hos=
t *vhost)
> =20
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> =20
> +	if (vhost->nvme_enabled) {
> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs))
> +			vhost->nvme_enabled =3D 0;
> +		else
> +			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);

[Severity: High]
If NVMe channel registration fails here, will it unintentionally disable SC=
SI
multiqueue support?

Looking at ibmvfc_reg_sub_crqs(), if channel registration fails, it clears
the global do_enquiry flag:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_reg_sub_crqs() {
    ...
	for (i =3D 0; i < channels->max_queues; i++) {
		if (ibmvfc_register_channel(vhost, channels, i)) {
			for (j =3D i; j > 0; j--)
				ibmvfc_deregister_channel(vhost, channels, j - 1);
			vhost->do_enquiry =3D 0;
			return;
		}
	}
    ...
}

Since ibmvfc_reg_sub_crqs() is called for the SCSI channels right before
the NVMe channels, setting do_enquiry to 0 upon an NVMe failure would
prevent the driver from sending IBMVFC_CHANNEL_ENQUIRY and
IBMVFC_CHANNEL_SETUP during NPIV login.

Does this cause the SCSI protocol to silently fall back to single-queue mode
if a user attempts to enable NVMe on a hypervisor that lacks support or
resources for additional sub-queues?

> +	}
> +
>  	LEAVE;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D9
