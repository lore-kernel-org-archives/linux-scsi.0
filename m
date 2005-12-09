From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sbp2: better check of transfer direction (protects from
 panic or oops)
Date: Fri, 09 Dec 2005 21:51:09 +0100
Message-ID: <4399EE3D.60003@s5r6.in-berlin.de>
References: <200512082144.jB8Li6Ul022982@einhorn.in-berlin.de> <20051209171922.GW19441@conscoop.ottawa.on.ca> <4399D477.8010504@s5r6.in-berlin.de> <20051209193423.GB19441@conscoop.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57549 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932387AbVLIUyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 15:54:16 -0500
In-Reply-To: <20051209193423.GB19441@conscoop.ottawa.on.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jody McIntyre <scjody@modernduck.com>
Cc: linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, Andrew de Quincey <adq@lidskialf.net>, linux-scsi@vger.kernel.org

Jody McIntyre wrote:
> On Fri, Dec 09, 2005 at 08:01:11PM +0100, Stefan Richter wrote:
>>If all *known* paths are fixed, we could consider to override a bad 
>>transfer direction silently like e.g. usb_storage does. But we should 
>>not leave sbp2_create_command_orb() as fragile as it currently is.
> 
> I didn't know USB did this.. the fact that USB checks itself suggests
> that we also need a check, and if we're checking we may as well warn.

Well, usb_storage actually does not override it explicitly. It just acts 
only on DMA_FROM_DEVICE or DMA_TO_DEVICE after having first checked for 
transfer buffer length AFAIU. However this is just one example. It 
differs between SCSI low level drivers. I don't know if any of them logs 
warnings about suspect transfer directions.
-- 
Stefan Richter
-=====-=-=-= ==-- -=--=
http://arcgraph.de/sr/
