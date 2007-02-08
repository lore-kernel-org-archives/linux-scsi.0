From: Michael Reed <mdr@sgi.com>
Subject: Re: persistent scsi with udev
Date: Thu, 08 Feb 2007 09:08:10 -0600
Message-ID: <45CB3CDA.9040704@sgi.com>
References: <eqf3li$9s7$1@sea.gmane.org> <45CB3141.2030707@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:36120 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423068AbXBHPIU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Feb 2007 10:08:20 -0500
In-Reply-To: <45CB3141.2030707@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Moroder <andreas.moroder@sb-brixen.it>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

While you didn't explicitly mention which distro you're using, some already
have udev in their initrd.  If this applies in your case, you should be able
to change the root= parameter passed to the kernel to specify your root device
via a persistent name.  For example:

	root=/dev/disk/by-path/pci-0000:01:03.0-scsi-0:0:1:0p1

You can do the same in your /etc/fstab for the root device.

You can ALSO change the order in which modules are loaded via /etc/modprobe.conf,
or /etc/sysconfig/kernel, or something similar for your distro, so that the driver
for your root device is always loaded first.

I hope this helps.

Mike


James Smart wrote:
> You can see if a white paper we put together, which includes information
> on tapes, can help you. There's also a small section on "boot from SAN"
> which talks about configuring udev in initrd for boot devices. Although
> the content references distros, it should be applicable to the kernel
> generically.
> http://www.emulex.com/white/hba/wp_linux26udev.pdf
> 
> -- james s
> 
> 
> Andreas Moroder wrote:
>> Hello,
>>
>> we have a big problem with scsi device mapping.
>>
>> We have a LSI Megaraid controller and a qlogic HBA with a attached SAN
>>
>> When we boot the machine without the SAN then  the first disk on the
>> MEGARAID becomes \dev\sda
>>
>> When we boot with the SAN attached then the first disk in the san
>> becomes \dev\sda and the system stop.
>>
>> Is there a step by step tot availabe on how to configure the udev
>> files when two SCSI devices are installed in one machine ?
>>
>> Thanks
>> Andreas
>>
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
