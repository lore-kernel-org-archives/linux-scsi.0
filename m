From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] removel useless mod use count manipulation
Date: Sun, 17 Nov 2002 13:48:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117134848.A4556@lst.de>
References: <20021116204009.A24052@lst.de> <3DD78E4B.6040006@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DD78E4B.6040006@torque.net>; from dougg@torque.net on Sun, Nov 17, 2002 at 11:40:43PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 17, 2002 at 11:40:43PM +1100, Douglas Gilbert wrote:
> Christoph Hellwig wrote:
> > There's a bunch of useless mod usecount handling in scsi:
> 
> While playing with scsi_debug today I saw the opposite effect:
> with a file system mounted on a scsi_debug fake disk **, lsmod
> showed a zero "in use" count. I was able to "rmmod scsi_debug"
> and crash the system when I tried to access that mounted fs.

This change didn't change the use-count handling for HBA driver at all,
so this must be something different.  Do you use a scsi_debug using
scsi_add_host/scsi_remove_host?  Try adding

	.module		= THIS_MODULE,

to sdebug_driver_template, I forgot that change when sendig you the
initial draft version of the change.

