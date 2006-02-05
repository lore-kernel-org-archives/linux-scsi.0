From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 6009] tcpdump causes kernel panic
Date: Sat, 04 Feb 2006 18:18:51 -0600
Message-ID: <1139098731.2957.2.camel@mulgrave.il.steeleye.com>
References: <200602042315.k14NFwuS006966@fire-2.osdl.org>
	 <20060204153118.4b0270b4.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1744 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964888AbWBEAS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Feb 2006 19:18:56 -0500
In-Reply-To: <20060204153118.4b0270b4.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Sat, 2006-02-04 at 15:31 -0800, Andrew Morton wrote:
> James, I don't recall whether we've fixed this or not?  It was non-trivial,
> wasn't it?

It's not fixed, and pretty non-trivial.  Basically we'd have to redo
most of our generic device (or kobject) handling through workqueues.

What I'd like for this is a way to tell context.  We know the locking
context and can cope with that, but it would be nice to tell if we have
user context or not and then only go through the workqueue for the
softirq or hardirq contexts.

If we can get the check, it would probably make sense to do the actual
manipulation in put_device().

James


