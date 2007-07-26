From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 6/21] advansys: Move to scsi hotplug initialisation model
Date: Thu, 26 Jul 2007 14:13:00 -0400
Message-ID: <46A8E42C.9070805@garzik.org>
References: <20070726171141.GE19275@parisc-linux.org> <11854705779-git-send-email-matthew@wil.cx> <20070726180112.GA3392@infradead.org> <20070726180446.GI19275@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50149 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761173AbXGZSN1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 14:13:27 -0400
In-Reply-To: <20070726180446.GI19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Jul 26, 2007 at 07:01:12PM +0100, Christoph Hellwig wrote:
>> On Thu, Jul 26, 2007 at 01:22:42PM -0400, Matthew Wilcox wrote:
>>>  - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
>>>    scsi_add_host, scsi_scan_host and scsi_host_put.
>>>  - Rename the scsi_host_template to advansys_template
>>>  - Move the memory freeing on error from advansys_wide_init_chip()
>>>    back into advansys_board_found() as we need to free it if
>>>    scsi_add_host() returns an error.
>> If you switch to new style allocation please also remove ->detect and
>> ->release.  We don't really want half-conversions to the new model.
> 
> That happened in patch 4.

Incorrect.  It happened in "convert to pci_register_driver interface", 
42a06cfdd19a436047fef419d9b621c917118e3c

And Christoph is right -- ->detect and ->release should disappear in the 
same commit that you upgrade to the new scsi host model -- and stop 
including scsi_module.c -- otherwise your patch is incomplete (and 
broken WRT git-bisect producing a working driver at each point).

Look at the relevant code in scsi_module.c:

         sht->detect(sht);
         if (list_empty(&sht->legacy_hosts))
                 return -ENODEV;

If you are not using the old scsi_register() stuff, you are not 
populating sht->legacy_hosts, and your module load will fail.

	Jeff


