Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B90B391846
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 09:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033930; cv=none; b=svrzJA2El0AARqcljlxKjl5SKCjXdtiPE8rlrKO5Y61vF/f9DJ9VQtiixUgURQXS7aV07QgCPwpShjGUXmnuWNpGsbbkaQHio4aq/Dhla7Qcb4JuPxeuqRLvLUrL6024q7PCPyq4ZdJXprUMYaNlNeyFpcieVZfu7/Xn4ZAS7oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033930; c=relaxed/simple;
	bh=JFsAB37wWXHYWL6PNWhtTk1WSDSxW/NFZ41/vdgySrg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=thDNC4Dn6iWLchOY5C5DQgfL6OgYeDf4m+rOznAPp5QWFf93tB2xtrb5dSsiouxLa/YgEuSZgiOEi/tD1DlhCsnJebsMRu5XXfPQO0DYJ+m1Vhtp7P3HkBCCuIf3Sor7+HFXxcOE9AgoDZJMaxkP/JxhnG1+0y/Ss1aDu3irpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Shd6Ggk3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Shd6Ggk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8261F000FF;
	Thu, 10 Sep 2026 09:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789033928;
	bh=oSHEQEf7VJj1l9ty3O0NeD3HwzUk9MAB0JcL6MPJ8/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Shd6Ggk3XTmPACAIgTHjHJjrXIyZMSAtNo464+zfVYEnmbOsJ9hyiUPFgfZOWYyMJ
	 94pweRNAIqnu55bX0BQVwgIvc84DpFuBWLhgi9AmfZMkGXG0x1M/06VR7ca7HO9uei
	 RedoNBMI2Asddl76TV32a4CQkFpGuMgPiGhBjtjwcW6EYugaP0vADCYZVlT1s0o4vZ
	 I1w5tD+ZavBcQXJatg9tantoWsLH3ZYPe3NyJwn+FUt3jlIsn17lORERM0boE13VVV
	 H5asOdkKjSlq+LZdVPTlMl1ki7BtkB6M2RAU8O5Q+JuWzqX10ZeevlyzJijsdwubIM
	 +AsCpMgM49new==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qedi: Initialize callback state before
 registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260910092405.1300129-1-runyu.xiao@seu.edu.cn>
References: <20260910092405.1300129-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 09:52:07 +0000
Message-Id: <20260910095208.6D8261F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Network packet reception in `qedi_ll2_rx` lacks bounds checks,=
 allowing malformed packets to cause out-of-bounds reads or NULL pointer de=
references.
- [High] Race condition and missing error checks for `kthread_run()` return=
 value lead to invalid pointer dereferences during LL2 Rx processing or mod=
ule teardown.
- [High] The patch leaves `recovery_work` and `board_disable_work` uninitia=
lized when registering `qedi_cb_ops` callbacks, exposing uninitialized work=
 structures to asynchronous hardware events.
- [High] User-configured custom MTU settings are silently overwritten to de=
faults during hardware recovery.
- [High] `iscsi_host_add` exposes the device to userspace before crucial co=
nnection structures (`ep_tbl`) are allocated, creating a race condition.
- [High] The background LL2 receiver kthread and hardware subsystem are not=
 stopped on the `__qedi_probe` error path, leading to Use-After-Free.
- [High] The error path for `iscsi_host_add` failure calls `iscsi_host_remo=
ve`, which will crash when attempting to remove an un-added host.
--

commit 7badf30e1ff5d4629509a7cbca53b6e22f3d67df
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: qedi: Initialize callback state before registration

This patch fixes a race condition where qedi_get_protocol_tlv_data() could
be called asynchronously by QED before the stats_lock and ll2_mtu were
initialized. It moves the callback registration to after these initializati=
ons
on the normal probe path.

> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 227ff7bd1bdc9..f394fcbb97e7e 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2652,8 +2652,6 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
>  	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
>  	qedi_ops->common->set_name(qedi->cdev, host_buf);
> =20
> -	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
> -
>  	memset(&params, 0, sizeof(params));
>  	params.mtu =3D DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
>  	qedi->ll2_mtu =3D DEF_PATH_MTU;

[Severity: High]
This is a pre-existing issue, but are user-configured custom MTU settings
overwritten during hardware recovery here?

During a hardware recovery event, __qedi_probe() is invoked with
mode =3D=3D QEDI_MODE_RECOVERY. This unconditional assignment to DEF_PATH_M=
TU
discards any custom MTU size (such as a 9000-byte jumbo MTU) that the user
may have configured.

