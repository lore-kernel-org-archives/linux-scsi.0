From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Sun, 20 Mar 2016 18:24:26 -0700
Message-ID: <56EF4D4A.6050000@sandisk.com>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
 <56EC797A.8000104@sandisk.com> <56ED6DB1.1050202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:14496
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbcCUBYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Mar 2016 21:24:32 -0400
In-Reply-To: <56ED6DB1.1050202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/19/16 08:18, Hannes Reinecke wrote:
> On 03/18/2016 10:56 PM, Bart Van Assche wrote:
>> On 03/17/2016 12:39 AM, Hannes Reinecke wrote:
>>> On larger installations it is useful to disable automatic LUN
>>> scanning, and only add the required LUNs via udev rules.
>>> This can speed up bootup dramatically.
>>>
>>> This patch introduces a new scan module parameter value 'manual',
>>> which works like 'none', but can be overriden by setting the 'rescan'
>>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>>> And it updates all relevant callers to set the 'rescan' value
>>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>
>> Hello Hannes,
>>
>> Will setting scsi_scan_type to 'manual' allow a system to boot from a
>> SCSI disk? If not, are there alternatives to this approach? Would it be
>> a valid alternative to e.g. introduce a new threshold parameter such
>> that only LUN numbers below this threshold are scanned during boot?
>>
> I have a patch for dracut, which will generate udev rules for all
> devices required for mounting the root fs.
> Once the system is booted properly I've got another patch for systemd
> which switches back to 'normal' scanning (ie by writing 'sync' into
> /sys/modules/scsi_mod/parameters/scan) and rescan all scsi hosts.
>
> With that there's no need to have any arbitrary limits; only the
> necessary devices are enabled during boot.

Hello Hannes,

That sounds like a really interesting approach. Will this approach also 
work if the SCSI host and/or LUN numbers change during a reboot?

Thanks,

Bart.
