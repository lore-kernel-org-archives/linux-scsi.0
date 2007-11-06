From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: FW: [PATCH 1/8] scsi: megaraid_sas - add hibernation support
Date: Tue, 6 Nov 2007 11:38:12 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501CA1B91@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37314 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbXKFSiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 13:38:14 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id lA6Ia2fL022408
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 10:36:02 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id lA6IcHLt027123
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 10:38:17 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Re-Sending:

James, 

The current feature request is to allow the user to change "cmd_per_lun"
and "max_sectors" only during the driver loading time. I agree with you
it is very good feature to provide option to modify these during run
time. In future this may be done as required/requested for. But as you
may see, there are more changes included in the patch submission.  We
really need this submission be accepted and then we can start to submit
the next set of changes. 

Thanks & Regards,

Bo Yang

From: Yang, Bo 
Sent: Thursday, November 01, 2007 3:17 PM
To: James Bottomley
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org;
linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: [PATCH 1/8] scsi: megaraid_sas - add hibernation support

James, 

The current feature request is to allow the user to change "cmd_per_lun"
and "max_sectors" only during the driver loading time. I agree with you
it is very good feature to provide option to modify these during run
time. In future this may be done as required/requested for. But as you
may see, there are more changes included in the patch submission.  We
really need this submission be accepted and then we can start to submit
the next set of changes. 

Thanks & Regards,

Bo Yang

 

 

From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
Sent: Wed 10/31/2007 11:12 AM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org;
linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: [PATCH 1/8] scsi: megaraid_sas - add hibernation support

On Wed, 2007-10-31 at 07:25 -0600, Yang, Bo wrote:
> James,
> I did respond to Randy earlier.

Sorry, I couldn't find it in the archive when I looked ... although the
scsi reflector seems to be missing quite a few of your emails for some
reason.

> About the module params being added :
>
> The fast_load parameter is for the user to decide at driver load time
> if (s)he wants to skip scan of devices in PD channels.
>
> After driver is loaded the user cannot be permitted to modify this
> value. If the user needs to see the devices in the PD channels, (s)he
> may initiate a scan via sysfs/proc based on the kernel being used.
> Once the user has done the scan, the fast_load value does not have any
> significance and thus not exposed for reading.
>
> cmd_per_lun & max_sectors are also intended to be provided by user
> only at driver load time. In the current implementation both these do
> appear as read-only values under host# in sysfs. The current design is
> not to allow these values to be modified on the fly.

fastload sounds reasonable.  cmd_per_lun and max_sectors could
reasonably be altered at runtime ... just execute and unbind and rebind
operation to make them take effect.

James



 
