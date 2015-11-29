From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: block: Always check queue limits for cloned requests
Date: Sun, 29 Nov 2015 18:05:06 +0100
Message-ID: <20151129170506.GB302@x4>
References: <1448524017-130967-1-git-send-email-hare@suse.de>
 <20151126131104.GA24297@redhat.com>
 <20151129114956.GA321@x4>
 <565B1D2A.5010603@suse.de>
 <20151129161532.GA302@x4>
 <20151129164947.GA15021@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:35738 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbK2RFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2015 12:05:10 -0500
Content-Disposition: inline
In-Reply-To: <20151129164947.GA15021@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

On 2015.11.29 at 11:49 -0500, Mike Snitzer wrote:
> On Sun, Nov 29 2015 at 11:15am -0500,
> Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
> > On 2015.11.29 at 16:43 +0100, Hannes Reinecke wrote:
> > > On 11/29/2015 12:49 PM, Markus Trippelsdorf wrote:
> > > > 
> > > > I'm still seeing the issue (BUG at drivers/scsi/scsi_lib.c:1096!) even
> > > > with this patch applied.
> > > > 
> > > > markus@x4 linux % git describe
> > > > v4.4-rc2-215-g081f3698e606
> > > > 
> > > Can you generate a crashdump?
> > > I would need to cross-check with the other dumps I'm having to figure
> > > out if this really is the same issue.
> > > There have been other reports (and fixes) which show we're fighting
> > > several distinct issues here.
> > 
> > Unfortunately no. The crash happens on the disk where I store my log
> > files. And after it happened the magic SysRq keys don't work anymore.
> > 
> > The crash only happens on my spinning rust drive that uses the cfq
> > scheduler. The SSDs (deadline) are fine.
> > 
> > The BUG happens reproducibly when building http://www.sagemath.org/ on
> > that drive.
> 
> Are you using DM multipath?  If unsure, please let us know which
> device(s) map to the "spinning rust drive", and provide output from:
> lsblk

No, I'm not using DM multipath. 

/dev/sdb2 on /var type btrfs (rw,relatime,compress=lzo,noacl,space_cache)
/dev/sdb2      btrfs     1.9T  904G  944G  49% /var

scsi 1:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
sd 1:0:0:0: [sdb] 4096-byte physical blocks
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST2000DM001-1CH164

-- 
Markus
