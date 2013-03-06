From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] aic7xxx: Remove redundant NULL check before kfree
Date: Wed, 06 Mar 2013 10:53:43 +0000
Message-ID: <1362567223.2446.33.camel@dabdike.int.hansenpartnership.com>
References: <1362511582-3657-1-git-send-email-s.syam@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59747 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461Ab3CFKxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Mar 2013 05:53:47 -0500
In-Reply-To: <1362511582-3657-1-git-send-email-s.syam@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de

On Wed, 2013-03-06 at 00:56 +0530, Syam Sidhardhan wrote:
> kfree on NULL pointer is a no-op.

This is true, but what's the saving?  kfree() has an identical check,
but by the time you get to it, the result of this one is cached, so it's
something like < 1 instruction cycle saving (because the instruction
will be pipelined).

If the maintainers of particular drivers want to integrate this, that's
OK, but I'd rather not do pure code churn on the older drivers.

James


