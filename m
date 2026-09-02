Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DE74ACC82;
	Wed,  2 Sep 2026 17:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369749; cv=none; b=g/e0UIyN371up1j7VxmNAVfxmuisdNtBCgHI4+QLlaxVarVBPPDQK0ok4yi5KGxlBRDH7/NoGYlx01EOS9/tF1JtdJJTSp0osBeDC5pT2y2XZ04mwR/e5Qm0zE5LiaY+RoqBn/YnmbD4qAHGo6pDNnbfnOEFbj0eBomlbjGyfco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369749; c=relaxed/simple;
	bh=oPZtH2fDP6ZOqSeyie/E2TobMTgqczmgQ3uNwn8ZnDA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B93rc2ky5ZyB+NnfWTdy7I1MZt8qxebrz7JTv4xkf3zqJ+TQJ+dCZqr3iOES/Tg2n8ryhZ6yLMCO85A1NkDlVpBLVWBBYslM4LAaIrIhp3HNdsb5NeCsEXb7OkPRuiQIXfbjZD4QohOr5nuSB+bJxV/mXgUc+F7k9qZcFDbKCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4EhbZfk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4EhbZfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7FF1F000E9;
	Wed,  2 Sep 2026 17:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369747;
	bh=6FmuSUViuPOrcu8Mypq9ufUDolOYDQVZKMTEQpEMGA0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N4EhbZfkU8LQDAvebizcZRpTyj1Zowxrs58iV1kvC1yeg4yCp2NHPDBq5YAw4s74K
	 Z627aRMJLDQZ4FKkbxxO0hS2gxSqoL8U4y8KfymL6q4ciFXUEgWpdne89AUbWoLFd/
	 LW9/FR+IQUxgNG/vkrkP/sYaQMOfqfOGLgxOyt2nzJRkQ0ZtTYO/bANTWy9ptybGed
	 B7PKWY/tKDFLEEpfMtjC/Bba1hxSBwTtQcseQSKF6enJ1x80En1osbyFRCCFI9dGq0
	 F2ntXO3tSa4474rxTSZMyNk24yQPhYi1ED0COoM79zKeylyXfxDZP9QEfr4S2ezuqm
	 bP9rt7Ouq36Tg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/9] driver core: warn should device_move try to move a
 need_parent_lock device
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260902170734.95504-4-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-4-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:22:26 +0000
Message-Id: <20260902172227.2D7FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Sysfs tree corruption during rollback of device_move_class_links f=
ailure.
- [High] Unconditional cleanup on failed rollback of device_move_class_link=
s leads to Use-After-Free of new_parent and its glue directory.
--

commit 80ab7b1ec98b82ed303226de698cbc0d137b6732
Author: David Jeffery <djeffery@redhat.com>

driver core: warn should device_move try to move a need_parent_lock device

This commit adds a warning to device_move() to catch any attempts to move a
device with need_parent_lock set. Moving such a device would break the
immutable parent-child relationship required for locking.

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index bce555dd74f69..e8a62c8f0ad3d 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4705,6 +4705,14 @@ int device_move(struct device *dev, struct device =
*new_parent,
>  	if (!dev)
>  		return -EINVAL;
> =20
> +	/*
> +	 * device_move() should not be used on devices with need_parent_lock
> +	 * set. Concurrent reparenting will violate the immutable
> +	 * relationship needed while locking and unlocking both parent and
> +	 * child.
> +	 */
> +	WARN_ON(dev->bus && dev->bus->need_parent_lock);
> +
>  	device_pm_lock();
>  	new_parent =3D get_device(new_parent);
>  	new_parent_kobj =3D get_device_parent(dev, new_parent);

Later in device_move():

> 	if (dev->class) {
> 		error =3D device_move_class_links(dev, old_parent, new_parent);
> 		if (error) {
> 			/* We ignore errors on cleanup since we're hosed anyway... */
> 			device_move_class_links(dev, new_parent, old_parent);
> 			if (!kobject_move(&dev->kobj, &old_parent->kobj)) {
                                                      ^^^^^^^^^^^^^^^^^^^

[Severity: High]
This is a pre-existing issue, but does this rollback correctly restore the
device's sysfs location?

The rollback explicitly uses &old_parent->kobj instead of the original glue
directory.

If a device uses a class glue directory, rolling back a failed move bypasses
the glue directory and places the device directly under the old parent's
kobject.

Can this break sysfs expectations for userspace and leak the original glue
directory during subsequent device removal if device_move_class_links()
fails?

> 				if (new_parent)
> 					klist_remove(&dev->p->knode_parent);
> 				dev->parent =3D old_parent;
> 				if (old_parent) {
> 					klist_add_tail(&dev->p->knode_parent,
> 						       &old_parent->p->klist_children);
> 					set_dev_node(dev, dev_to_node(old_parent));
> 				}
> 			}
> 			cleanup_glue_dir(dev, new_parent_kobj);
> 			put_device(new_parent);
                        ^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to unconditionally
drop these references here?

These lines drop the references to the new parent and glue directory, even =
if
the rollback failed and the device still holds pointers to them.

If device_move_class_links() fails and the subsequent rollback attempt via
kobject_move() also fails, the device remains partially moved with its pare=
nt
and kobj.parent pointers attached to the new parent.

Can dropping the references unconditionally leave these pointers dangling,
leading to a use-after-free or double-free?

> 			goto out;
> 		}
> 	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D3
