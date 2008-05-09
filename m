From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Clean patch to fix not working spindown over Firewire
Date: Sat, 10 May 2008 00:02:19 +0200 (CEST)
Message-ID: <tkrat.cd9196df20bc6982@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
 <481874BD.5010807@s5r6.in-berlin.de> <481875E4.6040606@s5r6.in-berlin.de>
 <20080509201635.GA20189@dose.home.local>
 <tkrat.606fe302c67e64b4@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53898 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYEIWCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2008 18:02:22 -0400
In-Reply-To: <tkrat.606fe302c67e64b4@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tino Keitel <tino.keitel@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> On  9 May, Tino Keitel wrote:
>> On Wed, Apr 30, 2008 at 15:36:36 +0200, Stefan Richter wrote:
>>> If it works for all RBC devices (it should according to the spec...) &&
>>> your ICY Box exposes itself as RBC device (it should do so), then we
>>> don't need any changes to struct scsi_device and to sbp2/ firewire-sbp2.
>> 
>> Do you mean something like in the attached (untested) patch?
>> 
>> Regards,
>> Tino
>> 
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 01cefbb..6b927f6 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1787,8 +1787,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>>  	struct scsi_device *sdp = sdkp->device;
>>  	int res;
>>  
>> -	if (start)
>> +	if (start) {
>>  		cmd[4] |= 1;	/* START */
>> +		/* active power condition */
>> +		cmd[4] |= (sdp->type == TYPE_RBC) ? (1 << 4) : 0; 
>> +	} else
>> +		/* standby power condition */
>> +		cmd[4] |= (sdp->type == TYPE_RBC) ? (3 << 4) : 0 ; 
>>  

PS:
The power conditions should be supported by many more devices besides
RBC devices.  Only SAT (and hence libata) and Linux' "File-backed USB
Storage Gadget" (drivers/usb/gadget/file_storage.c) have objections
against power condition.

But it's less intrusive if we enable it only for RBC for now because we
now have a good idea about how well it is supported by them.
-- 
Stefan Richter
-=====-==--- -=-= -=--=
http://arcgraph.de/sr/

