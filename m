From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: SCSI-ID persistence query...
Date: Thu, 13 May 2004 09:00:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFC89E11D6.DB902E0D-ON88256E93.0056DD71-88256E93.0057BCFA@us.ibm.com>
References: <20040513110021.36867.qmail@web51006.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:9393 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264271AbUEMQAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 12:00:08 -0400
In-Reply-To: <20040513110021.36867.qmail@web51006.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Shobhit Mathur <shobhitmmathur@yahoo.com>
Cc: linux-scsi@vger.kernel.org

>How do SCSI targets/LUNs get numbered ?

There are lots of different ways that SCSI targets and logical units get 
numbered/named.  (The LUN is one way a logical unit gets numbered).  You 
didn't say which numbers you're talking about, but I'm going to guess from 
some things you say in your posting that you're interested in the Linux 
device numbers (major/minor).

They're pretty much arbitrary and unpersistent.

Linux basically assigns them sequentially to logical units as it discovers 
their existence, which means if everything stays stable across reboots, 
including which devices are visible, which device drivers you load, and 
what LUNs the targets assign to their logical units, you will see the same 
device number for the same logical unit before and after reboot.  In 
practice, this stability is fairly common.  But the more complex your 
system, the less you can rely on that.  In large complex systems, people 
create device special files on the fly, one way or another (e.g. udev), 
such that the device special file name persistently identifies a 
particular logical unit, even though the device number (or even the target 
ID and LUN) are arbitrary.

