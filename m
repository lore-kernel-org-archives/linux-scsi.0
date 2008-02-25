From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDBcmds with sense info
Date: Mon, 25 Feb 2008 14:30:19 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501F69BBB@NAMAIL1.ad.lsil.com>
References: <1203698131.6206.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36823 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYBYVaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2008 16:30:46 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1203698131.6206.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>

James,

Thanks for the reply.  We will resubmit the patch to rollback it to our
original implementation.

Regards.

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, February 22, 2008 11:36 AM
To: Yang, Bo
Cc: Matthew Wilcox; linux-scsi@vger.kernel.org; akpm@osdl.org;
linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of
DCDBcmds with sense info


On Fri, 2008-02-22 at 09:17 -0700, Yang, Bo wrote:
> James,
> 
> What is the status for this patch?  We need to submit more patches 
> based on the acceptance of this patch.

OK, read the thread; Matthew is right.  What you propose would pretty
much destroy compat ioctl handling within the driver.  You need a compat
handler for MEGASAS_IOC_FW.

With your current patch you'd get a failure both from a 64 bit binary
running on x86-64 and if someone ran the x86 binary on ia64.

The driver already uses the compat infrastructure, it shouldn't be too
hard to add this in the correct manner.

James


