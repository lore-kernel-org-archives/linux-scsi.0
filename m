From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH] aacraid: Add module param to export disks as 'fixed' instead of 'removable'
Date: Fri, 20 May 2011 06:31:32 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A90177781C@XYUS-EX22.xyus.xyratex.com>
References: <4DD2CE01.9090403@suse.de> <20110517193544.GA27336@infradead.org> <FC1F9E38C0703341A1A750524E2525A9017776E1@XYUS-EX22.xyus.xyratex.com> <4DD665BF.4080502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:49076 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756450Ab1ETNcD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 09:32:03 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4DD665BF.4080502@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com, Hannes Reinecke <hare@suse.de>

There are several places where the transition from one RAID state to
another results in Capacity changes, or partition table changes. Each
change in state would walk the device nodes, and quite frankly, at a
rapid pace.

There are several steps when creating an array, each step requires the
updated information to be part of the system. These changes are
initiated asynchronously by the Firmware (only access to kernel space),
and not the Management Software (user space). The events that trigger
these changes are reported as AIF (Adapter Initiated FIB) and trigger
the rescan and target determination via APIs in the kernel. In one of
the more critical states of array creation the partition table of the
original targets can show on the array, then be cleared as the build
starts.

Hotspares have a similar action where the legacy partition table
information is erased, and this needs to be reflected on the system,
without a node walk (the alternative to re-reading the partition tables,
WWN and Capacity information is a node walk).

It is obvious the effect thin-provisioning would have on node-walking,
snapshot is less obvious. The Firmware actually creates a new R/O
device, but the original R/W device is replaced internally with the R/O
device with a Journal to track and manage the R/W nature. There is a
'glitch' where the device changes state three times and one of those
states resulted in a momentary increase in Capacity. They were not going
to fix this, but no bother, the fact that the device is listed as
Removable hid this problem from Linux.

Adaptec RAID controllers are not the only ones with this problem.

I am sure, given time, I can provide some additional cases.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Ankit Jain [mailto:jankit@suse.de] 
Sent: Friday, May 20, 2011 9:00 AM
To: Mark Salyzyn
Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; aacraid@adaptec.com;
Hannes Reinecke
Subject: Re: [PATCH] aacraid: Add module param to export disks as
'fixed' instead of 'removable'

On 05/19/2011 01:51 AM, Mark Salyzyn wrote:
>> On Wed, May 18, 2011 at 01:05:29AM +0530, Ankit Jain wrote:
>>> aacraid: Add 'aac_export_fixed' module param to export disks as
>>> 'fixed' instead of 'removable'.
>>> Adaptec controllers set the removable flag on devices to
>>> allow for reconfiguration. The fear is that _not_ setting this
>>> flag would inhibit the OS from detecting any device reconfiguration.
>> The flag should not be set at all and just be removed.
> 
> This will break the RAID Management Software, and various Firmware
> features (snapshot, thin-provisioning etc)

I'm trying to get a better understanding. How do the RAID management
software and firmware features depend on this?

-- 
Ankit Jain
SUSE Labs
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


