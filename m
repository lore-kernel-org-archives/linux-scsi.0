From: Greg KH <greg@kroah.com>
Subject: Re: Fw: blk_cleanup_queue, sleep in invalid context
Date: Wed, 4 Jan 2006 16:56:09 -0800
Message-ID: <20060105005609.GA17604@kroah.com>
References: <20060104165300.23fb4ce8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:7868 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S1751035AbWAEA4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 19:56:32 -0500
Content-Disposition: inline
In-Reply-To: <20060104165300.23fb4ce8.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Olaf Hering <olh@suse.de>

On Wed, Jan 04, 2006 at 04:53:00PM -0800, Andrew Morton wrote:
> 
> Looks like scsi is the culprit here - doing put_device() from softirq.
> 
> Greg, what are the rules here?  Can we enforce them with a highest-level
> might_sleep()?

You mean, put a might_sleep() in put_device()?  Yes, I can do that, as
that function might sleep.  SCSI is the culprit here, and I thought that
the scsi developers had fixed this up already.

thanks,

greg k-h
