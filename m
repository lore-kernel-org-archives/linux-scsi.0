From: Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 4/6] scsi: megaraid_sas - call cmd completion from reset
Date: Mon, 12 Nov 2007 01:40:40 -0500
Message-ID: <1194849640.5946.61.camel@perihelion>
References: <1194600944.6297.8.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbXKLGk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Nov 2007 01:40:56 -0500
In-Reply-To: <1194600944.6297.8.camel@dhcp-75-884.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Sumant.patro@lsi.com


On Fri, 2007-11-09 at 04:35 -0500, bo yang wrote:
> Driver will call cmd completion routine from Reset path without waiting for cmd completion from isr context.

Thanks. I'm going to take a look at this, as well as the other recent 2
patches for a couple of test kernels we have that are based on the -RT
patchset. We are seeing occasional problems with megasas (so far only
exhibited on specific systems based upon the PERC 5 cards) when:

* Using an -RT kernel.
* Lots of outstanding IO.

My analysis suggests that this happens because the -RT patch changes
tasklet behavior such that we won't run nearly as quickly as in vanilla
Linux, and we might end up with a lot more IO cmds outstanding with the
FW before we get around to dequeing them. I think there exists (but I
haven't proved it yet) a timing problem in that driver.

In a 2.6.21 test kernel we have, there's an inconsistency wrt. upstream
changes that happened at that time - James and Christoph were racing
wrt. oneanother and the use of the additional (optional) scsi host
callback that sas happens to use to handle io throttling. In later
kernels, this behavior almost seems to be working - I backported this to
2.6.21 and can see the throttle function get called a few times before
we finally go out to lunch. I'm planning to finish debugging tomorrow.

This is an FYI really, just to say that I'm actively poking at megasas
at the moment. I would also love to hear from yourself, and anyone else
who is (or who has) test[ing|ed] these ongoing patches on -RT.

Jon.