> @@ -2670,6 +2668,7 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
>  		spin_lock_init(&qedi->task_idx_lock);
>  		mutex_init(&qedi->stats_lock);
>  	}
> +	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);

[Severity: High]
This isn't a bug introduced by this patch, but could registering the callba=
cks
here expose uninitialized work structures?

The qedi_cb_ops expose callback functions like
qedi_schedule_recovery_handler() to the QED core. This handler attempts to
schedule qedi->recovery_work, but INIT_DELAYED_WORK(&qedi->recovery_work, .=
..)
is not called until much later in the probe sequence.

If an asynchronous hardware event occurs in this window, it looks like
schedule_delayed_work() could be invoked on zero-filled memory.

>  	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
>  	qedi_ops->ll2->start(qedi->cdev, &params);

[Severity: High]
This is a pre-existing issue, but does starting the hardware packet recepti=
on
here introduce a race condition?

If a packet arrives immediately, qedi_ll2_rx() calls
wake_up_process(qedi->ll2_recv_thread) while the thread pointer is still NU=
LL.

Additionally, is it safe to ignore the return value of kthread_run() when it
creates qedi->ll2_recv_thread shortly after this?

If kthread_run() fails, it returns an ERR_PTR which is neither checked nor
handled. This could cause subsequent packets or kthread_stop() during teard=
own
to dereference the ERR_PTR.


[Severity: High]
This is a pre-existing issue, but does exposing the device to userspace bef=
ore
crucial connection structures are allocated create a race condition?

In drivers/scsi/qedi/qedi_main.c:__qedi_probe():

    if (iscsi_host_add(qedi->shost, &pdev->dev)) {
        ...
    }

    rc =3D qedi_alloc_uio_rings(qedi);
    ...
    rc =3D qedi_cm_alloc_mem(qedi);

iscsi_host_add() registers the host with sysfs, emitting a uevent. If
userspace responds by issuing a netlink command to create an endpoint,
qedi_ep_connect() assigns the endpoint to qedi->ep_tbl[iscsi_cid].

However, qedi_cm_alloc_mem() allocates qedi->ep_tbl after iscsi_host_add(),
so qedi->ep_tbl would be NULL during this race.


[Severity: High]
This is a pre-existing issue, but is it possible the error path in
__qedi_probe() fails to clean up the LL2 subsystem and kthread?

If an initialization step fails after the hardware packet reception and
receiver kthread are started:

drivers/scsi/qedi/qedi_main.c:__qedi_probe():

    ...
stop_iscsi_func:
    qedi_ops->stop(qedi->cdev);
stop_slowpath:
    qedi_ops->common->slowpath_stop(qedi->cdev);
    ...

The error handler frees the qedi structure but seems to completely omit
stopping the hardware LL2 interface or killing the kthread, which could lead
to a use-after-free when they access the freed qedi structure.


[Severity: High]
This is a pre-existing issue, but would the error path for iscsi_host_add()
failure cause a crash?

drivers/scsi/qedi/qedi_main.c:__qedi_probe():

    if (iscsi_host_add(qedi->shost, &pdev->dev)) {
        QEDI_ERR(&qedi->dbg_ctx,
                 "Could not add iscsi host\n");
        rc =3D -ENOMEM;
        goto remove_host;
    }

If iscsi_host_add() fails, the code jumps to remove_host and unconditionally
executes iscsi_host_remove(). Since the host was never successfully added to
the driver core, won't this attempt to unregister an uninitialized device?


[Severity: Critical]
This is a pre-existing issue, but is there a missing bounds check during
network packet reception in qedi_ll2_rx()?

drivers/scsi/qedi/qedi_main.c:qedi_ll2_rx():

    if (eh->h_proto =3D=3D htons(ETH_P_8021Q)) {
        memmove((u8 *)eh + VLAN_HLEN, eh, ETH_ALEN * 2);
        eh =3D (struct ethhdr *)skb_pull(skb, VLAN_HLEN);
        skb_reset_mac_header(skb);
    }

    /* Filter out non FIP/FCoE frames here to free them faster */
    if (eh->h_proto !=3D htons(ETH_P_ARP) && ...

The code reads eh->h_proto without verifying skb->len >=3D ETH_HLEN. If the
protocol is 802.1Q (VLAN), it invokes skb_pull(skb, VLAN_HLEN).

If a malformed packet is smaller than VLAN_HLEN, skb_pull() returns NULL,
which is then unconditionally dereferenced in the subsequent check.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910092405.1300=
129-1-runyu.xiao@seu.edu.cn?part=3D1
