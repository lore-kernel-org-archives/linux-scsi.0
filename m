Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BF339CCFA
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 09:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788168393; cv=pass; b=D3HMVxljFo2VydHaBvE1dGEQT1eA2WvEnBexPk2sqhMXexDjp0a9QtIOHI+DfGY6753k9zQ/oQzMtwFZMuBg4r5JnH6WeicRRDziow9jKfrtit4N7SfeNBR0a7VTm9x/RCE6ftdHUePHIR/O09T0eSXLUYimnsadQDKwFEEMYtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788168393; c=relaxed/simple;
	bh=GBTgWejtGdJAKdiFr7UJ4AwaGexhIKwa4b9R0XxIbeg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qJroMaHgkSYM/4YCYMOeqr9W8ecnfk7lAmWcsTWIqctuOtlN2zzuuajIS8CcZ+G7/gtypZHy/h5KuB6kOWvZ0E4EyP59MHl7IRu4lNjYeFtyjVJK5k3GLQgk1WlW1rJfvtEcxaSSJDTkb2Nz4tCydWoPTOXBzS3ltpUMQER5GCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d1k/CVsK; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d1k/CVsK"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52e2d1bdbc0so22168041cf.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 02:26:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788168390; cv=none;
        d=google.com; s=arc-20260327;
        b=FEjqtknr0QxXqKPP+vVSsqkKkGW3NRgVwCsrbuuHzv+giQa/Qe+3GwzqowZVAsl4cr
         xwCxO2fh3XzAlkA/mreDmnJvL3W5YCV/JX9yxEI8qSAah5ZNGLpM7h5yQGRUwMpCo7cQ
         1pj0ezr+O/6aI2zVIhne3OBHovlvZSlPL8VuaauRFsT1Cu8T6CGvgvj2fzWoGXs+cBlL
         5psZChgDOQWhhbLOcLyyopiGNMA6LpqTFqLvvFRVwbP+V+7juqkw0IP83dfO8zyv3iwN
         VGpzMSm/mvZtAnmn5DPnBGuThxkKV0GurD85iECIOhs2gRcV8vKaIDFliLgF7mJvphY9
         J5IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Oc557eT+uz9yntWQBXBtcxG6zb+6RfKcRPnFhGyakfY=;
        fh=wiUyJwhgMEKZzf7yxLLNe2zjDorU1xOWsBAwgkKCAoM=;
        b=RsPThaRmnUJcynJFSoX8kqYc0AhAIrN4fjegUHfiI4u2CJ5bx8COAUpzI4H9GY/7ih
         PHp5Ue0xP/YNgdEyyxmb6Zzp3jRpxMgijDE/9PAK3laBr8zZuP78TPsscUaZqL6jQCy4
         H2MiloSsb38z0uh7R5nvc4rsxxhNCe80GkjpiAL2cV2m9YK+DqJjXOFEZjy9QGSjbCKf
         fsBRTKvUtUqgpZqF87IjjPNNGWnrjT6Ex3k0ViPabu0AmcBhLOSloInnWruHUFz6zj55
         UzXy6arSBVMF8jBuUM4Ef7DGy91U1xWgd/+kq2DVVWs5UnNSOzYY3MBX1LbaoLb0TaY+
         RLuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168390; x=1788773190; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Oc557eT+uz9yntWQBXBtcxG6zb+6RfKcRPnFhGyakfY=;
        b=d1k/CVsKVvaIyeR0uvK9X2eH41E0bdxY2jOhFnErtPi5Fm9hueftXJzYTey1dHGQbp
         Dn668Fs7dcF2WZJ76wcIlGQjgotVD1uKVDVUToY2UmIt/gA9DuB3pE/Meq/V4+mQnJ1W
         s7NdLCyC7UA5k4PCLc7wQitBCQTpzD2DREF8qXrLJjBEPQ8ihG8gwbVXXksJMtwsKqYc
         myzvE5IGoMlnoTDp9rjeo9juPt2k2TBHmkY9mp6P5ymTTUAHjkk1zcQd9v9PGsZtNiIu
         Qq33zDPIKHHEM3eb3tCj0m5FGW5uhMhwyhiVxFoKVt/OdVZFgZyPlYulTK2DYSiGvGOz
         TQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168390; x=1788773190;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Oc557eT+uz9yntWQBXBtcxG6zb+6RfKcRPnFhGyakfY=;
        b=KVIlnjEILdGVJuhUqSUWYQzLHpipKbeoDp4fLsNCFN13PcfxroqJ00iS0ugINZxFhE
         UOvTEtqkMzULZd1R89bou5Zs/Q62C9GWzqKN4+KweqnuJsm+jEup5N4us9B6siXpHuSd
         ZDRhBR0vQdyqNjigtouJIYc1W4nH37FRF/BIb6b4rlKvLe0LBIUdUom4xwQZKk1DwAg+
         Llh77YPKbCSraduh8CaWwG2A5Y2w+E14EONT3ZMMyo9STBPJUI+sg+k67Tuuymg+FT3f
         7NQEIgWd//WjDvJW9O9M8ZE4MJWUcM6dWnFDYhez+a/IpeI8LgvNm9w3sIsFLd5W3yHU
         /c/Q==
