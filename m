From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 1/1] lpfc: lpfc no longer discovers lun 255
Date: Fri, 04 Dec 2009 11:55:41 -0600
Message-ID: <4B194D1D.3060309@sgi.com>
References: <4B1932FA.7080407@sgi.com> <4B1949E3.8040400@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:46886 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932336AbZLDRzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 12:55:35 -0500
In-Reply-To: <4B1949E3.8040400@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Yeah.  I'm working on a patch for qla1280.c also.  Probably others
have been hit.  It would have been nice if the patch author had
fixed all the drivers instead of introducing this change and waiting
for people to discover their last lun is now missing.

James Smart wrote:
> Thanks Mike.   Wonder if that change broke other drivers too...
> 
> Acked-By:   James Smart <james.smart@emulex.com>
> 
> -- james s
> 
> Michael Reed wrote:
>> A change in lun scanning range in scsi_scan.c ( ">" becomes ">=") results
>> in lpfc no longer discovering lun 255 of my test configuration.  This
>> patch adjusts lpfc_attr.c to discover lun 255 again.
>>
>> scsi: host 3 channel 0 id 17 lun255 has a LUN larger than allowed by the host adapter
>>
>>
>> Signed-off-by: Michael Reed <mdr@sgi.com>
>>
>>
>> --- scsi-misc-2.6/drivers/scsi/lpfc/lpfc_attr.c	2009-12-01 16:18:40.000000000 -0600
>> +++ scsi-misc-2.6-modified/drivers/scsi/lpfc/lpfc_attr.c	2009-12-04 10:01:52.091503203 -0600
>> @@ -3099,10 +3099,10 @@ LPFC_VPORT_ATTR(discovery_threads, 32, 1
>>  
>>  /*
>>  # lpfc_max_luns: maximum allowed LUN.
>> -# Value range is [0,65535]. Default value is 255.
>> +# Value range is [0,65535]. Default value is 256, 1 greater than max lun number.
>>  # NOTE: The SCSI layer might probe all allowed LUN on some old targets.
>>  */
>> -LPFC_VPORT_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN");
>> +LPFC_VPORT_ATTR_R(max_luns, 256, 0, 65535, "Maximum allowed LUN");
>>  
>>  /*
>>  # lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.
>>
>>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
