From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix an integer overflow in sysfs code
Date: Wed, 30 Aug 2017 15:12:35 +0200
Message-ID: <20170830131235.GC12924@kroah.com>
References: <CAER+mfKPOt03DmPB4FTCjVvQ=2uRSMVbBHP-3CdoG+mQnSiYFw@mail.gmail.com>
 <20170830122106.dmdfril4kwi4p5e5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38111 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751385AbdH3NMc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 09:12:32 -0400
Content-Disposition: inline
In-Reply-To: <20170830122106.dmdfril4kwi4p5e5@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, shqking <shqking@gmail.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, security@kernel.org

On Wed, Aug 30, 2017 at 03:21:07PM +0300, Dan Carpenter wrote:
> The value of "size" comes from the user.  When we add "start + size"
> it could lead to an integer overflow bug.
> 
> It means we vmalloc() a lot more memory than we had intended.  I believe
> that on 64 bit systems vmalloc() can succeed even if we ask it to
> allocate huge 4GB buffers.  So we would get memory corruption and likely
> a crash when we call ha->isp_ops->write_optrom() and ->read_optrom().
> 
> Only root can trigger this bug.
> 
> Fixes: b7cc176c9eb3 ("[SCSI] qla2xxx: Allow region-based flash-part accesses.")
> Reported-by: shqking <shqking@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>


Cc: stable <stable@vger.kernel.org>

perhaps?

thanks,

greg k-h
