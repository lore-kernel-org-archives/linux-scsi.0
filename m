From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Thu, 27 Oct 2016 08:39:43 -0700
Message-ID: <ec9137f3-bdda-0ef8-d50b-b2f5eb608da5@sandisk.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
 <2b64c1d7-e6b4-01a9-0c6e-1d8590714595@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0058.outbound.protection.outlook.com ([104.47.42.58]:3129
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937392AbcJ0Pjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 11:39:51 -0400
In-Reply-To: <2b64c1d7-e6b4-01a9-0c6e-1d8590714595@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/27/2016 02:36 AM, Sagi Grimberg wrote:
>> The solution I prefer is to modify the SCSI scanning code such that
>> the scan_mutex is only held while performing the actual LUN scanning
>> and while ensuring that no SCSI device has been created yet for a
>> certain LUN number but not while the Linux device and its sysfs
>> attributes are created. Since that approach would require extensive
>> changes in the SCSI scanning code, another approach has been chosen,
>> namely to make self-removal asynchronous. This patch avoids that
>> self-removal triggers the following deadlock:
>
> Is this a real deadlock? or just a lockdep complaint?
>
> Wouldn't making scsi_remove_device() taking single depth
> mutex_lock_nested suffice here?

Hello Sagi,

It's a real deadlock, and I can trigger it relatively easy by deleting a 
SCSI device that is managed by the dm-multipath driver.

Bart.
