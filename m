From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: sgpool-8 double free
Date: Sun, 19 Feb 2006 15:56:04 -0600
Message-ID: <1140386164.4559.0.camel@mulgrave.il.steeleye.com>
References: <20060219202923.GF32492@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:62113 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932341AbWBSV4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 16:56:20 -0500
In-Reply-To: <20060219202923.GF32492@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org, bcollins@debian.org

On Sun, 2006-02-19 at 15:29 -0500, Dave Jones wrote:
> Feb 18 22:30:18 fgrbhw01 kernel: ieee1394: sbp2: Logged into SBP-2 device
> Feb 18 22:30:18 fgrbhw01 kernel:   Vendor: Initio    Model: 0KLAT80          Rev: 2.05
> Feb 18 22:30:18 fgrbhw01 kernel:   Type:   Direct-Access                     ANSI SCSI revision: 00
> Feb 18 22:30:18 fgrbhw01 kernel: SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
> Feb 18 22:30:18 fgrbhw01 kernel: slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or memory outside object was overwritten
> Feb 18 22:30:18 fgrbhw01 kernel:  [<c014d8bf>] cache_free_debugcheck+0xce/0x1b9
>     [<c01486cb>] mempool_free+0x5f/0x63
> Feb 18 22:30:18 fgrbhw01 kernel:  [<c014e230>] kmem_cache_free+0x2a/0x5c    
> [<c01486cb>] mempool_free+0x5f/0x63
> Feb 18 22:30:18 fgrbhw01 kernel:  [<f8864f65>] scsi_io_completion+0x65/0x3ce
> [scsi_mod]     [<f8860bb3>] scsi_finish_command+0xb8/0xbd [scsi_mod]
> Feb 18 22:30:18 fgrbhw01 kernel:  [<f8860ab6>] scsi_softirq+0x109/0x128

This is a characteristic trace for double done() on the same SCSI
command.

James


