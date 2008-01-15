From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: Open-FCoE on linux-scsi
Date: Mon, 14 Jan 2008 17:18:15 -0800
Message-ID: <10A7D0016239E24092DEF05CCC582E4302CFB7F7@fmsmsx411.amr.corp.intel.com>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com><477E1C69.9010203@s5r6.in-berlin.de> <20080104205938U.fujita.tomonori@lab.ntt.co.jp> <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com> <477EC411.9040703@s5r6.in-berlin.de> <477ECAD4.8010809@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54731 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYAOBSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 20:18:48 -0500
Content-class: urn:content-classes:message
In-Reply-To: <477ECAD4.8010809@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, "Dev, Vasu" <vasu.dev@intel.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
>Sent: Friday, January 04, 2008 4:10 PM
>To: Dev, Vasu
>Cc: FUJITA Tomonori; Love, Robert W; tomof@acm.org; Zou, Yi; Leech,
>Christopher; linux-scsi@vger.kernel.org
>Subject: Re: Open-FCoE on linux-scsi
>
>Stefan Richter wrote:
>> I.e. you have SCSI command set layer -- SCSI core -- SCSI transport
>> layer -- interconnect layer.
>
>The interconnect layer could be split further:
>SCSI command set layer -- SCSI core -- SCSI transport layer (FCP) --
>Fibre Channel core -- Fibre Channel card drivers, FCoE drivers.

This is how I see the comparison. ('/' indicates 'or')

You suggest						Open-FCoE
SCSI-ml						SCSI-ml
scsi_transport_fc.h				scsi_tranport_fc.h
scsi_transport_fc.c (FC core) / HBA		openfc / HBA
fcoe / HBA						fcoe / HBA

>From what I can see the layering is roughly the same with the main
difference being that we should be using more of (and putting more into)
scsi_transport_fc.h. Also we should make the FCP implementation (openfc)
fit in a bit nicer as scsi_transport_fc.c. We're going to look into
making better use of scsi_transport_fc.h as a first step.

I'm a little confused though; in a prior mail it seemed that you were
clubbing openfc and fcoe together, and at one point Fujita's stack
showed a libfcoe and fcoe fitting directly under scsi_transport_fc. I
think the layering is nicer at this point in the thread, where SCSI only
knows that it's using FC and the SW implementation of FCP knows the
transport. It's closer to my understanding of Open-iSCSI.

Open-iSCSI						Open-FCoE
scsi_transport_iscsi.c				scsi_transport_fc.c
iscsi_tcp.c						fcoe

I'm curious how aware you think scsi_transport_fc.h should be of FCoE?

>
>But this would only really make sense if anybody would implement
>additional FC-4 drivers besides FCP, e.g. RFC 2625, which would also
sit
>on top of Fibre Channel core.
>--
>Stefan Richter
>-=====-==--- ---= --=-=
>http://arcgraph.de/sr/
