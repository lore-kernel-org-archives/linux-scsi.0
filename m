Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B443812C2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400809; cv=none; b=EnIZO0k76Cd7XDE5zSI+DmEbNO7FAUU1k4Q9O8aR38X9nWsrVZqy9Q+cBuaqbdRtKZSeLgu2aFkUxMBPE6SrhrRiXoxRYEARRS/c7cmZvUK9MdOjQZ1rspaxN1B+nGROGXNsxWjgHhOvbXIZTUHME6XDF5SamMnG+JnccrFXtLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400809; c=relaxed/simple;
	bh=EOb3MXzuVe1ekLX0TPfCFbCC0o83uvQKb6O+ejisBuQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GIQuE4Tk75LEKoNNJvLlb7Aa+3H7zgCzJdv2SfWuwmiQVsSQAq1E11j+YBWN8Qiwa/fE8+VJUrio3x8ovYNTdqITzT8H3OmlpJccrEuQ9OUo5diIFoVuEpD49iL+rwPjE9pwLtl/HA4PMGDBh2oqrNadSmUS0yVpxaSxe5od0vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fePRiapS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fePRiapS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B081F000E9;
	Thu, 30 Jul 2026 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785400805;
	bh=iknwwgFvxRtdqCt06okT5+63sSGE7kbzTg/xr7ivaW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fePRiapSmsiY9DmmIoYk5TzOe8LpOj3GSS5Rwuy9Nzx9KmPM/pYAURWtjtgnWeyoA
	 hIDWlsA/it1ol+NI93fl1B2Ku1NblQaYz/w+jhsD/lSR87qGPfFOmHJJ94FS66khbF
	 WUCYgVypSXQK9nmY786hst7Rtk4xgwi7vVpR7XP5uTnYyoXAKVoCn3Wj11otI55/7B
	 wTtXO63yLGVlEEfoqcyLFF54w1oVNfLLpb375EO+PNOPpDt6ISjpI1e/vXKzLwFGUm
	 vH3ApH84vXjG/xLs5RiC7YjyK5a5NOUwrrLlnvbp5s3RZLRmVOIzmW5qgHU7+qLt5H
	 tbMWPoTNtlxww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: Fix NULL deref when clearing alua_lu_gp
 twice
Reply-To: sashiko-reviews@lists.linux.dev
To: kensanya@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260730082458.663015-1-kensanya@163.com>
References: <20260730082458.663015-1-kensanya@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 08:40:05 +0000
Message-Id: <20260730084005.A2B081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] An off-by-one error in the input length validation allows a stack =
buffer overread and out-of-bounds write if `count` is exactly equal to the =
buffer size.
- [High] Dropping a spinlock inside a `list_for_each_entry_safe` loop in AL=
UA release functions exposes the loop to list poisoning and Use-After-Free =
crashes.
- [High] TOCTOU race in ALUA group ID assignment corrupts lists, and the er=
ror path frees an active configfs item, causing a double-free.
--

--- Patch [1]: [PATCH] scsi: target: Fix NULL deref when clearing alua_lu_g=
p twice ---
commit 1601e8bb13acc929ed9af1ae24358c7f9e46e6aa
Author: TanZheng <tanzheng@kylinos.cn>

scsi: target: Fix NULL deref when clearing alua_lu_gp twice

This patch fixes a kernel panic caused by a NULL pointer dereference
when a device's ALUA LU group association is cleared multiple times. It
adds an early return to prevent passing a NULL lu_gp_new to
__core_alua_attach_lu_gp_mem.

Link: https://sashiko.dev/#/patchset/20260730031917.72750-1-kensanya@163.co=
m?part=3D1

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index 860e840461778..a9c3ab54022e1 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2058,6 +2058,12 @@ static ssize_t target_core_store_alua_lu_gp(
>  		__core_alua_drop_lu_gp_mem(lu_gp_mem, lu_gp);
>  		move =3D 1;
>  	}
> +
> +	if (!lu_gp_new) {
> +		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
> +		return count;
> +	}
> +
>  	/*
>  	 * Associate lu_gp_mem with lu_gp_new.
>  	 */

While reviewing this change, I noticed a few pre-existing issues in this
function and related ALUA code:

drivers/target/target_core_configfs.c:target_core_store_alua_lu_gp() {
...
    if (count > LU_GROUP_NAME_BUF) {
        pr_err("ALUA LU Group Alias too large!\n");
        return -EINVAL;
    }
    memset(buf, 0, LU_GROUP_NAME_BUF);
    memcpy(buf, page, count);
...

[Severity: High]
This is a pre-existing issue, but does this off-by-one check allow a
stack buffer overflow?

If count is exactly LU_GROUP_NAME_BUF, memcpy will fill the entire
buffer, leaving no space for a null terminator. Later calls to
strstrip(buf) or strim(buf) would run off the end of the stack buffer.

Could this happen when an administrator writes exactly 256 bytes without
a null terminator? The same pattern appears in
drivers/target/target_core_alua.c:core_alua_store_tg_pt_gp_info() where
TG_PT_GROUP_NAME_BUF is used.

[ ... ]

drivers/target/target_core_alua.c:core_alua_free_lu_gp() {
...
    spin_lock(&lu_gp->lu_gp_lock);
    list_for_each_entry_safe(lu_gp_mem, lu_gp_mem_tmp,
                &lu_gp->lu_gp_mem_list, lu_gp_mem_list) {
...
        spin_unlock(&lu_gp->lu_gp_lock);
...

[Severity: High]
This is a pre-existing issue, but does dropping the spinlock inside
list_for_each_entry_safe expose the loop to list poisoning and a
use-after-free?

Since the _safe variant only protects against the deletion of the
current element, dropping the lock could allow a concurrent thread
handling device teardown to remove and free the next element. When the
lock is reacquired and the loop continues, wouldn't it dereference the
freed next pointer?

The exact same pattern seems to exist in core_alua_free_tg_pt_gp() for
LUN list iteration.

[ ... ]

drivers/target/target_core_alua.c:core_alua_set_lu_gp_id() {
...
    if (lu_gp->lu_gp_valid_id) {
        return -EINVAL;
    }

    spin_lock(&lu_gps_lock);
    if (alua_lu_gps_count =3D=3D 0x0000ffff) {
        spin_unlock(&lu_gps_lock);
        kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
        return -ENOSPC;
    }
...

[Severity: High]
This is a pre-existing issue, but does this create a race condition that
corrupts the list, along with an illegal free?

The lu_gp_valid_id check happens outside the spinlock. Could concurrent
sysfs writes both pass this check, serialize on the lock, and then call
list_add_tail on the same node, corrupting the list?

Additionally, if the global count limit is reached, kmem_cache_free is
called directly on lu_gp. Since lu_gp embeds a configfs item that configfs
still references, does this bypass configfs lifecycle rules and result in
a double-free when the directory is removed?

The same pattern exists in core_alua_set_tg_pt_gp_id().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730082458.6630=
15-1-kensanya@163.com?part=3D1
