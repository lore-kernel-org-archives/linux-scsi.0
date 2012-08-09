From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: FC_PORTSPEED semantics confusion and zfcp regression
Date: Thu, 09 Aug 2012 18:15:02 +0200
Message-ID: <5023E206.2080104@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:37816 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2HIQQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2012 12:16:26 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Thu, 9 Aug 2012 17:16:24 +0100
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q79GGHDF2289760
	for <linux-scsi@vger.kernel.org>; Thu, 9 Aug 2012 17:16:18 +0100
Received: from d06av03.portsmouth.uk.ibm.com (localhost.localdomain [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q79GGHQY001834
	for <linux-scsi@vger.kernel.org>; Thu, 9 Aug 2012 10:16:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Neerav Parikh <neerav.parikh@intel.com>, Ross Brattain <ross.b.brattain@intel.com>, Robert Love <robert.w.love@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

Earlier, commit
1832a5862f2e1b4e5835611ee14bc30a8ed3cad5
"[SCSI] change port speed definitions for scsi_transport_fc"
changed the semantics of FC_PORTSPEED defines to match the Report Port=20
Speed Capabilities (RPSC) ELS of FC-GS/FS-LS instead of FC-HBA/SM-HBA.=20
It also mentions the problem that FC-HBA/SM-HBA and FC-GS/FC-LS contain=
=20
somewhat contradicting bit definitions for port speed.

Lately, commit
a9277e7783651d4e0a849f7988340b1c1cf748a4
"[SCSI] scsi_transport_fc: Getting FC Port Speed in sync with FC-GS"
reverted this.
(See also http://marc.info/?l=3Dlinux-scsi&m=3D132892310322550&w=3D2.)

However, there does not seem to be an explicit explanation of this.
While the source code comment of struct fc_host_attrs says its fields=20
adhere to HBAAPI 2.0, the comment of the FC_PORTSPEED defines does not=20
explicitly do so and a (new) user of the latter might not see the=20
relation to the structure fields, esp. since there is no obvious=20
relation in terms of C types other than being type compatible to a=20
generic int.
The commit message also does not say so but mentions SM-HBA along with=20
=46C-GS without stating that they contradict themselves and FS-GS even=20
within the same document since it defines both RPSC ELS and FDMI port=20
attributes.

1) Is this change of semantics deliberate?

The commit message of a9277e7 states that user space is not affected=20
since it only sees text strings in the corresponding sysfs attributes.

Actually, commit c3d2350a8420dbf9d48f5f8a0fb72117bfcbc1b0
"[SCSI] fc_transport: update potential link speeds"
deliberately decided against syncing the bit definitions because of a=20
potential binary-incompatibility.

Is there some use of the bit definition that is not as transparent as=20
the text string based sysfs interface of an fc_host? E.g. using=20
scsi_transport_fc.h in user space libraries or applications (if this is=
=20
even allowed to be exported to user space)? I could find an in-kernel=20
binary use in libfc/fc_lport.c which could alternatively do a conversio=
n=20
between the old RPSC ELS format of fc_host_{supported_}speed{s}() (and=20
libfc/fc_lport.c which has probably the same format as fc_host) when=20
building the FDMI blob in scsi/fc_encode.h:fc_ct_ms_fill()?

2) Why did commit a9277e7 change the kernel internal bit definitions?

The zfcp LLDD has been copying the supported speeds value directly from=
=20
what is reported by the HBA since the latter adheres to the RPSC ELS=20
format for line speeds. Since commit a9277e7 this is broken now and we=20
see 10 Gbit instead of 4 Gbit in the supported_speeds sysfs attribute o=
f=20
the fc_host. I don't mind converting zfcp to an explicit finite bit=20
conversion based on individually defined constants, esp. since all othe=
r=20
=46C LLDDs (qla2xxx, bfa, lpfc, ibmvscsi, fnic, mptfc) seem to do so=20
already. The only slight drawback I can see is that the code needs to b=
e=20
touched for new HBA generations supporting new port speeds.

3) Should we have port speed defines for both RPSC ELS (in=20
include/fc/fc_els.h?) and FDMI port attributes (in=20
include/scsi/scsi_transport_fc.h? unless the bit semantic change gets=20
reverted)?

This way I could reuse the former to convert to the latter within zfcp=20
and other users can reuse it with regard to RPSC ELS. I would send a=20
patch if we agree on this.

4) Either way, should the port speed defines indicate RPSC ELS vs. FDMI=
=20
more explicitly in their identifier names, in order to avoid future=20
confusion?

Regards,
Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
