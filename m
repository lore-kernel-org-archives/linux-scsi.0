From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 17 Nov 2003 14:38:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069105104.2324.331.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068766632.2851.142.camel@patrh9>
	 <20031113162401.A29775@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:14259 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261996AbTKQVi4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 16:38:56 -0500
In-Reply-To: <20031113162401.A29775@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> I don't have any sd removable read only media.

Eh?  Does http://www.torque.net/sg/sdebug26.html
not give us all sd removable read only media?

> If you want to test with your read only media,
> just use the dev flags:
> 
> 	echo "vendor:model:0x4000" > /proc/scsi/device_info 
> 
> Then add your device, see if it comes back as writable, and try to mount
> or write it, and compare without the above (you can't remove device_info
> entry without rebooting or rmmod-ing scsi).

Thanks for kindly finding the time to share these hints, I have now
begun the work of decrypting them.

1) `find /lib/modules -name '*.ko'` says I have no scsi.ko.  If I kick
around in `make xconfig` long enough, I may find one.

2) By vendor:model I first guess we mean what bash would say as
"$vendor:$model", of 8 and x10 bytes respectively, same as in op x12
Inquiry.

> can we easily nutshell for me how well
> > write-protect works now in sd?  ...
> ...
> removable ... once when found (sd_probe ... sd_revalidate_disk), and ...
> sd_open calls check_disk_change, calls sd_media_changed ...
> sd_revalidate_disk to figure out ... write_prot ...
> write_prot ... if ... set ... the open fails with EROFS.

Prompt & cogent thank you.

> AFAICT, the sd write_prot setting is never passed on up to the block layer.

Except, of course, by way of EROFS returned from sd_open.

Pat LaVarre


