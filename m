Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBBB35201F
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 06:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106522; cv=none; b=r96wROfsyyK8X0A/uwmUMwdkkZ7Ys++lkp3shp9CyVMQpdoBMC0gLG2yae6nOX1isptjrA1N7bXFt2qObGwd5VOAhaycwcKx73xyKU0jZIZn1LJlVfSJLu9+OuH2JtImbte3NxbP/HFXRDbaXkOFAISIKPKtsa+ipxezTq+Dt/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106522; c=relaxed/simple;
	bh=R6UWO8AAkNwQ7Y110vVeF6WBdPet2ZZSzIr5J+ls7R4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GpUQuEEGfGL39u2mvEGzGodBJdqy7UZBm422U0BWipaNSsj18bsnFWNxrH8fNfTZ1BTmMI7oJPFuTgBvPtha2KJiv3hj+a5D4BF7nEfJo5c6M4BaXmgacvP2FEAOy9tZeIBsq+fRtIOLwbihvBZzYi4r9oWnUauMB/djuwwLIhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLxpN/3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLxpN/3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC011F000FF;
	Fri, 11 Sep 2026 06:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106520;
	bh=UUS602HkPBhA3gposBMPfQ84FKw5K3SbpVqVs7RPZLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SLxpN/3X2hM4ZpfOEJ8mdhd7ljAZx/N2Dquhs1j6K3wu5CIi/KPnmfU5LGD7kZj+2
	 20cvqbGV0Q7+f3KgbOd4MCMyR/j5c4G41M7Tx8iypkJ8V+kiz7psl7wxEZXHGPYPC2
	 4zCgiaiFPh3rIvswLuUdCqi7/sEBfeH8o3PFInnT7HuhUhnCb0EItE0H8EPXlaiUE/
	 8uocPrCxGh3/5vWnpid9ujmmmZy+7ymRXl8GcH9fv5nxa13WIp6yKmoj/7h8HZtuSU
	 o1ip4QKO12nH+qZqIfBMSxPNR/mOXbedHVGNw7N2vELa9F+tM9NGW3CjpNvMqrbNzL
	 BIG2JOsQkTm6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 3/9] scsi: ibmvfc: add FPIN extended flag and async
 sub-CRQ queue handle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911054832.1311668-4-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-4-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 06:01:59 +0000
Message-Id: <20260911060200.5CC011F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Reference count leaks for `Scsi_Host` and `fc_rport` device on t=
he KUnit test success path.

Pre-existing issues:
- [High] Missing synchronous cancellation of event timers (`evt->timer`) du=
ring adapter teardown.
--

commit 85b1681af8405a42906206c7fc6fe27458b7faee
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle

This patch adds the IBMVFC_ASYNC_IS_FPIN_EXT flag bit to distinguish
extended FPIN events, and introduces a dedicated queue handle for
asynchronous sub-CRQs. The associated series also implements basic Fabric
Performance Impact Notifications (FPIN) support, offloads event handling
to a new workqueue, and provides KUnit test infrastructure.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..67bd3922a49f9
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -0,0 +1,148 @@
[ ... ]
> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
[ ... ]
> +	vhost =3D ibmvfc_get_first_vhost();
> +	if (!vhost)
> +		kunit_skip(test, "No ibmvfc devices available");
> +
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +	if (vhost->scsi_scrqs.num_targets < 1) {
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		scsi_host_put(vhost->host);
> +		kunit_skip(test, "No targets");
> +	}
> +	tgt =3D list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_targ=
et, queue);
> +	if (!tgt->rport) {
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		scsi_host_put(vhost->host);
> +		kunit_skip(test, "No rport");
> +	}
> +	rport =3D tgt->rport;
> +	get_device(&rport->dev);
> +	kref_get(&tgt->kref);
> +	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
[ ... ]
> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}

[Severity: Medium]
Does this success path leak the Scsi_Host and fc_rport device reference
counts?

The underlying devices vhost->host and rport->dev were acquired earlier in =
this
function with ibmvfc_get_first_vhost() and get_device().

However, the required cleanup calls scsi_host_put() and put_device() appear
to be entirely omitted before returning.


While reviewing the adapter teardown sequence, I noticed a pre-existing iss=
ue
in the event timer cleanup:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_fail_request() {
    ...
    timer_delete(&evt->timer);
}

[Severity: High]
This isn't a bug introduced by this patch, but does this asynchronous timer
deletion leave a race window where the timer callback could still run and
cause a use-after-free?

During the adapter teardown sequence:

ibmvfc_remove()
  -> ibmvfc_purge_requests()
    -> ibmvfc_fail_request()

The event timer is deleted asynchronously without waiting for any concurren=
tly
executing callbacks.

The driver then proceeds to free the event pool and release the host struct=
ure.

If the timer callback executes concurrently:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_timeout() {
    struct ibmvfc_host *vhost =3D evt->vhost;
    dev_err(vhost->dev, "Command timed out (%p). Resetting connection\n", e=
vt);
    ...
}

It accesses the event and host structures which may have already been freed=
 by
the teardown thread.

Could this lead to memory corruption or a kernel crash upon adapter removal,
hotplug, or connection reset?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911054832.1311=
668-1-tyreld@linux.ibm.com?part=3D3
