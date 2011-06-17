From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] iscsi: Use struct scsi_lun in iscsi structs instead of
 u8[8]
Date: Fri, 17 Jun 2011 09:31:38 -0700
Message-ID: <4DFB816A.2020901@redhat.com>
References: <1308265029-32337-1-git-send-email-agrover@redhat.com>	<4DFAECB2.2010107@suse.de> <20110617143807.485b7e35@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab1FQQbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 12:31:50 -0400
In-Reply-To: <20110617143807.485b7e35@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ankit Jain <jankit@suse.de>, linux-scsi@vger.kernel.org, Eddie Wai <eddie.wai@broadcom.com>

On 06/17/2011 05:38 AM, Stefan Richter wrote:
> On Jun 17 Ankit Jain wrote:
>> On 06/17/2011 04:27 AM, Andy Grover wrote:
>>> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
>>> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
>>> @@ -430,7 +430,7 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_conn,
>>>  	default:
>>>  		tmfabort_wqe->ref_itt = RESERVED_ITT;
>>>  	}
>>> -	memcpy(scsi_lun, tmfabort_hdr->lun, sizeof(struct scsi_lun));
>>> +	memcpy(scsi_lun, &tmfabort_hdr->lun, sizeof(struct scsi_lun));
>>>  	tmfabort_wqe->lun[0] = be32_to_cpu(scsi_lun[0]);
>>>  	tmfabort_wqe->lun[1] = be32_to_cpu(scsi_lun[1]);
>>>  
>>> @@ -547,7 +547,7 @@ int bnx2i_send_iscsi_nopout(struct bnx2i_conn *bnx2i_conn,
>>>  
>>>  	nopout_wqe->op_code = nopout_hdr->opcode;
>>>  	nopout_wqe->op_attr = ISCSI_FLAG_CMD_FINAL;
>>> -	memcpy(nopout_wqe->lun, nopout_hdr->lun, 8);
>>> +	memcpy(nopout_wqe->lun, &nopout_hdr->lun, 8);
>>
>> Should you be using "sizeof (..)" here (and similar instances), rather
>> than 8? It is being done that way in other instances and it would be
>> better practice, IMHO.
> 
> sizeof or not sizeof is the least of the coding style issues in drivers/scsi/bnx2i/.
> Exhibit one from 57xx_iscsi_hsi.h:

<snip>

I hear ya. The focus of this patch was really the change to
iscsi_proto.h. All the other bits are compile fixes from that, so I
tried not to get distracted by other obvious driver issues.

Regards -- Andy
