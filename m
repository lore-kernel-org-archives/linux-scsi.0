From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups
Date: Sat, 27 Nov 2004 01:40:00 +0100
Message-ID: <20041127004000.GA23180@merlin.emma.line.org>
References: <4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org> <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org> <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de> <m3actaw0pv.fsf@merlin.emma.line.org> <20041122133014.GF25636@parcelfarce.linux.theplanet.co.uk> <m3mzxaq8ra.fsf@merlin.emma.line.org> <Pine.LNX.4.61.0411261512320.14112@ligeti.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:56963 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S263067AbUK0AkJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 19:40:09 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0411261512320.14112@ligeti.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Winterfeldt <snwint@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Steffen Winterfeldt schrieb am 2004-11-26:

> It was indeed libsysfs reading the config space accidentally when one 
> (well, I) wouldn't expect it to do this.
> 
> If you want to try the fixed hwinfo package (hwinfo-8.70), it's here:
> 
> ftp://ftp.suse.com/pub/people/snwint/9.1/hwinfo/

Thanks.

We may need updated *udev* packages, too (at least for SuSE Linux 9.1).

The hwinfo-8.70-0.2 update alone doesn't appear to help, I still see parity
errors and still see 256-byte reads from
/sys/devices/pci0000:00/0000:00:0d.0/config (my SYM53C875's config space),
strace below

I also see that libsysfs is in the "udev-021-36" RPM on my system and
also on SuSE 9.2:

$ rpm -qf /usr/sbin/hwscan
hwinfo-8.70-0.2
$ ldd /usr/sbin/hwscan | awk '{print $3}' | xargs -tn1 rpm -qf
...(glibc, linker, gate and tls stripped)...
rpm -qf /usr/lib/libhd.so.8 
hwinfo-8.70-0.2
rpm -qf /lib/libsysfs.so.1 
udev-021-36

The kernel (vanilla 2.6.9) still begs that hwinfo be converted to SG_IO.

strace extract, relevant line marked with >
  
  22602 lstat("/sys/bus/pci/drivers/sata_via/0000:00:0d.0", 0xbfffe85c) = -1 ENOENT (No such file or directory)
  22602 lstat("/sys/bus/pci/drivers/serial/0000:00:0d.0", 0xbfffe85c) = -1 ENOENT (No such file or directory)
  22602 lstat("/sys/bus/pci/drivers/sym53c8xx/0000:00:0d.0", {st_mode=S_IFLNK|0777, st_size=0, ...}) = 0
  22602 lstat("/sys/devices/pci0000:00/0000:00:0d.0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
  22602 open("/sys/devices/pci0000:00/0000:00:0d.0", O_RDONLY|O_DIRECTORY) = 3
  22602 getdents(3, /* 13 entries */, 4020) = 268
  22602 lstat("/sys/devices/pci0000:00/0000:00:0d.0/host0", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
  22602 lstat("/sys/devices/pci0000:00/0000:00:0d.0/config", {st_mode=S_IFREG|0644, st_size=256, ...}) = 0
  22602 stat("/sys/devices/pci0000:00/0000:00:0d.0/config", {st_mode=S_IFREG|0644, st_size=256, ...}) = 0
> 22602 open("/sys/devices/pci0000:00/0000:00:0d.0/config", O_RDONLY) = 4
> 22602 read(4, "\0\20\17\0\27\0\20\2&\0\0\1\20 \0\0\1\320\0\0\0\0\200\344"..., 4096) = 256
  22602 close(4)                          = 0

Full strace available upon request, expect around 60 kB bzip2ed or 2.5 MB
uncompressed.

$ /sbin/lspci -s 0000:00:0d.0
0000:00:0d.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)

-- 
Matthias Andree
