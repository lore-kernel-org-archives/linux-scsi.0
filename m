From: Alexander Viro <viro@math.psu.edu>
Subject: Re: [PATCH] don't increment use count twice on open
Date: Thu, 31 Oct 2002 21:55:43 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0210312153580.16688-100000@weyl.math.psu.edu>
References: <20021101035238.A23109@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021101035238.A23109@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org



On Fri, 1 Nov 2002, Christoph Hellwig wrote:

> Since 2.4 drivers get their usecount managed by higher levels if they
> supply a owner field in block_device_operations/file_operations.
> 
> Remove managment of the additional usecount in ->open/->close.
> 
> 
> --- 1.17/drivers/scsi/osst.c	Thu Oct 17 13:52:39 2002
> +++ edited/drivers/scsi/osst.c	Thu Oct 31 00:50:21 2002
> @@ -4178,8 +4178,6 @@
>  
>  	if (STp->device->host->hostt->module)
>  		 __MOD_INC_USE_COUNT(STp->device->host->hostt->module);

BTW, that (and similar in other drivers) is a walking rmmod race.
Think what happens if module is already in the middle of unload -
it's done with checking the refcount, decision is already made.
try_inc_mod_count() is needed here...

