Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB5B3E9C0E
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789310411; cv=pass; b=ZmiQi3otM4fD8+wsVE5iG16FUf6XzG6Iph7kgZSMud6p1KX685TOIYVtMkMFhXB3YyoHY4h81CRTglX5ZmvEV3F3FOryIEGurjSCq4+mMjSAS7ueFatOOicprVdDuHr3K1FRo1zSjpAviOicRXc9vNYUI8UeWQtV5KbSD17QluA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789310411; c=relaxed/simple;
	bh=+qPJBWzmRKC9+OxVY9yN0s31Cu3tbv+EQeFTM5R4zPg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=parElzJKcM0frOQSeQTdFxMTJNjmwYFBeFr7f2Ifv7DOxdxsqvpniPsRbIMLglW7Cen8xRgWijZAgdBT/B7NWMSNLRf9LJ0ZzKLlkrjVOWGF5T1xBK3+wI4z80V01hot+SwqI70QOcGCMN08PFdupcOlScFveZc6B8WW8ViJsvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GK7ktkDk; arc=pass smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GK7ktkDk"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b34f95a85fso126279b6e.0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 07:40:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789310409; cv=none;
        d=google.com; s=arc-20260327;
        b=f4ldhPf6MnM98MpcAVAW7c6Dki+ecshK4BggRvDR4IsQyrqtBC2L0UQoXpiUQf7QTe
         OkX7PoNWUc2wjpGcaYFlimbPS5cd5SlrCX6XLwoEYFfJrR29rG6dzgBM+noQvviIoVGn
         fVm8wn6ETjAz2I7PY/QJtgeQf5fOhFGB6CmVicGw5Ml4Y75xOsT6PzsvSTtyKXwa57hc
         Q2ZlMYtkobvEsot3os3l+R2mrvgANr2Uy4Ol07A5cjrh/f7lOegE5DeCSIJptXk83NB3
         IdKAqvd9+QXL3BXJIIPAZK+YURi3AaPMuP8s2ZY9lJd7TsWApAcbn/QAmV6zTiaxhkUg
         1tZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=zqwZJGRl9Z45mEENuDDK/4UzwWu29byY1aWcLUyk39U=;
        fh=Kyeq+Zj/sPn6Z3Yw4X9sDoV7wEIeW+4mPDhHJpc8Byw=;
        b=canGpzvqOagEFn0gq/7Ljv1KFPdcXPfjI5jCjtNTYWpyed0+kGbSCDGzmgQzvAcTzt
         wpquJk5pvxYGzxL7C0YOpB+gH1ALlJGEnfk702aSycTffXIH9Wx20jrAeGWEyMXWpVh/
         O/nzqI47tyb9vFvmU4kT6wpBlblz1Z735dEhb4Bbl3mAr4BXlfv9b5QNbgkexPZn5PU4
         wFnrpFlpHJdMwURuh1Eqjro2nE49/2eQl8nMuBl7HWm2nZsMw4V1Y1iVujpW8HZtvOzf
         7sHYuAhmSbT7CJuPmu/o+UUt/UaGmpCpCqJnHy33OgB8n0JzU5YedfggUGZ4KJtKRHH6
         E49Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789310409; x=1789915209; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqwZJGRl9Z45mEENuDDK/4UzwWu29byY1aWcLUyk39U=;
        b=GK7ktkDkYYgeYyUR/lX8cMBh9vFB7nL4/9S46s7eWrGqO19okkyCAJ9Rd566oBb/R8
         Zmmj541OzAh/IHdEaESA7DrARHjm+w/u6uQefVt2rZ2GODCEvIUtDTMtX+hPnaVqIpDE
         ID8ioK9nG6spBN3G69J2scur2Tr8dYbAd5Qlkvaz0ZjiK0tAcKnLx5XKl1ncay0GE6Bc
         7VTa4d2dBWdJd+RZLFWYX/xJOFxtE4STfToKaGcQdAEIYM0dFX2dRu+cXhEXHD8ezLil
         8DnARvw4iDVVgAM+grMi3P5pIuYLLXK8ePQ5X9X395w0hvGOghgRU5RBzydPKbm+1qvy
         GRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789310409; x=1789915209;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqwZJGRl9Z45mEENuDDK/4UzwWu29byY1aWcLUyk39U=;
        b=kr2PmEHyvDIDOw8V2BBMZbklyonuhFvVKfrt54pvx0TWhp8dLGzL9zc+ZhWqNMDX/A
         Jz6YGQB7Wmn0ESJWhfOFOXeZzVHCDfBnMBh6VceBTtbHhiV/gmn/pw+D85Ifb8HfE3jM
         o77JjBwuYy3YkM+6M8ED88+nA/v/37btgkNQsxPaYM/5G9rU843+sRDzBy7Ir3PYEG8h
         aHi+e1twoV17N9kuVNsW2Au0w9Kn+al3akOvq69rqSnlGcPC31zXFLPrjHZ/mas3JWgZ
         OPfP5kXxlWfBWDPserID3uu/vBs8uW/flZDdLSkTy5ZHOJ3BxH9A+DT0IX5Ecum2CruU
         9GAQ==
