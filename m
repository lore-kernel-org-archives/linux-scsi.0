From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Wed, 22 Feb 2006 08:35:33 +0100
Message-ID: <43FC1445.40706@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de> <20060220060845.GS27946@ftp.linux.org.uk> <43FB7058.4040008@s5r6.in-berlin.de> <20060221215144.GW27946@ftp.linux.org.uk> <43FC0DDE.1050805@s5r6.in-berlin.de> <20060222071641.GA27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:33993 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932235AbWBVHft (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 02:35:49 -0500
In-Reply-To: <20060222071641.GA27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Al Viro wrote:
> On Wed, Feb 22, 2006 at 08:08:14AM +0100, Stefan Richter wrote:
>>...these 6 lines here? We would miss what can be extracted from these 
>>buggy devices but (a) sd_read_cache_type::bad_sense's defaults work IMO 
>>well enough for the so far reported devices
> 
> Yeah, right.  The same bridge loses its cache contents on reboot.
> I.e. missed cache type => dirty fs on every reboot, with actual
> corruption in case if there was any recent activity.  So...  No, thanks.
> It might make sense to split that in two patches, but if you really
> think that defaults work...  I've seen several enclosures where they
> don't (different types, at that).

Well, right.

BTW, I never noticed such kind of breakage myself yet. I almost always 
break connection not by reboot but by hot-unplug while sbp2 is still 
logged in. This would corrupt data too --- *if* these devices really had 
a write cache and did not flush it themthelves at some point. Maybe 
self-powered devices actually do this at each FireWire bus reset. But 
bus powered devices cannot.
-- 
Stefan Richter
-=====-=-==- --=- =-==-
http://arcgraph.de/sr/
