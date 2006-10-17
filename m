From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: sg_remove and pending write request
Date: Wed, 18 Oct 2006 00:02:11 +0200
Message-ID: <453552E3.9030505@s5r6.in-berlin.de>
References: <0F08E10B769EAF4EA2C43A573B8CC87F60B3A7@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:37859 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750793AbWJQWCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 18:02:25 -0400
In-Reply-To: <0F08E10B769EAF4EA2C43A573B8CC87F60B3A7@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <Yanling.Qi@lsi.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

Qi, Yanling wrote:
> It seems that the reattached SAS devices would take
> the same sg slot if the following conditions meet
> 1. wait for 2+ minutes for a pending SG-IO write request to come back
> before pushing the cable back. The 2+ minutes gives the scsi middle
> level to timeout the pending io request and do error-recovery if it is
> needed.
> 2. close user space fd properly (sg_release will try to do the
> sg_dev_arr[k] = NULL.
> 
> Do you see any other conditions?

3. Do not attach other SCSI devices in the meantime.
4. Hope that the kernel re-adds the missing devices in exactly the same
order as before.

That's why many SCSI transports provide unique persistent identifiers.
You can let udev name devices files according to these identifiers or
you can query them in your application software.
-- 
Stefan Richter
-=====-=-==- =-=- =---=
http://arcgraph.de/sr/
