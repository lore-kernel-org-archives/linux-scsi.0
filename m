From: Douglas Gilbert <dougg@torque.net>
Subject: Re: doubts about sg driver
Date: Thu, 14 Jun 2007 16:02:39 -0400
Message-ID: <46719EDF.3020308@torque.net>
References: <84219.67525.qm@web30104.mail.mud.yahoo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59191 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbXFNUDB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 16:03:01 -0400
In-Reply-To: <84219.67525.qm@web30104.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Parav Pandit <paravpandit@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Parav Pandit wrote:
> Hi,
> 
> Few basic questions on sg driver:
> 
> 1. Are there any hooks that low level HBA driver needs
> to implement - for providing support for SG (SCSI
> generic) driver?
> Or SG always interacts with scsi_mod and it is
> transparent to the HBA drivers?
>>From the tldp How-to and sg.c it looks like it doesn't
> directly talk with Low level HBA driver, but want to
> confirm.

The sg driver talks to the scsi mid level (and the
block layer strangely enough) but not directly to
LLDs.

> 2. Can applications talk with SCSI RAID controller
> device (some targets exposes LUN-0 as controller) 
> through sg interface or it is only for storage
> devices?

The sg driver is useful for any SCSI device (logical
unit) that is exposed by the scsi mid level. Apart
from direct access (i.e. disk) devices that might
include cd/dvd drives, tape drives, scsi enclosures,
saf-te controllers (which have processor peripheral
device type) and well known logical units.

> 3. How is the mapping between /dev/sda /dev/sdb etc to
> /dev/sg0 /dev/sg1 etc?
> Is this information is accessible via procfs or sysfs
> interface?

In the lk 2.6 series the mapping can be found in sysfs
(see lsscsi, specifically 'lsscsi -g'). In the sg3_utils
package the sg_map utility shows the mapping. That may
be helpful in the lk 2.4 series since there is no sysfs.

Doug Gilbert



