From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Request for comment on new I2O driver
Date: Tue, 29 Jun 2004 01:21:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40E0A7FA.4050208@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.239.201.226] ([213.239.201.226]:18883 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S265163AbUF1Xax (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 19:30:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

in the last few weeks i've partly rewritten the I2O subsystem to better 
suite the 2.6 kernel (sysfs support, PCI probing, dynamically allocated 
request queues and gendisks for block devices, ...). Although i'm not 
finished, it would be nice if someone could comment about it.

Because the patch is 500K large, it's better to view the sources online:

http://i2o.shadowconnect.com/svn/repos/kernel/trunk/drivers/message/i2o/

Login: anonymous
without a password.

The i2o_*.c files are still "old", so please skip those :-)

Any advices/comments would be appreciated, but escpecially interesting 
for me would be:

- sysfs
   * Is the way it is done okay?
   * Is there something important missing?
   * In the PCI probing function the device struct from pci_dev is simply
     copied to the device struct from I2O controller. Is this okay, or is
     there a better way to do it?

- interrupt handling
   * are 4 (or maybe more) function calls inside an interrupt bearable
   * could / should the interrupt handler put incomming data in a
     workqueue?

- workqueue
   * i've implemented a workqueue for event handling for each driver
     (e. g. block device, tape device, ...). Is this to expensive?

- file split
   * i've split the huge i2o_core into 7 smaller ones. Is there a problem
     with it?

- kmalloc/mempool in request queue prep function
   * i've used a kmalloc in the request queue prep. The scsi layer uses a
     mempool for it. At the moment the driver only need 47k memory. But
     is it better to pre-allocate the memory in this case?

Thank you very much for any advice/comment in advance.


Best regards,

Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
