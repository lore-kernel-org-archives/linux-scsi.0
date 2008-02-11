From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] iscsi: bidi support - libiscsi
Date: Mon, 11 Feb 2008 18:05:32 +0200
Message-ID: <47B0724C.2060108@panasas.com>
References: <47A20E85.6040906@panasas.com> <47A22FC4.2020804@panasas.com> <20080211154309.GA27183@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19628 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756583AbYBKQKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 11:10:07 -0500
In-Reply-To: <20080211154309.GA27183@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com

On Mon, Feb 11 2008 at 17:43 +0200, Pete Wyckoff <pw@osc.edu> wrote:
> bharrosh@panasas.com wrote on Thu, 31 Jan 2008 22:29 +0200:
>>   iscsi bidi support at the generic libiscsi level
>>   - prepare the additional bidi_read rlength header.
>>   - access the right scsi_in() and/or scsi_out() side of things.
>>     also for resid.
>>   - Handle BIDI underflow overflow from target
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> I see you do this a bit differently than in your previous patch set.
> In particular, the residual handling in libiscsi.c.  (I'm editing in
> a bit more context to the patch below.)
> 
>> +	if (scsi_bidi_cmnd(sc) &&
>> +		(rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
>> +					ISCSI_FLAG_CMD_BIDI_OVERFLOW))) {
>> +		int res_count = be32_to_cpu(rhdr->bi_residual_count);
>> +
>> +		if (res_count > 0 &&
>> +			(rhdr->flags & ISCSI_FLAG_CMD_BIDI_OVERFLOW ||
>> +			res_count <= scsi_in(sc)->length))
>> +			scsi_in(sc)->resid = res_count;
>> +		else
>> +			sc->result =
>> +				(DID_BAD_TARGET << 16) | rhdr->cmd_status;
>> +	}
>> +
>>  	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
>>  	                   ISCSI_FLAG_CMD_OVERFLOW)) {
>>  		int res_count = be32_to_cpu(rhdr->residual_count);
>>
>>  		if (res_count > 0 &&
>>  		    (rhdr->flags & ISCSI_FLAG_CMD_OVERFLOW ||
>>  		     res_count <= scsi_bufflen(sc)))
>> +			/* write side for bidi or uni-io set_resid */
>>  			scsi_set_resid(sc, res_count);
>>  		else
>>  			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
>>       } else if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
>>                                 ISCSI_FLAG_CMD_BIDI_OVERFLOW))
>>               sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
> 
> I haven't tested this, but, consider a bidi command that results in
> an overflow on the read part, and no overflow on the write part.
> E.g., the user supplied a data-in buffer that wasn't big enough to
> hold the returned data from the target, but the data-out buffer was
> just right.
> 
> Then this code will set scsi_in(sc)->resid properly, informing the
> caller that there were extra bytes that were not transferred.  But
> the "else" clause at the bottom will also set sc->result to be bad.
> I don't think we want this.
> 
> Your earlier patch got rid of the second bidi_overflow handler and
> just did all the logic for both bidi and non-bidi cases in a single
> if clause.  Seemed better.
> 
> 		-- Pete
You are most probably right I will investigate what happened. It looks
like I went back to some old version right? or a merge fallout
Thanks for reviewing.

Please also test latest head-of-line code if possible + iscsi patches
+ last varlen I sent.

Is there any new patches I need for 2.6.24 or head-of-line for my 
osd-dev tree?

Boaz
