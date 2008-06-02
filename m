From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 14:54:30 -0400
Message-ID: <484441E6.8020501@garzik.org>
References: <12124164141515-patch-mail.ibm.com>	 <48441AEE.6050605@garzik.org> <48441F82.6060706@linux.vnet.ibm.com>	 <1212425124.3369.20.camel@localhost.localdomain>	 <4844312C.7010403@garzik.org> <1212429428.3369.45.camel@localhost.localdomain> <484437C3.8020306@garzik.org> <48444126.8050107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48444126.8050107@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@linux.vnet.ibm.com, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> One thing that having a per-port SCSI host buys us is that it isolates
> EH to the port rather than the entire SCSI host. The way that the new
> libata EH is designed, it can end up spending a fair amount of time
> in EH and may even sleep for seconds at a time, waiting for the device
> to come ready. Quiescing all devices on a SAS host due to a single
> SATA device gets *very* painful. The new libata EH does much more than
> just EH. It wakes up for every ATAPI check condition...
> 
> Before we can move to a single SCSI host model, we will
> have to make some changes regarding how EH is done in libata...


Good points.  There definitely needs to be a discussion about how to 
integrate libata EH with libsas model and ipr model (which are distinct, 
if similar).

libata EH was coded to largely be "in the driver's seat", which isn't 
true in a world where it is a peer to SAS devices.  Also libata EH 
duplicates some of the link EH stuff that SAS deals with, and must 
subsume (since libsas knows about both SAS and SATA phys, and an ideal 
world doesn't have the two as separate as they are now).

	Jeff



