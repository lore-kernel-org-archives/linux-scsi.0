From: Andrew Morton <akpm@osdl.org>
Subject: Re: Fw: blk_cleanup_queue, sleep in invalid context
Date: Wed, 4 Jan 2006 17:12:56 -0800
Message-ID: <20060104171256.2c44a40e.akpm@osdl.org>
References: <20060104165300.23fb4ce8.akpm@osdl.org>
	<20060105005609.GA17604@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:39400 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751099AbWAEBLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 20:11:05 -0500
In-Reply-To: <20060105005609.GA17604@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, olh@suse.de

Greg KH <greg@kroah.com> wrote:
>
> On Wed, Jan 04, 2006 at 04:53:00PM -0800, Andrew Morton wrote:
> > 
> > Looks like scsi is the culprit here - doing put_device() from softirq.
> > 
> > Greg, what are the rules here?  Can we enforce them with a highest-level
> > might_sleep()?
> 
> You mean, put a might_sleep() in put_device()?  Yes, I can do that, as
> that function might sleep.

Yep.  And in any other high-level device management entrypoints which you
can think of.

>  SCSI is the culprit here, and I thought that
> the scsi developers had fixed this up already.

It seems to be resisting arrest.
