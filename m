From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: Kernel oops on st module cycling
Date: Fri, 22 Feb 2013 10:30:36 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302221017330.1736@jlaw-desktop.mno.stratus.com>
References: <1361538170.24311.209.camel@amber.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:41888 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab3BVPgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 10:36:00 -0500
In-Reply-To: <1361538170.24311.209.camel@amber.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jean Delvare <jdelvare@suse.de>
Cc: =?ISO-8859-15?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Fri, 22 Feb 2013, Jean Delvare wrote:

> Hi Kai, James,
> 
> It only takes a few st module rmmod/modprobe cycles to get a kernel
> oops. It was reported to me, and reproduced by me, on kernel 3.0.58 /
> SLES11 SP2, but I was also able to reproduce it on more recent kernels
> (3.4.6 / openSUSE 12.2 and 3.7.6 / openSUSE 12.3 RC1.)
>
> [ ... snip .. ]
> 
> Thanks,
> -- 
> Jean Delvare
> Suse L3

Hi Jean,

I remember finding an st module load/unload kref accounting bug a while 
ago: http://thread.gmane.org/gmane.linux.scsi/77539  I replied to the 
report with a hack-patch that grabbed an extra reference to avoid the 
crash.

There was an attempt at fixing this up in the block layer [1] but that 
change was pulled when problems were found with that patch [2].

[1] https://lkml.org/lkml/2012/8/27/354
[2] https://lkml.org/lkml/2012/9/22/113

Maybe this is the same bug?

Hope this helps,

-- Joe
