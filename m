Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383EB356757
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180021; cv=none; b=jiHBRAgMd7S6aFL2P9yUi8puibvxas3ZTMhA7JMRQJWmgiyWgKWSRcfL40P6BB8slPucKXrvSqW0govGOgVLhGe0TXPuTjP5tfzMDgkyVKMCWMk3qcoHM8hHca8yER0hOVKZrkLLxad6Tn7PELG3tJWLmX5f3amNMUWwmNd319s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180021; c=relaxed/simple;
	bh=YwyOs11V1rBMW9Vq66UqNMY6FCLbI1xvJ9psBBOvBdo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jHS0srYfx5x2aw400IGMuEkYMGjIvslcDKsnrmGWfe1a+a3f7xzvDnd2+E7WZuS0O/YXJMejajC13JYj8RD2M9jkcdM7DjXRKbsM1GH0cmD5jgMzNbOsCRaZNdvLAzcFbSubZiRcw9JVhi6fw0nRW10x2OBeAepCMk9kjzmfl3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lh8YYXjr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lh8YYXjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B216F1F000E9;
	Tue, 23 Jun 2026 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180019;
	bh=/0JmXnK3zfWrJruvhoKk8R4DClt7sjhQKbtVuUzNQSw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lh8YYXjr886EjrEkSxx3TeWK3tMr1CJIaTPRTVT0APvEUL54MhZmdq11M5fbTNPuq
	 NDQcKwMjrxFeTcwFJfWRpqqwWxNxUvqfdCgDRuNI4J+WCfJI7I3+5pIt2SzNr0mqFg
	 ZCXso2gzwDRrJXo+/o9XdeqSmnu/vcAJ0stFo9Mg0LqlJEnbQhRWxCl6gNrP3muf/c
	 DpHCczFxaPh+3Hv9Y/mw8y+b33Cnf2Sq4Meko/Tq2s9KrJV3hlDgL3rK35gKwdzAXj
	 /uxRIBEFqwzFkOqA2ZAqfuBCIfo9xD9Qq4z5HLLKlceFJt3Vh/SBkC9il1IyIh6K4u
	 +oeAumvKrm/mA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 21/29] ibmvfc: process NVMe/FC rports in work thread
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-22-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-22-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:00:19 +0000
Message-Id: <20260623020019.B216F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] Deterministic NULL pointer dereference during NVMe remote port=
 and local port unregistration.
- [High] NVMe targets marked for deletion are completely ignored by the mai=
n state machine, resulting in permanent resource leaks and stuck target sta=
tes.
- [High] `ibmvfc_nvme_unregister` is dead code, permanently leaking the NVM=
e local port on module unload.

Pre-existing issues:
- [Critical] Concurrent target deletion during port addition completely lea=
ks the newly registered remote port, leading to a Use-After-Free of the pri=
vate data pointer for NVMe targets.
- [High] Target structures allocated from a mempool are incorrectly freed u=
sing `kfree()`, draining the mempool reserves and leading to hangs under me=
mory pressure.
--

commit f73360d74019cb783c285fb8eef798a237334c34
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: process NVMe/FC rports in work thread

This commit adds an NVMe-specific remote-port add helper and updates
the rport worker thread to walk the NVMe target list. It handles
registration, rescan, and deletion transitions for NVMe remote
ports in the same worker context used for SCSI rports.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> +static void ibmvfc_tgt_add_nvme_rport(struct ibmvfc_target *tgt)
> +{
> +	struct ibmvfc_host *vhost =3D tgt->vhost;
[ ... ]
> +	if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
> +		tgt_dbg(tgt, "Deleting NVMe rport\n");
> +		list_del(&tgt->queue);
> +		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		ibmvfc_nvme_unregister_remoteport(tgt);

[Severity: Critical]
Does ibmvfc_nvme_unregister_remoteport() contain a null pointer dereference?

When unregistering the remote port, the completion callback appears to
explicitly set the tgt->nvme_remote_port pointer to NULL:

drivers/scsi/ibmvscsi/ibmvfc-nvme.c:ibmvfc_nvme_unregister_remoteport() {
    ...
    rc =3D nvme_fc_unregister_remoteport(tgt->nvme_remote_port);
    if (!rc) {
        wait_for_completion(&tgt->nvme_delete_done);
        tgt->nvme_remote_port->private =3D NULL;
    }
}

Will this attempt to dereference tgt->nvme_remote_port right after it was
set to NULL by ibmvfc_nvme_remoteport_delete before the completion signaled?
The same pattern seems to exist in ibmvfc_nvme_unregister() for the local
port.

> +		timer_delete_sync(&tgt->timer);
> +		kref_put(&tgt->kref, ibmvfc_release_tgt);

[Severity: High]
This is a pre-existing issue, but does ibmvfc_release_tgt() incorrectly free
mempool-allocated targets?

The targets are allocated via mempool_alloc(vhost->tgt_pool, GFP_NOIO) in
ibmvfc_alloc_targets(), but the kref release function calls kfree(tgt):

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
    struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, =
kref);
    kfree(tgt);
}

Does this bypass the mempool reserves and eventually cause mempool_alloc()
to hang under memory pressure?

> +		return;
> +	} else if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_AND_LOGOUT=
_RPORT) {
[ ... ]
> +	} else if (rport && tgt->action =3D=3D IBMVFC_TGT_ACTION_DELETED_RPORT)=
 {
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +		return;
> +	}

[Severity: Critical]
This is a pre-existing issue, but can this early return leak the newly
registered remote port?

If tgt->action is transitioned to IBMVFC_TGT_ACTION_DELETED_RPORT by the
state machine while the worker thread drops the lock to register the port,
we return early here without unregistering the newly created port.

For NVMe targets, tgt->nvme_remote_port->private points to the tgt
structure. If the tgt structure is subsequently freed via kref_put(), could
this cause a use-after-free in the NVMe midlayer when it uses the dangling
private data pointer?

[ ... ]
> @@ -6630,6 +6675,7 @@ static void ibmvfc_rport_add_thread(struct work_str=
uct *work)
[ ... ]
> -	} while(did_work);
> +
> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
> +			if (tgt->add_rport) {

[Severity: High]
Are NVMe targets marked for deletion completely ignored by the main state
machine?

The normal deletion path clears tgt->add_rport, which causes this worker
thread to ignore them. However, looking at the main state machine in
ibmvfc_do_work(), the deletion loop exists only for SCSI targets:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_do_work() {
    ...
    list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
        if (tgt->action =3D=3D IBMVFC_TGT_ACTION_DEL_RPORT) {
            ...
}

Since the equivalent loop is omitted for nvme_scrqs.targets, do targets
marked for deletion remain unlinked and permanently leaked?

[Severity: High]
On a related note, does the driver fail to unregister the NVMe local port on
module unload?

The teardown path in ibmvfc_remove() removes the SCSI host via
scsi_remove_host() but does not appear to invoke the NVMe equivalent logic.
There is an ibmvfc_nvme_unregister() function provided in the code, but it
seems to be completely dead code that is never called.

Could this lead to a permanent resource leak and potential use-after-free
in the NVMe midlayer if it interacts with the removed host?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D21
