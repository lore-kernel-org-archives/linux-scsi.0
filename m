From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvscsi: Non SCSI error status fixup
Date: Tue, 20 May 2008 08:52:36 -0500
Message-ID: <4832D7A4.1070609@linux.vnet.ibm.com>
References: <12112108763801-patch-mail.ibm.com> <18481.41759.969242.972595@gargle.gargle.HOWL> <1211245688.12970.0.camel@localhost>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53612 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbYETNwj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 09:52:39 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4KDqcOG023521
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 09:52:38 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4KDqcne163710
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 09:52:38 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4KDqb8N020388
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 09:52:38 -0400
In-Reply-To: <1211245688.12970.0.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michael@ellerman.id.au
Cc: Dave Boutcher <boutcher@cs.umn.edu>, linuxppc-dev@ozlabs.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Michael Ellerman wrote:
> On Mon, 2008-05-19 at 10:56 -0500, Dave Boutcher wrote:
>> On Mon, 19 May 2008 10:27:56 -0500, Brian King <brking@linux.vnet.ibm.com> said:
>>> Some versions of the Virtual I/O Server on Power
>>> return 0x99 in the non-SCSI error status field as success,
>>> rather than 0. This fixes the ibmvscsi driver to treat this
>>> response as success.
>> Yeah....0x99...that's an intuitive value for success.
> 
> Hopefully there are no versions that return 0x99 for an error? :)

There shouldn't be. 0x99 is actually not defined as a valid value for
that field, but it is what the ibmvscsis VIOS that is included in
SLES 9 and SLES 10 return on success, due to a bug in that driver.
We plan to fix the ibmvscsis driver as well, but it will take a while
for that fix to propagate. Until very recently, the status field was not
checked, which is why we are only recently running into this problem.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
