Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5268127603A
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766858; cv=none; b=S2dsMq50KSRuCwhwbWsICJ7DZHOraGu1W2NSkjgQwcU/lBcHMIxc+Gbx4uSt1g23m5HKC9NJ40141uCkRUIBDDOBLkGkkh7Ph/ZccktSPGe1GTusdI3+krWKHK9o5ZD+i/gU1J/ii9gEPtp/BHZS37JCRmjFdjSCQa4nOa0yRSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766858; c=relaxed/simple;
	bh=6xrIRrE9qI7Y9Ss+WazgJTorZH4WgMawZ1ATQutywPk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=suBRVvZUng3aiSW2tEkZBAlkM96pmk/v+8YeUEMClWNuAvnZIc7ZarIh6vS8b9sN8sNziYFbmORjIJU7XKH0YkoZ9hA+tFE8OCkSG+kWjFTGOQYqlbRgXbw1v4FqXhrVaRa8nMNpcLEeXeARxn1iInqeGdAAM7qB+tDsJs9cT+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nw21b7jr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nw21b7jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C359F1F000E9;
	Thu, 23 Jul 2026 00:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766855;
	bh=2kH7t0ECK/wHvdOqF5ePpXVG21rEDOUk1CH/g7suueI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nw21b7jrEoKI5l+GiRqcD4DnYRcS62G+Huw1Cg35eKskaWjavxSAinijX4sulJplc
	 djyly4+lDinMgwAbX+RaC9cFYXtc2TFioirtefQTWX4Wpyz11vBXf5hCDet0jyUP2g
	 RZq4s81//OKvH/jCeozVuPzFSz9BaufcpmHUIQg2YimbF0pAw9mCAOYDV0F1THqXfo
	 pKoyn7Y9Utehq0111VT7kJtmYwZxXgCEt/ri3Mi1k+h0YxwZ2qCub/hjmDetJo5Zak
	 y/lUPkUHwzchadgh9aN6LNOxZWLKEC7m2yz62N/9P8vRe1uocOYFT9DYv+JeXNyRNt
	 I1fMuLFAj1EFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/33] ibmvfc: move target list from host to protocol
 specific channel groups
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-6-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:34:14 +0000
Message-Id: <20260723003414.C359F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing memory leak and mempool_destroy BUG() trigger during =
module teardown for orphaned targets
--

--- Patch [5]: [PATCH v2 05/33] ibmvfc: move target list from host to proto=
col specific channel groups ---
commit daeeaeede0866c302e3a906a87d7eef6faf608ae
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: move target list from host to protocol specific channel groups

This commit prepares the driver for protocol-specific target management by
moving the target list and target count out of struct ibmvfc_host and into
struct ibmvfc_channels. The existing target iteration, allocation, and
discovery paths are updated to use the SCSI channel group's target list.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 412e946abcb77..78b4ac201a494 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
[ ... ]
> @@ -5662,7 +5662,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhos=
t)
>  		break;
>  	case IBMVFC_HOST_ACTION_TGT_DEL:
>  	case IBMVFC_HOST_ACTION_TGT_DEL_FAILED:
> -		list_for_each_entry(tgt, &vhost->targets, queue) {
> +		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
>  			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
>  				tgt->job_step(tgt);
>  				break;
> @@ -5674,7 +5674,7 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhos=
t)
>  			return;
>  		}
> =20
> -		list_for_each_entry(tgt, &vhost->targets, queue) {
> +		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {

[Severity: High]
This is a pre-existing issue, but does this code leave targets orphaned on =
the
new vhost->scsi_scrqs.targets list during module teardown?

If a target is in IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT when
ibmvfc_remove() begins, ibmvfc_link_down() fails to change its state.

The worker thread in ibmvfc_do_work() transitions the target to
IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT without unlinking it:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_do_work() {
    ...
    ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT);
    ...
}

It then calls fc_remote_port_delete(), which schedules asynchronous teardow=
n.

The worker thread sets vhost->action =3D IBMVFC_HOST_ACTION_NONE and
wakes the teardown wait queue. ibmvfc_remove() resumes and permanently kills
the worker thread before the target completes its asynchronous teardown:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_remove() {
    ...
    kthread_stop(vhost->work_thread);
    ...
}

When the asynchronous terminate_rport_io() callback finally fires, it chang=
es
the target state to LOGOUT_RPORT, but the dead worker thread cannot process=
 it.

Does this leave the orphaned target on vhost->scsi_scrqs.targets indefinite=
ly,
preventing its memory from being freed and triggering a
BUG_ON(pool->curr_nr !=3D pool->min_nr) during mempool_destroy() in
ibmvfc_free_mem()?

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_free_mem() {
    ...
    mempool_destroy(vhost->tgt_pool);
    ...
}

>  			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
>  				tgt_dbg(tgt, "Deleting rport\n");
>  				rport =3D tgt->rport;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D5
