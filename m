From: Michael Clark <michael@metaparadigm.com>
Subject: Re: [PATCH] blacklist device don't use SYNCHRONIZE_CACHE
Date: Fri, 29 Oct 2004 17:04:57 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <418207B9.20908@metaparadigm.com>
References: <418206C7.2070908@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gort.metaparadigm.com ([203.117.131.12]:8090 "EHLO
	gort.metaparadigm.com") by vger.kernel.org with ESMTP
	id S261390AbUJ2JEC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 05:04:02 -0400
Received: from localhost (unknown [127.0.0.1])
	by gort.metaparadigm.com (Postfix) with ESMTP id 4F7F81ACFD
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 17:04:01 +0800 (SGT)
Received: from gort.metaparadigm.com ([127.0.0.1])
 by localhost (gort [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 05615-09 for <linux-scsi@vger.kernel.org>;
 Fri, 29 Oct 2004 17:04:00 +0800 (SGT)
Received: from [10.1.0.59] (monty-ath0.metaparadigm.com [10.1.0.59])
	by gort.metaparadigm.com (Postfix) with ESMTP id 9E90C1ACCD
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2004 17:04:00 +0800 (SGT)
In-Reply-To: <418206C7.2070908@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Apologies for base64 attachment - if anyone can tell me how
to stop my Debian Mozilla 1.7 from randomly deciding to base64
my attached patches (it only decides to do it on some of them).

~mc

On 10/29/04 17:00, Michael Clark wrote:
> Hi all,
> 
> With qla2300 loaded (and sdc a LUN on an external FC RAID controller),
> I was getting a hang on reboot at:
> 
>   Synchronizing SCSI cache for disk sdc:
> 
> I did some debugging by changing the timeout in sd_sync_cache and
> found the RAID Controller was just dropping the commands (it's an
> external battery backed RAID array so the sd_sync_cache is not
> important anyway).
> 
> So, attached patch adds to the SCSI blacklist infrastructure to
> allow listing devices for which we shouldn't send a SYNCRONIZE_CACHE
> command and adds in the misbehaving device i have here.
> 
> Now I can reboot ;) without waiting 7.5 minutes.
> 
> BTW - The default of 15 retries of 30 secs each is insane
> (3 in sd_sync_cache x 5 in scsi_wait_req) - any real need
> for the additional outer loop in sd_sync_cache ?
> 
> ~mc
