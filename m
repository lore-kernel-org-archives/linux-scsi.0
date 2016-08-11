From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] SAS: use sas_rphy instead of sas_end_device to obtain
 address.
Date: Thu, 11 Aug 2016 08:09:35 -0700
Message-ID: <1470928175.2334.9.camel@linux.vnet.ibm.com>
References: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470902352-96734-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-08-11 at 09:59 +0200, Johannes Thumshirn wrote:
> Since commit 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
> enclosures') ses_match_to_enclosure() is calling sas_get_address(),
> which is coming from commit bcf508c13385 ('scsi_transport_sas: add
> function to get SAS endpoint address'). sas_get_address() itself 
> calls sas_sdev_to_rdev() which BUG_ON()s if a given scsi_device's 
> rphy is not a SAS_END_DEVICE.

Is the BUG_ON the problem?  you're supposed to gate this call with
is_sas_attached().

> As SAS Enclosure is a SAS expander device,

This isn't necessarily true.  There are several separated enclosure
chips even in the SAS world (although most of the new ones are
integrated).

>  we really shouldn't tie the lookup of a SAS address to the SAS End
> Device but the sas_rphy, which holds the address information.

This is conceptually wrong.  A wide end device may have many rphys
forming a port.  In that case the end device address is likely to be
only one of the rphy addresses ... how do you know this code picks the
right one?

> Fixes: 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
> enclosures')
> Cc: stable@vger.kernel.org # v4.5+

What's the actual bug being fixed here?

James
