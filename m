Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D91B30C619
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2025 17:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766509340; cv=none; b=FZ2MT/jsJ72PcCUh8KkNEwurxqpntEymzbCn5xPevbAfpWmwmG8hOAdMXT2+MCeam9BmYVRXrIy+02RKQ7YOzHFTRyyq3Qrl6wrqmsdBdzBxL13tHXGoEqgxFdn57T2XuR4w5CBoayPDdJBJb8gabInhrBvRtkuwhEoKnzWYG0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766509340; c=relaxed/simple;
	bh=TnNC2W1GzjL/ZzHC+j7fyTO6v5qiq5K4/Dsjop708Vs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SM5LMI4FkZG0ZQulbPy63vsCDC0vim7d1JEUSMkeXhOdzkP85nqRZiqCh/+ZOgtzAFI+pkexWAiHdp8fw1xBw8mL12zhFdKZtDiEwmfmhOAgwzkyokaM9idPLLYpcybh5cy323frG3IiEeG9oLIHU+ElyLGYVebic6dGGL7+KQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bK2eYr7O; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bK2eYr7O"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5dfd0101905so1475712137.3
        for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2025 09:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766509336; x=1767114136; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JiZp6r8/FOpuhi052wmk44uRuXYtSm8vu7BwRt88BgE=;
        b=bK2eYr7OvegMRFs+sRjW0YBpXqaNLClHJcytgT9ffJ3Afr/WgGS7frTGsKZQ8URVGT
         pdpxqa/Osac5iB6ppkXHRDlW+aLV5tXTWW9tWoMrDaOZDWAaub3yhRV7XPGsgoZnyyDs
         vLSXEN5wKdx88Y/fMftU14Ls3nQ505sTbjeV0y6uiJ1WlkcTx0itbCjABdIkcCSVgKq4
         wiHW5FLS26xDPQsB9qrApZXYZsWagYOl5JqZA7+D4dSzU4RaycbCejxwwAVSVTcJHq2Q
         +f0hWoMXZ7QTpDGmE+GusJMqT7AxOMlNbWxzl3/FEwljg7obgmWCPc5Z/loz/co0vm4S
         7GPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766509336; x=1767114136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiZp6r8/FOpuhi052wmk44uRuXYtSm8vu7BwRt88BgE=;
        b=U/tNRRFtIk4UQPcTbG+pUfoYAMqHo/ta6QXug+REcq+yIhkV+NYGGRDWm5hxe1Nv0o
         aR1ih+s6Fnz10XOphXx6NmTmQEUr+H+pdxlNOVu0CFvAji0IyYvm2uMUvthPRDt5htKs
         mFMJVip7N+BY1u+aDY652FEd2hJBHrF6+qiRhiUnmKB2Af3bdsVIdVrI5rR67tlM0nda
         nI9ow8xwAFYJdXYxmt8pXh24tXyw3JIb7CngTUAt99bE9kdN86HEytxSxha22XoJxVHS
         8YDVK9STBjLaSmgjC/RR6bTBrzgEeYMuQnMECEDnt6JCi87kh6R9WPHFxz9shxHHcwnE
         gtMg==
X-Gm-Message-State: AOJu0YzzgQUQSuK8l3+dFbIxb7jYylMtxM8RrYrSJwU68teu/L8SbTvK
	iuSheue3ov1LB34/6KP9zfmBnEpLj9iu1Xhod1XAf72Ac8JOBp6jjUenSTpw7Y6iFIIEw0oAakf
	dZL0M5EmiXPWTPbGVqAHkekMy2XObQHCb4vbU
X-Gm-Gg: AY/fxX7DKHJHkrqSbjTF18a3JqSv5wZBgoPJbHdzRQh75xL9evVu5by3XabCT5qneYI
	t1pwRm8Z/JcZ/iWiO1THJOCzb/5e2UV4479Fllbk/MH1g8OJjICe7zSiGbxJGx7GXXnP/4o+kUd
	CGC4Zhtdz0599Ii799o6TZ0VUTDs5lpAfhbSlSpW6DoIy+gcaDCk5xm1cv96WH4ALd0c27Xksl8
	kVqI3hPKaTS/ZnoC1gnzksUmEwZblapJYCT2YKu560UUWqN0XRyNHVuWCewweRujbxJhw==
X-Google-Smtp-Source: AGHT+IE8aWwEGu37WfAUbZ7CKoO7+sG1+lBdZ+ZZ+9EFyVBWvnnjpVNlOD2yz6S3u5sMiyiIwu7E11eseNERbEEXkJw=
X-Received: by 2002:a05:6102:3e27:b0:5df:c390:ef5b with SMTP id
 ada2fe7eead31-5eb1a8429cbmr5196941137.38.1766509335152; Tue, 23 Dec 2025
 09:02:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve Bravura <stevebravura52@gmail.com>
Date: Tue, 23 Dec 2025 19:02:03 +0200
X-Gm-Features: AQt7F2pOkJTyYHZ0uyHt8zZB85LPl4ediTsI4Ecw7Isspeyu1BTeT8yRuEjHbg0
Message-ID: <CAFkb6ArxO79Po_kdoQ9P7-GSrzy9gs8THnfkxJ9x67Dcvg6ZfQ@mail.gmail.com>
Subject: Intermittent mount failures with SanDisk SSD PLUS over USB
To: linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My system info:

OS: Debian GNU/Linux 13 (trixie) x86_64
Host: HP ProBook 650 G4 (SBKPF)
Kernel: Linux 6.12.57+deb13-amd64
Shell: bash 5.2.37
DE: Xfce4 4.20
WM: Xfwm4 (X11)
Terminal: xfce4-terminal 1.1.4
CPU: Intel(R) Core(TM) i5-8250U (8) @ 3.40 GHz
GPU: Intel UHD Graphics 620 @ 1.10 GHz [Integrated]
Memory: 3.00 GiB / 15.01 GiB (20%)




=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D


Alot of times, when I try to mount a specific (SDSSDA-480G) SSD, using
a specific (US221-30848) Ugreen enclosure, after a long mounting
loading, I get this 1st error in Thunar "Failed to mount "New Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1.",

and I get this 2nd error in Thunar when I try to remount "Failed to
mount "New Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: fsconfig() failed:
/dev/sdb1: Can't open blockdev."


the issue happens alot, but not all of the time


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
::::::::::::::::::::::::::::


I connected our SDSSDA-480G ssd via our US221-30848 enclosure and cable as =
usual

and clicked on it via thunar to mount it and waited for some unusually
long time, and I got an error in Thunar saying "Failed to mount "New
Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1."

