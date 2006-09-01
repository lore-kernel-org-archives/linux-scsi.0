From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: fix cache flushing on module removal
	(and	individual device removal)
Date: Fri, 01 Sep 2006 09:54:18 -0400
Message-ID: <1157118858.3675.13.camel@mulgrave.il.steeleye.com>
References: <1157058484.3666.5.camel@mulgrave.il.steeleye.com>
	 <1157062522.3666.10.camel@mulgrave.il.steeleye.com>
	 <44F7F70F.4010000@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:25221 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751334AbWIANzV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Sep 2006 09:55:21 -0400
In-Reply-To: <44F7F70F.4010000@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-09-01 at 11:02 +0200, Stefan Richter wrote:
> Somehow the (void)try_module_get(...) looks dangerous to me. Is it
> really safe to always ignore failures to get the module? Why would we
> want to ignore failures? Couldn't there be border cases where a
> module_getter/_putter in a concurrent code path disturbs
> scsi_device_get/_put's underlying assumptions?

As long as we don't do spurious module_puts, yes.  However, there looks
to be another nasty module race that's orthogonal to this, in that the
final scsi_host_put() of a module doesn't necessarily wait for the host
actually to be released, so it's possible to free the host template when
the module exit finishes and still have a partially functioning host.

James




