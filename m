From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/5] mpt fusion: Add logging support
Date: Fri, 27 Jul 2007 12:21:12 -0400
Message-ID: <1185553272.3655.22.camel@localhost.localdomain>
References: <20070724100659.GA1831@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43124 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762352AbXG0QVN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 12:21:13 -0400
In-Reply-To: <20070724100659.GA1831@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Tue, 2007-07-24 at 15:36 +0530, Prakash, Sathya wrote:
> The patches in this patch set adds support for logging facility that can be used
> to debug a number of Fusion MPT related problems.
> 
> The logging support can be enabled or disabled changing the kernel
> configuration flag CONFIF_FUSION_LOGGING
> 
> The debug level can be programmed on the fly via SysFS (hex values)
> 	echo [level] > /sys/class/scsi_host/host#/debug_level
> and also can be passed as module parameter mpt_debug_level for mptbase.ko

The way your module parameter works is slightly counter intuitive.  On
all our other drivers, you can write a value into 

/sys/module/<module>/parameters/<debug parameter>

And have it acted on immediately.  In yours, it seems only to work
before the host is probed (because after that, the value in the ioc
structure is what's used).

The other question is are you really sure you actually want per host
debugging?  is the added flexibility in being able to turn it on and off
per host worth the problems of explaining to the users where to find the
parameter?  I've got to bet that 95% of the installations only have a
single fusion card anyway.  would it not be simpler just to have a
global module parameter that can be set and acted on from /sys/modules?

James