and when, I close the error dialog, go to gnome-disks, and click
"Mount" on that partition, I get an error saying "Error mounting
/dev/sdb1 at /media/vlad/New Volume: fsconfig() failed: /dev/sdb1:
Can't open blockdev (udisks-error-quark, 0)"

and when I click poweroff from gnome-disks, I ger an error saying
"Error opening /dev/sdb for fsync: No such device or address
(udisks*error-quark, 0)"

and when I then go, and click eject from thunar, I get an error in
Thunar saying "Failed to eject "New Volume".
Error opening /dev/sdb for fsync: No such device or address.


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
::::::::::::::::::::::::::::


To get it to work normally, I have to reconnect it, sometimes once,
sometimes alot.


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
::::::::::::::::::::::::::::

Also, sometimes when I connect it, it does not appear in lsblk,
thunar, or gnome-disks, untill a next reconnect

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::=
::::::::::::::::::::::::::::


I wanted to also add that it stays connected, after it mounts
succesfully, no issue happens after this, and I keep it connected for
some time, comparing all bytes of 300gb+ of files those in a backup
drive, and no issue at all.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D




vlad@vlad:~$ sudo dmesg | tail -50
[sudo] password for vlad:
[ 4480.595505] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 4480.659421] usb 2-1: USB disconnect, device number 48
[ 4485.031811] usb 2-1: new SuperSpeed USB device number 49 using xhci_hcd
[ 4485.056738] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[ 4485.056761] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 4485.056771] usb 2-1: Product: Ugreen Storage Device
[ 4485.056778] usb 2-1: Manufacturer: Ugreen
[ 4485.056785] usb 2-1: SerialNumber: 133309270601
[ 4485.087216] usb 2-1: Enable of device-initiated U1 failed.
[ 4485.087935] usb 2-1: Enable of device-initiated U2 failed.
[ 4485.117323] usb 2-1: Enable of device-initiated U1 failed.
[ 4485.118082] usb 2-1: Enable of device-initiated U2 failed.
[ 4485.122740] scsi host2: uas
[ 4485.244213] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[ 4485.278193] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 4485.284662] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 4485.286626] sd 2:0:0:0: [sdb] Write Protect is off
[ 4485.286630] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[ 4485.289909] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 4485.340218] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[ 4485.340223] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[ 4485.393192]  sdb: sdb1
[ 4485.393382] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 4491.467027] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 4491.835118] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 4491.911253] usb 2-1: USB disconnect, device number 49
vlad@vlad:~$


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D



note: i tested that SDSSDA-480G SSD and another HDD, the HDD had no
issue, meanwhile, the SDSSDA-480G SSD had this issue (SDSSDA-480G in
US221-30848 enclosure, and the other in CM471-30725, but both used
same cable).


also, here is a dmesg comprison, of me succesfully connecting,
mounting partitions, and disconnecting the 2 drives:



vlad@vlad:~$ sudo dmesg | tail -900 #the other drive with the
CM471-30725 enclosure
[ 1014.860828] usb 2-1: new SuperSpeed USB device number 31 using xhci_hcd
[ 1014.878131] usb 2-1: New USB device found, idVendor=3D152d,
idProduct=3D0578, bcdDevice=3D 2.14
[ 1014.878151] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 1014.878159] usb 2-1: Product: Ugreen Storage Device
[ 1014.878165] usb 2-1: Manufacturer: Ugreen
[ 1014.878171] usb 2-1: SerialNumber: 000201040289
[ 1014.884415] scsi host2: uas
[ 1014.885027] scsi 2:0:0:0: Direct-Access     WDC WD10 SPZX-24Z10
  0214 PQ: 0 ANSI: 6
[ 1014.888131] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 1014.991964] sd 2:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/932 GiB)
[ 1014.991970] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[ 1014.992144] sd 2:0:0:0: [sdb] Write Protect is off
[ 1014.992147] sd 2:0:0:0: [sdb] Mode Sense: 53 00 00 08
[ 1014.992551] sd 2:0:0:0: [sdb] Disabling FUA
[ 1014.992554] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1015.040814] sd 2:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
[ 1015.040819] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
not a multiple of preferred minimum block size (4096 bytes)
[ 1015.079663]  sdb: sdb1
[ 1015.080044] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 1021.196738] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1021.541007] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 1021.569388] usb 2-1: USB disconnect, device number 31
vlad@vlad:~$ sudo sudo dmesg -C


vlad@vlad:~$ sudo dmesg | tail -900 #SDSSDA-480G in US221-30848 enclosure
[ 1064.267776] usb 2-1: new SuperSpeed USB device number 32 using xhci_hcd
[ 1064.291935] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[ 1064.291958] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 1064.291967] usb 2-1: Product: Ugreen Storage Device
[ 1064.291974] usb 2-1: Manufacturer: Ugreen
[ 1064.291981] usb 2-1: SerialNumber: 133309270601
[ 1064.316602] usb 2-1: Enable of device-initiated U1 failed.
[ 1064.317175] usb 2-1: Enable of device-initiated U2 failed.
[ 1064.346457] usb 2-1: Enable of device-initiated U1 failed.
[ 1064.346990] usb 2-1: Enable of device-initiated U2 failed.
[ 1064.350212] scsi host2: uas
[ 1064.470974] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[ 1064.504392] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 1064.510935] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 1064.512867] sd 2:0:0:0: [sdb] Write Protect is off
[ 1064.512871] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[ 1064.516051] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1064.564058] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[ 1064.564062] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[ 1064.616752]  sdb: sdb1
[ 1064.616899] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 1074.010240] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1074.358312] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 1074.422681] usb 2-1: USB disconnect, device number 32
vlad@vlad:~$

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D



vlad@vlad:~$ lsblk -f /dev/sdb
NAME FSTYPE FSVER LABEL      UUID
FSAVAIL FSUSE% MOUNTPOINTS
sdb
=E2=94=94=E2=94=80sdb1
     ntfs         New Volume 7A4E55864E553BD7
vlad@vlad:~$




=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D




Here is using differnet adapters/enclosures/cables with SDSSDA-480G:




