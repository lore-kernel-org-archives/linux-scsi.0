From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Sat, 28 Aug 2004 14:07:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41300511.2060303@torque.net>
References: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:49070 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268156AbUH1EI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 00:08:57 -0400
In-Reply-To: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
> Doug G:
> 
>  > so deferred errors can
>  > be ignored in many contexts
> 
> Any hope of Linux always reporting that deferred errors have occurred, 
> at least via dmesg if not in a critical dialog?

I certainly hope so. One small change I made in my patch
yesterday was to pass deferred errors back to the block
SG_IO code.

This could be a largish job. First put a more robust
mechanism in place, then sweep the scsi mid level and
perhaps upper level drivers and convert them to the
new interface. The important thing to do is to think
about the error checking code distributed around the
place. It is reasonably easy to fix the wrong headed
stuff but wider issues are often involved (e.g. should
this be ignored and/or processed at a different level).

> A deferred error, in the context of sense data ((bytes[0] & x7F) != x70) 
> is usually a purportedly rare and therefore interesting catastrophe of 
> some kind, yes?  A failure to write seen while flushing cache.  A 
> failure to eject after obediently faking "immediate"ly good status.  Etc.
> 
>  > http://marc.theaimsgroup.com/?l=linux-scsi&m=109359716220586

Perhaps deferred errors should be picked up at the lowest
level of the midlevel, logged and ignored at higher levels
unless they are going back to a pass through interface.

> Sorry I failed to click thru to the context for this thread.

That is fine, the only other folks that I seemed to wake up
were the style police :-)

Doug Gilbert

