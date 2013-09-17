From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/22] be2iscsi: Fix negotiated parameters upload to FW
Date: Tue, 17 Sep 2013 16:15:50 -0500
Message-ID: <5238C686.8010204@cs.wisc.edu>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com> <1379049014-32716-4-git-send-email-jayamohan.kallickal@emulex.com> <5237C56C.1060605@cs.wisc.edu> <00c19394-64ee-4326-8e7f-e58318974d70@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46829 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab3IQVQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 17:16:03 -0400
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
> Here is a small  userspace fix  that should  go along 
> 
> diff --git a/usr/be2iscsi.c b/usr/be2iscsi.c
> index ce8b719..ba4c29f 100644
> --- a/usr/be2iscsi.c
> +++ b/usr/be2iscsi.c
> @@ -33,10 +33,6 @@ void be2iscsi_create_conn(struct iscsi_conn *conn)
>  	if (conn->max_xmit_dlength > 65536)
>  		conn->max_xmit_dlength = 65536;
>  
> -	if (!conn_rec->iscsi.MaxXmitDataSegmentLength ||
> -	    conn_rec->iscsi.MaxXmitDataSegmentLength > 65536)
> -		conn_rec->iscsi.MaxXmitDataSegmentLength = 65536;
> -
>  	session->erl = 0;
>  	session->initial_r2t_en = 1;
>  }

For the case you are trying to fix are you getting 0 or 64K from
userspace?  In the kernel code you changed to set the value to 8K it
looks like you got 0 from userspace. Is that right?

Are you setting node.conn[0].iscsi.MaxXmitDataSegmentLength in
iscsif.conf to 64K or did you leave it as the default? Just to make sure
we are on the same page I really mean did you set it in iscsid.conf or
with iscsiadm. I am not talking about setting above in the be2iscsi
create_conn callout.

If it is the default of 0, then I think when the code above is called
iscsi_copy_operational_params will have set conn->max_xmit_dlength to
ISCSI_DEF_MAX_RECV_SEG_LEN (8k). The conn->max_xmit_dlength value is the
one we use for final negotiated value so that is what gets passed to the
kernel.

If the target does not negotiate for MRDSL then it should stay 8k.
iscsi_session_set_params will then pass down conn->max_xmit_dlength when
login is done.

If I am looking at the code right, the only way we can get 0 in the
kernel is if the target sends 0 for MRDSL. iscsid was not expecting that
and will just set conn->max_xmit_dlength to 0 and that will get passed
down to all drivers incorrectly. If I am right then we need to do a fix
for all drivers.
