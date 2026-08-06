Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A40E490BE3
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786046432; cv=none; b=kY9qkfTgKVnnnWCjXHSmoCQvD/LO8ZFFItDP8DaTuhTJjRhxv74F11gxPzlf26PNLezBQP/L94y1dustraIbW9ZH3Yrg8ywRyLkR2ohtmcVcFbpEjpRAerO+gJsc4rEpPQTHXEXnDcfqjefUK+I67tzFw44QDGM0Fj+3Z52PR/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786046432; c=relaxed/simple;
	bh=h01RCljVwtcA3xEhORvD7ZW3+xyKdP46qRIua/iRAzY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ea4tc5fIuWknCKLnes6VJFGNFT22xq5XrEWsziaI/oQ/KaTkP7I8lJpy3kULyFr7fSw+woPUsmWWa5zOg2G4Q9vJA7Ugz58YWObe9KdWsC94y6M9TOr+3+j68I8dZGznnjHkYyPpIIJ1VoJLTNPRYB2JlDp1IC17R7aZilj6GZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4y6LK0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4y6LK0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6751F000E9;
	Thu,  6 Aug 2026 20:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786046431;
	bh=3b1oI94fIN47e7OiqHx3Yioi6nnc44OKgjKI8hiQNOU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e4y6LK0m6I5+AS+06XI5O/BvB08aTNoF2IGFoR1VToA+rp3bGipKxSTJTmht82/tT
	 ZxIBT6PLAwDJ8IcctQOoFKYBxD64xkdohUegGQQqSYPLx74cC05UEXE4fGykUXkffP
	 PqaqePMZGjoXX6SZXhWYxaj88CT3Anp8vMr6A4LrELoedkg6VVzBgF4u+NnhADCoEU
	 J6TUJ7Q4qw2bcFVliBtOlfYLGG6sn0plnWfct4PqcoVFiep84zaey9VAuPcndrh7sq
	 j5t7hlkPKJBaVoqcvhT99Zq6Z5FLiiwZw7X8Tw5JOZbryZfQ5VRGAy2pzldz8O2sf9
	 fVXp6Y4EtX7rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] scsi: elx: efct: free the RQ buffers already
 allocated when one fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806192345.328621-5-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806192345.328621-5-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 20:00:30 +0000
Message-Id: <20260806200030.EE6751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing resource teardown in initialization error paths leads to m=
assive memory and resource leaks.
- [High] Unconditional call to `dma_free_coherent` on an unallocated memory=
 region causes undefined behavior/kernel panic.
- [High] Unprotected concurrent access to the global `efct_devices` list.
- [High] Use-after-free of `efct` object when PCI device is removed while L=
IO configfs retains a reference.
- [High] Missing `timer_delete_sync` and dangerous re-initialization of `st=
ats_timer` leads to concurrent UAF.
--

--- Patch [4]: [PATCH 4/5] scsi: elx: efct: free the RQ buffers already all=
ocated when one fails ---
commit cebc7192c16ac8492a77188ae439ad0352527068
Author: Ali Ahmet Memis <ali@iusegentoo.com>
Date:   Thu Aug 6 19:23:44 2026 +0000

scsi: elx: efct: free the RQ buffers already allocated when one fails

efct_hw_rx_buffer_alloc() allocates an array of descriptors and then a
coherent DMA buffer for each entry. When one of those allocations fails it
frees the array and returns NULL, leaving every buffer allocated before it
mapped. Use efct_hw_rx_buffer_free() for the entries that were filled in.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index db68516e80750..d645ce256b8aa 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -1170,6 +1170,10 @@ efct_get_wwpn(struct efct_hw *hw)
>  	return get_unaligned_be64(p);
>  }
> =20
> +static void
> +efct_hw_rx_buffer_free(struct efct_hw *hw, struct efc_hw_rq_buffer *rq_b=
uf,
> +		       u32 count);
> +
>  static struct efc_hw_rq_buffer *
>  efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
>  			u32 size)
> @@ -1196,7 +1200,7 @@ efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqi=
ndex, u32 count,
>  						   GFP_KERNEL);
>  		if (!prq->dma.virt) {
>  			efc_log_err(hw->os, "DMA allocation failed\n");
> -			kfree(rq_buf);
> +			efct_hw_rx_buffer_free(hw, rq_buf, i);
>  			return NULL;
>  		}
>  	}

[Severity: High]
This is a pre-existing issue, but missing resource teardown in initializati=
on
error paths leads to massive memory and resource leaks.

