From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Transport affected timeouts...
Date: 21 Apr 2004 15:20:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082575283.2583.6.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C016CE@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:57517 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263634AbUDUTVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 15:21:54 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C016CE@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Wed, 2004-04-21 at 12:53, Smart, James wrote:
> Where do we go from here ?   
> 
> What we are doing in our driver is the following:
> - Cancel the mid-layer timeout
> - Set timeout to (cmd->timeout_per_command/HZ) + hba_offset
> - Start timer based on new timeout value

Well, this is unacceptable.  Only the mid layer should be mucking with
mid-layer timers.

> Where hba_offset is: (2 * R_A_TOV) + administrative increment (default 0)
> Where R_A_TOV is the fabric-reported timeout. R_A_TOV is at least a round
> trip time, plus 2 times max delivery delay time within the fabric. (default
> 10 seconds).  This value can change based on fabric reconfiguration or
> plugging the adapter into a differnet fabric.

I'm still not clear on what you're trying to achieve.

the scsi_host_self_blocked interface was created with reconfig events in
mind...it still won't stop in-progress timers, but I've been considering
adding that feature for things like FC lip events.

James


