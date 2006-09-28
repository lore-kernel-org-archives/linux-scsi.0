From: Michael Reed <mdr@sgi.com>
Subject: Re: SCSI tape block size
Date: Thu, 28 Sep 2006 09:34:44 -0500
Message-ID: <451BDD84.2060704@sgi.com>
References: <200609241605.32327.johna@onevista.com> <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:65422 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1161153AbWI1OfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 10:35:02 -0400
In-Reply-To: <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org



Guennadi Liakhovetski wrote:
> Hi all
> 
> I've got a problem report and a patch from John Adams, he says tmscsim 
> driver under 2.6.17 and on doesn't allow him to read tapes with blocksize 
> of 1MB. He fixes this with the below patch.
> 
> On Sun, 24 Sep 2006, John Adams wrote:
> 
>> --- drivers/scsi/tmscsim.c.bak	2006-09-24 12:55:08.000000000 -0400
>> +++ drivers/scsi/tmscsim.c	2006-09-24 12:55:56.000000000 -0400
>> @@ -2300,7 +2300,8 @@
>>  	.this_id		= 7,
>>  	.sg_tablesize		= SG_ALL,
>>  	.cmd_per_lun		= 1,
>> -	.use_clustering		= DISABLE_CLUSTERING,
>> +	.use_clustering		= ENABLE_CLUSTERING,
>> +	.max_sectors            = 2048,
>>  };
>>  
>>  /***********************************************************************
> 
> It looks like
> 
> 1) use_clustering doesn't directly affect maximum block size, so, he 
> doesn't really need it, although, it might make sense for tmscsim to 
> improve performance.
> 
> 2) max_sectors is indeed what he needs, but it looks strange that now it 
> has to be set by the low-level driver... For block devices you can set it 
> at run time with /sys/block/sda/queue/max_sectors_kb, right? But what 
> about tapes?

Thank you for posting this.  I was wondering why with 2.6.16 the maximum
tape block I could access via by BusLogic adapter dropped to 64k.  Now
I know what to change.

Does anyone know what the appropriate max sectors limit is for BusLogic?

Thanks,
 Mike

> 
> Sorry, didn't find too much documentation about it.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
