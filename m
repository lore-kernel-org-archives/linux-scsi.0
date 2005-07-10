From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sbp2: modprobe -r fails, module allegedly in use
Date: Sun, 10 Jul 2005 19:51:40 +0200
Message-ID: <42D1602C.3040303@s5r6.in-berlin.de>
References: <42D133EE.9090204@s5r6.in-berlin.de> <1121016562.5078.15.camel@mulgrave> <20050710173732.GF14956@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:27077 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261990AbVGJRvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:51:52 -0400
In-Reply-To: <20050710173732.GF14956@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

Ben Collins wrote:
[James Bottomley wrote]
>>I notice that you don't do a scsi_device_put() after
>>scsi_add_device().  I think this is probably the source of the
>>refcounting errors: scsi_add_device returns an sdev with the refcount
>>incremented by one, so you need to decrement the count after you've
>>finished with it (in your case, you do nothing with it, so just
>>decrement after you've checked it's not an error pointer).
> 
> Thanks. Stefan, can you test with that change? I've already put it in the
> repo.

That fixes it. The error handler commits suicide when he should, and the
sbp2 module can be unloaded.

Thanks James.
-- 
Stefan Richter
-=====-=-=-= -=== -=-=-
http://arcgraph.de/sr/
