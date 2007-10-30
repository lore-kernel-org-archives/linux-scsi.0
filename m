From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Should be Acard ATP8620 2SATA / 1 IDE  driver
Date: Tue, 30 Oct 2007 06:24:22 -0400
Message-ID: <47270656.7080205@garzik.org>
References: <00b501c81ace$ece895f0$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58246 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXJ3KYa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Oct 2007 06:24:30 -0400
In-Reply-To: <00b501c81ace$ece895f0$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@acard.com>
Cc: linux-scsi@vger.kernel.org, 'David Miller' <davem@davemloft.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matti Aarnio <postmaster@vger.kernel.org>, tytso@us.ibm.com, IDE/ATA development list <linux-ide@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

jameshsu wrote:
> Should be in TEXT/PLAIN mode. --- resend
> 
> ************************
> Hello,
> 
> This driver has nothing changed since last time submit.
> However recently we download 2.6.23.1 kernel and found Acard ATP8620 SATA
> driver is still not there.
> Resend this message to submit the same driver again.
> Please help Acard to build in this SATA driver with latest Linux kernel.
> If any reason not able to add in, please let us know.

We would be glad to help!

This driver is an ATA driver, which duplicates the existing SCSI<->ATA 
translation code we already have.  It also fails to work around the 
problems ("quirks") found in a large number of ATA devices.

As such, it would be preferred that this ATA hardware use the existing 
ATA driver API.

You can see example drivers for advanced controllers such a 
drivers/ata/ahci.c and drivers/ata/sata_sil24.c, which are both 
FIS-based controllers with full NCQ support, hotplug support, port 
multiplier support, and many others.

It is important in Linux that we do not duplicate effort by merging 
drivers that duplicate the existing SCSI<->ATA translation layer, or 
fail to use our existing ATA API.

Overall, we wish to avoid adding another ATA driver inside the SCSI 
layer, without using the existing ATA<->SCSI code.

Is your hardware documentation public?  I can help provide a sample 
driver for your hardware, or help guide your engineers in this effort.

Regards,

	Jeff, the Linux ATA maintainer


