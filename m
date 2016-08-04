From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/22] libfc: additional debugging messages
Date: Thu, 4 Aug 2016 08:05:44 +0200
Message-ID: <7181a9bf-df0a-6aee-8984-b370e68fda44@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-3-git-send-email-hare@suse.de>
 <e65a6f9e-e81f-5daf-a766-cc6abb7f6beb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbcHDGYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 02:24:13 -0400
In-Reply-To: <e65a6f9e-e81f-5daf-a766-cc6abb7f6beb@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On 08/03/2016 07:33 PM, Bart Van Assche wrote:
> On 08/03/2016 06:13 AM, Hannes Reinecke wrote:
>> @@ -1121,8 +1124,10 @@ static void fc_rport_prli_resp(struct fc_seq
>> *sp, struct fc_frame *fp,
>>          fc_rport_enter_rtv(rdata);
>>
>>      } else {
>> -        FC_RPORT_DBG(rdata, "Bad ELS response for PRLI command\n");
>> -        fc_rport_error_retry(rdata, fp);
>> +        rjt = fc_frame_payload_get(fp, sizeof (*rjt));
>> +        FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
>> +                 rjt->er_reason, rjt->er_explan);
>> +        fc_rport_error_retry(rdata, NULL);
>>      }
> 
> Shouldn't the type of the frame be checked in this code instead of
> assuming that it's a reject?
> 
I've asked me the same question, but as it stands FC-LS only allows for
two frame types (LS_ACC or LS_RJT).
And it's (more-or-less) consistent usage throughout libfc.
But yeah, for safety one really should check for LS_ACC and LS_RJT and
throw an error for any other type.
However, that should be done throughout libfc, and would warrant a
different patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
