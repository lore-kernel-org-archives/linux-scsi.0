From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Removal of driverfs files in drivers/cdrom/cdrom.c
Date: Sun, 28 Jul 2002 14:50:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200207281950.g6SJo2Z02368@localhost.localdomain>
References: <sullivan@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA25552
	for <linux-scsi@vger.kernel.org>; Sun, 28 Jul 2002 12:50:42 -0700
In-Reply-To: Message from sullivan <sullivan@austin.ibm.com>
   of "Thu, 25 Jul 2002 08:36:49 CDT." <20020725083649.D1757@austin.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: sullivan <sullivan@austin.ibm.com>
Cc: Patrick Mochel <mochel@osdl.org>, linux-scsi@vger.kernel.org

mochel@osdl.org said:
> This looks wrong, based on the fact that it wasn't the cdrom layer
> that  created these files. They were, I believe, created by the SCSI
> cdrom  layer. So, why are they being removed here, esp. since they are
> removed at  a more general layer?  

sullivan@austin.ibm.com said:
> Maybe a first good step would be to move the cdrom support completely
> up into the general layer and use the presence of a non NULL parent
> field to indicate whether the lower level driver has added support for
> driverfs. We'd have to make sure the cdrom_drverfs_dev structure is
> initialized with zeros for all of the cdrom related driver layers that
> don't support driverfs yet. Let me know what you think. I'll pull a
> patch together...  

Pat,

I think the root cause of all the ugly code is that none of us knows how to 
match up the partitions or other adjunct elements which belong in the class 
code with the actual device, and the fact that the generic code (cdrom and 
genhd) is more than just SCSI, so we're all a little wary of messing too much 
with it.  Are you planning to embed a driverfs parent pointer in the relevant 
structures?  Do you think the best approach is to do driverfs creation/removal 
for everything in the generic cdrom driver?  We're all a bit reticent to do a 
wholesale rework of none scsi code without a clear idea of what we're supposed 
to be doing.

If you give me an idea of how you are thinking of matching up the parent 
pointers, I'll have a go at doing this more generally.

James




