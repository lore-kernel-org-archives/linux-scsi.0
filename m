From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] qla2xxx: avoid maybe_uninitialized warning
Date: Wed, 16 Mar 2016 16:11:51 +0100
Message-ID: <56E977B7.1030607@redhat.com>
References: <1458078051-529344-1-git-send-email-arnd@arndb.de>
 <56E975B8.6040807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56E975B8.6040807@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Alexei Potashnik <alexei@purestorage.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Swapnil Nagle <swapnil.nagle@purestorage.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 16.3.2016 16:03, Tomas Henzl wrote:
> On 15.3.2016 22:40, Arnd Bergmann wrote:
>> The qlt_check_reserve_free_req() function produces an incorrect warning
>> when CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
>>
>> drivers/scsi/qla2xxx/qla_target.c: In function 'qlt_check_reserve_free_req':
>> drivers/scsi/qla2xxx/qla_target.c:1887:3: error: 'cnt_in' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>    ql_dbg(ql_dbg_io, vha, 0x305a,
>>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>        "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
>>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>        vha->vp_idx, vha->req->ring_index,
>>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>        vha->req->cnt, req_cnt, cnt, cnt_in, vha->req->length);
>>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/qla2xxx/qla_target.c:1887:3: error: 'cnt' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>
>> The problem is that gcc fails to track the state of the condition across
>> an annotated branch.
>>
>> This slightly rearranges the code to move the second if() block
>> into the first one, to avoid the warning while retaining the
>> behavior of the code.
> When the first 'if' is true the vha->req->ring_index gets a new value 
> assigned - so it could be possible that the second 'if' wont be true any more.
> The code should not be merged into that single 'if', or am I missing something?

Oh, I haven't noticed that the second if actually remained in place
- please ignore my previous comments.


>
> tomash
>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/scsi/qla2xxx/qla_target.c | 16 +++++++++-------
>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
>> index 985231900aca..8a44d1541eb4 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -1881,15 +1881,17 @@ static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
>>  		else
>>  			vha->req->cnt = vha->req->length -
>>  			    (vha->req->ring_index - cnt);
>> -	}
>>  
>> -	if (unlikely(vha->req->cnt < (req_cnt + 2))) {
>> -		ql_dbg(ql_dbg_io, vha, 0x305a,
>> -		    "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
>> -		    vha->vp_idx, vha->req->ring_index,
>> -		    vha->req->cnt, req_cnt, cnt, cnt_in, vha->req->length);
>> -		return -EAGAIN;
>> +		if (unlikely(vha->req->cnt < (req_cnt + 2))) {
>> +			ql_dbg(ql_dbg_io, vha, 0x305a,
>> +			    "qla_target(%d): There is no room in the request ring: vha->req->ring_index=%d, vha->req->cnt=%d, req_cnt=%d Req-out=%d Req-in=%d Req-Length=%d\n",
>> +			    vha->vp_idx, vha->req->ring_index,
>> +			    vha->req->cnt, req_cnt, cnt, cnt_in,
>> +			    vha->req->length);
>> +			return -EAGAIN;
>> +		}
>>  	}
>> +
>>  	vha->req->cnt -= req_cnt;
>>  
>>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
