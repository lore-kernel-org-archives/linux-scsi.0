From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Fri, 14 Jan 2005 10:32:00 +0100
Message-ID: <20050114093200.GB5724@bogon.ms20.nix>
References: <20041210123333.GD685@bogon.ms20.nix> <20041213222206.GA18893@us.ibm.com> <20050110164200.GA8655@bogon.ms20.nix> <20050111181500.GA9046@us.ibm.com> <20050113124032.GB5701@bogon.ms20.nix> <20050114000115.GA13676@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from honk1.physik.uni-konstanz.de ([134.34.140.224]:24505 "EHLO
	honk1.physik.uni-konstanz.de") by vger.kernel.org with ESMTP
	id S261929AbVANJgX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 04:36:23 -0500
Content-Disposition: inline
In-Reply-To: <20050114000115.GA13676@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 13, 2005 at 04:01:15PM -0800, Patrick Mansfield wrote:
> On Thu, Jan 13, 2005 at 01:40:32PM +0100, Guido Guenther wrote:
> 
> > > Can you turn on some scsi logging, and send that?
> > Sure. I tried scsi_logging_level=... on the kernel command line but it
> > didn't show anything, did I miss something obvious?
> > /proc/sys/dev/scsi/logging_level was still zero afterwards.
> 
> It is a sysctl variable, so you can set it after you are booted, per my
> other email (and still below), and man sysctl.
Yes I saw that, I was just wondering why scsi_logging_level doesn't work
also it's a module option in scsi.c.

> If you are building the qlogic driver into the kernel you can still rescan
> the LUNs via:
> 
> 	echo "- - -" > /sys/class/scsi_host/hostN/scan
O.k. Thanks.
 -- Guido

> > > If you have root on scsi, you should shutdown syslogd (though this should
> > > not generate lots of logging for small amounts of IO it generates some,
> > > and if you screw up you'll be able to disable the logging), and then 
> > > capture the console/serial output.
> > > 
> > > If root on ide, just leave syslog on and get /var/log/messages output.
> > > 
> > > Turn on per-command and scan logging (0x2400 | 0x01c0):
> > > 
> > > 	sysctl -w dev.scsi.logging_level=0x25c0
> > > 
> > > Set back off afterwards with:
> > > 
> > > 	sysctl -w dev.scsi.logging_level=0
> > > 
> > > -- Patrick Mansfield
