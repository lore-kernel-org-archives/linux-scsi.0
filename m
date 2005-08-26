From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: fibre channel/multipath questions
Date: Fri, 26 Aug 2005 22:19:30 +0200
Message-ID: <430F7952.9010406@s5r6.in-berlin.de>
References: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:62865 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030250AbVHZUTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 16:19:38 -0400
Received: from [192.168.0.41] ([62.180.98.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j7QKJW6W015964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2005 22:19:33 +0200
In-Reply-To: <200508261812.23328.Rik.Bobbaers@cc.kuleuven.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Rik Bobbaers wrote:
> 2. Is it possible to make the fibrechannel driver get loaded AFTER the others? 
> (Our kernels have no modules support, so i built it all in the kernel for 
> security reasons etc...) The reason is very simple. If I have 1 disk on ESS, 
> it now becomes /dev/sda on scsi0, /dev/sdb on scsi1 and the local disks 
> are /dev/sdc and /dev/sdd. If I add another ESS disk , it will be /dev/sde 
> and /dev/sdf, after a reboot, they will be /dev/sdc and /dev/sdd, the  local 
> disks will become /dev/sde and /dev/sdf. At first i thought, use e2label, but 
> that's only for ext2/3 filesystems, our systems run on reiserfs. Are there 
> any sollutions for this in a monolythical kernel or is the only way to fix 
> this, compile the driver as modules and load them at boottime?

IMO the solution is not to enforce an order of device file names by 
whatever workaround (like order of driver initialization), but rather to 
identify devices independently of their device file name. Use persistent 
properties of devices like GUIDs, bus type, etc. There is a wealth of 
such information to be collected from sysfs or maybe procfs. Have a look 
at how udev gets such information and what it can do with it.
-- 
Stefan Richter
-=====-=-=-= =--- ==-=-
http://arcgraph.de/sr/
