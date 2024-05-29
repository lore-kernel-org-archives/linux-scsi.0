Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE0C1C6887
	for <linux-scsi@vger.kernel.org>; Wed, 29 May 2024 20:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717015862; cv=none; b=gk1TY2/nxPYGZXNxyJiqdqbf30r9QvHaLpyQtMibG145Y9qu4n2egCzVk6CfJLu0dvb2+vBRFeUgVFlHN1KycTWi/fIvg8bxKExaEDzCW7pyFpH53Cw34teiArR58WdfyqI+acaa9dxBrPJpGW+mr9UoGDbRH9YktzPceruVpiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717015862; c=relaxed/simple;
	bh=539hEqnmBZN3LZxEQOXsccZpq0tgKaxCwS/17v/SP1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ec8/HkIxpZjNQt5++CFEYJhKnWHrv1UtRnozpeo/WeezxMo24Xke9+5NcLuge25h+KzZ3m5WoW7qB3r9bkstCjBI/pJDdW2UlNJ1xO0rfHVZHp8/2bLMx8e2iNzstqWktbGjZVZLnEVB3yTdeoLmpe+rdTKeCENcq/bWLLlTcko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mCT26shB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mCT26shB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqM3m02nyz6Cnk97;
	Wed, 29 May 2024 20:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717015854; x=1719607855; bh=hLx1LCgtNmuK685ryrFVnw4O
	xj5zeXTZWjF0+kR0oY0=; b=mCT26shBIUJTgOKvxvFdQ1lptKqlai92XnBBql8z
	ZO/C4hKDjDwpGAXVD1atgpKls5Td/Jom+kQIO7H6cw1WkxxhJ2M4VexMejZrqdzb
	CFYvNXX/Z23DZC9Sc+ujLIi0v52wPy+cXZvzkrZNTWPt8AvqubshJe6cyOCaYPza
	qK7y4NaE9gEN9coMj7FktGlSeK1Ee+p5TWl4zxuDzDG23Am2hIiza+C61RecS2UH
	WJhXhagCnRZyF85P8/BEq+Zq8/p4QejtbICmoZL8pUXpGdkd3ZWKI8rZ1SxROcVU
	oRYxn7AGm8KENBetcCVLlkz9fMDeQiGOF86y979n7B7KYg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PKOP457acvJ0; Wed, 29 May 2024 20:50:54 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqM3f3Y3nz6Cnk95;
	Wed, 29 May 2024 20:50:54 +0000 (UTC)
Message-ID: <493e6372-cb4d-4f1f-9803-17d37a0fcbc4@acm.org>
Date: Wed, 29 May 2024 13:50:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] USB flash drive unusable with constant resets, since
 commit 4f53138fff
To: Joao Machado <jocrismachado@gmail.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 regressions@lists.linux.dev
References: <CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/26/24 07:53, Joao Machado wrote:
> Linux Distribution: Archlinux
> Kernel version: 6.9.1
>=20
> Noticed my "Kingston DataTraveler G2" is unusable on kernel 6.9.x, cons=
tantly resetting in a loop:
>=20
> May 21 21:42:46 oldell kernel: usb 1-1.3: new high-speed USB device num=
ber 4 using ehci-pci
> May 21 21:42:46 oldell kernel: usb 1-1.3: New USB device found, idVendo=
r=3D0951, idProduct=3D1624, bcdDevice=3D 1.00
> May 21 21:42:46 oldell kernel: usb 1-1.3: New USB device strings: Mfr=3D=
1, Product=3D2, SerialNumber=3D3
> May 21 21:42:46 oldell kernel: usb 1-1.3: Product: DataTraveler G2
> May 21 21:42:46 oldell kernel: usb 1-1.3: Manufacturer: Kingston
> May 21 21:42:46 oldell kernel: usb 1-1.3: SerialNumber: 0014780F9955F97=
1A5EC08D7
> May 21 21:42:47 oldell kernel: usb-storage 1-1.3:1.0: USB Mass Storage =
device detected
> May 21 21:42:47 oldell kernel: scsi host6: usb-storage 1-1.3:1.0
> May 21 21:42:47 oldell kernel: usbcore: registered new interface driver=
 usb-storage
> May 21 21:42:47 oldell kernel: usbcore: registered new interface driver=
 uas
> May 21 21:42:48 oldell kernel: scsi 6:0:0:0: Direct-Access =C2=A0 =C2=A0=
 Kingston DataTraveler G2 =C2=A01.00 PQ: 0 ANSI: 2
> May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] 15654848 512-byte logi=
cal blocks: (8.02 GB/7.46 GiB)
> May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Write Protect is off
> May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Mode Sense: 16 24 09 5=
1
> May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Incomplete mode parame=
ter data
> May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Assuming drive cache: =
write through
> May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:50 oldell kernel: usb 1-1.3: reset high-speed USB device n=
umber 4 using ehci-pci
> May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 FAILED Result: h=
ostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
> May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 Sense Key : Unit=
 Attention [current]
> May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 Add. Sense: Not =
ready to ready change, medium may have changed
> May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 CDB: Read(10) 28=
 00 00 00 00 00 00 00 08 00