X-Forwarded-Encrypted: i=1; AKwUvByvydDVTlfVvANCsZftXIykNCm2D7gg7MNVRYhJ9MCY3tEBNXgjfk5G8ZnRLmNbEY/SEcqT9HpJe2bV@vger.kernel.org
X-Gm-Message-State: AFuF++kl0yDIqh0xP7bZzuMuPfdQVtf/ZMs+JAwZMh88nOmq38OMrhSW
	R10IxDMiIkF17nJDGif7h+bMQ0ygCr93Ck82E851dtKX+XNv6NckML9gZZQdmcsLpQFHgZQ71Oh
	Kl1Lx0hvfDt6H7vZvVlnOEnIO3yuj/t8=
X-Gm-Gg: AYBFou25NsTKe01lOpjrKF3Gq9ohIDYs5DXnk4Bpmdq7mzgPtLznANNuzSm0NuSsXls
	M4246bEEC1z5wpMeufweLOmv0TbcSS3Nb2saUJ2PJVDkRM432an8EYvu7s4o764yv9KVkWlzDJ4
	x0h/yljtoZGfmL2iE381VqCeIM4EIxudikEAsoeZCl6x3qCXyRcTRH4BsweRYheHsLGo1n5hb6d
	1YxsVEyxVgtD8Kj7slTefYNIHQatTIJ7CjhJ4B3oDFpMfMwm+4cJolitjS7Aa06rb/p2qwRTQwM
	YI3rrksvNCJNfYdc0pkTDlS6TjYMdtl5/qKeUQERaVM7U5hLNDVU2BMkPKc5VnEioAI=
X-Received: by 2002:a05:6808:d4e:b0:4bd:c8be:1e07 with SMTP id
 5614622812f47-4c31953a9c1mr7372154b6e.1.1789310409260; Sun, 13 Sep 2026
 07:40:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: djraszit <djraszit@gmail.com>
Date: Sun, 13 Sep 2026 16:39:58 +0200
X-Gm-Features: AcwNN1VwoT2VUWhe17bgbZOfmp9_1oOxXNbRnbuULJgSCMaRgXdFdPqFLeAj_XQ
Message-ID: <CAFKhL9fbUj0ToFRTB2_yujEK8zo81GTGAeXPWpC=fF3DO8H98Q@mail.gmail.com>
Subject: [BUG] uas: JMS578 returns reproducibly incorrect data after host reboot
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Subject: JMS578 USB-SATA bridge returns reproducibly incorrect data
with UAS after host reboot

Hello,

I would like to report a possible issue involving the Linux UAS driver
and a JMS578-based USB-to-SATA bridge. I am not yet sure whether the
root cause is in the UAS driver, xHCI interaction, or the JMS578
firmware, but I have been able to reproduce the problem and isolate it
to UAS operation.

Hardware / system

Host:

Raspberry Pi 4

Linux 6.18.45-v8_1khz+

aarch64 kernel, 32-bit armhf userspace

USB-SATA bridge:

Bus 002 Device 005: ID 0080:a001 Unknown JMS578 based SATA bridge

The device identifies itself as:

Product: External USB 3.0
Manufacturer: TOSHIBA
SerialNumber: 2015033100081

It is connected through a Realtek USB 3.0 hub:

0bda:0411 Realtek Semiconductor Corp. Hub

The SATA disk contains a LUKS2 container with an ext4 filesystem. The
enclosure has its own external power supply and remains powered during
a reboot of the Raspberry Pi.

Problem

