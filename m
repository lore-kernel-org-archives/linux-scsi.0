From: Ramesh Chikkanayakanahally <rcnagara@Brocade.com>
Subject: Question on SCSI target scan
Date: Wed, 6 Nov 2013 07:10:12 -0700
Message-ID: <5645D6F831469342AF2BC26CC827D68C5940032A27@BRM-EXCH-3.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:59409 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932208Ab3KFObs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Nov 2013 09:31:48 -0500
Received: from pps.filterd (m0000700 [127.0.0.1])
	by mx0b-000f0801.pphosted.com (8.14.5/8.14.5) with SMTP id rA6E8ZFP030232
	for <linux-scsi@vger.kernel.org>; Wed, 6 Nov 2013 06:10:15 -0800
Received: from brmwp-exchub01.corp.brocade.com ([208.47.132.227])
	by mx0b-000f0801.pphosted.com with ESMTP id 1fybut8f49-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2013 06:10:15 -0800
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>

Hi,

This question is related to scsi_transport_fc layer.

Background:
=A0=A0=A0 When new LUNs are added to a target, the target can send chec=
k condition with SK/ASC/ASCQ indicating that the reported LUNS data has=
 changed. Then the initiator can send the report LUNs command to discov=
er the changes. But if there are currently no LUNs or in case there is =
no activity on existing LUNs, then this mechanism will not be efficient=
=2E So few target implementations seem to trigger RSCN with the Event q=
ualifier set to zeroes (event not specified) and Address format set to =
Port address of the effected target port. The expectation here is that,=
 if the initiator had already logged into this target, it would verify =
the status of this target and if found online, it would issue report LU=
Ns to discover the changes to LUNs. While this mechanism does not compl=
y with SCSI or FC standards, this looks like one of the methods that is=
 used by few target implementations. Assumption here is that, there is =
no other mechanism provided by SCSI or FC standards to achieve this.

Question:
=A0 The existing interfaces of scsi_transport_fc module does not seem t=
o provide a mechanism to trigger the SCSI target scan on a rport which =
is already registered using fc_remote_port_add() and is currently onlin=
e (not blocked or deleted). If this understanding is correct, would it =
be useful to provide an interface that can be used to trigger the SCSI =
target scan in the above mentioned scenario ?

Could you please suggest ?

Thanks,
Ramesh C N

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
