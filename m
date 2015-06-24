From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] hpsa: fix an sprintf() overflow in the reset handler
Date: Wed, 24 Jun 2015 14:01:27 +0300
Message-ID: <20150624110127.GT28762@mwanda>
References: <20150604144756.GA8897@mwanda>
 <07F70BBF6832E34FA1C923241E8833AB486B305D@BBYEXM01.pmc-sierra.internal>
 <DDB9C85B850785449757F9914A034FCB3BFF5E58@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27997 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbFXLBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2015 07:01:36 -0400
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BFF5E58@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: Don Brace <Don.Brace@pmcs.com>, "James E.J. Bottomley" <JBottomley@odin.com>, ISS StorageDev <iss_storagedev@hp.com>, dl Team ESD Storage Dev Support <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>

On Fri, Jun 19, 2015 at 07:13:47AM +0000, Seymour, Shane M wrote:
> With a size of 48 while it won't overflow since you're using snprintf the string with a maximum value in %d:
> 
> echo -n "cmd 2147483647 RESET FAILED, new lockup detected" |wc -c
> 48

I actually just chose 48 because it was divisible by sizeof(long) on
64 bit.  The compiler is going to pad it out a bit anyway because of
alignment.

> 
> is 48 characters long without a null terminator on the string (and in the unlikely event that it's somehow a the largest possible negative value it would be 49 characters after including the minus sign without a null terminator). If you always want a complete message no matter what the value formatted as %d will be I believe it needs to have a length of 50. The worst that will happen now though because you're using snprintf is you'll drop the trailing "d" or "ed" in the message with very large positive or negative numbers.
> 
> My somewhat sketchy memory of the hpsa driver is that the nr_cmds member of the struct ctlr_info is never more than 1040 (?) anyway. If things are working correctly I don't think it should ever happen but I thought I should point out that msg isn't large enough to contain the complete contents of the longest possible character string.

My knowledge is sketchier than yours.

When I was reading this I was thinking that instead of 1040 the
upper limit was 32.  I got that from hpsa_get_max_perf_mode_cmds().
The only negative number was -1, I think.

But either way, we both agree that 48 is probably safe.

regards,
dan carpenter