X-Forwarded-Encrypted: i=1; AHgh+RoWFFUmV2wq0I/mblH/eeQ9edopju3uwdBae2neEHxs4GbFS9S392qCnDdr9ckc9nxeSIgMLkvofHRc@vger.kernel.org
X-Gm-Message-State: AFuF++nyWkVKSoi3jeFSR6III1f1bQIodhX+o8WAblDSgi/++4zwjC6d
	rVkps34qyiATr5+I1CCDlNsYhFKS52PZ54NzighLj39MVrNv6Hm8DwWHSg8sjCVXjy1XujY3Ofl
	SavRyRVyuWobxId5HvDyzPdVyE1yP2eA=
X-Gm-Gg: AR+sD12rZRb52ha6BW6najl4KjDf8A2XgTQ107ZUHX3rigV7YUGDRMzQ+3eGPQal8E8
	d/oJIYH6TeunPe19I/pj11g+vW1pu8GaQ096ewxu54ffc25RpuGG4FzWNMd+QIw/rKWBDiveCZ2
	wczReloVFP82RU5wwwPY+xFKZbLpbMvZKDcMOke4FpXTY8XvV275XM3gVL6R2feWHP5R2TK0g0c
	C/rymam/WjOb7wi2rbYQWG0oDw+gYGBoTKbUKGz0Q6Ueln96gynynh5M6Stn/bEp1E9lIjqHrx4
	JEw/zThFfVYioYDrw42FjgoYTifI7YORF49C+4GgWiPGk4++MUsBO88C5h2TZr5vuUPfOUXfa9y
	H3BUr2cet8XpRB6e0B4m0tsTA2sUnxoKCgyLL81Y=
X-Received: by 2002:ac8:5751:0:b0:528:583:a6ca with SMTP id
 d75a77b69052e-52fb947ce64mr298965361cf.14.1788168390317; Mon, 31 Aug 2026
 02:26:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Mon, 31 Aug 2026 17:26:19 +0800
X-Gm-Features: AcwNN1VmE5hg-mg3rivFLUTIR9ieFN67679RSw-ZKkt1qwYIsnJOkNZQM4cS9tE
Message-ID: <CAA2SOT4Hok5xOtbviX4HkeqVK_u79NZjw3+0WKZMmUQb35jORw@mail.gmail.com>
Subject: [BUG] usb: gadget: f_tcm: possible circular locking dependency in usbg_make_tpg
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a possible circular locking dependency triggered by a
syzkaller reproducer on Linux 7.2.0-rc3. Similar issues appear to have
been reported upstream before, but I can still reproduce this warning on
Linux 7.2.0-rc3 with HEAD commit
1137d8b5df06137fb49513cc923b3b24d94cb809.

