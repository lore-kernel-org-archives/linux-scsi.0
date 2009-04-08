From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Adding directory under /sys/class/fc_host/hostX
Date: Tue, 7 Apr 2009 18:05:51 -0700
Message-ID: <84C2BA6A-9B05-407A-BD34-03EA905D5DE6@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:32756 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbZDHBFx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 21:05:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I see following two ways to add sub-directories under the /sys/class/ 
fc_host/hostX/ in sysfs.
	a) Add a new attribute_group for each directory to be created in  
transport_container structure.
	2) Create a sysfs group and add attributes to it in the transport  
layer.

	I was thinking of second approach, since the sub-directories that  
needs to be added, may not be a generic one and specific to transport.  
In such a case adding the attribute group to transport_container  
structure may affect all other transport layer. Keeping it local to  
particular transport layer will restrict the changes to a particular  
transport layer.
	
	I see class devices getting added to the system after host setup  
routine is completed by transport layer. These sub-directories needs  
to be created after the class devices are added to the system. Hence,  
I was thinking of doing this in FC transport layer by passing  
host_configure routine as part of  transport class declaration.  
During, host configure routine, the transport layer will go ahead and  
create the sub-directories and add the attributes to them.

Thanks,
Giridhar.M.B






