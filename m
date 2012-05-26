From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH] scsi: fix hot unplug vs async scan race
Date: Fri, 25 May 2012 23:52:21 -0500
Message-ID: <4FC06185.10003@cs.wisc.edu>
References: <20120525075352.27883.81838.stgit@dwillia2-linux.jf.intel.com> <CAA9_cme9j7n726kOxOupJLd4Tajjic8QwLA_LXk21B7YEH15BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58472 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab2EZEwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 May 2012 00:52:40 -0400
In-Reply-To: <CAA9_cme9j7n726kOxOupJLd4Tajjic8QwLA_LXk21B7YEH15BA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, Robert Love <robert.w.love@intel.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>, Matthew Wilcox <matthew@wil.cx>, Dariusz Majchrzak <dariusz.majchrzak@intel.com>

On 05/25/2012 10:34 AM, Dan Williams wrote:
>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
>> index f7565fc..3afb38d 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -1592,7 +1592,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
>>                else
>>                        lun = 0;
>>
>> -               scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);
>> +               rphy->starget = scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id, lun, 0);
>>        }
>>
>>        return 0;
>> @@ -1669,7 +1669,8 @@ sas_rphy_remove(struct sas_rphy *rphy)
>>
>>        switch (rphy->identify.device_type) {
>>        case SAS_END_DEVICE:
>> -               scsi_remove_target(dev);
>> +               __scsi_remove_target(rphy->starget);
>> +               rphy->starget = NULL;
>>                break;

I do not think it is safe to have the starget pointer on the phy and
then pass it to scsi_remove_target. If you did

for each device
	echo 1 > /sys/..../remove

then the target would get reaped/freed from under the transport class right?

It looks like the fc class needs a similar fix though too.

iSCSI is ok since no iscsi driver does scsi_scan_host and does async
scanning from userspace.
