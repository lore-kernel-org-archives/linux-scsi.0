Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4AD17C7AC
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 10:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717065997; cv=none; b=OOHYltC+K3FZyS/3qN5BH8cmEmUKokzZD11lowyk6rbvp3Ie7tLHkshos0ws0fWM10C7Ba4RsNtuEe0oDDL82xK663S6+1e4Rl+ox7r+l0V8Kmxif00+BTJPi7jV/8+dCmm7WGp+WPKry+uJLBhu06vDECxuoMgPSMM2WqDLXXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717065997; c=relaxed/simple;
	bh=zST0u6NSHfG89InptW92RaG4rh6jfFzmOrvlAGPtDjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=osE4zuSgdk/RW0L5fiTVuVNo3ZAKZke435Ms8b0/yea3n6119/Y/yB9gzqFeSR7S6qiUpZZctGSEVlVhbnQVVkgREHUzCxXlZz4LTQfiCveyLPN6GgokjynLs3GWNKkatu7XAkLc+1CrPP31O8tmfrX+06Aq3d5XYPn2KGIhQ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DyPWpDgN; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DyPWpDgN"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-80ac7385672so265551241.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 May 2024 03:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717065993; x=1717670793; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ruSw7jFllsWUqABwDlx+8Dd+wUCdg1POdA6XGwinqrA=;
        b=DyPWpDgNub5mVavf6WIpfePbzvAHp36BsLx44w7Bo43Ks06v55SU71DkXuU+ApKE06
         bPMGGLYCWntEyacQgWlZMfbl0cUDK/JY3MgJKWnwjezjjBvQWdrb4MwZwUITj6SJkTrp
         tdyEu6Q921tmrwY/mU/oQ05lRMYLF0+p5sSvhUQY23LUM7yuArWOVQldSK3m6YQi5+aK
         /z5L8PJFel1ndqR81H5Zzd3oShHtKgbBqjoZz8jW8N+LgEW/Ks7d0T1TCgZFDk202AwJ
         l9qMsmO4tl8natqdm1dTb75ONhxJ2RfDn6m1YjESZnAKinEp/EE0sknSBxr+FFZ9TJIZ
         pqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717065993; x=1717670793;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ruSw7jFllsWUqABwDlx+8Dd+wUCdg1POdA6XGwinqrA=;
        b=MO1eqnWYan7sBQiXhX2hX7xeq8J9Bnkf4QLJSopIJbSGtx/TsCJ+xvKtb0eOM/LrWi
         RvDn1xc1AxQYuqROTp25ZiBsiYrcPM/XE6ipd3OYvVf0PIM1fcwlmOMwCqFgcpqSBFFB
         IkA6kaTAwRjVWRVGLCJm/Q/HSFrFa5OK5d8QiEZ7VQ8YJOJt+Jw7KfVg/Et0BxQ7Nxmd
         a3G8rCdyWm0YNRa+9K5k5C5G7PEyfvKlwAeomiNUpNe9gux3Ux4KA6kw4972oHhnUX8U
         NoNWrT9dGAUlXSztkWl2ZkInufkUafihB8a5LgKU5vNBFogzZHwySfEg+PiGODjH/8xs
         RSDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqXKcUxmxnQ4jNA3vfVa/60UHcxSgnvbl94e/VdzIfPBhmqpVBb6pRvcWqHuGLtZEGfjcEBttn3vakfiwJAJFeXCJMIoqeERS+uA==
X-Gm-Message-State: AOJu0YwgpOoEnrqAIqu2fiP2RRGMnwqa3YJZEgL11djVKYra0rWWMb5p
	1z/KHiq22lim6HT5Uimvq+a8HM6xaL+vVmuGUH94aO+xTJE/Ok0Smg0DCHbJGdU5NmWn5g0UFJi
	2M1IZfORa2Fi0wJzVWdFUiQfzGK0QOmlD
X-Google-Smtp-Source: AGHT+IGTCUNuqAxX6ztesG1PyL9zAy6UpQYSFmkkxEJxMbHP6ulJ5Iyw1WEfyl0WzqtyGEek80fRvU3ULvG7P7wMFJI=
X-Received: by 2002:a05:6122:d02:b0:4e1:8d63:de74 with SMTP id
 71dfb90a1353d-4eaf2186c91mr1985036e0c.6.1717065991458; Thu, 30 May 2024
 03:46:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com>
 <493e6372-cb4d-4f1f-9803-17d37a0fcbc4@acm.org>
