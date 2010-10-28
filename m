From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [Open-FCoE] [PATCH 1/2] libfc: fix memory leakage in local port
Date: Thu, 28 Oct 2010 16:31:26 -0700
Message-ID: <4CCA07CE.2060702@cisco.com>
References: <AANLkTi=dLRNj0r8aUehqtVPgzpJsbGqnX2t-7AOkQfkS@mail.gmail.com> <1288307525.1431.201.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:1311 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312Ab0J1Xbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 19:31:48 -0400
In-Reply-To: <1288307525.1431.201.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Hillf Danton <dhillf@gmail.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org



On 10/28/10 4:12 PM, Robert Love wrote:
> On Wed, 2010-10-27 at 20:40 +0800, Hillf Danton wrote:
>> There seems info should get freed when error encountered.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/libfc/fc_lport.c	2010-09-13 07:07:38.000000000 +0800
>> +++ b/drivers/scsi/libfc/fc_lport.c	2010-10-27 20:33:36.000000000 +0800
>> @@ -1766,8 +1766,10 @@ static int fc_lport_ct_request(struct fc
>>  	info->sg = job->reply_payload.sg_list;
>>
>>  	if (!lport->tt.exch_seq_send(lport, fp, fc_lport_bsg_resp,
>> -				     NULL, info, tov))
>> +				     NULL, info, tov)) {
>> +		kfree(info);
> 
> We cannot free the BSG info here. If you look at fc_exch_seq_send you
> can see that it's attached to the exchange and then when the response is
> received it is passed to the response handler, in the case
> fc_lport_bsg_resp, where it is free'd.

This is on failure of seq_send().  It's confusing because that returns the
sequence, which is NULL on error.  So, I think the kfree() is correct.

> 
>>  		return -ECOMM;
>> +	}
>>  	return 0;
>>  }
>> _______________________________________________
>> devel mailing list
>> devel@open-fcoe.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
> 
> 
> _______________________________________________
> devel mailing list
> devel@open-fcoe.org
> http://www.open-fcoe.org/mailman/listinfo/devel
