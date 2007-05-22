From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] bug fix: SCSI async scan sysfs -EEXIST problem
Date: Tue, 22 May 2007 17:10:34 -0400
Message-ID: <46535C4A.8020509@emulex.com>
References: <1178564267.302.15.camel@localhost.localdomain> <1179848907.3738.19.camel@mulgrave.il.steeleye.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39671 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbXEVVLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 17:11:30 -0400
In-Reply-To: <1179848907.3738.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org



James Bottomley wrote:
> On Mon, 2007-05-07 at 14:57 -0400, James Smart wrote:
>> +       mutex_lock(&shost->scan_mutex);
>>         scsi_sysfs_add_devices(shost);
>> +       atomic_set(&shost->async_scan, 0);
>> +       mutex_unlock(&shost->scan_mutex);
> 
> It really seems that the only safety here is expanding the scan mutex to
> cover more of the code.  I don't really see any value to using the
> atomic types ... it's not a simultaneous variable update problem, it's a
> scan race which the mutex can be used to mediate.
> 
> James

True. First requirement is that scsi_sysfs_add_devices() must be under
the scan_mutex.  Additionally, (ignoring the atomic) shost->async_scan,
based on its use in scsi_add_lun(), should be changed under the mutex
as well, thus the "proper" placement in the snippet above is while
under the scan mutex.

The real headache was the other code paths that read the value of
async_scan and determine whether to enumerate or ignore the sdev.
Reorganizing that code to place it under scan_mutex was very ugly.
Converting to an atomic simply addressed the synchronicity on sampling,
although it essentially makes it independent of the scan_mutex.

Are you suggesting you would rather rework all the other code paths for
scan_mutex encapsulating async_scan ?

-- james




