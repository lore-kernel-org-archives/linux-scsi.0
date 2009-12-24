From: "Penchala Narasimha Reddy Chilakala, ERS-HCLTech"
	<narasimhareddyc@hcl.in>
Subject: RE:  [PATCH ]  scsi-misc-2.6:  File System going into read-only
 mode
Date: Thu, 24 Dec 2009 11:59:58 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E91679286@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:51550 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbZLXGbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2009 01:31:41 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@kernel.org>, "'linux-scsi@vger.kernel.org'" <'linux-scsi@vger.kernel.org'>
Cc: ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James and linux-scsi community,

Please let us your comments on the patch (community_aac24702.patch) we =
submitted on December 21, 2009.

Thanks,
Narasimha Reddy

-----Original Message-----
=46rom: Penchala Narasimha Reddy Chilakala, ERS-HCLTech=20
Sent: Monday, December 21, 2009 6:39 PM
To: 'linux-scsi@vger.kernel.org'; 'James Bottomley'
Cc: ServeRAID Driver
Subject: [PATCH ] scsi-misc-2.6: File System going into read-only mode=20

Hi James and linux-scsi community,

       I would request you that please review the attached updated patc=
h, which contains the fix for racy issue (which was raised by James) an=
d do the needful to incorporate the patch in up-coming release.=20

Note: The patch was generated against the "kernel 2.6.33-rc1"

=46rom: Narasimha Reddy <ServeRAIDDriver@hcl.in>

	The attached patch was generated for fixing the following issues. Thes=
e issues were reported by Cisco, SAP and some other customers as well.

Regarding the testing of fixes:
--------------------------------

	These particular problems were reported by Cisco and SAP and customers=
 as well. Cisco reported on RHEL4 U6 and SAP reported on SLES9 SP4 and =
SLES10 SP2. We added these fixes on RHEL4 U6 and gave a private build t=
o IBM and Cisco. Cisco and IBM tested it for more than 15 days and they=
 reported that they did not see the issue so far. Before the fix, Cisco=
 used to see the issue within 5 days. We generated a patch for SLES9 SP=
4 and SLES10 SP2 and submitted to Novell. Novell applied the patch and =
gave a test build to SAP. SAP tested and reported that the build is wor=
king properly.

We also tested in our lab using the tools "dishogsync", which is IO str=
ess tool and the tool was provided by Cisco.

Issue1: File System going into read-only mode
---------

Root cause:
-----------
=A0=A0=A0=A0=A0=A0 The driver tends to not free the memory (FIB) when t=
he management request exits prematurely. The accumulation of such un-fr=
eed memory causes the driver to fail to allocate anymore memory (FIB) a=
nd hence return 0x70000 value to the upper layer, which puts the file s=
ystem into read only mode.

=46ix details:
------------
=A0=A0=A0=A0 The fix makes sure to free the memory (FIB) even if the re=
quest exits prematurely hence ensuring the driver wouldn't run out of m=
emory (FIBs).


Issue2:
-------=20
	False Raid Alert occurs- when the Physical Drives and Logical drives a=
re reported as deleted or added, even though there is no change done on=
 the system

Root cause:
-----------
=A0=A0=A0=A0=A0=A0=A0 Driver IOCTLs is signaled with EINTR while waitin=
g on response from the lower layers. Returning "EINTR" will never initi=
ate internal retry.=20

=46ix details:
------------
=A0=A0=A0=A0=A0=A0=A0 The issue was fixed by replacing "EINTR" with "ER=
ESTARTSYS" for mid-layer retries.


Signed-off-by: Narasimha Reddy <ServeRAIDDriver@hcl.in>

       Please find the attached patch file "community_aac24701.patch", =
which has been generated for the issues we fixed and "email" file "comm=
unity_aac24701.email", which has been generated for the statistics like=
 number of lines inserted and deleted, errors etc.
      =20
Regards - Narasimha Reddy


DISCLAIMER:
-----------------------------------------------------------------------=
------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and =
intended for the named recipient(s) only.=20
It shall not attach any liability on the originator or HCL or its affil=
iates. Any views or opinions presented in=20
this email are solely those of the author and may not necessarily refle=
ct the opinions of HCL or its affiliates.=20
Any form of reproduction, dissemination, copying, disclosure, modificat=
ion, distribution and / or publication of=20
this message without the prior written consent of the author of this e-=
mail is strictly prohibited. If you have=20
received this email in error please delete it and notify the sender imm=
ediately. Before opening any mail and=20
attachments please check them for viruses and defect.

-----------------------------------------------------------------------=
------------------------------------------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
