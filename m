From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: 3ware and scsi ids
Date: Sat, 07 Jun 2003 01:51:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE128F0.6050209@fl.priv.at>
References: <12C23B584849261-01@MMS__ad.corp.aoltw.net_>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12C23B584849261-01@MMS__ad.corp.aoltw.net_>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Deas, Jim wrote:
> I am currently using 3wares products to create 2T raids.
> To increase performance on my NAS type boxes I am
> using software raids.
>  My problem relates to a falure of a IDE drive.
> Once a drive fails the next boot of the machine remaps all scsi ids.
> so /dev/sda-adi becomes /dev/sda-sdh.
> In short, if /dev/sdb dies, all raids become bad as all scsi ids
> shift down making my raidtab file now point at the wrong drives.
> (I assume this will also be a possible problem when I use
> my USB dongle to update software.)
> 
>  Is there a way to hard assign logical /dev/sd(x) in the driver
> so they will always map the same ide port on the 3ware controllers?
> 3ware is no help on this. They say it is the bios/system and they
> have no control over this.

You'd better use mdadm instead of the raidtools.

The config file for mdadm looks like this:
# cat /etc/mdadm.conf
DEVICE /dev/hd* /dev/sd*
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=52094036:b2e9cf8b:4267c923:750757da

So you do not have to worry about which drive gets assigned which
scsi id.

A
    /sbin/mdadm --assemble --scan
will do the trick.

Get it at http://www.cse.unsw.edu.au/~neilb/source/mdadm/

-- 
MfG / Regards
Friedrich Lobenstock
____________________________________________________________________
Friedrich Lobenstock                       Linux Services Lobenstock
URL: http://www.lsl.at/                         Email: fl@fl.priv.at
____________________________________________________________________


