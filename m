From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Warning: about not setting max_sectors
Date: Mon, 09 Dec 2002 08:55:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212091455.gB9Etg601956@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA14243
	for <linux-scsi@vger.kernel.org>; Mon, 9 Dec 2002 06:55:47 -0800
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id GAA14154
	for <linux-scsi@vger.kernel.org>; Mon, 9 Dec 2002 06:55:45 -0800
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id gB9Etg601956
	for <linux-scsi@vger.kernel.org>; Mon, 9 Dec 2002 08:55:43 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For some reason, the SCSI core is now warning about drivers which don't set 
max_sectors.

Just for the record, we have two parameters in the template:

sg_tablesize which determines the maximum number of scatter gather entries the 
host can have (corresponds to max_phys_segments in the block layer), and

max_sectors, which imposes a maximum overall transfer length (corresponds to 
max_sectors in the block queue).

The comments over max_sectors list it as optional (if unset, we set it to the 
scsi equivalent of machine infinity---well, actually 1024, or 512Mb for usual 
blocks).

The reason it's unset on so many drivers is that usually, they have no 
absolute transfer limit, so they're just bounded by the number of entries in 
the scatter-gather list.

I can't see a reason to force every driver suddenly to have an arbitrary 
max_sectors, so if no-one objects, I'll pull out the warning.

James


