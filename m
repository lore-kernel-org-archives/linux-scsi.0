From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Some interesting results in the aic7xxx slowdown problem
Date: Tue, 30 Aug 2005 08:52:22 -0500
Message-ID: <1125409942.5037.2.camel@mulgrave>
References: <1123119347.5019.78.camel@mulgrave>
	 <20050804061809.GA4158@in.ibm.com> <1123166928.5026.8.camel@mulgrave>
	 <20050819095428.GA9130@in.ibm.com> <1124457765.5130.13.camel@mulgrave>
	 <20050825103943.GA7421@in.ibm.com> <1125328875.5089.37.camel@mulgrave>
	 <20050830044956.GA4187@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:61390 "EHLO
	accolon.hansenpartnership.com") by vger.kernel.org with ESMTP
	id S1750868AbVH3Nwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 09:52:37 -0400
In-Reply-To: <20050830044956.GA4187@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: suparna@in.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-08-30 at 10:19 +0530, Suparna Bhattacharya wrote:
> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>         <Adaptec aic7896/97 Ultra2 SCSI adapter>
>         aic7896/97: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
[...]
> scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
>         <Adaptec aic7896/97 Ultra2 SCSI adapter>
>         aic7896/97: Ultra2 Wide Channel B, SCSI Id=7, 32/253 SCBs

Aha, what I think has happened is that scsi0 and scsi1 have reversed
their detection order.  This is a consequence of moving aic7xxx to the
new PCI model.  We no-longer control the detection order, we get probed
in the order that the PCI subsystem decides.  In your case, it must have
decided to detect the external card first.

The PCI subsystem pulls a few tricks to try to prevent this, but most of
them rely on ACPI I think ... I assume this isn't an ACPI system?

James


