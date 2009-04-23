From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH 4 of 8] sd: Physical block size and alignment support
Date: Thu, 23 Apr 2009 14:44:21 -0400
Message-ID: <20090423184421.GB9104@mars.virtualiron.com>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <fc4cc94aa1e2612b3489.1240464571@sermon.lab.mkp.net> <20090423163700.GB8350@mars.virtualiron.com> <yq1ab67b51p.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:2938
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753098AbZDWSrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 14:47:18 -0400
Content-Disposition: inline
In-Reply-To: <yq1ab67b51p.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 02:25:54PM -0400, Martin K. Petersen wrote:
> >>>>> "Konrad" == Konrad Rzeszutek <konrad@virtualiron.com> writes:
> 
> [Printing physical block size]
> 
> Konrad> With the changes in the read_capacity_16 (where you set the
> Konrad> hw_sector_size) this won't be printed (at least on first probe).
> 
> Why not?

The read_capacity_16 sets the sdkp->hw_sector_size to sector_size:
@@ -1402,6 +1413,7 @@ static int read_capacity_10(struct scsi_

        sector_size =   (buffer[4] << 24) | (buffer[5] << 16) |
                        (buffer[6] << 8) | buffer[7];
+       sdkp->hw_sector_size = sector_size;
        lba =   (buffer[0] << 24) | (buffer[1] << 16) |
                (buffer[2] << 8) | buffer[3];


That function also returns that value, which sd_read_capacity assigns to the
sector_size variable. So when the check for sdkp->hw_sector_size
inequality is reached, it is skiped as sdkp->hw_sector_size ==
sector_size. No?

> 
> [root@10 ~]# modprobe scsi_debug dev_size_mb=1024 num_parts=4 physblk_exp=3
> scsi 6:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
> sd 6:0:0:0: Attached scsi generic sg3 type 0
> sd 6:0:0:0: [sdc] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
> sd 6:0:0:0: [sdc] 4096-byte physical blocks

Is that doing a read_capacity_16 or _10?
> 
> 
> Konrad> Another question - should the Documentation/*.txt have an entry
> Konrad> about what a 'logical block', and 'physical block' is
> Konrad> vs. 'hardware sector' ?
> 
> Well, another item on my todo list is to kill the notion of hardware
> sector completely.  The protocols have been referring to logical blocks
> for ages.

Do they refer to physical blocks as well?
> 
> It hasn't been a big problem until now because logical block size has
> been equal to the hardware sector size.  That's no longer a valid
> assumption.

Right.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