The reproducer mounts configfs, creates a USB gadget TCM function, creates
a target usb_gadget fabric TPG, and then links the TCM function into a USB
gadget configuration.

Lockdep reports a cycle involving the configfs inode mutex,
tpg_instances_lock, and the f_tcm opts->dep_lock. The current path is
creating a TPG through configfs_mkdir(). It reaches usbg_make_tpg(), holds
tpg_instances_lock and opts->dep_lock, and then calls
configfs_depend_item_unlocked(), which tries to acquire a configfs inode
mutex.

The existing reverse dependency is created by the USB gadget symlink path:
configfs_symlink() calls config_usb_cfg_link(), which calls
usb_get_function() and then tcm_alloc(), where tpg_instances_lock is
acquired.

This creates the following lock order cycle:

configfs inode mutex -> tpg_instances_lock -> opts->dep_lock
opts->dep_lock -> configfs inode mutex

This looks like a lock-ordering issue in the USB gadget TCM function /
target configfs integration. The kernel should avoid taking these locks in
opposite orders, because this can lead to an actual deadlock.

Reproducer:

syz reproducer: https://pastebin.com/raw/xHmrR2GY
console output: https://pastebin.com/raw/G4WtE3Xs
kernel config: https://pastebin.com/raw/GhP15ssA

Kernel:

HEAD commit: 1137d8b5df06137fb49513cc923b3b24d94cb809
git tree: torvalds/linux
kernel version: 7.2.0-rc3 #1 PREEMPT(full) (QEMU Ubuntu 24.10)

Relevant log:

syz.0.17/12335 is trying to acquire lock:
ffff88801e4a6280 (&sb->s_type->i_mutex_key#26){+.+.}-{4:4},
at: configfs_depend_item_unlocked+0xe8/0x460

but task is already holding lock:
ffff888058c6c918 (&opts->dep_lock){+.+.}-{4:4},
at: usbg_make_tpg+0x153/0x5e0

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3 (&opts->dep_lock){+.+.}-{4:4}:
__mutex_lock+0x16e/0x2760
usbg_make_tpg+0x153/0x5e0
target_fabric_make_tpg+0xab/0xad0
configfs_mkdir+0x5ae/0xc50
vfs_mkdir+0x35f/0x7b0
filename_mkdirat+0x407/0x580
__x64_sys_mkdirat+0x8a/0xc0

-> #2 (tpg_instances_lock){+.+.}-{4:4}:
__mutex_lock+0x16e/0x2760
tcm_alloc+0x20/0x310
usb_get_function+0x61/0xd0
config_usb_cfg_link+0x1f6/0x3f0
configfs_symlink+0x53c/0x1180
vfs_symlink+0x180/0x4e0
filename_symlinkat+0x324/0x430
__x64_sys_symlinkat+0x9c/0xe0

-> #1 (&gi->lock){+.+.}-{4:4}:
__mutex_lock+0x16e/0x2760
config_usb_cfg_link+0x57/0x3f0
configfs_symlink+0x53c/0x1180
vfs_symlink+0x180/0x4e0
filename_symlinkat+0x324/0x430
__x64_sys_symlinkat+0x9c/0xe0

-> #0 (&sb->s_type->i_mutex_key#26){+.+.}-{4:4}:
down_write+0x91/0x200
configfs_depend_item_unlocked+0xe8/0x460
usbg_make_tpg+0x214/0x5e0
target_fabric_make_tpg+0xab/0xad0
configfs_mkdir+0x5ae/0xc50
vfs_mkdir+0x35f/0x7b0
filename_mkdirat+0x407/0x580
__x64_sys_mkdirat+0x8a/0xc0

Chain exists of:
&sb->s_type->i_mutex_key#26 --> tpg_instances_lock --> &opts->dep_lock

Possible unsafe locking scenario:

  CPU0                    CPU1
  ----                    ----

lock(&opts->dep_lock);
lock(tpg_instances_lock);
lock(&opts->dep_lock);
lock(&sb->s_type->i_mutex_key#26);

*** DEADLOCK ***
