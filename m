From: Douglas Gilbert <dougg@torque.net>
Subject: Informational Exception mpage [was: usb storage traces]
Date: Fri, 05 Dec 2003 13:56:04 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD001D4.9010404@torque.net>
References: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>	 <1070573894.2269.47.camel@patibmrh9> <1070576669.2269.108.camel@patibmrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:54801 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263866AbTLED6F
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 22:58:05 -0500
In-Reply-To: <1070576669.2269.108.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

Pat LaVarre wrote:
>>Does anybody know what ... mode page x1c do?  Although 
>>nominally vendor-specific, they must be reasonably standardized if Windows 
>>can get away with using them on a generic device.
> 
> 
> I fetch my SPC guess from the web as follows.  As ever we cannot know if
> MMC contradicts unless we check nearby.  To sort these clicks from most
> to least applicable I logged them in reverse chronological order.
> 
> 1Ch = Informational Exceptions Control

The latest drafts of MMC-3 and MMC-4 call this mode page:
"Fault/Failure Reporting Control Page". Looking at the
definition in MMC-4 it is basically the same as the
Informational Exceptions mode page defined in SPC-3 with
a few fields reserved.

Just to confuse things further there is an Informational
Exceptions _log_ page that started life as the SMART log page.
Seems as though someone in t10 is keen on the term
"Informational Exceptions" but other groups are not so
enthusiastic.

Various command sets (e.g. SSC (tapes) and MMC (cd/dvd)) "fine
tune" the defintion of mode pages. Mode page 0x1c is the
only one in which the name changes that I have noticed.
SSC also overloads this mode page but keeps the SPC-3 name.

In work I'm doing on sginfo to decode a mode page, first the
peripheral device type is obtained from an INQUIRY. Then a
peripheral device type specific list is checked; if there is
no match then the common list (from SPC-3) is checked.

There is another dimension of mode pages for different
transport protocols (e.g. FCP, SPI-4 and SAS). It is based
around the Protocol Specific lu/port pages (0x18 and 0x19
and their subpages). Pity that USB is not a SPC-3 recognised
transport (evidentally ATAPI will be added shortly).
But I digress ...

Doug Gilbert

