From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patches] rq_dev removal
Date: Fri, 01 Nov 2002 09:05:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211011405.gA1E53x02349@localhost.localdomain>
References: <dougg@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA13211
	for <linux-scsi@vger.kernel.org>; Fri, 1 Nov 2002 06:05:07 -0800
In-Reply-To: Message from Douglas Gilbert <dougg@torque.net>
   of "Fri, 01 Nov 2002 13:43:04 +1100." <3DC1EA38.2080105@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: wrlk@riede.org, Alexander Viro <viro@math.psu.edu>, linux-scsi@vger.kernel.org

dougg@torque.net said:
> It seems as though sg's (scsi) _device_ abstraction has been replaced
> by a _disk_ abstraction. At the very least this is misleading for the
> dvd/cd writers, scanners, tape robots and enclosures that sg typically
> deals with. 

Well, yes and no.  SCSI makes use of the block layer queueing facilities for 
all SCSI commands (including those for character devices).  Technically, block 
devices are "disc like" and hence can have gendisk structures associated with 
them.  Since we have a block layer queue for every scsi device, we can make 
use of the gendisk api if we wish.  I suppose you could look at it the other 
way and say that gendisk has become more removed from an actual partitionable 
physical disk, and thus of more use to general block devices and their queues.

What the change does is leverage the major/minor device handling from the 
gendisk and solve our upper layer device identification problem in the block 
queue (this was the scsi_get_request_dev() function).

I think modulo a few list_entry() calls which should be container_of(), the 
changes look good to me.

James


