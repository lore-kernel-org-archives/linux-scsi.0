From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: Re: [PATCH 1/2] sdev_printk - scsi_device helper macro
Date: Mon, 19 Apr 2004 11:46:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404191146.21093.dsteklof@us.ibm.com>
References: <200310071318.11847.dsteklof@us.ibm.com> <1080758108.1804.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:16875 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261724AbUDSSuG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 14:50:06 -0400
In-Reply-To: <1080758108.1804.18.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wednesday 31 March 2004 10:35 am, James Bottomley wrote:
> On Tue, 2003-10-07 at 16:18, Daniel Stekloff wrote:
> > +#define sdev_printk(level, sdev, format, arg...) \
> > +	printk(level "scsi <%s>: " format , (sdev)->sdev_gendev.bus_id , ##
> > arg) +
>
> OK, after six months, I've reconsidered on this one.
>
> Make it #define to dev_printk() and it can go in.
>
> James


Hi James,

I really don't think it's worth putting in sdev_printk() if it points to 
dev_printk(). As you have seen recently:

http://marc.theaimsgroup.com/?l=linux-scsi&m=108189253319586&w=2

dev_printk() is only useful when a driver is bound to the specific device. 
This would make sdev_printk() useless really except for upper level drivers. 
It can't safely be used in the mid-layer. If you're interested in cleaning up 
some of the printks in the midlayer and identifying messages with consistant 
scsi information, I would suggest using the sdev_printk() as I had submitted 
it. 

Thanks,

Dan


