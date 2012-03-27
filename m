From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: [PATCH 0/3] scsi_dh_alua: Optimize the STPG behaviour in ALUA
 handler
Date: Tue, 27 Mar 2012 20:55:25 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B02C3D5@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:17389 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab2C0Uzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 16:55:33 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "Qi, Yanling" <Yanling.Qi@netapp.com>, "Stankey, Robert" <Robert.Stankey@netapp.com>

Past few months, we have been working on scsi_dh_alua handler using TPGS on NetApp
E series storage. One of the issue we found during the testing was, driver sends
STPG(Set Target Port Group) command every time the path group switch happens.
This is not optimal. It is not required to send STPG exclusively for every path
Group switch. It is beneficial to let the target to initiate implicit transfer in
some cases. These set of patches takes care of this handling.

By default there is no change in the behavior. User level(multipath tools) has to
Set the flag to take effect of the new behavior. Code has been tested on 
NetApp E series storage. 

Thanks to Bob Stankey and Yanling Qi for their help.

Big thanks to Hannes Reinecke for his suggestion and also reviewing the code.

thanks 
