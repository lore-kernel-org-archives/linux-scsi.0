From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [RFC - PATCH 0/3] SCSI: Initiator based LUN Masking - SCSI mid-layer
Date: Tue, 14 Aug 2012 13:16:28 +0200
Message-ID: <502A338C.4040006@linux.vnet.ibm.com>
References: <1344652511-13899-1-git-send-email-kgudipat@brocade.com> <50292D97.1030606@linux.vnet.ibm.com> <B5EE62D80D50B84BB9E5174F7FCCE80A2839ABBD1F@HQ1-EXCH02.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55854 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2HNLRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 07:17:48 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 14 Aug 2012 12:17:46 +0100
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7EBHc758650942
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2012 11:17:38 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7EBHh9c019134
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2012 05:17:44 -0600
In-Reply-To: <B5EE62D80D50B84BB9E5174F7FCCE80A2839ABBD1F@HQ1-EXCH02.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krishna Gudipati <kgudipat@Brocade.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Rob Evers <revers@redhat.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "hch@infradead.org" <hch@infradead.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.com>, Akshay Mathur <amathur@Brocade.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>

Hi Krishna,

On 08/14/2012 12:48 AM, Krishna Gudipati wrote:
>> From: Steffen Maier [mailto:maier@linux.vnet.ibm.com]
>> On 08/11/2012 04:35 AM, kgudipat@brocade.com wrote:

> [KRISHNA]: Steffen, yes you are right, currently in this proposal we =
only have 3 interfaces
> exported from SCSI mid-layer for LLD to configure LUN Masking.
> I believe with the interfaces provided currently we should be able to=
 enable LUN masking
> even though we don't have a persistent storage or a vendor-specific B=
SG based interface.
>
> The interfaces scsi_target_mask_lun() to mask a LUN and scsi_target_u=
nmask_lun() to unmask
> a LUN can be called dynamically even from your current sysfs implemen=
tation of LUN Masking.

Right, but this would mean unnecessary code duplication because each LL=
D=20
would have to implement its own user space interface, whereas common=20
code in the midlayer could handle all this transparently for any=20
(unmodified) LLD.

A common user space interface would also ease establishing a common=20
persistency mechanism in user space that can be used transparently by=20
any LLD.

> The advantage of having persistent storage in the LLD is we can have =
LUN Masking enabled/configured
> during the driver load, as we can call the APIs to configure LUN Mask=
ing from target_alloc() entry point
> and can avoid LUN Masking configuration from user space during every =
module load and during the
> target offline/online events as above.

I understand this makes sense for an LLD that already has a persistency=
=20
layer. However, in general, this is probably not the case. Therefore, i=
t=20
seems to me as if your approach focuses on the specific case rather tha=
n=20
the generic one.

> [KRISHNA]: The disadvantage of the LUN Masking implementation using t=
he SCSI slave callouts
> is we cannot do a REPORT_LUNS based SCSI scan and need to fall back t=
o Sequential LUN scan.
> The reason being if we return -ENXIO from slave_alloc() for any LUN t=
hat is part of the REPORT_LUNS
> response payload this would result in the scan being aborted. So we n=
eed to do a sequential LUN scan which
> is not so good as we end up scanning for 16K LUNs, for SPARSE LUNs. S=
o we came up with this proposal.

Good point, thanks for the explanation. This is definitely a big pro fo=
r=20
midlayer lun masking.

In zfcp, we haven't had this issue so far, because it was either no lun=
=20
scanning at all or allow all luns scanned by the midlayer. With midlaye=
r=20
lun masking, we could even allow the user to filter/select luns for the=
=20
latter case which is very useful for big storage sites with relaxed=20
target lun masking.

Speaking of big SANs, this could also extend to initiator based "zoning=
"=20
one day, i.e. having a common mechanism in scsi_transport_fc to let the=
=20
user specify which remote target port WWPNs she would like to use and=20
only login to those. But I guess, this is just wishful thinking right=20
now. We have users with >30 Linux images sharing each (of multiple for=20
multipathing) HBA and thus making up a lot of initiators often=20
configured into the same FC zone and this can cause all kinds of troubl=
e=20
especially if rezoning the fabric (preferably into single initiator=20
zones which can get many) is not an option.

> In addition the design can be enhanced to have something like udev ru=
les to maintain persistency
> as you mentioned; I will think it through, please let me know if you =
have some ideas.

Have a look at how SuSE configures s390 devices by means of udev rules=20
/etc/udev/rules.d/51-....rules written by /sbin/zfcp_disk_configure=20
being part of the s390-tools rpm package. Instead of writing to zfcp=20
specific sysfs attributes, it could write to midlayer sysfs attributes=20
provided for lun masking, as an example:
https://build.opensuse.org/package/view_file?file=3Dzfcp_disk_configure=
&package=3Ds390-tools&project=3DBase%3ASystem

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
