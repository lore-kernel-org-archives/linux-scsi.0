From: James.Smart@Emulex.Com
Subject: RE: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 11:13:46 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F278@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48044 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262366AbUKQQOK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 11:14:10 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MPESCHKE@de.ibm.com, hch@lst.de
Cc: akpm@osdl.org, linux390@de.ibm.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, schwidefsky@de.ibm.com

> What is your answer to those who wish to manage FC HBAs in a
> common way?

FYI - We (Emulex) have taken the action to update the FC Transport such that hbaapi can be layered upon it. You're welcome to join in.

To date, we have proposed changes to provide local port statistics and attributes. See the following threads:
http://marc.theaimsgroup.com/?l=linux-scsi&m=109813309907129&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=109776541525816&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=109776571032665&w=2

A patch proposal for remote port attributes will be posted soon. Adding target attributes would have been easy - but we needed to present all remote ports, regardless of whether they are FCP targets or not, and it complicated things.

Also, a first cut at sysfs functions for hbaapi services is contained in our 8.0.13 driver out on sourceforge. After the remote port attributes, we'll move the functions out of the driver and into the fc transport at the host level - and put out the corresponding proposal. There are 2 functions that are problematic under sysfs (CT pass thru, and RNID) as the payload sizes want to be bigger than 4k. The current implementations in our driver limit the payloads at 4k.

After the above exists - it should remove the need for vendor-specific hbaapi libraries. A single library can be created that uses the fc transport interfaces to interact with the drivers. We've identified a couple of small things that may be vendor-specific, but it should be very easy to deal with via a text-based config file that can be used by the library.

-- James