vlad@vlad:~$ sudo sudo dmesg -C
[sudo] password for vlad:
vlad@vlad:~$ sudo dmesg | tail -900 #SDSSDA-480G in US221-30848
enclosure, but with a different cable
[ 1198.936484] usb 2-1: new SuperSpeed USB device number 33 using xhci_hcd
[ 1198.961127] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[ 1198.961147] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 1198.961155] usb 2-1: Product: Ugreen Storage Device
[ 1198.961162] usb 2-1: Manufacturer: Ugreen
[ 1198.961168] usb 2-1: SerialNumber: 133309270601
[ 1198.986378] usb 2-1: Enable of device-initiated U1 failed.
[ 1198.986983] usb 2-1: Enable of device-initiated U2 failed.
[ 1199.016557] usb 2-1: Enable of device-initiated U1 failed.
[ 1199.017314] usb 2-1: Enable of device-initiated U2 failed.
[ 1199.022044] scsi host2: uas
[ 1199.142796] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[ 1199.177580] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 1199.184310] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 1199.186046] sd 2:0:0:0: [sdb] Write Protect is off
[ 1199.186059] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[ 1199.189273] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1199.240740] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[ 1199.240749] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[ 1199.283649]  sdb: sdb1
[ 1199.283762] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 1203.671550] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1203.999555] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 1204.079471] usb 2-1: USB disconnect, device number 33
vlad@vlad:~$ sudo sudo dmesg -C


vlad@vlad:~$ sudo dmesg | tail -900 #different sata to usb adapter
cable (70609-CM321)
[ 1275.797893] usb 2-1: new SuperSpeed USB device number 34 using xhci_hcd
[ 1275.815713] usb 2-1: New USB device found, idVendor=3D174c,
idProduct=3D1153, bcdDevice=3D 1.00
[ 1275.815733] usb 2-1: New USB device strings: Mfr=3D2, Product=3D3, Seria=
lNumber=3D1
[ 1275.815741] usb 2-1: Product: Ugreen Storage Device
[ 1275.815748] usb 2-1: Manufacturer: Ugreen
[ 1275.815753] usb 2-1: SerialNumber: 26A1EE833529
[ 1275.824137] scsi host2: uas
[ 1275.831468] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  0    PQ: 0 ANSI: 6
[ 1275.833782] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 1275.834624] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 1275.834750] sd 2:0:0:0: [sdb] Write Protect is off
[ 1275.834754] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 1275.834913] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1275.889937] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[ 1275.889941] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[ 1275.929854]  sdb: sdb1
[ 1275.929989] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 1280.133705] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1280.461921] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 1280.505823] usb 2-1: USB disconnect, device number 34







=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D








later, I moved the SDSSDA-480G SSD to the CM471-30725 enclosure and
tried another usb cable, and when I connected it and clicked on it in
Thunar to mount, I instantly got an error saying "Failed to mount "New
Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1.", then I waited, then closed it, and then I
clicked on the drive again in Thunar to mount it, and it mounted
normally.



again, I moved it to a another ORICO-25PW1-U3 enclosure and using
another usb cable, and when I connected it and clicked on it in Thunar
to mount, I instantly got an error saying "Failed to mount "New
Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1.", then I waited, then closed it, and then I
clicked on the drive again in Thunar to mount it, and it mounted
normally.

then, I moved it back to the US221-30848 enclosure, using the other
cable, when I connected it and clicked on it in Thunar to mount, it
took time loading, and I got this error, "Failed to mount "New
Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1."

and when I closed the error dialog and clicked on the drive in Thunar
to try to mount it, I got this "Failed to mount "New Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: fsconfig() failed:
/dev/sdb1: Can't open blockdev."





=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D

also, here are some dmesgs:
https://drive.google.com/file/d/1CDGiMW9S-4I2RHDi8PGmnzbwYE5gxsL2/view?usp=
=3Dsharing


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D




Again, I moved SDSSDA-480G to the ORICO-25PW1-U3 enclosure and using
another usb cable, and when I connected it and clicked on it in Thunar
to mount, I instantly got an error saying "Failed to mount "New
Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1.", then I waited, then closed it, and then I
clicked on the drive in Thunar again to mount it, and it mounted
normally.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D


I was unable to reproduce the issue with the HikVision SSD in the
US221-30848 enclosure. But using the SDSSDA-480G drive in the
ORICO-25PW1-U3 enclosure, I was only able to get a smaller issue, an
instant error after clicking mount in Thunar, and maybe again, and
agian, but at some point, it mounts normally anyway. it happened very
few times. I wanted to note that the same cable was used for both.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D


I tried our SDSSDA-480G SSD with the US221-30848 enclosure, I got the
bigger issue, when I connected it and clicked on it in Thunar to
mount, it took time loading, and I got this error, "Failed to mount
"New Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1."

and when I closed the error dialog and clicked on the drive in Thunar
to try to mount it again, I got this "Failed to mount "New Volume".
Error mounting /dev/sdb1 at /media/vlad/New Volume: fsconfig() failed:
/dev/sdb1: Can't open blockdev."


I replaced the SDSSDA-480G SSD in the US221-30848 enclosure, with a
hikvision SSD, I kept disconnecting and reconnecting 20+ times, and I
couldn't reproduce the issue


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D





I restarted the laptop, and I connedted the SDSSDA-480G SSD in the
US221-30848 enclosure, but clicked mount using gnome-disks instead of
thunar, and it kept loading fot a long time, then, I got an error
saying "Error mounting filesystem
Error mounting /dev/sdb1 at /media/vlad/New Volume: can't read
superblock on /dev/sdb1 (udisks-error-quark, 0)", but when I closed
the error dialog and clicked mpunt again, it mounted normally.




here is a dmesg after i ejected it:


