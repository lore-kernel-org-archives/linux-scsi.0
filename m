From: Srinivas Naga Venkatasatya Pasagadugula <satyasrinivasp@hcl.in>
Subject: LIBSAS:Issue with cascading of edge expanders
Date: Fri, 16 Oct 2009 17:14:12 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF38546AA22B@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:55720 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZJPLqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2009 07:46:36 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "jasonchu@marvell.com" <jasonchu@marvell.com>, "ayan@marvell.com" <ayan@marvell.com>, "kewei@marvell.com" <kewei@marvell.com>

Hi,

I have some issues with cascading of edge expanders in linux kernel-2.6.31.

Test Environment:
-------------------
Linux Kernel-2.6.31.
I'm using Adaptec ASC-1045/1405 which uses the Marvell 88SE6440 chip and I am using 2.6.31-mvsas driver.

Problem Description.
--------------------
Cold boot of cascading expanders are working fine but hot plug in and plug out of the same is not working properly.

Root Cause:
-------------
After analyzing the same I have figured out the problem is in sas_expander.c (libsas). It is not working when the phy change is occurred to remove the devices or to rediscover the devices.

...... sas_expander.c....
1805 static int sas_discover_new(struct domain_device *dev, int phy_id)

1832         res = sas_ex_discover_devices(dev, phy_id);
1833         if (!res)
1834                 goto out;
..........

Solution:
------------
The same issue doesn't occur after modifying the code like this.
...sas_expander.c...
1832            res = sas_ex_discover_devices(dev, phy_id);
1833        if (res)
1834               goto out;
............

Is this is the fix for the same? Any inputs are highly appreciated.

Thanks
Srinivas.


DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
