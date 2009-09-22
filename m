From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: MD/RAID time out writing superblock
Date: Tue, 22 Sep 2009 00:16:17 -0600
Message-ID: <4AB86BB1.6040901@gmail.com>
References: <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca> <4AB25736.1060601@suse.de> <4AB260CA.8040308@rtr.ca> <4AB2610F.8010904@rtr.ca> <20090918170517.GI2141@arachsys.com> <20090921102654.GD8789@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090921102654.GD8789@arachsys.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On 09/21/2009 04:26 AM, Chris Webb wrote:
> On another machine, I saw this with write caching turned off:
>
>    ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>    ata2.00: cmd 61/08:00:28:1f:80/00:00:00:00:00/40 tag 0 ncq 4096 out
>             res 40/00:00:40:1f:80/00:00:00:00:00/40 Emask 0x4 (timeout)
>    ata2.00: status: { DRDY }
>    ata2: hard resetting link
>    ata2: softreset failed (device not ready)
>    ata2: hard resetting link
>    ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata2.00: configured for UDMA/133
>    ata2: EH complete
>    ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
>    ata2.00: cmd 61/08:00:28:1f:80/00:00:00:00:00/40 tag 0 ncq 4096 out
>             res 40/00:00:20:1f:80/00:00:00:00:00/40 Emask 0x4 (timeout)
>    ata2.00: status: { DRDY }
>    ata2: hard resetting link
>    ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>    ata2.00: qc timeout (cmd 0xef)
>    ata2.00: failed to set xfermode (err_mask=0x4)
>    ata2: hard resetting link
>    ata2: softreset failed (device not ready)
>    ata2: hard resetting link
>    ata2: softreset failed (device not ready)
>    ata2: hard resetting link
>    ata2: link is slow to respond, please be patient (ready=0)
>    ata2: softreset failed (device not ready)
>    ata2: limiting SATA link speed to 1.5 Gbps
>    ata2: hard resetting link
>    ata2: softreset failed (device not ready)
>    ata2: reset failed, giving up
>    ata2.00: disabled

Basically an NCQ command timed out, then the drive basically stopped 
talking to the controller even after banging on it with multiple resets. 
That failure especially looks suspicious of some kind of hardware issue..
