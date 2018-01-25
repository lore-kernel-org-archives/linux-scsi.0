From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] Improving Asynchronous SCSI Disk Probing
Date: Thu, 25 Jan 2018 19:23:53 +0100
Message-ID: <3106d9c4-16f0-224f-d838-729ea9166bd4@suse.de>
References: <1516231473.2820.81.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750994AbeAYSXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jan 2018 13:23:55 -0500
In-Reply-To: <1516231473.2820.81.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/18/2018 12:24 AM, Bart Van Assche wrote:
> When the SCSI scanning code discovers a SCSI device it calls the driver core
> function device_add() to associate a SCSI ULD with the device. The driver
> core invokes the probing function for the matching SCSI ULP, e.g. sd_probe().
> In order to minimize the time needed to scan SCSI targets that have a large
> number of LUNs, the SCSI disk driver scans LUNs asynchronously by starting
> the actual probing work asynchronously from inside sd_probe()
> 
> An unfortunate aspect of how SCSI disk probing works today is that there is
> unnecessary serialization between probing and removal activity. For a
> possible approach of how to increase SCSI disk probing concurrency, see also
> [PATCH] sd: Increase SCSI disk probing concurrency, linux-scsi mailing list,
> December 2017 (https://www.spinics.net/lists/linux-scsi/msg115657.html).
> 
> A second unfortunate aspect of SCSI disk probing is that certain race
> conditions in the block layer are hit if removal starts before asynchronous
> probing has finished. This is because the driver core is unaware that the
> SCSI disk code works asynchronously.
> 
> Additionally, the SCSI disk asynchronous probing approach is incompatible
> with the power management code. The power management code calls
> wait_for_device_probe() in the driver core to wait for device probing
> activity to finish. wait_for_device_probe() however is unaware of the
> asynchronous probing in the SCSI sd driver and hence doesn't wait for the
> SCSI sd probing activity to finish.
> 
> My proposal is to hold a session to discus potential solutions for
> increasing SCSI disk probing concurrency in a way that is compatible with
> the driver core and the power management subsystem.
> 
Having submitted one attempt to fix this up myself I'd definitely be
interested in this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
