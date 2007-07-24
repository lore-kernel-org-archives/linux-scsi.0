From: David Miller <davem@davemloft.net>
Subject: Re: QLGC,ISP SCSI driver not finding attached devices
Date: Mon, 23 Jul 2007 17:36:14 -0700 (PDT)
Message-ID: <20070723.173614.74744738.davem@davemloft.net>
References: <1184950646.3455.45.camel@localhost.localdomain>
	<Pine.LNX.4.61.0707201822250.8013@mtfhpc.demon.co.uk>
	<Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0707232315510.16213@mtfhpc.demon.co.uk>
Sender: sparclinux-owner@vger.kernel.org
To: mark@mtfhpc.demon.co.uk
Cc: James.Bottomley@SteelEye.com, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date: Mon, 23 Jul 2007 23:41:34 +0100 (BST)

> I can also get the ESP driver to fail to find disks with the same error 
> codes if I build it as a module driver however if I build the ESP driver 
> into the kernel, it does not fail (ESP BUS_TIMEOUT=275).

That's truly strange.

For the qlogicpti.c driver case, try increasing
qpti->host_param.bus_reset_delay.

For the ESP failure as a module case, record and report the
time that passes around the msleep() calls.  If it's less
than it's trying to delay, that's the bug.

Your identify results are what I've seen when a device has recently
reset and is not fully ready yet, indicating that the post-reset delay
is not sufficient.

I'm %99 sure it's yet another sparc32 specific kernel bug of some sort
in both of these cases, especially since the qlogicpti.c driver hasn't
changed substantially in many many years.
