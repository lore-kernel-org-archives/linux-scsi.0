From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI sg: Questions regarding jiffies usage
Date: Mon, 12 Jul 2004 19:11:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F31ABA.1060709@torque.net>
References: <20040711004153.GZ28324@fs.tum.de> <40F2E7EA.6010907@torque.net> <20040712224629.GY4701@fs.tum.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:54675 "EHLO
	tomts25-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S264113AbUGLXLw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 19:11:52 -0400
In-Reply-To: <20040712224629.GY4701@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Jul 12, 2004 at 03:35:06PM -0400, Douglas Gilbert wrote:
> 
<snip/>

>>>In function sg_new_write:
>>>  timeout = sg_ms_to_jif(srp->header.timeout);
>>>How is it possible that srp->header.timeout isn't already
>>>in jiffies?
>>
>>The sg_new_write() function is invoked when the sg_io_hdr
>>interface structure is used (compared with the older
>>sg_header structure). The unit of the timeout in the
>>sg_io_hdr structure is milliseconds [which is probably
>>overkill]. The mid level wants timeouts in jiffies.
> 
> 
> As far as I can see, timeout is set in two places:
> 
> sg_add_sfp:
>   sfp->timeout = SG_DEFAULT_TIMEOUT;
> 
> sg_ioctl:
>   sfp->timeout = MULDIV (val, HZ, USER_HZ);
> 
> Isn't timeout set to jiffies in both places?
> 
Adrian,
There may be some confusion here. The older struct
sg_header interface did not have explicit per command timeouts.
As a poor substitute an ioctl was added to associate
a timeout (in seconds) to the file descriptor. This way
subsequent commands issued via that file descriptor
got the new timeout value. This is the "sfp->timeout"
value. The snippets above show the "sfp->timeout"
value being set to a default when a sg device is opened
and then being changed after a SG_SET_TIMEOUT ioctl call.

The newer sg_io_hdr interface has per command timeouts
(in milliseconds). A sg_io_hdr::timeout value overrides
the "sfp->timeout" value. In the above code the
sg_io_hdr::timeout value is in "srp->header.timeout".

Doug Gilbert


