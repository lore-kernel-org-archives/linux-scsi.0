From: "Martin J. Bligh" <mbligh@aracnet.com>
Subject: Re: 2.5.73-mm1 falling over in SDET
Date: Sat, 28 Jun 2003 22:35:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <6620000.1056864944@[10.10.2.4]>
References: <45120000.1056810681@[10.10.2.4]><49400000.1056814561@[10.10.2.4]>  <20030628170235.51ee2f69.akpm@digeo.com> <1056857338.2514.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from franka.aracnet.com ([216.99.193.44]:5766 "EHLO
	franka.aracnet.com") by vger.kernel.org with ESMTP id S265577AbTF2FVq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2003 01:21:46 -0400
In-Reply-To: <1056857338.2514.4.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@digeo.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--James Bottomley <James.Bottomley@SteelEye.com> wrote (on Saturday, June 28, 2003 22:28:57 -0500):

> On Sat, 2003-06-28 at 19:02, Andrew Morton wrote:
>> Yes, isplinux_queuecommand() returns non-zero and the scsi generic layer
>> cheerfully goes infinitely recursive.
> 
> Sigh, certain persons need to be more careful when doing logic
> alterations.
> 
> Try the attached.

OK, that gets rather further, and I strongly suspect fixes the SCSI
problem. Thanks very much.

But now it just OOMs instead, which seems to be slab failing 
dismally to shrink it's fat ass enough to fit in that lazy-boy.
Ext2 doesn't look desparately happy either. Maybe it's really
that one's fault?

 EXT2-fs error (device sda2): ext2_new_inode: Free inodes count corrupted in group 30
Remounting filesystem read-only
Out of Memory: Killed process 215 (portmap).
Out of Memory: Killed process 338 (sshd).

larry:~# cat /proc/meminfo
MemTotal:     16076324 kB
MemFree:      15068968 kB
Buffers:           476 kB
Cached:         260824 kB
SwapCached:          0 kB
Active:         241972 kB
Inactive:        23196 kB
HighTotal:    15335424 kB
HighFree:     15047680 kB
LowTotal:       740900 kB
LowFree:         21288 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:           0 kB
Mapped:           5396 kB
Slab:           697856 kB
Committed_AS:     9688 kB
PageTables:        264 kB
VmallocTotal:   114680 kB
VmallocUsed:      3156 kB
VmallocChunk:   111524 kB

slabinfo:

dentry_cache      3999781 4011624    160   24    1 : tunables  120   60    8 : slabdata 167151 167151      0

Bad dentries. no no.