In efct_hw_rx_allocate(), if efct_hw_rx_buffer_alloc() succeeds for
rq->hdr_buf but fails for rq->payload_buf, it breaks the loop and returns
-EIO without freeing the just-allocated hdr_buf or any previous queues:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_rx_allocate() {
    ...
    if (!rq->payload_buf) {
        efc_log_err(efct, "rx_buffer_alloc fb_buf failed\n");
        rc =3D -EIO;
        break;
    }
    ...
}

This error propagates up through efct_hw_init() and efct_xport_initialize(),
both of which return the error and explicitly bypass efct_hw_teardown():

drivers/scsi/elx/efct/efct_xport.c:efct_xport_initialize() {
    ...
    rc =3D efct_hw_init(&efct->hw);
    if (rc) {
        efc_log_err(efct, "efct_hw_init failure\n");
        goto out;
    }
    ...
}

Since this patch attempts to fix exactly this type of leak in the callee but
leaves the caller completely unprotected, does this need a similar fix to
prevent identical leaked resources?

[Severity: High]
This is a pre-existing issue, but does this unconditional call to
dma_free_coherent() on an unallocated memory region cause undefined behavior
or a kernel panic?

efct_hw_teardown() unconditionally calls dma_free_coherent() on hw->rnode_m=
em:

drivers/scsi/elx/efct/efct_hw.c:efct_hw_teardown() {
    ...
    dma_free_coherent(&efct->pci->dev,
              hw->rnode_mem.size, hw->rnode_mem.virt,
              hw->rnode_mem.phys);
    ...
}

Since rnode_mem is never allocated anywhere in the driver, it remains
0-initialized, meaning virt is NULL and size is 0. Calling dma_free_coheren=
t()
with a NULL virtual address is an API violation that can crash or WARN on
architectures that do not check for it.

[Severity: High]
This is a pre-existing issue, but is there unprotected concurrent access to
the global efct_devices list?

The driver adds and removes devices from the global efct_devices list in
efct_device_alloc() without using any locks:

drivers/scsi/elx/efct/efct_driver.c:efct_device_alloc() {
    ...
    list_add_tail(&efct->list_entry, &efct_devices);
    ...
}

Concurrently, efct_find_wwpn() (triggered by LIO configfs operations)
iterates over this list using list_for_each_entry() without any locking:

drivers/scsi/elx/efct/efct_lio.c:efct_find_wwpn() {
    ...
    list_for_each_entry(efct, &efct_devices, list_entry) {
    ...
}

Can this lead to linked list corruption, infinite loops, or use-after-free
if a privileged administrator configures LIO targets concurrently with hotp=
lug
or sysfs unbind events?

[Severity: High]
This is a pre-existing issue, but is there a use-after-free of the efct obj=
ect
when the PCI device is removed while LIO configfs retains a reference?

efct_lio_make_nport() assigns a raw efct pointer to the LIO target without
taking a reference count on the device:

drivers/scsi/elx/efct/efct_lio.c:efct_lio_make_nport() {
    ...
    lio_nport->efct =3D efct;
    ...
}

If the PCI device is unbound or removed, efct_pci_remove() completely destr=
oys
the device and frees the efct structure:

drivers/scsi/elx/efct/efct_driver.c:efct_pci_remove() {
    ...
    efct_device_free(efct);
    ...
}

Could subsequent LIO teardown or target I/O dereference the freed efct memo=
ry
if configurable LIO targets survive the unloading of the underlying hardware
device?

[Severity: High]
This is a pre-existing issue, but does the missing timer_delete_sync() and
dangerous re-initialization of stats_timer lead to a concurrent
use-after-free?

During device detachment, efct_xport_detach() uses the asynchronous
timer_delete():

drivers/scsi/elx/efct/efct_xport.c:efct_xport_detach() {
    ...
    if (timer_pending(&xport->stats_timer))
        timer_delete(&xport->stats_timer);
    ...
}

If the timer callback efct_xport_stats_timer_cb() is running concurrently, =
the
driver will free the xport memory immediately after. The callback then
executes efct_xport_config_stats_timer(), which calls timer_setup() and
mod_timer() on the just-freed xport->stats_timer:

drivers/scsi/elx/efct/efct_xport.c:efct_xport_config_stats_timer() {
    ...
    timer_setup(&xport->stats_timer, &efct_xport_stats_timer_cb, 0);
    mod_timer(&xport->stats_timer, jiffies + msecs_to_jiffies(timeout));
    ...
}

Can this cause timer list corruption and a kernel panic via use-after-free =
if
a driver unload races with the periodic 3-second stats timer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D4
