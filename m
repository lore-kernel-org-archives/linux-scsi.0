From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Thu, 27 Oct 2016 08:38:03 -0700
Message-ID: <72f0f8f4-d08e-547d-6c40-f56916b31e7d@sandisk.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
 <20161027094634.fifk7wd43vyu64bd@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0081.outbound.protection.outlook.com ([104.47.36.81]:13948
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755509AbcJ0PiO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 11:38:14 -0400
In-Reply-To: <20161027094634.fifk7wd43vyu64bd@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/27/2016 02:46 AM, Johannes Thumshirn wrote:
> On Wed, Oct 26, 2016 at 11:44:51AM -0700, Bart Van Assche wrote:
>> +static void scsi_remove_device_async(struct scsi_device *sdev)
>> +{
>> +	if (scsi_device_get(sdev) < 0)
>
> Nit: the < 0 could be dropped, scsi_device_get returns either -ENXIO or
> 0. But no reason to respin.
>
> Anyways,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Hello Johannes,

Thanks for the review. But I'd like to clarify that I added the "< 0" on 
purpose. Some *_get*() functions in the Linux kernel return 0 upon 
failure (e.g. kref_get_unless_zero()) and others a negative value (e.g. 
scsi_device_get()). The "< 0" part avoids that someone who reads this 
code has to look up what return value convention scsi_device_get() uses.

Bart.

