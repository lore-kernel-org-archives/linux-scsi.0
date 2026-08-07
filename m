Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1900044C65C
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786085006; cv=none; b=V7P6g1u/6tRJmhjSJXPf3NjOVZK9hZktg+M205VweWRakrS/f46hN2zmebDBFcRIwZkOtz92ucDywvPobU2yDbC+dyATdZFIqbuuiO9qLTM0/JJZVfefEgxwDgTAq28Rgv/fDYd5Gfa38tvFnBtHDgX6SWN1GBOAtKW0UuSJxI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786085006; c=relaxed/simple;
	bh=WTzdjMrrNG5p8EdJAkF1UDWt43Lzi8taNvi16rI9cj0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fijtJCh+i3Olo16FJJgVsQrFIq0CZjZBerdAMIvtB9yiw6zkZrqNZfagcJAKcDNxoOBljDNWKt64agIHR90aE2t9atb0L6ha1qByREunpaeZ0XAc/ApwSKhNm4k35wUZ84qSpfWY0ON/xgZmavh6qhapNzFR524Sq0DF+rxDm7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJ70hSyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJ70hSyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264111F000E9;
	Fri,  7 Aug 2026 06:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786085003;
	bh=H+Lxyb8bpSvNqS9wkzIbUtLhvreFmAA2yXa4wleTpv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BJ70hSyPlll58IF2ph+ID/MMpNW49d4Vfohu+cYSnqxrgc4b6ugnI8ipx0SjGPnDf
	 i8hnRX9Lj/S3IRAX2/UWotryEwH7RcjeBkCaIjF/ElrjjTRL8SpKa41b+ZAW7KFgGP
	 nDSQeZ62KhyhQJPpzkP3l6V6kxzW9g/4LpTFRuCS2WrGu6CRJsKd2+gd1sXEJFzh2/
	 Dxa/s1y6yPzwi2SVlZlXl0AikqmRQi8RFnz5cu1XWAbc7TK5MaMRiv2SraAqmIIF7W
	 r64ItV9cNXTiffb1jxpDctbTBsu1YQpL1QQBiQpLOCJTze+P0tVJQJb7l/IKs0Vb8f
	 oe7p2hff6CQpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] usb: gadget: f_tcm: keep port count until LUN teardown
 completes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuangpeng Bai" <shuangpeng.kernel@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260807060733.3186624-1-shuangpeng.kernel@gmail.com>
References: <20260807060733.3186624-1-shuangpeng.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 06:43:22 +0000
Message-Id: <20260807064323.264111F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch moves the `tpg_port_count` decrement to `fabric_post_unl=
ink` for `f_tcm` to fix a nexus removal UAF race, but fails to apply this f=
ix to sister drivers `vhost_scsi` and `xen-scsiback`.
- [High] Lockless access to `tpg->tpg_nexus` in the I/O path leads to Use-A=
fter-Free and NULL pointer dereferences when racing with `tcm_usbg_drop_nex=
us`.
- [High] The patch's fix for 'free active' and `sess_cmd_map` UAF is incomp=
lete because it ignores pending work items when `tpg_port_count =3D=3D 0`.
- [High] TOCTOU race between `target_fabric_port_link` and `tcm_usbg_drop_n=
exus` allows the nexus to be destroyed while a LUN is actively linked.
--

--- Patch [1]: [PATCH] usb: gadget: f_tcm: keep port count until LUN teardo=
wn completes ---
commit 052b5e8542d90321dbacef963d1804574c8248ec
Author: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

usb: gadget: f_tcm: keep port count until LUN teardown completes

This patch introduces an optional fabric_post_unlink callback to the
target core. It uses this callback in f_tcm to defer decrementing the
port count until after core_dev_del_lun has drained active LUN
references, fixing a use-after-free race during nexus removal.

Cc: stable@vger.kernel.org

> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/targe=
t/target_core_fabric_configfs.c
> index 166dbf4c40616..ab8f81650710e 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -690,6 +690,14 @@ static void target_fabric_port_unlink(
>  	}
> =20
>  	core_dev_del_lun(se_tpg, lun);
> +
> +	if (tf->tf_ops->fabric_post_unlink) {
> +		/*
> +		 * Allow fabrics to release state that must remain valid until
> +		 * core_dev_del_lun() has drained all active LUN references.
> +		 */
> +		tf->tf_ops->fabric_post_unlink(se_tpg, lun);
> +	}
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does the separation of LUN
attachment and port count increment create a time-of-check to time-of-use
race?

In target_fabric_port_link():

drivers/target/target_core_fabric_configfs.c:target_fabric_port_link() {
    ...
    ret =3D core_dev_add_lun(se_tpg, dev, lun);
    ...
    if (tf->tf_ops->fabric_post_link)
        tf->tf_ops->fabric_post_link(se_tpg, lun);
}

Since tpg_port_count is incremented inside fabric_post_link() for f_tcm, is
there a window after core_dev_add_lun() attaches the LUN where
tcm_usbg_drop_nexus() could observe tpg_port_count =3D=3D 0?

If it executes concurrently during this window, would it bypass the safety
check and remove the session while a LUN has just been fully linked?

> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/fun=
ction/f_tcm.c
> index b3fa5a17fd2db..98414e7611c08 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -2024,7 +2024,7 @@ static const struct target_core_fabric_ops usbg_ops=
 =3D {
>  	.fabric_enable_tpg		=3D usbg_enable_tpg,
>  	.fabric_drop_tpg		=3D usbg_drop_tpg,
>  	.fabric_post_link		=3D usbg_port_link,
> -	.fabric_pre_unlink		=3D usbg_port_unlink,
> +	.fabric_post_unlink		=3D usbg_port_unlink,
>  	.fabric_init_nodeacl		=3D usbg_init_nodeacl,

[Severity: High]
This isn't a bug introduced by this patch, but does moving this decrement to
fabric_post_unlink for f_tcm leave vhost_scsi and xen-scsiback vulnerable to
the same race?

Looking at vhost_scsi_ops in drivers/vhost/scsi.c:

    .fabric_pre_unlink =3D vhost_scsi_port_unlink,

And scsiback_ops in drivers/xen/xen-scsiback.c:

    .fabric_pre_unlink =3D scsiback_port_unlink,

If a nexus removal is triggered concurrently with the removal of the last
LUN on either of these fabrics, won't the early port count decrement in
fabric_pre_unlink allow them to bypass the EBUSY check? It appears they cou=
ld
proceed to call target_remove_session() before core_dev_del_lun() has finis=
hed
waiting for active commands to drain, potentially causing a similar
use-after-free.

[Severity: High]
This is a pre-existing issue, but can lockless reads of tpg->tpg_nexus
in the I/O path race with nexus removal?

In tcm_usbg_drop_nexus(), we free the nexus and clear the pointer:

drivers/usb/gadget/function/f_tcm.c:tcm_usbg_drop_nexus() {
    ...
    tpg->tpg_nexus =3D NULL;
    kfree(tv_nexus);
    ...
}

Meanwhile, the USB completion callbacks like usbg_submit_command() and
usbg_submit_tmr() read it without holding tpg_mutex or the RCU read lock:

drivers/usb/gadget/function/f_tcm.c:usbg_submit_command() {
    ...
    tv_nexus =3D tpg->tpg_nexus;
    ...
}

Could this result in a NULL pointer dereference or use-after-free if the
nexus is dropped via configfs while a command is actively being processed?

[Severity: High]
This is a pre-existing issue, but does this fix cover the case where
tpg_port_count is 0 but work is still pending?

If no explicit LUNs are configured, tpg_port_count is 0. If a command is
queued to usbg_cmd_work concurrently with the admin dropping the nexus:

drivers/usb/gadget/function/f_tcm.c:tcm_usbg_drop_nexus() {
    ...
    if (tpg->tpg_port_count !=3D 0) {
        ...
    }
    ...
    target_remove_session(se_sess);
}

Could this flow proceed to remove the session and free sess_cmd_map without
waiting for usbg_cmd_work to complete?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807060733.3186=
624-1-shuangpeng.kernel@gmail.com?part=3D1
