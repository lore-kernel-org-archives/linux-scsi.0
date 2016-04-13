From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [-next] BUG_ON in scsi_target_destroy()
Date: Wed, 13 Apr 2016 23:47:04 +0900
Message-ID: <20160413144704.GA490@swordfish>
References: <20160411090146.GA537@swordfish>
 <2201725.I2to9GCRQJ@c203>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34883 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750AbcDMNtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 09:49:22 -0400
Content-Disposition: inline
In-Reply-To: <2201725.I2to9GCRQJ@c203>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-next@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Xiong Zhou <jencce.kernel@gmail.com>

Hi,

On (04/13/16 10:41), Johannes Thumshirn wrote:
> Hi Sergey,  Xiong,
> 
> Can you try below patch?

it panics my system.
first it warn_on-s in lib/kobject.c:244

then NULL dereferences
do_scan_async
 __scsi_remove_device
  scsi_target_reap
   device_del
    dpm_sysfs_remove
     sysfs_unmerge_group
      kernfs_find_and_get_ns
       kernfs_find_ns

	-ss
