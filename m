Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663E5342CBA
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 06:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783925600; cv=none; b=Rv2ap9Ld2844CFREDDljghNeeEerDCxR4YnDFwBjs/DY6WAfxLdkyZwcWKpUwePjGYpuqknM1FWQEUyh8aunusSlAGQbJQVMrq2+tVszuBnhhhlgk8gMQvutWKGSWvUKY7GqWbWX1da9Ld3clKDV5vfAqGTH5xN17sFtu8XfXDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783925600; c=relaxed/simple;
	bh=QDySocU4wJQi+Qzw2gR86fbLWbClmYgAtiy7lIDliIE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZnUkPxykMv05mDeAzIDSaFps48ORcmq+yG3EdmcB04BqKHk+YxQ1uiYj2zMTyFpvjr7v2cOjufrIEqo+wlEHLBVXU+5Xaa5o/7rgTq8s+P1IB6jlb9k+VILe+gsSH946WGW4lhjdeHqxEGHirA62OYyTREht/sydV20g+roMHxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1gLxXMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1gLxXMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEEE1F000E9;
	Mon, 13 Jul 2026 06:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783925599;
	bh=M/7qpbKNp6XrtBmWE/bpXppoP9nqKzj1L5P2sVhYe2s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G1gLxXMhQWmkIi87fmQKUXWXRm/ECGZUHZiA3FLTgLViq4/XC5fTh9UuLuaA3LQBM
	 P1fOSqZT4cwX6Ci9ZnIPHkND17N6ZhS9LFsQCpqIircHcdY7DY0y9dye304OU8weIo
	 RZd1rJdaSP1xjUnVCxE+87nPxs6DkuX1HTUCkeIMr64B5qW7a7id5dSDq+TO/qm2Zr
	 kwljttADfBjFw/eNJMjj0j1IDVCgdZUZisiQgPkad10TajO3IciC7nZbrJt12o0Ho3
	 /+XWGajWNPA4xlFXXRCjmu1mR3hR9n4T4YmmmgVGc2COcDkALNvxk9w72HRavM9vLo
	 TeTlB8VtuG+Qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: scsi_dh_rdac: fix NULL pointer dereference in
 error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aleksey Shishkin" <demonaxsh@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260713063640.3081603-1-demonaxsh@gmail.com>
References: <20260713063640.3081603-1-demonaxsh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 13 Jul 2026 06:53:18 +0000
Message-Id: <20260713065318.CDEEE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] A malicious SCSI device can trigger a stack buffer overflow in=
 `get_lun_info()` by providing an oversized `array_uniq_id_len` in VPD page=
 0xC8.
- [High] In the error handling path of `rdac_bus_attach()`, if an initializ=
ation step such as `check_ownership` or `set_mode_select` fails, the handle=
r data `h` is freed without removing `h->node` from the RCU-protected `h->c=
tlr->dh_list`, causing a Use-After-Free.
- [High] A time-of-check to time-of-use (TOCTOU) race condition between `rd=
ac_bus_detach()` and the `send_mode_select()` workqueue function allows det=
achment to proceed while work is actively executing, resulting in Use-After=
-Free of handler data.
--

--- Patch [1]: [PATCH] scsi: scsi_dh_rdac: fix NULL pointer dereference in =
error handling ---
commit 712793434a46fcd5b5270defe36dc411e0363100
Author: Aleksey Shishkin <aishishkin@cloud.ru>
Subject: scsi: scsi_dh_rdac: fix NULL pointer dereference in error handling

This patch fixes a logic error in error handling where the return code was
incorrectly overwritten to SCSI_DH_OK after a failed get_controller() call,
moving the assignment into the success block.

> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/de=
vice_handler/scsi_dh_rdac.c
> index 88c8e36b221e2..ed02e1737bd79 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -455,9 +455,9 @@ static int initialize_controller(struct scsi_device *=
sdev,
>  		else {
>  			h->sdev =3D sdev;
>  			list_add_rcu(&h->node, &h->ctlr->dh_list);
> +			err =3D SCSI_DH_OK;
>  		}

[Severity: High]
This is a pre-existing issue, but I noticed a potential use-after-free in t=
he
error handling path.

When initialize_controller() succeeds, it adds the node to the RCU list her=
e.
However, if a subsequent initialization step fails in rdac_bus_attach(),
the error path looks like this:

rdac_bus_attach() {
    ...
clean_ctlr:
	spin_lock(&list_lock);
	kref_put(&h->ctlr->kref, release_controller);
	spin_unlock(&list_lock);

failed:
	kfree(h);
}

Is it possible to reach kfree(h) without removing the node from the
controller's dh_list? If the controller remains alive and is shared by
another LUN, could subsequent RCU traversals of the list access this freed
memory?

>  		spin_unlock(&list_lock);
> -		err =3D SCSI_DH_OK;
>  	}
>  	return err;
>  }

[Severity: High]
This is a pre-existing issue, but does rdac_bus_detach() have a race condit=
ion
with the mode select workqueue?

In rdac_bus_detach(), the code locklessly checks ms_queued before flushing:

rdac_bus_detach() {
    ...
    if (h->ctlr && h->ctlr->ms_queued)
        flush_workqueue(kmpath_rdacd);
    ...
}

However, the worker thread send_mode_select() clears this flag early before
completing the potentially blocking SCSI command:

send_mode_select() {
    ...
    ctlr->ms_queued =3D 0;
    ctlr->ms_sdev =3D NULL;
    ...
}

Could rdac_bus_detach() run concurrently during this window, see ms_queued =
as
zero, skip the workqueue flush, and proceed to free the handler data while
the worker is still actively executing?

[Severity: Critical]
This is a pre-existing issue, but is there a potential stack buffer overflow
in get_lun_info()?

The function retrieves device data into inqp and uses array_uniq_id_len
directly for a memory copy:

get_lun_info() {
    ...
    memcpy(array_id, inqp->array_unique_id, inqp->array_uniq_id_len);
    ...
}

The destination buffer is a 16-byte fixed-size stack array declared in
rdac_bus_attach():

rdac_bus_attach() {
    char array_id[UNIQUE_ID_LEN];
    ...
}

Since array_uniq_id_len is provided by the device (potentially up to 255),
could an untrusted or misconfigured device provide an oversized length and
overflow the stack frame?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260713063640.3081=
603-1-demonaxsh@gmail.com?part=3D1
