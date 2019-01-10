From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 09/41] scsi: bfa: bfa_fcpim: Mark expected switch
 fall-throughs
Date: Thu, 10 Jan 2019 14:12:32 -0600
Message-ID: <c6dca956-619a-1f88-8e28-65304ed63319@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <8f042a78366807fe4cf3c1f7157dc80f1dd49219.1543374820.git.gustavo@embeddedor.com>
 <8d5684c5-7b09-3e4a-d0ad-a024e3d06d05@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8d5684c5-7b09-3e4a-d0ad-a024e3d06d05@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 12/19/18 9:38 AM, Gustavo A. R. Silva wrote:
> Hi,
> 
> Friendly ping:
> 
> Who can ack or review this patch, please?
> 
> Thanks
> -- 
> Gustavo
> 
> On 11/27/18 10:27 PM, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>> where we are expecting to fall through.
>>
>> Notice that I replaced "Fall through !!!" with a "fall through"
>> annotation, which is what GCC is expecting to find.
>>
>> Addresses-Coverity-ID: 114971 ("Missing break in switch")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/bfa/bfa_fcpim.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
>> index 2c85f5b1f9c1..7e996bcf026c 100644
>> --- a/drivers/scsi/bfa/bfa_fcpim.c
>> +++ b/drivers/scsi/bfa/bfa_fcpim.c
>> @@ -2586,6 +2586,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
>>       case FCP_IODIR_RW:
>>           bfa_stats(itnim, input_reqs);
>>           bfa_stats(itnim, output_reqs);
>> +        /* fall through */
>>       default:
>>           bfi_h2i_set(m->mh, BFI_MC_IOIM_IO, 0, bfa_fn_lpu(ioim->bfa));
>>       }
>> @@ -2820,6 +2821,7 @@ bfa_ioim_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
>>       case BFI_IOIM_STS_TIMEDOUT:
>>           bfa_stats(ioim->itnim, iocomp_timedout);
>> +        /* fall through */
>>       case BFI_IOIM_STS_ABORTED:
>>           rsp->io_status = BFI_IOIM_STS_ABORTED;
>>           bfa_stats(ioim->itnim, iocomp_aborted);
>> @@ -3215,9 +3217,7 @@ bfa_tskim_sm_cleanup_qfull(struct bfa_tskim_s *tskim,
>>       switch (event) {
>>       case BFA_TSKIM_SM_DONE:
>>           bfa_reqq_wcancel(&tskim->reqq_wait);
>> -        /*
>> -         * Fall through !!!
>> -         */
>> +        /* fall through */
>>       case BFA_TSKIM_SM_QRESUME:
>>           bfa_sm_set_state(tskim, bfa_tskim_sm_cleanup);
>>           bfa_tskim_send_abort(tskim);
>>
