From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 22:19:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098908346.12464.44.camel@zezette>
References: <1098833278.4914.24.camel@zezette>
	 <20041027081713.GC32712@marowsky-bree.de>
	 <1098903759.12464.32.camel@zezette>
	 <1098905875.4472.92.camel@gator.sc.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.wanadoo.fr ([193.252.22.27]:13639 "EHLO
	mwinf0401.wanadoo.fr") by vger.kernel.org with ESMTP
	id S262677AbUJ0UTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 16:19:09 -0400
In-Reply-To: <1098905875.4472.92.camel@gator.sc.steeleye.com>
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@Steeleye.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> Switching LUNs from one path to another is not a fast process and if
> this happens during periods of heaving IO periods, significant thrashing
> can result.
> 
> I think if we want to play at the Enterprise level where there are many
> servers connected up to large arrays I don't think it is a good idea to
> knowingly cause disruptions to others on the SAN.  Causing LUNs to
> switch from one path to another is such a behavior.
> 
I certainly don't militate for the NOSTARTONADD flag removal for all
devices. I just consider it annoying for the HSG80 / HSV* family
controlers :

- Either they are in failover mode and there is no bouncing possible, so
start_stop is harmless

- Either they are in multibus mode, then not sending start_stop before
READ CAPA lead to cmd failure and wrong size stored. Hence ghosts path
are ununsable even when they come up. [Here, I shamely hide the
device-mapper hooks on path activation could work]

- Either way, these controler families are *not* high-end devices,
whatever the criteria (capacity, throughput, cache, alarming, ...). The
whole ghost-path notion being the best evidence.

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

