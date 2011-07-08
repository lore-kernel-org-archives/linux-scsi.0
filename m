From: Karel Zak <kzak@redhat.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Fri, 8 Jul 2011 21:45:01 +0200
Message-ID: <20110708194501.GU6418@nb.net.home>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 08, 2011 at 05:45:47PM +0900, Nao Nishijima wrote:
> This patch series provides an "alias name" of the disk into kernel and procfs
> messages. The user can assign a preferred name to an alias name of the device.
> 
> Based on previous discussion (*), I changed patches as follows
> - This is "alias name"
> - An "alias name" is stored in gendisk struct
> - Add document to Documentation/ABI/testing/sysfs-block
> - When the user changes an "alias name", kernel notifies udev
> 
> (*) http://marc.info/?l=linux-scsi&m=130812625531219&w=2
> 

[...]

> [localhost]# cat /proc/partitions
> major minor  #blocks  name
> 
>    8        0   12582912 foo
>    8        1   12582878 foo1
>    8        0    8388608 sdb
>    8        1     512000 sdb1
>    8        2    7875584 sdb2

 If there is not /dev/foo and /sys/block/foo then the patch introduces
 a REGRESSION. 
 
 The names from /proc/partitions are used in many applications
 (libblkid, fdisk, ...) for many many years. The applications will not
 work as expected.

 It's crazy to assume that all the applications will be improved to
 translate the "pretty name" from /proc/partitions by /sys/block/<maj>:<min>.

 Note, it's pretty naive to expect that people will use the pretty
 names for printk()/dmesg only. I'm absolutely sure that it's will be
 expected (by end-users) in /etc/fstab, mount, df, fdisk, ...

 It's will be necessary to modify all these utils. 

 The patch is opening Pandora's box :-(

    Karel
    
-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
