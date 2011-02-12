From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [v5 PATCH 1/4] bnx2fc: Header files
Date: Sat, 12 Feb 2011 13:44:06 -0600
Message-ID: <1297539846.3026.19.camel@mulgrave.site>
References: <1296266426.268.50.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1BLToN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Feb 2011 14:44:13 -0500
In-Reply-To: <1296266426.268.50.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, Mike Christie <michaelc@cs.wisc.edu>, mchan@broadcom.com

On Fri, 2011-01-28 at 18:00 -0800, Bhanu Gollapudi wrote:
> This patch contains header files for bnx2fc driver.

Do we have to have this litter of

#ifdef (__BIG_ENDIAN)
...
#else
...
#endif

throughout all the structures ... it really makes quite a mess, and is
very fragile (you have two entries to change and test each time, not
just one).  You can use the cpu neutral format for all the headers and
then use the cpu_to... accessors to make the conversions.

To see how to do all of this, here's an ancient driver that used to look
like yours and got converted:

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=0353305208ae64b5d4a27957bb3e25c6045b3f68

James