When the Raspberry Pi is rebooted while the USB-SATA enclosure remains
powered, the disk is detected normally using UAS:

scsi host2: uas
sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks
sd 2:0:0:0: [sdc] 4096-byte physical blocks

There are no obvious I/O errors, but some sectors are read with
incorrect contents.

This initially appeared to be severe ext4 filesystem corruption. For example:

EXT4-fs error (device dm-3): ext4_find_extent:944:
inode #8: comm mount: pblk 121667583 bad header/extent:
invalid magic - magic 7426, entries 15446, max 59087(0), depth 39757(0)

jbd2_journal_init_inode: Cannot locate journal superblock
EXT4-fs (dm-3): Could not load journal inode

However, the filesystem itself is not corrupted.

Reproducible block test

I opened the LUKS device read-only and repeatedly read ext4 block 121667583:

cryptsetup open --readonly /dev/disk/by-label/MP3_FILMY MP3_FILMY_encrypted

dd if=/dev/mapper/MP3_FILMY_encrypted \
   bs=4096 skip=121667583 count=1 status=none | sha256sum

With UAS after a Raspberry Pi reboot, the result is consistently:

66c32ba5b97394b491efb79e11fcfeae2a9040aa237beb51e09afee342903dc2

I repeated this read many times and always received exactly the same
incorrect hash. Therefore this does not appear to be random USB
transmission corruption.

After physically powering the USB-SATA enclosure off and back on, the
same block reads as:

6b716692a9eecccf9ab693a6419dc7325b3072c6ecf8499ffa2a1e4bd126b483

This is the correct value.

The same correct value is also obtained when the enclosure and disk
are connected to another Linux computer.

USB resets do not recover the device

I tested a USB device reset. The kernel reported:

usb 2-2.2: reset SuperSpeed USB device number 9 using xhci_hcd

but the block still returned the incorrect hash:

66c32ba5b97394b491efb79e11fcfeae2a9040aa237beb51e09afee342903dc2

I also used per-port power switching with uhubctl. The kernel
performed a complete USB disconnect and re-enumeration:

usb 2-2.2: USB disconnect, device number 5
...
usb 2-2.2: new SuperSpeed USB device number 9 using xhci_hcd
...
scsi host2: uas
...
sd 2:0:0:0: [sdc] Attached SCSI disk

but the incorrect block contents remained.

Because the enclosure is externally powered, the JMS578 itself
apparently remains powered during these USB-side resets.

Only physically removing power from the enclosure restored correct
reads while UAS was in use.

Disabling UAS fixes the problem

I then disabled UAS specifically for this bridge using:

usb-storage.quirks=0080:a001:u

After rebooting the Raspberry Pi, while leaving the enclosure
continuously powered, lsusb -t showed:

Class=Mass Storage, Driver=usb-storage, 5000M

instead of:

Class=Mass Storage, Driver=uas, 5000M

I then repeated exactly the same LUKS block test.

The result was immediately correct:

6b716692a9eecccf9ab693a6419dc7325b3072c6ecf8499ffa2a1e4bd126b483

I also ran a complete read-only ext4 check:

e2fsck -fn /dev/mapper/MP3_FILMY_encrypted

It successfully completed all five passes without filesystem errors:

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

MP3_FILMY: 18368/61046784 files (19.3% non-contiguous),
71945629/244186289 blocks

The only messages were several harmless suggestions that extent trees
"could be shorter".

Summary

The behaviour is therefore reproducible as follows:

JMS578 enclosure is externally powered and remains powered.

Linux uses the uas driver.

Reboot the Raspberry Pi without power-cycling the enclosure.

The disk is detected normally, but at least some reads return
reproducibly incorrect data.

USB reset does not fix it.

USB disconnect/re-enumeration does not fix it.

Physically power-cycling the JMS578 enclosure fixes it.

Disabling UAS with usb-storage.quirks=0080:a001:u also fixes it, even
without power-cycling the enclosure.

This is particularly dangerous because the problem does not
necessarily produce an I/O error. Valid but incorrect data is returned
to the block layer, causing higher layers such as dm-crypt and ext4 to
interpret the filesystem as corrupted.

I would be happy to perform additional tests, enable UAS/SCSI/xHCI
debugging, collect usbmon traces, provide kernel logs, or test a patch
if that would help determine whether this is a Linux UAS issue or a
firmware quirk in this JMS578 implementation.

Regards
