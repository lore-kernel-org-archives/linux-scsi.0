From: berthiaume_wayne@emc.com
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Fri, 12 Apr 2002 09:15:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F527C91A6ED411AFE10050040665D0049BF8E4@corpusmx1.us.dg.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: hbryan@us.ibm.com
Cc: linux-scsi@vger.kernel.org

	The CLARiiON returns pages 00h, 80h, and 83h. Page 80h will contain
the array's serial number. Bytes 4 thru 23 of page 83h contain the
Identifier Descriptor 0 data which carries the LUN's WWN and bytes 24 thru
43 contain the Identifier Descriptor 1 data which carries the LUN and VLU
numbers. The LUN/VLU come from the VLUT (Virtual LUN Table). This is how you
are able to map your virtual LUN in your storage group to the physical LUN
in the array. The physical LUN itself is not a physical disk in the physical
array but created at the time you bind disks or portions of disks into LUN.
For example, I may bind five disks into a RAID 5 group and portion them up
into 10 LUNs. Then if I install and use the AccessLogix software on the
array I can break up the array into virtual arrays called Storage Groups to
be used by multiple hosts. Storage Groups can be shared or individually
owned and, for the clever array administrator, you can design individual
storage groups which contain private and shared LUNs. All this is only
possible because we utilize the WWN of the array. The LUNs themselves use a
concatenation of the array's WWN to form the WWN for each individual LUN.
The WWN for the attached HBA is used to identify the unique storage group.
Thus persistence is maintained in the array. Now the trick will be to get
the same for Linux. =;^)

-----Original Message-----
From: Bryan Henderson [mailto:hbryan@us.ibm.com]
Sent: Thursday, April 11, 2002 12:01 PM
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org
Subject: RE: [RFC] Persistent naming of scsi devices


>                VLUN = virtual LUN 
>
>This would be the number assigned by the storage system. A storage
>system can be broken up into multiple virtual storage systems each unique 
to
>the owner. The real trick is when to virtual storage systems share the 
same
>LUN.

This VLUN sounds like what SCSI/FCP defines as a LUN.  What you're calling 
a LUN is apparently something that's not defined in SCSI.  I'm guessing a 
LUN here identifies a volume, and the same volume is connected to multiple 
SCSI logical units, one in each virtual storage subsystem.  I'm also 
assuming that a virtual storage subsystem is a target device/node in SCSI 
terms.

That raises the question:  What do you get if you INQUIRE as to the 
logical unit serial number of two SCSI logical units, in different virtual 
storage subsystems, associated with the same volume?  Is it the same 
serial number?
