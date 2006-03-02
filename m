From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 2 Mar 2006 15:13:23 -0800
Message-ID: <20060302231323.GA12869@us.ibm.com>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:62445 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752082AbWCBXSJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 18:18:09 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k22NI8eP007865
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 18:18:08 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k22NKsYA132230
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 16:20:54 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k22NI8Nr030861
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 16:18:08 -0700
Content-Disposition: inline
In-Reply-To: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> This fairly minimal patch correctly attaches the aic94xx driver to the
> SAS transport class (The driver is available from
> 
> www.kernel.org/git/jgarzik/sas-2.6
> 
> ).  Unfortunately, the driver itself still has the following critical
> issues
> 
> 1. Discovery order is non-deterministic (it starts one thread per port,
> so the threads race for discovery)
> 

The issue also results in the device discovery not completing by the time
the module load completes resulting in the initrd not finding the boot
disk
http://bugzilla.kernel.org/show_bug.cgi?id=6045

I agree that we need a solution for this. Should the solution be in the
LLDDs.I thought previous comments was that we wanted this fixed outside
the kernel in user space. Though I have not seen any enabled support in
initrds or support in the initrd bins.

This appears to not only be an issue with aic94xx as it appears this could
happen with some of the fc transport LLDDs.

-andmike
--
Michael Anderson
andmike@us.ibm.com
