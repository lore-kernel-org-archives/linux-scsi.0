From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 21 Jun 2007 21:41:22 -0400
Message-ID: <1182476482.3923.44.camel@mulgrave.il.steeleye.com>
References: <200706191025.30986.swen@vnet.ibm.com>
	 <20070619171217.GA30099@infradead.org>
	 <1182307586.10507.7.camel@mulgrave.il.steeleye.com>
	 <20070621150308.GA29643@schmichrtp.de.ibm.com>
	 <467AAB55.9040306@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41461 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbXFVBlX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 21:41:23 -0400
In-Reply-To: <467AAB55.9040306@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

On Thu, 2007-06-21 at 18:46 +0200, Stefan Richter wrote:
> For example, the SCSI midlayer H:C:T:L tuple is useless for
> SBP-2-attached devices.  What is useful is the ieee1394_id sysfs
> attribute which we expose as a scsi_device's sysfs attribute.  This
> attribute was something implementation-defined until now, but I changed
> it to the concatenation of target port identifier and logical unit
> identifier for Linux 2.6.22, as per SAM(-4) annex A.  (That change is
> merely an alternative format for the old sbp2 driver and the only format
> for the new fw-sbp2 driver.)
> 
> Or did I miss something and there is already a mechanism for transports
> to expose target/LU identifiers?  So that userland doesn't have to care
> what transport it is, except as far as the details of the identifiers'
> formats are concerned? 

H:C is really mid-layer defined (although I'd like to get rid of C
eventually).  They really correspond to physical enumeration of the HBA
devices.  T (or I) is the one we think could be abstracted and placed
within the gift of the transport, but so far there's been a lot of
debate with few actual concrete proposals.  L is basically defined by
SAM for every transport, but I'm really unsure how it should be
represented in all its SAM specified glory.

James


