From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: sd_remove() called on a tape device - Linux 2.6.8.1 kernel
Date: Thu, 26 Aug 2004 05:42:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412DB089.1090403@optonline.net>
References: <1093494731.3549.117.camel@swtf.comptex.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta10.srv.hcvlny.cv.net ([167.206.5.85]:32398 "EHLO
	mta10.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S268278AbUHZJme (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 05:42:34 -0400
Received: from [67.86.72.128] (ool-43564880.dyn.optonline.net [67.86.72.128])
 by mta10.srv.hcvlny.cv.net
 (iPlanet Messaging Server 5.2 HotFix 1.25 (built Mar  3 2004))
 with ESMTP id <0I3100EDYSAYA7@mta10.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Thu, 26 Aug 2004 05:42:34 -0400 (EDT)
In-reply-to: <1093494731.3549.117.camel@swtf.comptex.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Burn Alting <burn@goldweb.com.au>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Burn Alting wrote:

>I'm running Fedora Core 2 with a ftp.kernel.org 2.6.8.1 kernel.
>
>I've noticed that for some reason, when I reboot the system, it sends a
>SCSI Synchronize Cache command to a tape device I have attached to the
>system. This occurs at the end of the shutdown process just before doing
>a reset into the BIOS (or whatever).
>
>The tape is at LUN 0 and a disk is at LUN 7, the only scsi devices on
>this system (hanging off an LSI Logic FC controller). The main disk is
>an IDE.
>
>Is there anything I can do to further track this down? I know that for
>  
>
Add a call to WARN_ON to the locations that can send the SYNCHRONIZE 
CACHE command. That will force a stack trace.

Disable PM poweroff before you halt the system so that you can see the 
trace.

>some reason the sd_remove() routine is being called rather than
>st_remove() - but not sure why. The system recognises the tape quite
>happily and reads/writes to it, so it knows what's at that scsi bus
>location.
>
>Regards
>Burn Alting
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

