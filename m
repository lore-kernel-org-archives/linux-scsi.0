From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] add request prep functions to SCSI
Date: Thu, 7 Nov 2002 13:45:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107214509.GB1690@beaverton.ibm.com>
References: <200211062218.gA6MI2t04813@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211062218.gA6MI2t04813@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

J.E.J. Bottomley [James.Bottomley@steeleye.com] wrote:
> This patch adds request prep functions to the mid-layer.  At the moment, its a single request prep function for all of SCSI.  I've altered the logic in scsi_request_fn so that we now do early preparation (this should improve throughput slightly in the untagged case with only a single command block).
> 
> The prep function also cannot drop the queue lock, so the calling assumptions for scsi_init_io and the upper layer driver init_commands have changed to be that the lock is now held and they cannot drop it.  I think this means that we have no callers of scsi_init_io that aren't atomic, so perhaps I can just take the if out.
> 
> I've hammered this in my usual set up, but other testers would be welcome.
> 
> James
> 

The patch looks good.

I ran the patch on scsi-for-linus-2.5 plus my sysfs patches. I have
booted and ran some dd based io.

I have the following drivers loaded:
	isp, aic7xxx, isp1020, scsi_debug, qla2300

Hopefully later today I can generate a error in scsi_debug and get a
requeue. I have generated a couple port down/ups on the fibre, but this
is mainly being handled inside the LLD.

-andmike
--
Michael Anderson
andmike@us.ibm.com

