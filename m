From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/38] Implement scsi_opcode_sa_name
Date: Tue, 30 Sep 2014 07:50:40 +0200
Message-ID: <542A44B0.5000907@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de> <1411991947-130166-14-git-send-email-hare@suse.de> <5429B320.2090003@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaI3Fun (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 01:50:43 -0400
In-Reply-To: <5429B320.2090003@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>

On 09/29/2014 09:29 PM, Douglas Gilbert wrote:
> On 14-09-29 07:58 AM, Hannes Reinecke wrote:
>> Implement a lookup array for SERVICE ACTION commands instead
>> of hardcoding it in a large switch statement.
>>
>> Reviewed-by: Christoph Hellwig <hch@infradead.org>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/constants.c | 132
>> +++++++++++++++++++----------------------------
>>   1 file changed, 54 insertions(+), 78 deletions(-)
>>
>> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
>> index 6e16b19..b9eb6a1 100644
>> --- a/drivers/scsi/constants.c
>> +++ b/drivers/scsi/constants.c
>> @@ -244,102 +244,77 @@ static const struct value_name_pair
>> variable_length_arr[] =3D {
>>   };
>>   #define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
>>
>> -static const char * get_sa_name(const struct value_name_pair * arr,
>> -                    int arr_sz, int service_action)
>> +struct sa_name_list {
>> +    int cmd;
>> +    const struct value_name_pair *arr;
>> +    int arr_sz;
>> +};
>> +
>> +static struct sa_name_list sa_names_arr[] =3D {
>> +    {VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
>> +    {MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
>> +    {MAINTENANCE_OUT, maint_out_arr, MAINT_OUT_SZ},
>> +    {PERSISTENT_RESERVE_IN, pr_in_arr, PR_IN_SZ},
>> +    {PERSISTENT_RESERVE_OUT, pr_out_arr, PR_OUT_SZ},
>> +    {SERVICE_ACTION_IN_12, serv_in12_arr, SERV_IN12_SZ},
>> +    {SERVICE_ACTION_OUT_12, serv_out12_arr, SERV_OUT12_SZ},
>> +    {SERVICE_ACTION_BIDIRECTIONAL, serv_bidi_arr, SERV_BIDI_SZ},
>> +    {SERVICE_ACTION_IN_16, serv_in16_arr, SERV_IN16_SZ},
>> +    {SERVICE_ACTION_OUT_16, serv_out16_arr, SERV_OUT16_SZ},
>> +    {THIRD_PARTY_COPY_IN, tpc_in_arr, TPC_IN_SZ},
>> +    {THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
>> +    {0, NULL, 0},
>> +};
>> +#define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
>
> Since you placed a terminating element on sa_names_arr[] then
> you don't need the SA_NAME_LIST_SZ define any more.
>
> The for loop can become:
>    for (sa_name_ptr =3D sa_names_arr; sa_name_ptr->arr; ++sa_name_ptr=
) {
> ...
>
Good point. Will be including this for the next round.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
