From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Wed, 29 Sep 2010 00:47:29 -0400
Message-ID: <20100929044729.GA4967@xanatos>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com>
 <1285668896-6356-2-git-send-email-willy@linux.intel.com>
 <201009281513.53869.oliver@neukum.org>
 <20100929005413.GB4689@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42767 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0I2Erc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2010 00:47:32 -0400
Content-Disposition: inline
In-Reply-To: <20100929005413.GB4689@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, greg@kroah.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue, Sep 28, 2010 at 08:54:13PM -0400, Matthew Wilcox wrote:
> 
> [Could you trim a little when replying?]
> 
> On Tue, Sep 28, 2010 at 03:13:53PM +0200, Oliver Neukum wrote:
> > Am Dienstag, 28. September 2010, 12:14:56 schrieb Matthew Wilcox:
> > > +	usb_free_streams(intf, eps, 3, GFP_KERNEL);
> > 
> > This implies that this can fail due to a lack of memory.
> > Then what?
> 
> Uhh.  I think I'll have to get Sarah to answer that question.  We probably
> end up resetting the endpoints instead of telling the endpoint to stop
> doing streams.

Sorry Oliver, the usb_free_streams() calls into the xHCI driver, which
doesn't actually do anything with the memory flags.  Alan Stern already
noted it should be removed.  Freeing streams doesn't rely on memory
allocation (a command is pre-allocated when streams are enabled, and a
TRB is reserved on the command ring).

Sarah Sharp
