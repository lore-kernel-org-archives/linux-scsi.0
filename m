From: Patrick Mochel <mochel@osdl.org>
Subject: Removal of driverfs files in drivers/cdrom/cdrom.c
Date: Wed, 24 Jul 2002 14:57:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0207241456570.954-100000@cherise.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (mochel@localhost)
	by cherise.pdx.osdl.net (8.11.6/8.11.6) with ESMTP id g6OLvBt06419
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jul 2002 14:57:11 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



So, I'm looking at changing the driverfs API. In doring so, I came across 
this code in drivers/cdrom/cdrom.c:unregister_cdrom:

        if (atomic_read (&cdi->cdrom_driverfs_dev.refcount)) {
                device_remove_file (&cdi->cdrom_driverfs_dev, "name");
                device_remove_file (&cdi->cdrom_driverfs_dev, "kdev");
                put_device (&cdi->cdrom_driverfs_dev);
        }

This looks wrong, based on the fact that it wasn't the cdrom layer that 
created these files. They were, I believe, created by the SCSI cdrom 
layer. So, why are they being removed here, esp. since they are removed at 
a more general layer? 

Thanks,

        -pat


