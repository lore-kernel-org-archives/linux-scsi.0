From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sgpool-8 double free
Date: Mon, 20 Feb 2006 00:10:09 +0100
Message-ID: <43F8FAD1.9060307@s5r6.in-berlin.de>
References: <20060219202923.GF32492@redhat.com> <1140386164.4559.0.camel@mulgrave.il.steeleye.com> <43F8F807.30605@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:25019 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751137AbWBSXKd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 18:10:33 -0500
In-Reply-To: <43F8F807.30605@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org, bcollins@debian.org

I wrote:
> James Bottomley wrote:
>> This is a characteristic trace for double done() on the same SCSI
>> command.
> 
> Perhaps. OTOH, maybe there was indeed memory overwritten.

PS: I suspect sbp2 may indeed doubly call done() in corner cases:
http://bugzilla.kernel.org/show_bug.cgi?id=5998

However a double done() is extremely unlikely in the case reported by 
Dave. AFAICS from the messages at 
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=182005 , sbp2 does 
not run any of the code code paths which lead to alternative routes to 
done(), besides the normal command completion. (These routes are 
FireWire bus reset handling and SCSI error handling. In theory these 
routes cannot doubly call done() either...)
-- 
Stefan Richter
-=====-=-==- --=- =--==
http://arcgraph.de/sr/
