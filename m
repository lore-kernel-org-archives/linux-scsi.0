From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Urgent: mptsas: the new port identifier mapping broken - itegrated raid, and no-raid devices on last channel
Date: Mon, 10 Jul 2006 20:19:53 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701F6255@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49081 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965051AbWGKCUI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jul 2006 22:20:08 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: dougg@torque.net

James -

I seemed to forgot I was reserving the last channel for 
integrated RAID. Thanks to Doug Gilbert reporting the issue.

The scsi channel is mapped to the port identifier, and 
port identifier is created by the sas transport layer, 
no longer mptsas.  Also,  we had to provide unique port 
identifiers inorder for new wide port API to work with
having unique kobject->bus_ids. Hence the mptsas firmware 
assigned port identifiers were thrown out, and that was
when this was broke.

Depending on which controller your using.  For the 1068, its
a 8 phy card, thus the 8th channel is suppose to be reserved
for the integrated raid volumes.  If your using a non-raid 
disk ends up getting assigned channel 8 by the sas transport
layer, its not going to be seen by scsi_scan_target. The
reason is due to incorrect target mapping in mptsas_target_alloc. 

That is due to my check 

	if (starget->channel == hd->ioc->num_ports)
		goto out;


So I can remove this check and non-raid devices work.

However what to do with integrated raid volumes.  I have 
to report these volumes separately from rphy_add. I have 
to use scsi_add_device from mptsas_scan_sas_topology.    

What channel can I place these at, which I can look for 
in the target/slave alloc routines? Or do you have
a better suggestion of handling integrated raid?

Eric Moore
		

