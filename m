From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Warning: about not setting max_sectors
Date: Tue, 10 Dec 2002 08:47:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212101447.gBAElpJ01949@localhost.localdomain>
References: <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA06856
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 06:47:55 -0800
In-Reply-To: Message from Christoph Hellwig <hch@infradead.org>
   of "Tue, 10 Dec 2002 13:23:48 GMT." <20021210132348.A31628@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

hch@infradead.org said:
> I added this intentionally.  The default is set in scsi_register_host
> which is an obsolete interface.  This warning reminds driver writers
> to set the value explicitly, with scsi_add_host & friends they won't
> get a default anymore. 

I don't think that's the correct behaviour.  The parameter is labelled as 
optional (and clearly should be for drivers that have no hard transfer limit).

The blk_queue_max_sectors() clearly should be initialised with the device in 
mind.  We have this limit coming at us from two directions: the driver (if it 
imposes such a limit) and the device (e.g. a SCSI-1 device only does read 6 
and thus 256 is the maximum etc.)

we should probably take the lowest of the scsi-1 minimum and the HBA if it 
exists in scsi_initialize_queue and readjust it when we've decided on the 
capabilities of the device.

In any event, moving the zero check for shpnt->max_sectors to 
scsi_initialize_queue would fix the loss of scsi_add_host, wouldn't it?

James


