From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Transport affected timeouts...
Date: 22 Apr 2004 15:02:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082660534.1778.106.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C016E2@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:40173 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264634AbUDVTCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 15:02:17 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C016E2@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'Brian King' <brking@us.ibm.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Thu, 2004-04-22 at 14:54, Smart, James wrote:
> To be honest, it's probably both.  The folks that performed the
> trouble-shooting in the past blamed much of the problem on the latency, and
> used link timer values to resolve it. However, since the qual was
> predominantly raid arrays, I'd bet that it was heavily influenced by the
> target as you indicate. (note: the resulting timeout based on r_a_tov value
> is very close to just doubling the timeout). Note: I was rather surprised to
> see the timeout value of sd to be 30 seconds. I know when I was in Tru64, we
> had 60 seconds as a minimum.
> 
> One question though - how does the LLD really know what the timeout should
> be ?  It doesn't identify a target as a raid device does it ? or what raid
> level it's using ?

You don't, really.  If the default value were larger (say 60s) would we
even be having this discussion?

I know the way solaris does this is to have a global variable that
allows you to raise the timeout.  If we simply exposed Brian's proposed
parameter in sysfs, so you could change it from user space, would that
be sufficient?

I'd really like to keep the default as small as possible ... too may
people have eccentric setups which lose commands.  The longer the
timeout is, the longer we take to notice and correct the situation.

James


