From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB
	cmds with sense info
Date: Fri, 22 Feb 2008 10:35:31 -0600
Message-ID: <1203698131.6206.22.camel@localhost.localdomain>
References: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34043 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547AbYBVQfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 11:35:34 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>


On Fri, 2008-02-22 at 09:17 -0700, Yang, Bo wrote:
> James,
> 
> What is the status for this patch?  We need to submit more patches based
> on the acceptance of this patch.

OK, read the thread; Matthew is right.  What you propose would pretty
much destroy compat ioctl handling within the driver.  You need a compat
handler for MEGASAS_IOC_FW.

With your current patch you'd get a failure both from a 64 bit binary
running on x86-64 and if someone ran the x86 binary on ia64.

The driver already uses the compat infrastructure, it shouldn't be too
hard to add this in the correct manner.

James


