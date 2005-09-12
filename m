From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process (end devices)
Date: Mon, 12 Sep 2005 12:29:48 -0700
Message-ID: <20050912192948.GA14699@us.ibm.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F459D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37526 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932161AbVILTaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 15:30:02 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F459D@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, dougg@torque.net, hch@infradead.org, ltuikov@yahoo.com, luben_tuikov@adaptec.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Sep 12, 2005 at 03:04:03PM -0400, James.Smart@Emulex.Com wrote:
> 
> 
> > Though we still have problems with scsi_report_lun_scan code like:
> > 
> >                 } else if (lun > sdev->host->max_lun) {
> > 
> > max_lun just has to be large, at least greater than 0xc001 
> > (49153), maybe
> > even 0xffffffff, correct?
> 
> right...

> > 
> > But then some sequential scanning could take a while. Maybe the above
> > check is not needed.
> > 
> > lpfc has max_luns set to 256, with max limited to 32768, I 
> > don't know how
> > it could be working OK here. (Has James S or anyone tested this?)
> 
> Yes we did test this (actually, we tested out to 64k). Time to perform all
> this looping, plus impacts due on sg devices (some configs generate huge
> numbers - outside of sg's range), made us pull back to 256 - although it's
> tunable.

I meant did you test many (even a few) LUNs with non 00b addressing mode?

sg (scsi generic) had fixed limits removed some time ago (in 2.6.x).

-- Patrick Mansfield
