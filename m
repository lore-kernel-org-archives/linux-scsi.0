From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 12:58:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206201658.g5KGwYL04775@localhost.localdomain>
References: <dalecki@evision-ventures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA31414
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2002 09:58:40 -0700
In-Reply-To: Message from Martin Dalecki <dalecki@evision-ventures.com>
   of "Thu, 20 Jun 2002 18:30:36 +0200." <3D12032C.7040105@evision-ventures.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Dalecki <dalecki@evision-ventures.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

dalecki@evision-ventures.com said:
> 1. There was the mistake of using different major numbers for SCSI and
> IDE/ATAPI devices. (disk and CD-ROM are the most striking). 

Don't confuse major numbers (which are really a kernel internal thing) with 
names.  Major numbers serve a very useful purpose in allowing quick device 
driver identification.  It would be an unhappy state of affairs if we had to 
parse both the major and minor numbers extensively just to identify the device 
driver to handle the request.  There's no reason why we can't use a consistent 
naming scheme for all CD-ROMs and yet have them using different major numbers.

One of the advantages of driverfs, I think, is that it separates the device 
name from a static entry in /dev which is tied to a major/minor number.

> 6. The /name is entierly redundant logically to the fact that we have
> already a unique path to the device. For "pretty" printing we have
> userspace. For PCI it's for example repeating the ID info found
> already by lspci. 

The /name is useful in the enterprise for persistent device identification.  
Leaves in the device tree can move as boxes are regconfigured.  The name entry 
helps you find your leaf again when this happens.  It also helps you find the 
same storage in a cluster regardless of the device driver or storage 
connection method.

> And last but not least: I still don't see any kind of abstraction
> there which would allow to easly enumerate for example all disks in
> the system. 

Doesn't this depend on the semantics provided in the device node (leaf)?  If 
you had a way of identifying disk devices (say from an empty type=disk file) 
then you could do a simple find to list all the disks in the system regardless 
of being SCSI, IDE, SSA etc.

James




