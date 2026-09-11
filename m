Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030BA3B38AD
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093581; cv=none; b=qbq/qm/g++DYfGM8/zlUIHlBXy3MAq6uOgQ85LSo70uQKy39kElFkvL3MLaZXwGrh2KdCttEErS/ovTSuKbzlFcyrLWR3KZ2uXnRj0Hq3kDkbapfcXeo0SrLaHX63N96pzS2dx/9FKs+DHmWoJdxgsyucSbPdkpd8xY39VgdPf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093581; c=relaxed/simple;
	bh=K+JSxKfS2GUr2DRS6hgkqIIweYcYBixfeabHimx39hk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ly0RvQwEyFq+Nk6ceue6c3N+R0DvXuOOxrdCz9YPUt/iFYjIBTNHmPiJSiOzMvNweLF4Z9XoGdXtPuncoW3cCbHWz5jDLQPeZkhV1/N+0jj/qEWQR48RufpitaStHQHLdiCsXDh6vuFbQ9IHdnvuKFK8xCpVfhDLu9F95Fw4/aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/qf/g/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/qf/g/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5CE1F000FF;
	Fri, 11 Sep 2026 02:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093579;
	bh=qs14n2l/ELo/EGwRfIRc5Lx3w1gxcJkUdBXPHUQlAxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D/qf/g/BNFr1i9l2F6EcW9b8LU1DTE7DbqJaAXh66F6OPuZsB/tsgJWXLdkDbO+R5
	 oSkfF6eoygy3Meqgvrzmf5/0dI7pIGSna2qAiICz93DNcHpFP/4w6R6vE/jJZZxvs/
	 5rzDmrrIJUoS2h0U5eNBaF+3ezZLqL0ogCAekJ/6iOpUrFXLg1iL96naHrlMN/RemS
	 QL3P1fK9AKuN5Fy1TY+pLSfiwtumaYJ5sqR9AdkN5Q2tbGfCw/M5JwjAftamC7Yofw
	 CiPd2vKmxr8jLQGnz//NMA1pqRfZsLlkze4Px71jiSLQBnDWpKej4PuHtbyT+L8E08
	 VuAS1yHX4JoWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 9/9] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-9-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-9-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:26:18 +0000
Message-Id: <20260911022619.5B5CE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the target looku=
p logic in `ibmvfc_find_target` contains a logical error that unconditional=
ly skips every valid target, causing it to always return NULL and completel=
y breaking FPIN asynchronous event processing.
--

commit 9ac7aa2b8bc80c6159248d07f474070225aca779
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

Implement support for extended FPIN messages received via the
asynchronous sub-queue, completing full FPIN functionality.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6eb299989724d..bd10c3fd5ccf5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -3511,6 +3547,7 @@ static struct ibmvfc_target *ibmvfc_find_target(str=
uct list_head *target_list,
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
>  	struct ibmvfc_async_sub_crq *subq =3D NULL;
> +	struct ibmvfc_async_subq_fpin *sqfpin;
>  	struct ibmvfc_async_work *aw;

[Severity: High]
This isn't a bug introduced by this patch, but the target lookup logic in
ibmvfc_find_target() in drivers/scsi/ibmvscsi/ibmvfc-core.c contains a
logical error that unconditionally skips every valid target, completely
breaking FPIN asynchronous event processing.

When an FPIN is received, ibmvfc_handle_async() queues
ibmvfc_process_async_work(), which calls ibmvfc_find_target(). Inside
ibmvfc_find_target(), there is this check:

	if (!tgt->rport || !tgt->nvme_remote_port)
		continue;

Since the lists of SCSI and NVMe targets are strictly separated, a target
will only have either rport or nvme_remote_port populated, but never both.
This causes the condition to always evaluate to true, skipping all valid
targets and unconditionally returning NULL.

Since all FPIN events from the fabric will be dropped due to the failed
target lookup, does this make the extended FPIN functionality added by
this patch completely unreachable in practice?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D9
