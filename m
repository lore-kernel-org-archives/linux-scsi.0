From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch for 2.6.32? 3/3] scsi: fix another crash at disconnect
 of usb strorage
Date: Tue, 17 Nov 2009 17:44:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911171742380.3501-100000@iolanthe.rowland.org>
References: <200911172210.nAHMADAW014298@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60373 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754535AbZKQWoe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 17:44:34 -0500
In-Reply-To: <200911172210.nAHMADAW014298@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, kuznet@ms2.inr.ac.ru, alan@lxorguk.ukuu.org.uk, den@openvz.org

On Tue, 17 Nov 2009 akpm@linux-foundation.org wrote:

> From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> 
> Asynchronous scan (scsi_add_lun()) sets state to SDEV_RUNNING, but the
> device is not registered in sysfs.  Before async scan it was OK, because
> before releasing scan_mutex old code called either scsi_sysfs_add_sdev()
> or scsi_destroy_sdev() and, therefore, completed the work or discarded it.
> 
> With async scan the invariant is broken and scsi crashes in
> __scsi_remove_device() when trying to unregister not registered devices.

Alexey, have you seen the patches I posted?  In particular this one, 
but also the following three messages:

	http://marc.info/?l=linux-scsi&m=125675695827770&w=2

It does what you want to accomplish and more.

Alan Stern

