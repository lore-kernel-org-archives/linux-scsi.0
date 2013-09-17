From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/22] be2iscsi: Fix negotiated parameters upload to FW
Date: Tue, 17 Sep 2013 16:23:12 -0500
Message-ID: <5238C840.9090001@cs.wisc.edu>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com> <1379049014-32716-4-git-send-email-jayamohan.kallickal@emulex.com> <5237C56C.1060605@cs.wisc.edu> <00c19394-64ee-4326-8e7f-e58318974d70@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46841 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3IQVXX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 17:23:23 -0400
In-Reply-To: <00c19394-64ee-4326-8e7f-e58318974d70@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Cc: Jayamohan Kallickal <jayamohank@gmail.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sony John-N <Sony.John-N@Emulex.Com>

On 09/16/2013 11:28 PM, Jayamohan Kallickal wrote:
> 
> 
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Monday, September 16, 2013 7:59 PM
> To: Jayamohan Kallickal
> Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Jayamohan Kallickal; Sony John-N
> Subject: Re: [PATCH 04/22] be2iscsi: Fix negotiated parameters upload to FW
> 
> On 09/13/2013 12:09 AM, Jayamohan Kallickal wrote:
>>  - If target does not send MaxRecvDSL in login repsonse, then
>>    initiator should consider the MaxRecvDSL for target is 8K.
>>    In this scenario driver was setting the value to 64K and this
>>    caused target to close cxn as data xfer was more than the
>>    MaxRecvDSL
>>  - Update connection offload data structure for SKH-R adapters.
>>
>> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
>> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
>> ---
>>  drivers/scsi/be2iscsi/be_iscsi.c |    9 +++++++--
>>  drivers/scsi/be2iscsi/be_main.h  |   29 ++++++++++++++++-------------
>>  drivers/scsi/be2iscsi/be_mgmt.c  |    8 +++-----
>>  3 files changed, 26 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c 
>> b/drivers/scsi/be2iscsi/be_iscsi.c
>> index 2496ea7..60c1dff 100644
>> --- a/drivers/scsi/be2iscsi/be_iscsi.c
>> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>> @@ -672,9 +672,10 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
>>  			session->max_burst = 262144;
>>  		break;
>>  	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
>> -		if ((conn->max_xmit_dlength > 65536) ||
>> -		    (conn->max_xmit_dlength == 0))
>> +		if (conn->max_xmit_dlength > 65536)
>>  			conn->max_xmit_dlength = 65536;
>> +		else if (conn->max_xmit_dlength == 0)
>> +			conn->max_xmit_dlength = 8192;
> 
>> Was the target sending 0 or not sending anything at all? Userspace should not be sending 0 if the target did not send >MaxRecvDSL. It looks like it should be sending 8k for that case. It looks like there is a bug in the tools where it will pass 0 >if the target sent 0.
> 
>> It seems other drivers would be hitting this bug too and we should fix everyone.
> 
> This was an IET target that  did not send any value and we were defaulting to 64K
> 

I am still not sure how you are getting 0 passed from userspace.

Do you mean the target sent the MaxRecvDataSegmentLength key but no
value or that it did not even send the MaxRecvDataSegmentLength key.

The thing is that iscsi_copy_operational_params will set
conn->max_xmit_dlength to ISCSI_DEF_MAX_RECV_SEG_LEN (8K). We then do
the login negotiation dance. If the target does not send the
MaxRecvDataSegmentLength key then it will stay 8K and that is what
should be getting passed down to the drivers. If that is not working
correctly then we need to fix for all drivers.

If the target is sending 0 for the value then again we need to fix this
for all drivers since none of them can handle this.

