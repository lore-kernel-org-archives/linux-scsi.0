From: Christian Krause <chkr@plauener.de>
Subject: MEDIUM_NOT_PRESENT ignored in some cases
Date: Fri,  4 Nov 2005 13:58:42 +0100
Message-ID: <20051104135842.f0s0urfd68ssw0c0@mail.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:62933 "EHLO
	john.hrz.tu-chemnitz.de") by vger.kernel.org with ESMTP
	id S932738AbVKDM6O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 07:58:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

here are my thoughts about a second issue I found in sd.c:

function media_not_present, line 952:

---------------
      if (!scsi_sense_valid(sshdr))
                return 0;
        /* not invoked for commands that could return deferred errors */
        if (sshdr->sense_key != NOT_READY &&
            sshdr->sense_key != UNIT_ATTENTION)
                return 0;
        if (sshdr->asc != 0x3A) /* medium not present */
                return 0;
--------------------------


The source indicates, that in case of
sense_key == NOT_READY and
asc == MEDIUM_NOT_PRESENT
(or the same with sense_key == UNIT_ATTENTION) set_media_not_present
is not called and hence media_present is not set to 0.

As reason for this behaviour the following comment is given in the
source: "not invoked for commands that could return deferred errors".

Sure, this is true, but as far as I understand this assumption covers
even cases in which the error is not deferred.

The sense data format contains a member "Response Code" which is
normally 0x70 or 0x71 [1]. 0x70 means: "current errors" and 0x71 means
"deferred errors". So it seems to me that a good solution would be
to accept asc == MEDIUM_NOT_PRESENT even if sense_key == NOT_READY or 
== UNIT_ATTENTION, given that the
response code == 0x70.


I've discovered this problem during developing a usb mass storage device
which uses the "transparent SCSI" command set and reports itself as
"direct access device" (DeviceType == 0x0 in the Inquiry data). If I
attach this device with no medium inserted (virtually, because its
just an emulation of a SCSI device), the kernel repeats "Test Unit
Ready" and "Request Sense" for more than a minute (the last kernel
output is: sda: "Spinning up disk........."). Because of this I've 
started to look into the source of the linux scsi
subsystem and found the mentioned issue.


What do you think about this issue? Would it make sense to honor the 
ResponseCode and to accept "MEDIUM_NOT_PRESENT" in the case the current
error is returned? If yes, I would create an appropriate patch.



Best regards,
Christian

[1]: SPC-2, 7.20.2, Sense Data format


