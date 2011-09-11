From: Chris Boot <bootc@bootc.net>
Subject: Re: NAA breakage
Date: Sun, 11 Sep 2011 15:00:13 +0100
Message-ID: <4E6CBEED.1090507@bootc.net>
References: <4E494F9F.4000909@zoner.cz>  <1313522082.2853.10.camel@haakon2.linux-iscsi.org>  <4E4BAB1D.6070104@zoner.cz>  <1313618333.9928.61.camel@haakon2.linux-iscsi.org>  <4E528F05.9090208@zoner.cz>  <4E6A0618.3040102@zoner.cz>  <1315604283.7420.58.camel@haakon2.linux-iscsi.org>  <4E6B7B76.4090805@zoner.cz> <1315687061.12709.52.camel@haakon2.linux-iscsi.org> <4E6CA0E6.8080300@zoner.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yuna.grokhost.net ([87.117.228.63]:36544 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1IKOAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2011 10:00:17 -0400
In-Reply-To: <4E6CA0E6.8080300@zoner.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Svec <martin.svec@zoner.cz>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On 11/09/2011 12:52, Martin Svec wrote:
> thanks a lot for your comments. Clearly there was a misunderstanding 
> of who is the vendor that defines what is "vendor-specific" in case of 
> LIO. Of course, it is easy for me to fix my userspace code to generate 
> serial numbers without these issues. But I suggest to enforce 
> vpd_unit_serial restrictions in configfs code because rtslib/lio-utils 
> is just a referential userspace implementation, not a kernel ABI.

I feel it's time to add my 2 cents to this discussion. A vendor-specific 
identifier in my mind could very well be what Martin uses it for, in my 
opinion - at least according to SPC-3. If the LIO stack cannot handle 
such use of identifiers the configfs code should refuse to accept such 
an identifier. If for example the LIO code only creates a valid NAA/WWN 
from a hex string of a certain length, it should only accept a hex 
string of that length. It should not be a requirement to exactly follow 
what rtslib does in every case.

Of course the way I see it the vendor specific identifier doesn't 
necessarily have anything to do with the NAA/WWN, so it would be nice if 
one could set both a WWN as a hex string of the correct length and 
format, and a vendor-specific string in a mostly freeform manner as long 
as it abides by SPC-3. The WWN shouldn't necessarily be generated from 
the vendor identifier.

Chris

