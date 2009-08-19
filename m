From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Performance issues with Areca 1680 SAS Controllers
Date: Wed, 19 Aug 2009 17:08:48 +0300
Message-ID: <20090819140848.GW19938@edu.joroinen.fi>
References: <492403B8.5090007@fuckner.net> <20081119171820.0823457d.akpm@linux-foundation.org> <DB3A7CF1B9EB4E1B80FCEF215C16EA24@arecac12242173>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from edu.joroinen.fi ([194.89.68.130]:43745 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbZHSOdw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2009 10:33:52 -0400
Content-Disposition: inline
In-Reply-To: <DB3A7CF1B9EB4E1B80FCEF215C16EA24@arecac12242173>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Cheng <nick.cheng@areca.com.tw>
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, 'Michael Fuckner' <michael@fuckner.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 'Erich Chen' <erich@areca.com.tw>

On Thu, Nov 20, 2008 at 03:39:40PM +0800, Nick Cheng wrote:
> Hi Michael,
> I will get around handling your issue.
> Thanks for your kindly patience,
> 

Hello,

Was this issue resolved? I'm seeing similar behaviour.. I think it's related
to flushing the controller cache?

Waiting a while (after the disk leds stop blinking) performance is back to
normal.. 

-- Pasi

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org] 
> Sent: Thursday, November 20, 2008 9:18 AM
> To: Michael Fuckner
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nick Cheng;
> Erich Chen
> Subject: Re: Performance issues with Areca 1680 SAS Controllers
> 
> (cc's added)
> 
> On Wed, 19 Nov 2008 13:16:56 +0100
> Michael Fuckner <michael@fuckner.net> wrote:
> 
> > Hi,
> > 
> > I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagate 1TB
> > ST31000640SS). I set up a Raid6 with all 16 disks and formatted it with
> > XFS. The Controller has 512MB RAM and a BBU. The OS is installed to
> > another disk attached to the onboard AHCI controller.
> > 
> > After doing some IO, the areca raidset is slower compared to the rate 
> > directly
> > after boot.
> > 
> > 
> > [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
> iflag=direct
> > 51200+0 records in
> > 51200+0 records out
> > 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> > [root@storage ~]# mount /dev/sdb1 /data
> > [root@storage ~]# cd /data/
> > [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t 8 -+r
> > -o  >raid6_sync_t8.log
> > [root@storage data]# cd
> > [root@storage ~]# umount /data/
> > [root@storage ~]# dd if=/dev/sdb1 of=/dev/null bs=1M count=50k
> iflag=direct
> > 51200+0 records in
> > 51200+0 records out
> > 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> > 
> > I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, Debian
> > Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour.
> > 
> > Idea why the device slows down after IO- or better: how to keep the high
> > rate? Is this reproducible foer Areca SATA Controllers (Type 11XX and
> 12XX)
> > 
> > Regards,
> >    Michael!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
