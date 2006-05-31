From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 17:11:25 -0500
Message-ID: <1149113485.22134.146.camel@mulgrave.il.steeleye.com>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
	 <1149104797.7543.64.camel@localhost.localdomain>
	 <1149109073.22134.105.camel@mulgrave.il.steeleye.com>
	 <1149112802.7543.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22479 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965204AbWEaWMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 18:12:30 -0400
In-Reply-To: <1149112802.7543.83.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 15:00 -0700, Alexis Bruemmer wrote:
> Below is a ls -R of my tree on this machine.  It seems that it sees
> the
> expander as a wide port (port-0:0) and then the expander has a series
> of
> phys attached to end devices.  What I am curious about is the
> port-0:0:[0...4]-- the way this is laid out it seems that there is one
> port for each phy which is attached to one end device, which would be
> a
> narrow port.  Does your x260 create the same topology?

Yes, that's by design.

Now every start point for a device must be a port (either narrow or
wide).  The port-0:0:X are ports formed on the expander.  And, since you
only have narrow devices attached, that's all it shows  you'll see this
if you look at the tree under /sys/devices rather than /sys/class (since
the latter is flat).  All of the port-0:0:x will show up under
expander-0:0 (just do ls /sys/class/sas_expander/expander-0:0/device/ to
see this).

James


