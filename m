From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Write protected devices, unexpected dm-multipath queueing
Date: Fri, 6 Jan 2012 17:55:54 -0500
Message-ID: <20120106225554.GA15329@redhat.com>
References: <1325878251.19595.13.camel@lapoo.opensvc.com>
 <20120106223212.GB2393@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826Ab2AFW4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2012 17:56:06 -0500
Content-Disposition: inline
In-Reply-To: <20120106223212.GB2393@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
Cc: "cyril.galibern" <cyril.galibern@opensvc.com>, linux-scsi@vger.kernel.org

On Fri, Jan 06 2012 at  5:32pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jan 06 2012 at  2:30pm -0500,
> Christophe Varoqui <christophe.varoqui@gmail.com> wrote:
> 
> > Hannes, list,
> > 
> > reading your kernel path there
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=63583cca745f440167bf27877182dc13e19d4bcf
> > I wonder if this is expected that a write io on a write protected device
> > is returned to the queue ? I would have guessed it qualified as
> > TARGET_ERROR, hence not retryable (and not causing path invalidation).
> > 
> > In the following log the sense code is clearly seen as 
> > Sense Key : Data Protect [current]
> > Add. Sense: Write protected
> > 
> > The log is grabbed from a el6 kernel rev. 131 which include the
> > mentioned patch (since rev. 110 iirc).
> > 
> > Care to confirm something is fishy there ?
> 
> scsi_check_sense() needs to be trained to return TARGET_ERROR for this
> case.
> 
> The commit you referenced wasn't meant to have covered _every_ possible
> TARGET_ERROR case.

Hmm, but looking closer that commit _does_ return TARGET_ERROR for
DATA_PROTECT.

I need to dig deeper, but I think Hannes gets back to work on Monday.

Mike
