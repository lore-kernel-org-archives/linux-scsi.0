From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI sg: Questions regarding jiffies usage
Date: Mon, 12 Jul 2004 15:35:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F2E7EA.6010907@torque.net>
References: <20040711004153.GZ28324@fs.tum.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts10.bellnexxia.net ([209.226.175.54]:42412 "EHLO
	tomts10-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S263784AbUGLWZl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2004 18:25:41 -0400
In-Reply-To: <20040711004153.GZ28324@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> Hi,
> 
> I have some questions regarding jiffies usage in the SCSI sg driver in 
> 2.6.7-mm7:
> 
> 
> Is there a good reason for the local sg_ms_to_jif/sg_jif_to_ms functions  
> instead of using the time.h msecs_to_jiffies/jiffies_to_msecs macros?

Adrian,
I don't think the msec_to_jiffies() macro was there when I
wanted it. So the sg driver should be changed to use the
macros in time.h .

> In function sg_new_write:
>    timeout = sg_ms_to_jif(srp->header.timeout);
> How is it possible that srp->header.timeout isn't already
> in jiffies?

The sg_new_write() function is invoked when the sg_io_hdr
interface structure is used (compared with the older
sg_header structure). The unit of the timeout in the
sg_io_hdr structure is milliseconds [which is probably
overkill]. The mid level wants timeouts in jiffies.

> Why do both sg_add_request and sg_common_write set
>   duration = jiffies

It doesn't look like both are required.

Doug Gilbert


