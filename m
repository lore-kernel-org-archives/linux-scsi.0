From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Emulex HBA Issues
Date: Wed, 07 Feb 2007 09:41:46 -0500
Message-ID: <45C9E52A.4000707@emulex.com>
References: <000901c74abb$c0402ec0$0a01a8c0@cenergynetworks.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:49517 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161343AbXBGOl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 09:41:57 -0500
In-Reply-To: <000901c74abb$c0402ec0$0a01a8c0@cenergynetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Knipe <savage@savage.za.org>
Cc: linux-scsi@vger.kernel.org

Everything is working, as it should, on a 2.6 kernel. see comments below...

Chris Knipe wrote:
> Hi,
> 
> I have a RedHat 9 system running kernel 2.6.16... The system is attached 
> to 3 x EMC FC4700 DOE's operating as simple JBODs....
> 
> Looking at /proc/scsi/scsi, I can clearly see all the devices are 
> visable (see below)

Ok - but with 2.6.x - you should start looking in /sys/class/scsi_device
and /sys/class/scsi_host for scsi things now. /proc stuff is mainly
for compatibility.

> 
> However, each time RedHat boots it assigns a different device to a 
> different hard drive... For example, one of my CLAR18 disks in Eclosure 
> 3 Bay 3, ends up at /dev/sde.  When I reboot, that same drive, will all 
> of a sudden become /dev/sdm.  Needless to say with the devices flying 
> arround like this, it is impossibly to create any array or use any of 
> the devices...

Well - The lpfc driver performs discovery in parallel to all the FC
devices on the fabric, so that it completes faster, and doesn't allow
good devices to get hung up behind slow responders. The order in which
discovery complete to each device decides what SCSI Target ID gets
assigned by the FC transport - it's a first-seen-first-assigned basis.
If you want to serialize things, which reduces but does not eliminate
what you are seeing (consider one of the 4700's being powered off at
the time you boot), set the lpfc module parameter lpfc_discovery_threads=1.
Here's a pointer to some additional lpfc linux documentation:
http://www.emulex.com/ts/downloads/shared_docs/linux/81/manual.pdf

However, you should realize, the 2.6 kernel fully expects hot plug
and dynamic discovery, and that users, if they want persistent names,
are to use udev to supply them.  There is no guarantee the /dev/sdX names
are persistent (and in truth, there never was under the 2.4 kernel either).
Udev matches unique device identifiers and creates a consistent symlink
to the underlying device name.
See:
http://www.emulex.com/white/hba/wp_linux26udev.pdf
http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

> 
> I have no way to know that any device will have the same name after a 
> reboot... Is there any way to fix this??

Follow udev and you will be all set.

-- james s


> 
> Thanks,
> Chris.
> 
> 
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 04 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 05 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 07 Lun: 00
>  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi0 Channel: 00 Id: 08 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 09 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 10 Lun: 00
>  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A84
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 11 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 12 Lun: 00
>  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 13 Lun: 00
>  Vendor: SEAGATE  Model: ST318304 CLAR18  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 14 Lun: 00
>  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 15 Lun: 00
>  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A84
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 16 Lun: 00
>  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 17 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 18 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 19 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 20 Lun: 00
>  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 21 Lun: 00
>  Vendor: SEAGATE  Model: ST336605 CLAR36  Rev: 4A20
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 22 Lun: 00
>  Vendor: SEAGATE  Model: ST336605 CLAR36  Rev: 4A20
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi0 Channel: 00 Id: 23 Lun: 00
>  Vendor: SEAGATE  Model: ST118202 CLAR18  Rev: 3528
>  Type:   Direct-Access                    ANSI SCSI revision: 02
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
