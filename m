From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: QLA2300, Infortrand and LBD?
Date: Thu, 29 Jul 2004 06:17:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CC8B6@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:33325 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S264627AbUG2NRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2004 09:17:31 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "tester7 A." <benew666@hotmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, tech@storageone.co.kr

James,You guessed right, I sent a read capacity 16 cdb to the controller
and recieved a 
check condition back: sense 05 illegal request and additional qualifiers
2000 = invalid 
command operation. Seems as though controller was not architected to
support luns greater
than 2 .1 TB. The size of any lun > than 2 .1 TB will be set as a modulo
2.1 TB
 
-Frank

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 
 

>>-----Original Message-----
>>From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
>>Sent: Wednesday, July 28, 2004 9:18 AM
>>To: Frank Borich
>>Cc: tester7 A.; SCSI Mailing List; tech@storageone.co.kr
>>Subject: RE: QLA2300, Infortrand and LBD?
>>
>>On Wed, 2004-07-28 at 09:46, Frank Borich wrote:
>>> Looking at an FC trace on an Infortrend controller I have, 
>>shows that 
>>> for a LUN 3586680 MB in size, the LBA is B5D3BFFF in the "RETURNED 
>>> LOGICAL BLOCK ADDRESS FIELD"
>>> and with in the "BLOCK LENGTH IN BYTES FIELD" field is 200h , ( 
>>> B5D3BFFF
>>> * 200h =  approx. 1.6 TB). Seems that infortrend does NOT respond 
>>> properly to READ_CAPACITY_10, at least in my case.
>>
>>Well 3586680 MB == 0x1b5d3bfff * 0x200
>>
>>so I think you can see where the returned figure is coming from...
>>
>>Infortrends should be made aware of the problem so they can 
>>do a bios upgrade.  I suspect that even if the array returned 
>>the correct capacity it would be unable to process the 
>>READ/WRITE(16) commands necessary to reach it anyway, so 
>>their "fix" may be to tell you that no individual luns can be 
>>configured beyond 2TB.
>>
>>> James, this may be a dumb question, please excuse my 
>>ignorance of the 
>>> internals of the scsi subsystem, but is there a plan to 
>>implement LBD 
>>> support in the 2.4 tree ?
>>
>>The problem is not just in SCSI, it permeates the block 
>>layer.  I don't think there's much point backporting LBD to 
>>2.4, although many vendor trees have it.
>>
>>James
>>
>>
>>
>>
