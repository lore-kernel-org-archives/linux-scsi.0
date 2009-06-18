From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 13572] New: hdparm -W1 /dev/sda causes oops and hard
 lockup
Date: Thu, 18 Jun 2009 17:20:29 -0500
Message-ID: <1245363629.4286.19.camel@mulgrave.site>
References: <bug-13572-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41921 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755548AbZFRXFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 19:05:48 -0400
In-Reply-To: <bug-13572-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-06-18 at 16:05 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=13572
> 
>            Summary: hdparm -W1 /dev/sda causes oops and hard lockup
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 2.6.30, 2.6.30-rc6
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: vc@artstyle.net
>         Regression: No
> 
> 
> Worked in 2.6.29.
> 
> [  257.940560] ata1.00: configured for UDMA/100 
> [  257.940694] ata1: EH complete 

This is printed just before the libata-eh:ata_scsi_error() exits

> [  257.940799] BUG: unable to handle kernel NULL pointer dereference at
> 00000228 

This is 0 offset by sdev_state

> [  257.940965] IP: [<c031dae3>] scsi_device_get+0x3/0x60 

So clearly the SCSI device going into scsi_device_get was a NULL
pointer.

> [  257.941116] *pde = 00000000  
> [  257.941224] Oops: 0000 [#2] SMP 
> [  257.941380] last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0a/PNP0C09:00/ACPI0003:00/power_supply/ACAD/online 
> [  257.941470] Modules linked in: netconsole ipt_ECN iptable_mangle xt_recent
> xt_tcpudp ipt_REJECT ipt_LOG iptable_filter ip_tables x_tables dm_mod
> usb_storage snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss
> snd_pcm uhci_hcd ehci_hcd snd_timer snd i2c_i801 rsrc_nonstatic e100 psmouse
> mousedev soundcore rtc_cmos snd_page_alloc i2c_core usbcore pcmcia_core mii
> rtc_core rtc_lib evdev intel_agp 8250_pnp(-) intel_rng rng_core agpgart sonypi
> [last unloaded: parport]
> [  257.943760]  
> [  257.943825] Pid: 937, comm: scsi_eh_0 Tainted: G      D   
> (2.6.30+vc+ipmi+ow #2) PCG-R505TL(UC)       
> [  257.943905] EIP: 0060:[<c031dae3>] EFLAGS: 00010007 CPU: 0 
> [  257.943982] EIP is at scsi_device_get+0x3/0x60 
> [  257.944051] EAX: fffffff8 EBX: fffffff8 ECX: 00008484 EDX: 00000246 
> [  257.944123] ESI: fffffff8 EDI: cb9ac400 EBP: 00000000 ESP: cb9d4f68 
> [  257.944192]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 
> [  257.944262] Process scsi_eh_0 (pid: 937, ti=cb9d4000 task=cb9cd860
> task.ti=cb9d4000) 
> [  257.944337] Stack: 
> [  257.944394]  cb9ac400 c031dcaa 00000246 00000293 cb9ac400 cb9d4fc0 00000000
> c0322c93 
> [  257.944415]  00000000 00000086 cb82cfb0 cb824d20 00000001 cb9cdae8 cb9d4fc0
> 00000000 
> [  257.944415]  00000003 cb824d2c cb9ac444 cb9ac454 c01230d0
> [  257.944415] Call Trace: 
> [  257.944415]  [<c031dcaa>] ? __scsi_iterate_devices+0x3a/0x70 
> [  257.944415]  [<c0322c93>] ? scsi_error_handler+0xe3/0x5a0 
> [  257.944415]  [<c01230d0>] ? complete+0x40/0x60 
> [  257.944415]  [<c0322bb0>] ? scsi_error_handler+0x0/0x5a0 

Unfortunately, as seems to be the wont on x86 these days, this trace is
complete rubbish: if we theorise that the __scsi_iterate_devices is
correct, then we're at shost_for_each_device().

Thus, I think we must be in scsi_restart_operations(), which is the only
thing that happens after the strategy handler exits.

So, it looks a bit like corruption in the host device list ... or a
scsi_device_get() is no longer pinning a device in that list.  I'm at a
loss to find any commit between 2.6.29 and now that would cause this,
though ... could you try a bisection to find the offending commit?

Thanks,

James