vlad@vlad:~$ sudo dmesg | tail -999999
[  646.921303] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[  646.949770] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[  646.949791] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[  646.949800] usb 2-1: Product: Ugreen Storage Device
[  646.949808] usb 2-1: Manufacturer: Ugreen
[  646.949814] usb 2-1: SerialNumber: 133309270601
[  646.982182] usb 2-1: Enable of device-initiated U1 failed.
[  646.982946] usb 2-1: Enable of device-initiated U2 failed.
[  647.026722] usbcore: registered new interface driver usb-storage
[  647.061982] usb 2-1: Enable of device-initiated U1 failed.
[  647.062560] usb 2-1: Enable of device-initiated U2 failed.
[  647.064801] scsi host2: uas
[  647.064912] usbcore: registered new interface driver uas
[  647.185687] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[  647.221248] sd 2:0:0:0: Attached scsi generic sg1 type 0
[  647.227865] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[  647.229593] sd 2:0:0:0: [sdb] Write Protect is off
[  647.229605] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[  647.232878] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  647.281753] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[  647.281763] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[  647.328748]  sdb: sdb1
[  647.328842] sd 2:0:0:0: [sdb] Attached SCSI disk
[  666.212439] sd 2:0:0:0: [sdb] tag#16 uas_eh_abort_handler 0 uas-tag
2 inflight: CMD
[  666.212456] sd 2:0:0:0: [sdb] tag#16 CDB: ATA command pass
through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[  687.204493] sd 2:0:0:0: [sdb] tag#23 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD IN
[  687.204511] sd 2:0:0:0: [sdb] tag#23 CDB: Read(10) 28 00 00 5f e6
18 00 00 08 00
[  687.228368] scsi host2: uas_eh_device_reset_handler start
[  687.353169] usb 2-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  687.426455] usb 2-1: Enable of device-initiated U1 failed.
[  687.427395] usb 2-1: Enable of device-initiated U2 failed.
[  687.428473] scsi host2: uas_eh_device_reset_handler success
[  717.936392] scsi host2: uas_eh_device_reset_handler start
[  717.936681] sd 2:0:0:0: [sdb] tag#6 uas_zap_pending 0 uas-tag 1 inflight=
: CMD
[  717.936688] sd 2:0:0:0: [sdb] tag#6 CDB: Read(10) 28 00 00 5f e6 18
00 00 08 00
[  718.057701] usb 2-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  718.132073] usb 2-1: Enable of device-initiated U1 failed.
[  718.132664] usb 2-1: Enable of device-initiated U2 failed.
[  718.133629] scsi host2: uas_eh_device_reset_handler success
[  748.648371] scsi host2: uas_eh_device_reset_handler start
[  748.648791] sd 2:0:0:0: [sdb] tag#11 uas_zap_pending 0 uas-tag 1
inflight: CMD
[  748.648807] sd 2:0:0:0: [sdb] tag#11 CDB: Read(10) 28 00 00 5f e6
18 00 00 08 00
[  748.769452] usb 2-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  748.847364] usb 2-1: Enable of device-initiated U1 failed.
[  748.848025] usb 2-1: Enable of device-initiated U2 failed.
[  748.848543] scsi host2: uas_eh_device_reset_handler success
[  779.384526] scsi host2: uas_eh_device_reset_handler start
[  779.384955] sd 2:0:0:0: [sdb] tag#8 uas_zap_pending 0 uas-tag 1 inflight=
: CMD
[  779.384969] sd 2:0:0:0: [sdb] tag#8 CDB: Read(10) 28 00 00 5f e6 18
00 00 08 00
[  779.504965] usb 2-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  779.583263] usb 2-1: Enable of device-initiated U1 failed.
[  779.584094] usb 2-1: Enable of device-initiated U2 failed.
[  779.584713] scsi host2: uas_eh_device_reset_handler success
[  810.104160] scsi host2: uas_eh_device_reset_handler start
[  810.104477] sd 2:0:0:0: [sdb] tag#9 uas_zap_pending 0 uas-tag 1 inflight=
: CMD
[  810.104484] sd 2:0:0:0: [sdb] tag#9 CDB: Read(10) 28 00 00 5f e6 18
00 00 08 00
[  810.224828] usb 2-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  810.298686] usb 2-1: Enable of device-initiated U1 failed.
[  810.299502] usb 2-1: Enable of device-initiated U2 failed.
[  810.300213] scsi host2: uas_eh_device_reset_handler success
[  840.812133] scsi host2: uas_eh_device_reset_handler start
[  840.812563] sd 2:0:0:0: [sdb] tag#10 uas_zap_pending 0 uas-tag 1
inflight: CMD
[  840.812578] sd 2:0:0:0: [sdb] tag#10 CDB: Read(10) 28 00 00 5f e6
18 00 00 08 00
[  840.932712] usb 2-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  841.014574] usb 2-1: Enable of device-initiated U1 failed.
[  841.015524] usb 2-1: Enable of device-initiated U2 failed.
[  841.016664] scsi host2: uas_eh_device_reset_handler success
[  841.017808] sd 2:0:0:0: [sdb] tag#10 timing out command, waited 180s
[  841.017829] sd 2:0:0:0: [sdb] tag#10 FAILED Result:
hostbyte=3DDID_RESET driverbyte=3DDRIVER_OK cmd_age=3D184s
[  841.017839] sd 2:0:0:0: [sdb] tag#10 CDB: Read(10) 28 00 00 5f e6
18 00 00 08 00
[  841.017844] I/O error, dev sdb, sector 6284824 op 0x0:(READ) flags
0x0 phys_seg 1 prio class 2
[  841.017944] ntfs3(sdb1): failed to read volume at offset 0xbfbc3000
[  841.017962] ntfs3(sdb1): Failed to initialize $Bitmap (-5).
[ 1137.587782] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1137.919905] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
[ 1137.976099] usb 2-1: USB disconnect, device number 2
[ 1143.055957] warning: `Socket Thread' uses wireless extensions which
will stop working for Wi-Fi 7 hardware; use nl80211
vlad@vlad:~$


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D







vlad@vlad:~$ lsblk #after connecting the SDSSDA-480G SSD
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 238.5G  0 disk
=E2=94=9C=E2=94=80sda1        8:1    0   976M  0 part /boot/efi
=E2=94=9C=E2=94=80sda2        8:2    0 225.2G  0 part /
=E2=94=94=E2=94=80sda3        8:3    0  12.3G  0 part [SWAP]
sdb           8:16   0 447.1G  0 disk
=E2=94=94=E2=94=80sdb1        8:17   0 447.1G  0 part
nvme0n1     259:0    0 931.5G  0 disk
=E2=94=94=E2=94=80nvme0n1p1 259:1    0 931.5G  0 part /mnt/D
vlad@vlad:~$ lsblk #after trying to mount, then getting 1st error,
then trying again, then getting a 2nd error
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 238.5G  0 disk
=E2=94=9C=E2=94=80sda1        8:1    0   976M  0 part /boot/efi
=E2=94=9C=E2=94=80sda2        8:2    0 225.2G  0 part /
=E2=94=94=E2=94=80sda3        8:3    0  12.3G  0 part [SWAP]
sdb           8:16   0 447.1G  0 disk
=E2=94=94=E2=94=80sdb1        8:17   0 447.1G  0 part
nvme0n1     259:0    0 931.5G  0 disk
=E2=94=94=E2=94=80nvme0n1p1 259:1    0 931.5G  0 part /mnt/D
vlad@vlad:~$ sudo mount /dev/sdb1 "/media/vlad"
[sudo] password for vlad:
mount: /media/vlad: fsconfig() failed: /dev/sdb1: Can't open blockdev.
       dmesg(1) may have more information after failed mount system call.

vlad@vlad:~$ sudo dmesg | tail -47
[ 6198.471989] usb 2-1: USB disconnect, device number 19
[ 6272.215781] atkbd serio0: Unknown key pressed (translated set 2,
code 0x85 on isa0060/serio0).
[ 6272.215806] atkbd serio0: Use 'setkeycodes e005 <keycode>' to make it kn=
own.
[ 6424.980207] usb 2-1: new SuperSpeed USB device number 20 using xhci_hcd
[ 6425.005115] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[ 6425.005137] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 6425.005146] usb 2-1: Product: Ugreen Storage Device
[ 6425.005153] usb 2-1: Manufacturer: Ugreen
[ 6425.005160] usb 2-1: SerialNumber: 133309270601
[ 6425.032533] usb 2-1: Enable of device-initiated U1 failed.
[ 6425.033121] usb 2-1: Enable of device-initiated U2 failed.
[ 6425.062658] usb 2-1: Enable of device-initiated U1 failed.
[ 6425.063217] usb 2-1: Enable of device-initiated U2 failed.
[ 6425.066336] scsi host2: uas
[ 6425.186764] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[ 6425.219372] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 6425.225775] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 6425.227737] sd 2:0:0:0: [sdb] Write Protect is off
[ 6425.227741] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[ 6425.230847] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 6425.292553] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[ 6425.292557] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[ 6425.354157]  sdb: sdb1
[ 6425.354460] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 6462.483040] sd 2:0:0:0: [sdb] tag#23 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD IN
[ 6462.483057] sd 2:0:0:0: [sdb] tag#23 CDB: Read(10) 28 00 00 5f e6
38 00 00 08 00
[ 6462.502896] scsi host2: uas_eh_device_reset_handler start
[ 6462.624188] usb 2-1: reset SuperSpeed USB device number 20 using xhci_hc=
d
[ 6462.707451] usb 2-1: Enable of device-initiated U1 failed.
[ 6462.708487] usb 2-1: Enable of device-initiated U2 failed.
[ 6462.709741] scsi host2: uas_eh_device_reset_handler success
[ 6472.942750] sd 2:0:0:0: [sdb] tag#23 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD
[ 6472.942770] sd 2:0:0:0: [sdb] tag#23 CDB: Test Unit Ready 00 00 00 00 00=
 00
[ 6472.942778] scsi host2: uas_eh_device_reset_handler start
[ 6473.063528] usb 2-1: reset SuperSpeed USB device number 20 using xhci_hc=
d
[ 6473.145743] usb 2-1: Enable of device-initiated U1 failed.
[ 6473.146629] usb 2-1: Enable of device-initiated U2 failed.
[ 6473.147648] scsi host2: uas_eh_device_reset_handler success
[ 6473.147668] sd 2:0:0:0: Device offlined - not ready after error recovery
[ 6473.147695] sd 2:0:0:0: [sdb] tag#23 FAILED Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK cmd_age=3D41s
[ 6473.147705] sd 2:0:0:0: [sdb] tag#23 CDB: Read(10) 28 00 00 5f e6
38 00 00 08 00
[ 6473.147711] I/O error, dev sdb, sector 6284856 op 0x0:(READ) flags
0x0 phys_seg 1 prio class 2
[ 6473.147794] ntfs3(sdb1): failed to read volume at offset 0xbfbc7000
[ 6473.147817] ntfs3(sdb1): Failed to initialize $Bitmap (-5).
[ 6735.578087] usb 2-1: USB disconnect, device number 20
[ 6735.646048] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 6735.978386] sd 2:0:0:0: [sdb] Synchronize Cache(10) failed: Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
vlad@vlad:~$






=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D






When I connected the SDSSDA-480G SSD using the ORICO-25PW1-U3
enclosure with our cable, I clicked mount in Thunar, got an error,
then clicked mount again, and got an error, and then again, and also
got an error, But then I clicked, and it finally mounted, here are the
dmesgs:

vlad@vlad:~$ sudo dmesg | tail -200
[ 2368.457328] usb 2-1: new SuperSpeed USB device number 13 using xhci_hcd
[ 2368.474983] usb 2-1: New USB device found, idVendor=3D152d,
idProduct=3D0583, bcdDevice=3D32.02
[ 2368.475004] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 2368.475014] usb 2-1: Product: JMicron
[ 2368.475021] usb 2-1: Manufacturer: JMicron
[ 2368.475027] usb 2-1: SerialNumber: DD564198838A1
[ 2368.485166] scsi host2: uas
[ 2368.486461] scsi 2:0:0:0: Direct-Access     JMicron  Tech
  3202 PQ: 0 ANSI: 6
[ 2368.490199] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 2368.491400] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 2368.491416] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[ 2368.491639] sd 2:0:0:0: [sdb] Write Protect is off
[ 2368.491652] sd 2:0:0:0: [sdb] Mode Sense: 53 00 00 08
[ 2368.492048] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 2368.492064] sd 2:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
[ 2368.492074] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
not a multiple of preferred minimum block size (4096 bytes)
[ 2368.517926]  sdb: sdb1
[ 2368.518050] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 2371.058610] sd 2:0:0:0: [sdb] tag#2 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_OK cmd_age=3D0s
[ 2371.058616] sd 2:0:0:0: [sdb] tag#2 Sense Key : Medium Error [current]
[ 2371.058619] sd 2:0:0:0: [sdb] tag#2 Add. Sense: Unrecovered read error
[ 2371.058622] sd 2:0:0:0: [sdb] tag#2 CDB: Read(10) 28 00 00 5f e6 30
00 00 08 00
[ 2371.058623] critical medium error, dev sdb, sector 6284848 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[ 2371.058696] ntfs3(sdb1): failed to read volume at offset 0xbfbc6000
[ 2371.058701] ntfs3(sdb1): Failed to initialize $Bitmap (-5).
[ 2374.808546] sd 2:0:0:0: [sdb] tag#3 FAILED Result: hostbyte=3DDID_OK
driverbyte=3DDRIVER_OK cmd_age=3D0s
[ 2374.808554] sd 2:0:0:0: [sdb] tag#3 Sense Key : Medium Error [current]
[ 2374.808558] sd 2:0:0:0: [sdb] tag#3 Add. Sense: Unrecovered read error
[ 2374.808561] sd 2:0:0:0: [sdb] tag#3 CDB: Read(10) 28 00 00 5f e6 08
00 00 08 00
[ 2374.808564] critical medium error, dev sdb, sector 6284808 op
0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[ 2374.808632] ntfs3(sdb1): failed to read volume at offset 0xbfbc1000
[ 2374.808640] ntfs3(sdb1): Failed to initialize $Bitmap (-5).
vlad@vlad:~$



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D






here is the "lsusb -v" output of SDSSDA-480G + US221-30848:

Bus 002 Device 015: ID 0bda:9201 Realtek Semiconductor Corp. Ugreen
Storage Device
Couldn't open device, some information will be missing
Negotiated speed: SuperSpeed (5Gbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.20
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x9201 Ugreen Storage Device
  bcdDevice           f2.00
  iManufacturer           1 Ugreen
  iProduct                2 Ugreen Storage Device
  iSerial                 3 133309270601
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0079
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              896mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     98
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             32
        Data-in pipe (0x03)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             32
        Data-out pipe (0x04)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             32
        Status pipe (0x02)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
        Command pipe (0x01)



:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



here is the "lsusb -t" output of SDSSDA-480G + US221-30848:


vlad@vlad:~$ lsusb -t
/:  Bus 001.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dxhci_hcd/12p, 480=
M
    |__ Port 002: Dev 011, If 0, Class=3DHuman Interface Device,
Driver=3Dusbhid, 12M
    |__ Port 002: Dev 011, If 1, Class=3DHuman Interface Device,
Driver=3Dusbhid, 12M
    |__ Port 002: Dev 011, If 2, Class=3DHuman Interface Device,
Driver=3Dusbhid, 12M
    |__ Port 002: Dev 011, If 3, Class=3DHuman Interface Device,
Driver=3Dusbhid, 12M
    |__ Port 007: Dev 003, If 0, Class=3DWireless, Driver=3Dbtusb, 12M
    |__ Port 007: Dev 003, If 1, Class=3DWireless, Driver=3Dbtusb, 12M
    |__ Port 008: Dev 004, If 0, Class=3DVendor Specific Class, Driver=3D[n=
one], 12M
    |__ Port 009: Dev 005, If 0, Class=3DVideo, Driver=3Duvcvideo, 480M
    |__ Port 009: Dev 005, If 1, Class=3DVideo, Driver=3Duvcvideo, 480M
/:  Bus 002.Port 001: Dev 001, Class=3Droot_hub, Driver=3Dxhci_hcd/6p, 5000=
M
    |__ Port 001: Dev 010, If 0, Class=3DMass Storage, Driver=3Duas, 5000M





=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D






I connected SDSSDA-480G + US221-30848 again, clicked mount in
Thunar,it took alot, then as usual, gave me 1st error, then clicked
again to mount, and it gave 2nd error, then an error when I clicked
again

so I used these commands to fetch some info:

sudo dmesg > dmesg.log
sudo lsusb -v > lsusb.log
sudo lspci -nn > lspci.log



and here are PARTS of the contents of the files:




=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
dmesg.log
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


[ 6888.926754] usb 2-1: new SuperSpeed USB device number 26 using xhci_hcd
[ 6888.951136] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[ 6888.951159] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[ 6888.951168] usb 2-1: Product: Ugreen Storage Device
[ 6888.951176] usb 2-1: Manufacturer: Ugreen
[ 6888.951182] usb 2-1: SerialNumber: 133309270601
[ 6888.981567] usb 2-1: Enable of device-initiated U1 failed.
[ 6888.982136] usb 2-1: Enable of device-initiated U2 failed.
[ 6889.011638] usb 2-1: Enable of device-initiated U1 failed.
[ 6889.012404] usb 2-1: Enable of device-initiated U2 failed.
[ 6889.015947] scsi host2: uas
[ 6889.136492] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[ 6889.169136] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 6889.175613] sd 2:0:0:0: [sdb] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[ 6889.177538] sd 2:0:0:0: [sdb] Write Protect is off
[ 6889.177541] sd 2:0:0:0: [sdb] Mode Sense: 37 00 00 08
[ 6889.180760] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 6889.231051] sd 2:0:0:0: [sdb] Preferred minimum I/O size 512 bytes
[ 6889.231055] sd 2:0:0:0: [sdb] Optimal transfer size 33553920 bytes
[ 6889.288147]  sdb: sdb1
[ 6889.288568] sd 2:0:0:0: [sdb] Attached SCSI disk
[ 6925.001524] sd 2:0:0:0: [sdb] tag#4 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD IN
[ 6925.001546] sd 2:0:0:0: [sdb] tag#4 CDB: Read(10) 28 00 00 5f e6 40
00 00 08 00
[ 6925.025240] scsi host2: uas_eh_device_reset_handler start
[ 6925.146114] usb 2-1: reset SuperSpeed USB device number 26 using xhci_hc=
d
[ 6925.226227] usb 2-1: Enable of device-initiated U1 failed.
[ 6925.227005] usb 2-1: Enable of device-initiated U2 failed.
[ 6925.228214] scsi host2: uas_eh_device_reset_handler success
[ 6935.461294] sd 2:0:0:0: [sdb] tag#4 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD
[ 6935.461315] sd 2:0:0:0: [sdb] tag#4 CDB: Test Unit Ready 00 00 00 00 00 =
00
[ 6935.461324] scsi host2: uas_eh_device_reset_handler start
[ 6935.582006] usb 2-1: reset SuperSpeed USB device number 26 using xhci_hc=
d
[ 6935.664684] usb 2-1: Enable of device-initiated U1 failed.
[ 6935.665405] usb 2-1: Enable of device-initiated U2 failed.
[ 6935.666436] scsi host2: uas_eh_device_reset_handler success
[ 6935.666452] sd 2:0:0:0: Device offlined - not ready after error recovery
[ 6935.666475] sd 2:0:0:0: [sdb] tag#4 FAILED Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK cmd_age=3D42s
[ 6935.666484] sd 2:0:0:0: [sdb] tag#4 CDB: Read(10) 28 00 00 5f e6 40
00 00 08 00
[ 6935.666490] I/O error, dev sdb, sector 6284864 op 0x0:(READ) flags
0x0 phys_seg 1 prio class 2
[ 6935.666583] ntfs3(sdb1): failed to read volume at offset 0xbfbc8000
[ 6935.666600] ntfs3(sdb1): Failed to initialize $Bitmap (-5).
















=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
lsusb.log
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Negotiated speed: High Speed (480Mbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         1 Single TT
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            6.12
  iManufacturer           3 Linux 6.12.57+deb13-amd64 xhci-hcd
  iProduct                2 xHCI Host Controller
  iSerial                 1 0000:00:14.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0019
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength              11
  bDescriptorType      41
  nNbrPorts            12
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
    TT think time 8 FS bits
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x98 0x07
  PortPwrCtrlMask    0xff 0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0103 power enable connect
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
   Port 7: 0000.0107 power suspend enable connect
   Port 8: 0000.0107 power suspend enable connect
   Port 9: 0000.0507 highspeed power suspend enable connect
   Port 10: 0000.0100 power
   Port 11: 0000.0100 power
   Port 12: 0000.0100 power
Device Status:     0x0001
  Self Powered



.
.
.




Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 [unknown]
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)




.
.
.




Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Negotiated speed: SuperSpeed (5Gbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         3
  bMaxPacketSize0         9
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0003 3.0 root hub
  bcdDevice            6.12
  iManufacturer           3 Linux 6.12.57+deb13-amd64 xhci-hcd
  iProduct                2 xHCI Host Controller
  iSerial                 1 0000:00:14.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x001f
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
        bMaxBurst               0
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x000f
  bNumDeviceCaps          1
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x02
      Latency Tolerance Messages (LTM) Supported
    wSpeedsSupported   0x0008
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat         512 micro seconds
Hub Descriptor:
  bLength              12
  bDescriptorType      42
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  bHubDecLat          0.0 micro seconds
  wHubDelay             0 nano seconds
  DeviceRemovable    0x10
 Hub Port Status:
   Port 1: 0000.0203 5Gbps power U0 enable connect
   Port 2: 0000.02a0 5Gbps power Rx.Detect
   Port 3: 0000.02a0 5Gbps power Rx.Detect
   Port 4: 0000.02a0 5Gbps power Rx.Detect
   Port 5: 0000.02a0 5Gbps power Rx.Detect
   Port 6: 0000.02a0 5Gbps power Rx.Detect
Device Status:     0x0001
  Self Powered

Bus 002 Device 026: ID 0bda:9201 Realtek Semiconductor Corp. Ugreen
Storage Device
Negotiated speed: SuperSpeed (5Gbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.20
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x9201 Ugreen Storage Device
  bcdDevice           f2.00
  iManufacturer           1 Ugreen
  iProduct                2 Ugreen Storage Device
  iSerial                 3 133309270601
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0079
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              896mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     98
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             32
        Data-in pipe (0x03)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             32
        Data-out pipe (0x04)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             32
        Status pipe (0x02)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
        Command pipe (0x01)
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength       0x002a
  bNumDeviceCaps          3
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000006
      BESL Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat        2047 micro seconds
  SuperSpeedPlus USB Device Capability:
    bLength                20
    bDescriptorType        16
    bDevCapabilityType     10
    bmAttributes         0x00000001
      Sublink Speed Attribute count 2
      Sublink Speed ID count 1
    wFunctionalitySupport   0x1100
      Min functional Speed Attribute ID: 0
      Min functional RX lanes: 1
      Min functional TX lanes: 1
    bmSublinkSpeedAttr[0]   0x000a4030
      Speed Attribute ID: 0 10Gb/s Symmetric RX SuperSpeedPlus
    bmSublinkSpeedAttr[1]   0x000a40b0
      Speed Attribute ID: 0 10Gb/s Symmetric TX SuperSpeedPlus
Device Status:     0x0000
  (Bus Powered)












=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
lspci.log
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v6/7th Gen
Core Processor Host Bridge/DRAM Registers [8086:5914] (rev 08)
00:02.0 VGA compatible controller [0300]: Intel Corporation UHD
Graphics 620 [8086:5917] (rev 07)
00:04.0 Signal processing controller [1180]: Intel Corporation Xeon
E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem
[8086:1903] (rev 08)
00:14.0 USB controller [0c03]: Intel Corporation Sunrise Point-LP USB
3.0 xHCI Controller [8086:9d2f] (rev 21)
00:14.2 Signal processing controller [1180]: Intel Corporation Sunrise
Point-LP Thermal subsystem [8086:9d31] (rev 21)
00:15.0 Signal processing controller [1180]: Intel Corporation Sunrise
Point-LP Serial IO I2C Controller #0 [8086:9d60] (rev 21)
00:15.1 Signal processing controller [1180]: Intel Corporation Sunrise
Point-LP Serial IO I2C Controller #1 [8086:9d61] (rev 21)
00:16.0 Communication controller [0780]: Intel Corporation Sunrise
Point-LP CSME HECI #1 [8086:9d3a] (rev 21)
00:17.0 SATA controller [0106]: Intel Corporation Sunrise Point-LP
SATA Controller [AHCI mode] [8086:9d03] (rev 21)
00:1c.0 PCI bridge [0604]: Intel Corporation Sunrise Point-LP PCI
Express Root Port #4 [8086:9d13] (rev f1)
00:1d.0 PCI bridge [0604]: Intel Corporation Sunrise Point-LP PCI
Express Root Port #9 [8086:9d18] (rev f1)
00:1e.0 Signal processing controller [1180]: Intel Corporation Sunrise
Point-LP Serial IO UART Controller #0 [8086:9d27] (rev 21)
00:1e.6 SD Host controller [0805]: Intel Corporation Sunrise Point-LP
Secure Digital IO Controller [8086:9d2d] (rev 21)
00:1f.0 ISA bridge [0601]: Intel Corporation Sunrise Point LPC/eSPI
Controller [8086:9d4e] (rev 21)
00:1f.2 Memory controller [0580]: Intel Corporation Sunrise Point-LP
PMC [8086:9d21] (rev 21)
00:1f.3 Audio device [0403]: Intel Corporation Sunrise Point-LP HD
Audio [8086:9d71] (rev 21)
00:1f.4 SMBus [0c05]: Intel Corporation Sunrise Point-LP SMBus
[8086:9d23] (rev 21)
00:1f.6 Ethernet controller [0200]: Intel Corporation Ethernet
Connection (4) I219-V [8086:15d8] (rev 21)
01:00.0 Network controller [0280]: Intel Corporation Wireless 8265 /
8275 [8086:24fd] (rev 78)
02:00.0 Non-Volatile memory controller [0108]: Sandisk Corp WD Blue
SN580 NVMe SSD (DRAM-less) [15b7:5041] (rev 01)




=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D






So I did a test on Arch




on Arch:

system info:

OS: Arch Linux x86_64
Host: HP ProBook 650 G4 (SBKPF)
Kernel: Linux 6.18.2-arch2-1
Shell: bash 5.3.9
DE: Xfce4 4.20
WM: Xfwm4 (X11)
Terminal: xfce4-terminal 1.1.5
CPU: Intel(R) Core(TM) i5-8250U (8) @ 3.40 GHz
GPU: Intel UHD Graphics 620 @ 1.10 GHz [Integrated]
Memory: 933.17 MiB / 15.00 GiB (6%)






After I connected the SDSSDA-480G SSD in the US221-30848 enclosure,
same issue, I clicked mount in Thunar and got the 1st error, then,
clicked again and got that 2nd error, and I kept getting errors each
time I clicked on the drive to mount it, till I reconnected the drive.




[vlad@vlad ~]$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 447.1G  0 disk
=E2=94=94=E2=94=80sda1        8:1    0 447.1G  0 part
nvme0n1     259:0    0 238.5G  0 disk
=E2=94=9C=E2=94=80nvme0n1p1 259:1    0     1G  0 part /boot
=E2=94=9C=E2=94=80nvme0n1p2 259:2    0    32G  0 part /
=E2=94=94=E2=94=80nvme0n1p3 259:3    0 205.5G  0 part /home
[vlad@vlad ~]$ lsblk -f
NAME FSTYPE FSVER LABEL      UUID
FSAVAIL FSUSE% MOUNTPOINTS
sda
=E2=94=94=E2=94=80sda1
     ntfs         New Volume 7A4E55864E553BD7
nvme0n1
=E2=94=82
=E2=94=9C=E2=94=80nvme0n1p1
=E2=94=82    vfat   FAT32            6F1C-F7E7
977M     4% /boot
=E2=94=9C=E2=94=80nvme0n1p2
=E2=94=82    ext4   1.0              5477566d-a2c7-475c-860e-7906972aff69
25G    15% /
=E2=94=94=E2=94=80nvme0n1p3
     ext4   1.0              5d00f980-676e-4e9c-9fc3-3c2d00b8de43
190.8G     0% /home
[vlad@vlad ~]$ dmesg | tail -n 50
dmesg: read kernel buffer failed: Operation not permitted
[vlad@vlad ~]$ sudo lsblk
-f=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

For security reasons, the password you type will not be visible.

[sudo] password for vlad:
NAME        FSTYPE FSVER LABEL      UUID
  FSAVAIL FSUSE% MOUNTPOINTS
sda
=E2=94=94=E2=94=80sda1      ntfs         New Volume 7A4E55864E553BD7
nvme0n1
=E2=94=9C=E2=94=80nvme0n1p1 vfat   FAT32            6F1C-F7E7
     977M     4% /boot
=E2=94=9C=E2=94=80nvme0n1p2 ext4   1.0
5477566d-a2c7-475c-860e-7906972aff69     25G    15% /
=E2=94=94=E2=94=80nvme0n1p3 ext4   1.0
5d00f980-676e-4e9c-9fc3-3c2d00b8de43  190.8G     0% /home
[vlad@vlad ~]$ sudo dmesg | tail -n
50=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
[   32.520566] block nvme0n1: No UUID available providing old NGUID
[   54.091725] sda: detected capacity change from 30720000 to 0
[  179.577931] wlan0: authenticate with 8c:0d:76:3a:39:00 (local
address=3D68:ec:c5:2b:29:38)
[  179.579194] wlan0: send auth to 8c:0d:76:3a:39:00 (try 1/3)
[  179.587003] wlan0: authenticated
[  179.587877] wlan0: associate with 8c:0d:76:3a:39:00 (try 1/3)
[  179.591997] wlan0: RX AssocResp from 8c:0d:76:3a:39:00 (capab=3D0x411
status=3D0 aid=3D2)
[  179.600589] wlan0: associated
[  205.238992] usb 2-1: USB disconnect, device number 2
[  220.231747] usb 2-1: new SuperSpeed USB device number 3 using xhci_hcd
[  220.253571] usb 2-1: New USB device found, idVendor=3D0bda,
idProduct=3D9201, bcdDevice=3Df2.00
[  220.253587] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[  220.253595] usb 2-1: Product: Ugreen Storage Device
[  220.253601] usb 2-1: Manufacturer: Ugreen
[  220.253606] usb 2-1: SerialNumber: 133309270601
[  220.280236] usb 2-1: enable of device-initiated U1 failed.
[  220.280747] usb 2-1: disable of device-initiated U1 failed.
[  220.310370] usb 2-1: enable of device-initiated U1 failed.
[  220.313708] scsi host2: uas
[  220.434060] scsi 2:0:0:0: Direct-Access     SanDisk  SSD PLUS 480GB
  1.02 PQ: 0 ANSI: 6
[  220.473866] sd 2:0:0:0: [sda] 937721856 512-byte logical blocks:
(480 GB/447 GiB)
[  220.475793] sd 2:0:0:0: [sda] Write Protect is off
[  220.475801] sd 2:0:0:0: [sda] Mode Sense: 37 00 00 08
[  220.479166] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  220.507580] sd 2:0:0:0: [sda] Preferred minimum I/O size 512 bytes
[  220.507593] sd 2:0:0:0: [sda] Optimal transfer size 33553920 bytes
[  220.548214]  sda: sda1
[  220.548578] sd 2:0:0:0: [sda] Attached SCSI disk
[  222.509335] ntfs3: Enabled Linux POSIX ACLs support
[  222.509341] ntfs3: Read-only LZX/Xpress compression included
[  253.735742] sd 2:0:0:0: [sda] tag#2 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD IN
[  253.735763] sd 2:0:0:0: [sda] tag#2 CDB: Read(10) 28 00 00 5f e6 30
00 00 08 00
[  253.741789] scsi host2: uas_eh_device_reset_handler start
[  253.854487] usb 2-1: reset SuperSpeed USB device number 3 using xhci_hcd
[  253.895467] usb 2-1: disable of device-initiated U1 failed.
[  253.925010] usb 2-1: enable of device-initiated U1 failed.
[  253.925515] scsi host2: uas_eh_device_reset_handler success
[  263.954775] sd 2:0:0:0: [sda] tag#2 uas_eh_abort_handler 0 uas-tag
1 inflight: CMD
[  263.954785] sd 2:0:0:0: [sda] tag#2 CDB: Test Unit Ready 00 00 00 00 00 =
00
[  263.954789] scsi host2: uas_eh_device_reset_handler start
[  264.067377] usb 2-1: reset SuperSpeed USB device number 3 using xhci_hcd
[  264.113651] usb 2-1: disable of device-initiated U1 failed.
[  264.143535] usb 2-1: enable of device-initiated U1 failed.
[  264.144193] scsi host2: uas_eh_device_reset_handler success
[  264.144213] sd 2:0:0:0: Device offlined - not ready after error recovery
[  264.144239] sd 2:0:0:0: [sda] tag#2 FAILED Result:
hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK cmd_age=3D40s
[  264.144248] sd 2:0:0:0: [sda] tag#2 CDB: Read(10) 28 00 00 5f e6 30
00 00 08 00
[  264.144252] I/O error, dev sda, sector 6284848 op 0x0:(READ) flags
0x0 phys_seg 1 prio class 2
[  264.144302] ntfs3(sda1): failed to read volume at offset 0xbfbc6000
[  264.144314] ntfs3(sda1): Failed to initialize $Bitmap (-5).
[vlad@vlad ~]$