>=20
> This is not affecting all USB flash drive models. For instance, this de=
vice works fine:
>=20
> |May 23 20:15:37 oldell kernel: usb 2-1.2: new high-speed USB device nu=
mber 9 using ehci-pci May 23 20:15:37 oldell kernel: usb 2-1.2: New USB d=
evice found, idVendor=3D6557, idProduct=3D2031, bcdDevice=3D 1.10 May 23 =
20:15:37 oldell kernel: usb 2-1.2: New USB device strings:=20
> Mfr=3D1, Product=3D2, SerialNumber=3D3 May 23 20:15:37 oldell kernel: u=
sb 2-1.2: Product: USB DISK 3.0 May 23 20:15:37 oldell kernel: usb 2-1.2:=
 Manufacturer: May 23 20:15:37 oldell kernel: usb 2-1.2: SerialNumber: 07=
0D393C83CB5024 May 23 20:15:37 oldell kernel: usb-storage=20
> 2-1.2:1.0: USB Mass Storage device detected May 23 20:15:37 oldell kern=
el: scsi host6: usb-storage 2-1.2:1.0 May 23 20:15:37 oldell mtp-probe[23=
00]: checking bus 2, device 9: "/sys/devices/pci0000:00/0000:00:1d.0/usb2=
/2-1/2-1.2" May 23 20:15:37 oldell mtp-probe[2300]:=20
> bus: 2, device: 9 was not an MTP device May 23 20:15:37 oldell mtp-prob=
e[2301]: checking bus 2, device 9: "/sys/devices/pci0000:00/0000:00:1d.0/=
usb2/2-1/2-1.2" May 23 20:15:37 oldell mtp-probe[2301]: bus: 2, device: 9=
 was not an MTP device May 23 20:15:38 oldell kernel:=20
> scsi 6:0:0:0: Direct-Access USB DISK 3.0 PMAP PQ: 0 ANSI: 6 May 23 20:1=
5:39 oldell kernel: sd 6:0:0:0: [sdb] 121145344 512-byte logical blocks: =
(62.0 GB/57.8 GiB) May 23 20:15:39 oldell kernel: sd 6:0:0:0: [sdb] Write=
 Protect is off May 23 20:15:39 oldell kernel: sd=20
> 6:0:0:0: [sdb] Mode Sense: 45 00 00 00 May 23 20:15:39 oldell kernel: s=
d 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't supp=
ort DPO or FUA May 23 20:15:39 oldell kernel: sdb: sdb1 sdb2 May 23 20:15=
:39 oldell kernel: sd 6:0:0:0: [sdb] Attached SCSI=20
> removable disk|
>=20
> Proceeded to bisect the kernel, which points to commit 4f53138fffc2b183=
96859aa4ff3e7ef2b0839c2b <https://git.kernel.org/pub/scm/linux/kernel/git=
/torvalds/linux.git/commit/?id=3D4f53138fffc2b18396859aa4ff3e7ef2b0839c2b=
> causing the issue to surface.
> Changing USB port made no difference. Tried the same device on a differ=
ent computer using kernel 6.9.2 - issue replicates.
>=20
> Attached bisection log, systemd journal kernel logs.

Thank you for the detailed report and also for having bisected this issue=
.
Does the patch below help (compile-tested only)?

Thanks,

Bart.


---
  drivers/scsi/scsi_devinfo.c | 1 +
  drivers/scsi/scsi_scan.c    | 2 ++
  drivers/scsi/sd.c           | 4 ++++
  include/scsi/scsi_devinfo.h | 4 +++-
  4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a7071e71389e..85111e14c53b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -197,6 +197,7 @@ static struct {
  	{"INSITE", "I325VM", NULL, BLIST_KEY},
  	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
  	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY=
_36},
+	{"Kingston", "DataTraveler G2", NULL, BLIST_SKIP_IO_HINTS},
  	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
  	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
  	{"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8300fc28cb10..ca7d14ee4575 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -745,6 +745,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
  		*bflags =3D scsi_get_device_flags(sdev, &inq_result[8],
  				&inq_result[16]);

+		sdev_printk(KERN_INFO, sdev, "bflags =3D %#llx\n", *bflags);
+
  		/* When the first pass succeeds we gain information about
  		 * what larger transfer lengths might work. */
  		if (pass =3D=3D 1) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3a43e2209751..fcf3d7730466 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -63,6 +63,7 @@
  #include <scsi/scsi_cmnd.h>
  #include <scsi/scsi_dbg.h>
  #include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
  #include <scsi/scsi_driver.h>
  #include <scsi/scsi_eh.h>
  #include <scsi/scsi_host.h>
@@ -3117,6 +3118,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp=
, unsigned char *buffer)
  	struct scsi_mode_data data;
  	int res;

+	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
+		return;
+
  	res =3D scsi_mode_sense(sdp, /*dbd=3D*/0x8, /*modepage=3D*/0x0a,
  			      /*subpage=3D*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
  			      sdkp->max_retries, &data, &sshdr);
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 6b548dc2c496..fa8721e49dec 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -69,8 +69,10 @@
  #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
  /* Always retry ABORTED_COMMAND with ASC 0xc1 */
  #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Do not read the I/O hints mode page */
+#define BLIST_SKIP_IO_HINTS	((__force blist_flags_t)(1ULL << 34))

-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS

  #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
  			       (__force blist_flags_t) \

