From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [stable] [PATCH 1/2] sd: fix memory corruption by sd_read_cache_type
Date: Sun, 26 Feb 2006 10:11:48 +0100
Message-ID: <440170D4.4040103@s5r6.in-berlin.de>
References: <tkrat.014f03dc41356221@s5r6.in-berlin.de> <20060225021009.GV3883@sorel.sous-sol.org> <4400E34B.1000400@s5r6.in-berlin.de> <20060225232201.GK27946@ftp.linux.org.uk> <4401629C.8070803@s5r6.in-berlin.de> <20060226082206.GN27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36554 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750917AbWBZJNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 04:13:45 -0500
In-Reply-To: <20060226082206.GN27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org, Linus Torvalds <torvalds@osdl.org>, Jody McIntyre <scjody@modernduck.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Al Viro wrote:
> On Sun, Feb 26, 2006 at 09:11:08AM +0100, Stefan Richter wrote:
>>Al Viro wrote:
>>>Speaking of sbp2 problems...  Why the _hell_ are we blacklisting on
>>>firmware revision alone?  Especially with entries like "all firmware
>>>with 2.<whatever> as version is broken"...
>>
>>The firmware_revision CSR key value has so far been a good method to 
>>guesstimate the bridge chip. I don't know a better one.
> 
> Umm...  What about ->vendor_name_kv (plus firmware_revision, obviously)?

Not a single one of the devices in my collection features vendor_name_kv 
in the ROM's unit directory. The vendor_name_kv in the ROM's root 
directory more often reflects the vendor of the enclosure or bridge 
board than the vendor of the bridge chip. (Most vendors of enclosures or 
boards seem to put only their name into a firmware although they have 
the opportunity for market differentiation by an own firmware full of 
their very own bugs...)

>>I posted an improved blacklisting patch a few days ago. Among other 
>>small cleanups, I removed skip_ms_page_8 from the Initio blacklist entry.
>>http://marc.theaimsgroup.com/?l=linux1394-devel&m=114065678722190
> 
> FWIW, that puppy appears to live just fine without forcing 36byte
> inquiry here...

A few older Initio based enclosures needed it. Newer don't, including 
the one I have here. AFAIK the 36byte inquiry workaround does not break 
anything if forced onto non-broken devices.
-- 
Stefan Richter
-=====-=-==- --=- ==-=-
http://arcgraph.de/sr/
