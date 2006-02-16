From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] shutdown processing
Date: Thu, 16 Feb 2006 19:56:52 +0100
Message-ID: <43F4CAF4.1070004@s5r6.in-berlin.de>
References: <20060215114605.1568c8cc.randy_d_dunlap@linux.intel.com>	<43F43EB9.40406@s5r6.in-berlin.de> <20060216104007.67cf613f.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56198 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1030474AbWBPS6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 13:58:19 -0500
In-Reply-To: <20060216104007.67cf613f.randy_d_dunlap@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 16 Feb 2006 09:58:33 +0100
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>Why are you calling these from SCSI? Wouldn't ahci_pci_driver.remove() 
>>and piix_pci_driver.remove() be a proper place to perform what you are 
>>doing in ata_device_shutdown?
> 
> Mostly to have the scsi_device pointers available.

Note that roughly as long a scsi_device exists, SCSI high-level drivers 
expect to be able to send commands to them. In particular, when 
scsi_remove_device is called, (or scsi_remove_host, which calls 
scsi_remove_device for all still existing devices of a host), the SCSI 
high-level drivers' shutdwon methods get executed. Some of them send 
SCSI commands. The upshot is, a SCSI low-level driver has to be able to 
handle newly enqueued command while it is calling 
scsi_remove_{device,host}. Moreover it must not block a SCSI host at 
this moment.

IOW the most natural order for layers to shut down would be first SCSI, 
then ATA. (But then, I don't really comprehend whether your shutdown 
code would actually collide with that of the SCSI subsystem at all.)
-- 
Stefan Richter
-=====-=-==- --=- =----
http://arcgraph.de/sr/
