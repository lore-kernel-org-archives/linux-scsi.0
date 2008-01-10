From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to
	unlocked_ioctl
Date: Thu, 10 Jan 2008 12:54:58 -0600
Message-ID: <1199991298.3141.75.camel@localhost.localdomain>
References: <20080110180529.GA32640@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43454 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbYAJSzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 13:55:10 -0500
In-Reply-To: <20080110180529.GA32640@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Richard Knutsson <ricknu-0@student.ltu.se>


On Thu, 2008-01-10 at 19:05 +0100, Andre Noll wrote:
> [Resent with proper subject and to additional recipients]
> 
> This patch against linus-current is compile-tested on x86 and x86-64.
> 
> Please review

This is rather long.  For the utility of what you've just done, what's
wrong with just making the .unlocked_ioctl point to sg_unlocked_ioctl()
and doing:

sg_unlocked_ioctl()
	int rc;

	lock_kernel();
	rc = sg_ioctl();
	unlock_kernel();

	return rc;
}

Really, all this is doing is open coding what the ioctl handler is doing
anyway, isn't it? in which case, why bother to change it at all?

James


