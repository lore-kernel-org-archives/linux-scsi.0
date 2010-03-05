From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Fri, 5 Mar 2010 09:31:02 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003050926090.1677-100000@iolanthe.rowland.org>
References: <233671224A0FED4688218FFDBED26E1A5181BF12E4@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <233671224A0FED4688218FFDBED26E1A5181BF12E4@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 4 Mar 2010, Hugh Daschbach wrote:

> I have added get_device()/put_device() to ensure there's the device
> hasn't fully disappeared before calling list_del_init().  Is this
> needed?

Yes, it is.  In fact, it's necessary to insure the device doesn't
disappear before you call the shutdown routines!

>  If so, there's "might_sleep()" commented out in put_device().
> Do I need to release the lock before calling put_device()?

A better approach might be to do the list_del_init() while still 
holding the initial spinlock, before you call the shutdown methods.  
Then do the put_device() before reacquiring the spinlock at the end of 
the loop.

Alan Stern
