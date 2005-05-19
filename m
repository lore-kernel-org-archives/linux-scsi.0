From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: megaraid Error 40005 on cluster
Date: Thu, 19 May 2005 09:23:55 -0500
Message-ID: <20050519142355.GA2261@lists.us.dell.com>
References: <151.92.176.3.1249009224.1116511903@webmail.atlavia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:13994 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S262515AbVESOX4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 10:23:56 -0400
Content-Disposition: inline
In-Reply-To: <151.92.176.3.1249009224.1116511903@webmail.atlavia.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "pg@atlavia.it" <pg@atlavia.it>
Cc: linux-scsi@vger.kernel.org

On Thu, May 19, 2005 at 02:11:43PM +0000, pg@atlavia.it wrote:
> I exerienced the following error on a RedHat cluster configuration
> with Dell hardware (Perc 3/DC controller and PowerVault 220 disk
> array).  When the error occurs the cluster manager shutdown the
> cluster node, but the filesystem is corruped and the other node
> cannot mount it until a manual fsck.
> 
> Any idea?

The firmware on the PERC 3/DC is not multi-initiator cluster-capable
under Linux.  For this reason, neither Dell nor Red Hat recommend
trying to create a HA shared storage cluster with this configuration.
Even with write cache disabled, the lock sectors used by the cluster
manager don't manage to stay coherent.

I understand that newest versions of the Red Hat Cluster Suite may no
longer use lock sectors on the disk as the I/O fencing mechanism,
which may then enable such configurations.  But neither Dell nor Red
Hat have done any testing with the hardware config you've got.

The price is right, until you actually need your data to be highly
available and it crashes.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
