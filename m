Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D9F368D50
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 04:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787028049; cv=none; b=UWVXOV7HC9T4j8M4+An4bUvTjdGyYI/DKWHRJ13QrNlXgqTUOUhO4zmXyH7HTpTrzon1yg847NKTbBzNaMTfs6Dn584RlJoWxkW6EQHobTTEuZSE62f8Nn/AXovz1hkIreTADTsYiY44BeWkLI9LLLTjQTLM1tJLEk/Vz89EgeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787028049; c=relaxed/simple;
	bh=JUPJAXneYRZnQRYuObo4a+QalfhUWr9fxPQHcuMomx8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r8IpljLjPu6JHf2VWxR+sqyLKX61N/9SNNHPYkPnX45VBZIDjhXpVJ2av57XZSEq+Zy1q1iANpaDnc+JDRDiJ9TrBTu/+7H5SeY9veO9Xz1CJFrwfgB0mhPtdTKgfbzFN6nUpDA59BCS/zFZ6iUabd48RaLO8cXB5QUHl3drKys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkFufwAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkFufwAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A821F000E9;
	Tue, 18 Aug 2026 04:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787028047;
	bh=CY7tx1ZonX//sCyshmXgUHsbO6RD0tH3ddabWxApM2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GkFufwADoGQBKFHINnoUDqK642ZmvvMeq0IAhj03J7HojGkwWEEdUwJEfhw7jp5YG
	 z84c416mgsYfZTqH2SQwBMLaQ6ebku9wI56nZX7TiAc1GLwkPuEwopneEfMMfFi4cR
	 gGA+UCbv//7RCG/PObGdPiiMoE79zNLTFKweem4zRuDsRkbYkR3VuvCoc/o/X5BGOY
	 jThApiXXPkMSTYDGPFpKklA8nmsLUUFfsDMvRmbmqzz67IKj2IsRT8BqKLG7uACrXJ
	 Q8gaQI1wwKgwGo6qQ4y1qnHGK4ra0guqwHKz355bu8YVNZ39G+lzB6LKwcZ0+/3da+
	 AQ2Her1Fh/L1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: reject configfs db_root for ALUA metadata
Reply-To: sashiko-reviews@lists.linux.dev
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260818042720.1511778-1-runyu.xiao@seu.edu.cn>
References: <20260818042720.1511778-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 04:40:47 +0000
Message-Id: <20260818044047.85A821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Time-Of-Check to Time-Of-Use (TOCTOU) race bypasses the configfs p=
ath validation, leaving the deadlock vulnerability open.

Pre-existing issues:
- [High] Pre-existing lock inversion between `target_devices_lock` and the =
VFS directory `i_rwsem` causes an ABBA deadlock.
--

--- Patch [1]: [PATCH] scsi: target: reject configfs db_root for ALUA metad=
ata ---
commit 2cce6aeea624aad95569faa866567fc7a0a6be25
Author: Runyu Xiao <runyu.xiao@seu.edu.cn>

scsi: target: reject configfs db_root for ALUA metadata

The commit adds a check to target_core_item_dbroot_store to reject db_root
paths that resolve to a configfs filesystem. This is to prevent ALUA metada=
ta
writes from recursively re-entering configfs and deadlocking.

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index 2b19a956007b7..2c79e78105ea6 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -138,8 +138,16 @@ static ssize_t target_core_item_dbroot_store(struct =
config_item *item,
>  			pr_err("db_root: not a directory: %s\n", db_root_stage);
>  		goto unlock;
>  	}

[Severity: High]
This is a pre-existing issue, but does calling kern_path() while holding
target_devices_lock introduce a lock inversion with i_rwsem?

Looking at target_core_item_dbroot_store(), it acquires target_devices_lock
and then resolves a path using kern_path(). If the provided path forces a w=
alk
through an uncached directory, VFS acquires the directory's i_rwsem:

drivers/target/target_core_configfs.c:target_core_item_dbroot_store() {
    mutex_lock(&target_devices_lock);
    ...
    r =3D kern_path(db_root_stage, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
    ...
}

Conversely, if a user creates a directory in configfs, vfs_mkdir() acquires
the parent directory's i_rwsem and calls target_core_make_subdev(), which
subsequently tries to acquire target_devices_lock:

drivers/target/target_core_configfs.c:target_core_make_subdev() {
    ...
    mutex_lock(&target_devices_lock);
    ...
}

Could this result in an ABBA deadlock if a user concurrently creates a
directory in configfs while writing an uncached configfs path to dbroot?

> +	if (!strcmp(path.dentry->d_sb->s_type->name, "configfs")) {
> +		pr_err("db_root: configfs is not a valid target database root: %s\n",
> +		       db_root_stage);
> +		r =3D -EINVAL;
> +	}
>  	path_put(&path);
> =20
> +	if (r)
> +		goto unlock;
> +
>  	strscpy(db_root, db_root_stage);

[Severity: High]
Does saving the path string instead of the path reference leave a TOCTOU
window that could bypass the new validation?

The new validation checks if the resolved path is on configfs, but then dro=
ps
the path reference and stores only the string. If a user writes a path to a
symlink pointing to a normal directory, it would pass this validation check.

If the user then modifies the symlink to point to /sys/kernel/config after
the check succeeds, later ALUA operations that use filp_open() on the string
will follow the symlink directly into configfs. Could this allow the recurs=
ive
deadlock to still be triggered?

>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818042720.1511=
778-1-runyu.xiao@seu.edu.cn?part=3D1