In-Reply-To: <493e6372-cb4d-4f1f-9803-17d37a0fcbc4@acm.org>
From: Joao Machado <jocrismachado@gmail.com>
Date: Thu, 30 May 2024 10:46:19 +0100
Message-ID: <CACLx9VdOeY6ZXEwGp-FOQY5VKJzgN6jJZQMhOdY9WnQjm07KSA@mail.gmail.com>
Subject: Re: [REGRESSION] USB flash drive unusable with constant resets, since
 commit 4f53138fff
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: multipart/mixed; boundary="0000000000007a34f80619a994fb"

--0000000000007a34f80619a994fb
Content-Type: multipart/alternative; boundary="0000000000007a34f60619a994f9"

--0000000000007a34f60619a994f9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tried the patch over commit 1613e604df0. Issue persists.
Attached git and journal logs - notice here usb is using xhci_hcd instead
of ehci-pci, but this is because it's a different computer/environment than
the one originally reported.

Thanks!

On Wed, May 29, 2024 at 9:51=E2=80=AFPM Bart Van Assche <bvanassche@acm.org=
> wrote:

> On 5/26/24 07:53, Joao Machado wrote:
> > Linux Distribution: Archlinux
> > Kernel version: 6.9.1
> >
> > Noticed my "Kingston DataTraveler G2" is unusable on kernel 6.9.x,
> constantly resetting in a loop:
> >
> > May 21 21:42:46 oldell kernel: usb 1-1.3: new high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:46 oldell kernel: usb 1-1.3: New USB device found,
> idVendor=3D0951, idProduct=3D1624, bcdDevice=3D 1.00
> > May 21 21:42:46 oldell kernel: usb 1-1.3: New USB device strings: Mfr=
=3D1,
> Product=3D2, SerialNumber=3D3
> > May 21 21:42:46 oldell kernel: usb 1-1.3: Product: DataTraveler G2
> > May 21 21:42:46 oldell kernel: usb 1-1.3: Manufacturer: Kingston
> > May 21 21:42:46 oldell kernel: usb 1-1.3: SerialNumber:
> 0014780F9955F971A5EC08D7
> > May 21 21:42:47 oldell kernel: usb-storage 1-1.3:1.0: USB Mass Storage
> device detected
> > May 21 21:42:47 oldell kernel: scsi host6: usb-storage 1-1.3:1.0
> > May 21 21:42:47 oldell kernel: usbcore: registered new interface driver
> usb-storage
> > May 21 21:42:47 oldell kernel: usbcore: registered new interface driver
> uas
> > May 21 21:42:48 oldell kernel: scsi 6:0:0:0: Direct-Access     Kingston
> DataTraveler G2  1.00 PQ: 0 ANSI: 2
> > May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] 15654848 512-byte
> logical blocks: (8.02 GB/7.46 GiB)
> > May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Write Protect is off
> > May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Mode Sense: 16 24 09 5=
1
> > May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Incomplete mode
> parameter data
> > May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Assuming drive cache:
> write through
> > May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:50 oldell kernel: usb 1-1.3: reset high-speed USB device
> number 4 using ehci-pci
> > May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 FAILED Result:
> hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
> > May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 Sense Key : Unit
> Attention [current]
> > May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 Add. Sense: Not
> ready to ready change, medium may have changed
> > May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 CDB: Read(10) 28
> 00 00 00 00 00 00 00 08 00
> >
> > This is not affecting all USB flash drive models. For instance, this
> device works fine:
> >
> > |May 23 20:15:37 oldell kernel: usb 2-1.2: new high-speed USB device
> number 9 using ehci-pci May 23 20:15:37 oldell kernel: usb 2-1.2: New USB
> device found, idVendor=3D6557, idProduct=3D2031, bcdDevice=3D 1.10 May 23
> 20:15:37 oldell kernel: usb 2-1.2: New USB device strings:
> > Mfr=3D1, Product=3D2, SerialNumber=3D3 May 23 20:15:37 oldell kernel: u=
sb
> 2-1.2: Product: USB DISK 3.0 May 23 20:15:37 oldell kernel: usb 2-1.2:
> Manufacturer: May 23 20:15:37 oldell kernel: usb 2-1.2: SerialNumber:
> 070D393C83CB5024 May 23 20:15:37 oldell kernel: usb-storage
> > 2-1.2:1.0: USB Mass Storage device detected May 23 20:15:37 oldell
> kernel: scsi host6: usb-storage 2-1.2:1.0 May 23 20:15:37 oldell
> mtp-probe[2300]: checking bus 2, device 9:
> "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2" May 23 20:15:37
> oldell mtp-probe[2300]:
> > bus: 2, device: 9 was not an MTP device May 23 20:15:37 oldell
> mtp-probe[2301]: checking bus 2, device 9:
> "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2" May 23 20:15:37
> oldell mtp-probe[2301]: bus: 2, device: 9 was not an MTP device May 23
> 20:15:38 oldell kernel:
> > scsi 6:0:0:0: Direct-Access USB DISK 3.0 PMAP PQ: 0 ANSI: 6 May 23
> 20:15:39 oldell kernel: sd 6:0:0:0: [sdb] 121145344 512-byte logical
> blocks: (62.0 GB/57.8 GiB) May 23 20:15:39 oldell kernel: sd 6:0:0:0: [sd=
b]
> Write Protect is off May 23 20:15:39 oldell kernel: sd
> > 6:0:0:0: [sdb] Mode Sense: 45 00 00 00 May 23 20:15:39 oldell kernel: s=
d
> 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't suppor=
t
> DPO or FUA May 23 20:15:39 oldell kernel: sdb: sdb1 sdb2 May 23 20:15:39
> oldell kernel: sd 6:0:0:0: [sdb] Attached SCSI
> > removable disk|
> >
> > Proceeded to bisect the kernel, which points to commit
> 4f53138fffc2b18396859aa4ff3e7ef2b0839c2b <
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D4f53138fffc2b18396859aa4ff3e7ef2b0839c2b>
> causing the issue to surface.
> > Changing USB port made no difference. Tried the same device on a
> different computer using kernel 6.9.2 - issue replicates.
> >
> > Attached bisection log, systemd journal kernel logs.
>
> Thank you for the detailed report and also for having bisected this issue=
.
> Does the patch below help (compile-tested only)?
>
> Thanks,
>
> Bart.
>
>
> ---
>   drivers/scsi/scsi_devinfo.c | 1 +
>   drivers/scsi/scsi_scan.c    | 2 ++
>   drivers/scsi/sd.c           | 4 ++++
>   include/scsi/scsi_devinfo.h | 4 +++-
>   4 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index a7071e71389e..85111e14c53b 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -197,6 +197,7 @@ static struct {
>         {"INSITE", "I325VM", NULL, BLIST_KEY},
>         {"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
>         {"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE |
> BLIST_INQUIRY_36},
> +       {"Kingston", "DataTraveler G2", NULL, BLIST_SKIP_IO_HINTS},
>         {"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
>         {"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
>         {"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 8300fc28cb10..ca7d14ee4575 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -745,6 +745,8 @@ static int scsi_probe_lun(struct scsi_device *sdev,
> unsigned char *inq_result,
>                 *bflags =3D scsi_get_device_flags(sdev, &inq_result[8],
>                                 &inq_result[16]);
>
> +               sdev_printk(KERN_INFO, sdev, "bflags =3D %#llx\n", *bflag=
s);
> +
>                 /* When the first pass succeeds we gain information about
>                  * what larger transfer lengths might work. */
>                 if (pass =3D=3D 1) {
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3a43e2209751..fcf3d7730466 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -63,6 +63,7 @@
>   #include <scsi/scsi_cmnd.h>
>   #include <scsi/scsi_dbg.h>
>   #include <scsi/scsi_device.h>
> +#include <scsi/scsi_devinfo.h>
>   #include <scsi/scsi_driver.h>
>   #include <scsi/scsi_eh.h>
>   #include <scsi/scsi_host.h>
> @@ -3117,6 +3118,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp=
,
> unsigned char *buffer)
>         struct scsi_mode_data data;
>         int res;
>
> +       if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
> +               return;
> +
>         res =3D scsi_mode_sense(sdp, /*dbd=3D*/0x8, /*modepage=3D*/0x0a,
>                               /*subpage=3D*/0x05, buffer, SD_BUF_SIZE,
> SD_TIMEOUT,
>                               sdkp->max_retries, &data, &sshdr);
> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
> index 6b548dc2c496..fa8721e49dec 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -69,8 +69,10 @@
>   #define BLIST_RETRY_ITF               ((__force blist_flags_t)(1ULL <<
> 32))
>   /* Always retry ABORTED_COMMAND with ASC 0xc1 */
>   #define BLIST_RETRY_ASC_C1    ((__force blist_flags_t)(1ULL << 33))
> +/* Do not read the I/O hints mode page */
> +#define BLIST_SKIP_IO_HINTS    ((__force blist_flags_t)(1ULL << 34))
>
> -#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
> +#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS
>
>   #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
>                                (__force blist_flags_t) \
>
>

--0000000000007a34f60619a994f9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Tried the patch over commit 1613e604df0. Issue persis=
ts.</div><div>
 Attached git and journal logs - notice here usb is using xhci_hcd instead =
of=20
ehci-pci, but this is because it&#39;s a different computer/environment tha=
n the one originally reported.</div><div><br></div><div>Thanks!<br></div></=
div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On=
 Wed, May 29, 2024 at 9:51=E2=80=AFPM Bart Van Assche &lt;<a href=3D"mailto=
:bvanassche@acm.org">bvanassche@acm.org</a>&gt; wrote:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px so=
lid rgb(204,204,204);padding-left:1ex">On 5/26/24 07:53, Joao Machado wrote=
:<br>
&gt; Linux Distribution: Archlinux<br>
&gt; Kernel version: 6.9.1<br>
&gt; <br>
&gt; Noticed my &quot;Kingston DataTraveler G2&quot; is unusable on kernel =
6.9.x, constantly resetting in a loop:<br>
&gt; <br>
&gt; May 21 21:42:46 oldell kernel: usb 1-1.3: new high-speed USB device nu=
mber 4 using ehci-pci<br>
&gt; May 21 21:42:46 oldell kernel: usb 1-1.3: New USB device found, idVend=
or=3D0951, idProduct=3D1624, bcdDevice=3D 1.00<br>
&gt; May 21 21:42:46 oldell kernel: usb 1-1.3: New USB device strings: Mfr=
=3D1, Product=3D2, SerialNumber=3D3<br>
&gt; May 21 21:42:46 oldell kernel: usb 1-1.3: Product: DataTraveler G2<br>
&gt; May 21 21:42:46 oldell kernel: usb 1-1.3: Manufacturer: Kingston<br>
&gt; May 21 21:42:46 oldell kernel: usb 1-1.3: SerialNumber: 0014780F9955F9=
71A5EC08D7<br>
&gt; May 21 21:42:47 oldell kernel: usb-storage 1-1.3:1.0: USB Mass Storage=
 device detected<br>
&gt; May 21 21:42:47 oldell kernel: scsi host6: usb-storage 1-1.3:1.0<br>
&gt; May 21 21:42:47 oldell kernel: usbcore: registered new interface drive=
r usb-storage<br>
&gt; May 21 21:42:47 oldell kernel: usbcore: registered new interface drive=
r uas<br>
&gt; May 21 21:42:48 oldell kernel: scsi 6:0:0:0: Direct-Access =C2=A0 =C2=
=A0 Kingston DataTraveler G2 =C2=A01.00 PQ: 0 ANSI: 2<br>
&gt; May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] 15654848 512-byte log=
ical blocks: (8.02 GB/7.46 GiB)<br>
&gt; May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Write Protect is off<=
br>
&gt; May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Mode Sense: 16 24 09 =
51<br>
&gt; May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Incomplete mode param=
eter data<br>
&gt; May 21 21:42:48 oldell kernel: sd 6:0:0:0: [sdb] Assuming drive cache:=
 write through<br>
&gt; May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:48 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:49 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:50 oldell kernel: usb 1-1.3: reset high-speed USB device =
number 4 using ehci-pci<br>
&gt; May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 FAILED Result: =
hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s<br>
&gt; May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 Sense Key : Uni=
t Attention [current]<br>
&gt; May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 Add. Sense: Not=
 ready to ready change, medium may have changed<br>
&gt; May 21 21:42:50 oldell kernel: sd 6:0:0:0: [sdb] tag#0 CDB: Read(10) 2=
8 00 00 00 00 00 00 00 08 00<br>
&gt; <br>
&gt; This is not affecting all USB flash drive models. For instance, this d=
evice works fine:<br>
&gt; <br>
&gt; |May 23 20:15:37 oldell kernel: usb 2-1.2: new high-speed USB device n=
umber 9 using ehci-pci May 23 20:15:37 oldell kernel: usb 2-1.2: New USB de=
vice found, idVendor=3D6557, idProduct=3D2031, bcdDevice=3D 1.10 May 23 20:=
15:37 oldell kernel: usb 2-1.2: New USB device strings: <br>
&gt; Mfr=3D1, Product=3D2, SerialNumber=3D3 May 23 20:15:37 oldell kernel: =
usb 2-1.2: Product: USB DISK 3.0 May 23 20:15:37 oldell kernel: usb 2-1.2: =
Manufacturer: May 23 20:15:37 oldell kernel: usb 2-1.2: SerialNumber: 070D3=
93C83CB5024 May 23 20:15:37 oldell kernel: usb-storage <br>
&gt; 2-1.2:1.0: USB Mass Storage device detected May 23 20:15:37 oldell ker=
nel: scsi host6: usb-storage 2-1.2:1.0 May 23 20:15:37 oldell mtp-probe[230=
0]: checking bus 2, device 9: &quot;/sys/devices/pci0000:00/0000:00:1d.0/us=
b2/2-1/2-1.2&quot; May 23 20:15:37 oldell mtp-probe[2300]: <br>
&gt; bus: 2, device: 9 was not an MTP device May 23 20:15:37 oldell mtp-pro=
be[2301]: checking bus 2, device 9: &quot;/sys/devices/pci0000:00/0000:00:1=
d.0/usb2/2-1/2-1.2&quot; May 23 20:15:37 oldell mtp-probe[2301]: bus: 2, de=
vice: 9 was not an MTP device May 23 20:15:38 oldell kernel: <br>
&gt; scsi 6:0:0:0: Direct-Access USB DISK 3.0 PMAP PQ: 0 ANSI: 6 May 23 20:=
15:39 oldell kernel: sd 6:0:0:0: [sdb] 121145344 512-byte logical blocks: (=
62.0 GB/57.8 GiB) May 23 20:15:39 oldell kernel: sd 6:0:0:0: [sdb] Write Pr=
otect is off May 23 20:15:39 oldell kernel: sd <br>
&gt; 6:0:0:0: [sdb] Mode Sense: 45 00 00 00 May 23 20:15:39 oldell kernel: =
sd 6:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn&#39;t s=
upport DPO or FUA May 23 20:15:39 oldell kernel: sdb: sdb1 sdb2 May 23 20:1=
5:39 oldell kernel: sd 6:0:0:0: [sdb] Attached SCSI <br>
&gt; removable disk|<br>
&gt; <br>
&gt; Proceeded to bisect the kernel, which points to commit 4f53138fffc2b18=
396859aa4ff3e7ef2b0839c2b &lt;<a href=3D"https://git.kernel.org/pub/scm/lin=
ux/kernel/git/torvalds/linux.git/commit/?id=3D4f53138fffc2b18396859aa4ff3e7=
ef2b0839c2b" rel=3D"noreferrer" target=3D"_blank">https://git.kernel.org/pu=
b/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3D4f53138fffc2b1839685=
9aa4ff3e7ef2b0839c2b</a>&gt; causing the issue to surface.<br>
&gt; Changing USB port made no difference. Tried the same device on a diffe=
rent computer using kernel 6.9.2 - issue replicates.<br>
&gt; <br>
&gt; Attached bisection log, systemd journal kernel logs.<br>
<br>
Thank you for the detailed report and also for having bisected this issue.<=
br>
Does the patch below help (compile-tested only)?<br>
<br>
Thanks,<br>
<br>
Bart.<br>
<br>
<br>
---<br>
=C2=A0 drivers/scsi/scsi_devinfo.c | 1 +<br>
=C2=A0 drivers/scsi/scsi_scan.c=C2=A0 =C2=A0 | 2 ++<br>
=C2=A0 drivers/scsi/sd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 4 ++++<b=
r>
=C2=A0 include/scsi/scsi_devinfo.h | 4 +++-<br>
=C2=A0 4 files changed, 10 insertions(+), 1 deletion(-)<br>
<br>
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c<br>
index a7071e71389e..85111e14c53b 100644<br>
--- a/drivers/scsi/scsi_devinfo.c<br>
+++ b/drivers/scsi/scsi_devinfo.c<br>
@@ -197,6 +197,7 @@ static struct {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {&quot;INSITE&quot;, &quot;I325VM&quot;, NULL, =
BLIST_KEY},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {&quot;Intel&quot;, &quot;Multi-Flex&quot;, NUL=
L, BLIST_NO_RSOC},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {&quot;iRiver&quot;, &quot;iFP Mass Driver&quot=
;, NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0{&quot;Kingston&quot;, &quot;DataTraveler G2&qu=
ot;, NULL, BLIST_SKIP_IO_HINTS},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {&quot;LASOUND&quot;, &quot;CDX7405&quot;, &quo=
t;3.10&quot;, BLIST_MAX5LUN | BLIST_SINGLELUN},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {&quot;Marvell&quot;, &quot;Console&quot;, NULL=
, BLIST_SKIP_VPD_PAGES},<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 {&quot;Marvell&quot;, &quot;91xx Config&quot;, =
&quot;1.01&quot;, BLIST_SKIP_VPD_PAGES},<br>
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c<br>
index 8300fc28cb10..ca7d14ee4575 100644<br>
--- a/drivers/scsi/scsi_scan.c<br>
+++ b/drivers/scsi/scsi_scan.c<br>
@@ -745,6 +745,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, uns=
igned char *inq_result,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *bflags =3D scsi_ge=
t_device_flags(sdev, &amp;inq_result[8],<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &amp;inq_result[16]);<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sdev_printk(KERN_IN=
FO, sdev, &quot;bflags =3D %#llx\n&quot;, *bflags);<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* When the first p=
ass succeeds we gain information about<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* what larger=
 transfer lengths might work. */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pass =3D=3D 1) =
{<br>
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c<br>
index 3a43e2209751..fcf3d7730466 100644<br>
--- a/drivers/scsi/sd.c<br>
+++ b/drivers/scsi/sd.c<br>
@@ -63,6 +63,7 @@<br>
=C2=A0 #include &lt;scsi/scsi_cmnd.h&gt;<br>
=C2=A0 #include &lt;scsi/scsi_dbg.h&gt;<br>
=C2=A0 #include &lt;scsi/scsi_device.h&gt;<br>
+#include &lt;scsi/scsi_devinfo.h&gt;<br>
=C2=A0 #include &lt;scsi/scsi_driver.h&gt;<br>
=C2=A0 #include &lt;scsi/scsi_eh.h&gt;<br>
=C2=A0 #include &lt;scsi/scsi_host.h&gt;<br>
@@ -3117,6 +3118,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp, =
unsigned char *buffer)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct scsi_mode_data data;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int res;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sdp-&gt;sdev_bflags &amp; BLIST_SKIP_IO_HIN=
TS)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 res =3D scsi_mode_sense(sdp, /*dbd=3D*/0x8, /*m=
odepage=3D*/0x0a,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*subpage=3D*/0x05, buffer, SD_BUF_SIZE, SD=
_TIMEOUT,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sdkp-&gt;max_retries, &amp;data, &amp;sshdr=
);<br>
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h<br>
index 6b548dc2c496..fa8721e49dec 100644<br>
--- a/include/scsi/scsi_devinfo.h<br>
+++ b/include/scsi/scsi_devinfo.h<br>
@@ -69,8 +69,10 @@<br>
=C2=A0 #define BLIST_RETRY_ITF=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0((__force blist_flags_t)(1ULL &lt;&lt; 32))<br>
=C2=A0 /* Always retry ABORTED_COMMAND with ASC 0xc1 */<br>
=C2=A0 #define BLIST_RETRY_ASC_C1=C2=A0 =C2=A0 ((__force blist_flags_t)(1UL=
L &lt;&lt; 33))<br>
+/* Do not read the I/O hints mode page */<br>
+#define BLIST_SKIP_IO_HINTS=C2=A0 =C2=A0 ((__force blist_flags_t)(1ULL &lt=
;&lt; 34))<br>
<br>
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1<br>
+#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS<br>
<br>
=C2=A0 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(__force blist_flags_t) \<br>
<br>
</blockquote></div>

--0000000000007a34f60619a994f9--
--0000000000007a34f80619a994fb
Content-Type: application/x-zip-compressed; name="patch_result.zip"
Content-Disposition: attachment; filename="patch_result.zip"
Content-Transfer-Encoding: base64
Content-ID: <f_lwt25ndo0>
X-Attachment-Id: f_lwt25ndo0

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
AAA=
--0000000000007a34f80619a994fb--
