From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Quantum disk firmware update
Date: Wed, 8 Jan 2003 09:08:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D4FE@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from petasus.fm.intel.com (petasus.fm.intel.com [10.1.192.37])
	by caduceus.fm.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.51 2002/09/23 20:43:23 dmccart Exp $) with ESMTP id h08H0tx03623
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jan 2003 17:00:55 GMT
Received: from fmsmsxvs041.fm.intel.com (fmsmsxvs041.fm.intel.com [132.233.42.126])
	by petasus.fm.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.27 2002/10/16 23:46:59 dmccart Exp $) with SMTP id h08H1Sq23595
	for <linux-scsi@vger.kernel.org>; Wed, 8 Jan 2003 17:01:28 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Shanker Balan' <shanu@exocore.com>
Cc: Linux-SCSI <linux-scsi@vger.kernel.org>, "'scsirastools-developers@lists.sourceforge.net.'" <scsirastools-developers@lists.sourceforge.net>

Shanu,

The sense key message shows "Illegal Request" for the Write Buffer command.
This could be one of several things:
  1) The device cannot handle SCSI commands this large (377k).
or
  2) The command was truncated or malformed so that it appeared incomplete.
or 
  3) Some devices return this sense code if the model number in the image 
     does not match the device model number.

For (1) it would be an issue to take back to Quantum, asking how does this
disk device expect to download firmware?  Most disks use one big buffer like
this, but some require a fragmented, iterative download algorithm.  I've
downloaded firmware images as large as 600k with this tool, so it is within
a normal range.  
For (2), it could be a software bug, but the fact that the DOS Quantum tool
provided gets the same error would weigh against this.  It could be a
cabling/termination problem, or it could be an issue with the adapter
handling large SCSI commands.  Which SCSI adapter was involved? 
For (3), this seems like the most likely case.  You can also do a "strings"
on the image file to see if there is a model string there that matches.  You
can check with Quantum/Maxtor to verify the image.  The sgdskfl should also
explictly check this, but I just noticed that Quantum wasn't in my list of
vendors that support this.  This will be changed in the next cut.  

RE "servo image":
Some disk devices have the capability to download a servo image as well as a
firmware image.
The servo controls the mechanical/physical operation of the disk (comparable
to BIOS on a PC), while the firmware handles higher level logic, including
the SCSI protocol.  

-----Original Message-----
From: Shanker Balan [mailto:shanu@exocore.com] 
Sent: Wednesday, January 08, 2003 3:15 AM
To: Linux-SCSI
Subject: Re: Seagate Cheetah: Firmware, Bugs, Compatibility?

[...]

I got a similar sense error while trying to flash using the Quantum supplied
"DL_scsi.exe" under DOS.

Andrew, any idea what might be the problem here? Also whats a "Servo
image"?

Here is paste from "sgdskfl" run:

Log file /var/log/sgdskfl.log is open, debug=0

Num Name [bus:ch:id:lun] Type Vendor   Device_Model     FW__ Serial#_
Servo___
0 /dev/sg0 [0:0:0:0] Disk  QUANTUM  ATLAS10K3_18_SCA 020W 34220894
1 /dev/sg1 [0:0:1:0] Disk  QUANTUM  ATLAS10K3_73_SCA 020W 34820965
2 /dev/sg2 [0:0:2:0] Disk  QUANTUM  ATLAS10K3_73_SCA 020W 34820635

Enter Selection ('d' to download, 'q' to quit) : d

Device Num (0 to 2) : 2
Selected 2: [0:2] QUANTUM ATLAS10K3_73_SCA020W34820635
Reading image file atlas10k.lod, size = 377167
No servo image
Device [2] is ready for download
Starting download process for 1 disk.
Downloading Firmware image to disk 2 Wed Jan  8 13:40:52 2003
Current sg_cmd_done_bh00:00: sense key Illegal Request
write_buffer: Check Condition Driver_status=0x08 (DRIVER_SENSE,SUGGEST_OK)
sense error, key=05 asc=26 ascq=80 Illegal Request
Info valid=0, Current
[2] Error -2 in writing buffer
Press ENTER to continue

-- Shanu
http://shankerbalan.com/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
