From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Ejecting removable disk causes a flood of ALLOW_MEDIUM_REMOVAL
Date: Thu, 13 Jul 2006 01:45:31 -0400
Message-ID: <44B5DDFB.9090701@torque.net>
References: <44B5C717.40300@tw.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12951 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751412AbWGMFqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jul 2006 01:46:20 -0400
In-Reply-To: <44B5C717.40300@tw.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: albertl@mail.com
Cc: Jeff Tranter <tranter@pobox.com>, linux-scsi@vger.kernel.org, Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>, Unicorn Chang <uchang@tw.ibm.com>, Doug Maxey <dwm@enoyolf.org>, Gary Hade <garyhade@us.ibm.com>

Albert Lee wrote:
> Hi Doug,
> 
> A problem related to SG_IO.
> When testing the 2.6.18-rc1 libata, a flood of ALLOW_MEDIUM_REMOVAL is seen
> after ejecting a removable disk drive:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=6799
> 
> The interaction to trigger the problem is below:
> 1. The "eject" utility, using SG_IO, issues ALLOW_MEDIUM_REMOVAL twice to unlock the disk of the device.
> 2. The disk of the physical device is now unlocked, however, sdev->locked is still 1, inconsistent with the physical device status.
> 3. The "eject" utility ejects the disk by START_STOP_UNIT.
> 4. Someone issues TEST_UNIT_READY. The device is not ready since no disk inside. ATAPI check condition returned.
> 5. 2.6.18-rc1 libata EH triggered in SCSI EH context to request sense.
> 6. scsi_restart_operations(), seeing sdev->locked == 1, tries to lock the door.
> 7. Lock failed since no disk inside. ATAPI check condition returned.
> 8. 2.6.18 libata EH triggered in SCSI EH context. Goto 5 and loop forever until the disk is inserted again.
> 
> It looks more like eject/scsi problem. (Libata 2.6.17 EH is not affected by the problem 
> because the request sense is done when qc is completed, not in the SCSI EH context.)
> 
> Maybe adding a filter to the SCSI SG IO layer to
>  - Check incoming SCSI commands
>  - Whenever ALLOW_MEDIUM_REMOVAL is seen, update the sdev->locked to make the 
>    kernel data structure consistent with the physical device status
> can fix the problem?

Albert,
Just fix libata. My usb external cd/dvd combo drive has a little switch
under it to unlock the door. How could use of that switch be "filtered"
by an OS?

If an OS wants to maintain a state variable for a device that a
user (and perhaps another initiator) can get to then it needs to
be able to cope with that state variable being out
of sync once in a while.

Doug Gilbert

