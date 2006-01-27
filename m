From: Ariel <askernel2615@dsgml.com>
Subject: Re: More information on scsi_cmd_cache leak... (bisect)
Date: Fri, 27 Jan 2006 13:53:06 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0601271342000.8977@pureeloreel.qftzy.pbz>
References: <200601270410.06762.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc14.comcast.net ([204.127.202.59]:32246 "EHLO
	sccrmhc14.comcast.net") by vger.kernel.org with ESMTP
	id S1751541AbWA0SxN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 13:53:13 -0500
In-Reply-To: <200601270410.06762.chase.venters@clientec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org, a.titov@host.bg, axboe@suse.de, jamie@audible.transient.net, neilb@suse.de, arjan@infradead.org


I found a patch called: slab-leak-detector.patch and applied it (manually 
since it's for a slightly older kernel).

Here are the results: (after leaking about 1MB)

c03741ba <__scsi_get_command+0x29/0x73>

Is the leaker with 294 of them, vs 4 of:

c03743fd <scsi_setup_command_freelist+0xb0/0x101>

and 21:
fffffffe <0xfffffffe>

I'm not sure how helpful that result is though, since I guess we already 
knew it was scsi, and from the other email, that's it's also some 
interaction with md.

 	-Ariel
