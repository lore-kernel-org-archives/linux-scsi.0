From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: ibmvscsi: Don't use rc uninitialized in
 ibmvscsi_do_work
Date: Mon, 3 Jun 2019 16:35:52 -0700
Message-ID: <3416c496-9f5d-ea3c-8df5-85227007d29d@linux.vnet.ibm.com>
References: <20190531185306.41290-1-natechancellor@gmail.com>
 <20190603221941.65432-1-natechancellor@gmail.com>
 <6fa1dd2e-676f-b12a-5bb6-e86f5c5628fa@linux.vnet.ibm.com>
 <8598d642-82e3-daad-a487-693208e13c90@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8598d642-82e3-daad-a487-693208e13c90@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Michael Ellerman <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org

On 06/03/2019 04:34 PM, Tyrel Datwyler wrote:
> On 06/03/2019 04:25 PM, Tyrel Datwyler wrote:
>> On 06/03/2019 03:19 PM, Nathan Chancellor wrote:
>>> clang warns:
>>>
>>> drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
>>> uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
>>>         case IBMVSCSI_HOST_ACTION_NONE:
>>>              ^~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/scsi/ibmvscsi/ibmvscsi.c:2151:6: note: uninitialized use occurs
>>> here
>>>         if (rc) {
>>>             ^~
>>>
>>> Initialize rc to zero in the case statements that clang mentions so that
>>> the atomic_set and dev_err statement don't trigger for them.
>>>
>>> Fixes: 035a3c4046b5 ("scsi: ibmvscsi: redo driver work thread to use enum action states")
>>> Link: https://github.com/ClangBuiltLinux/linux/issues/502
>>> Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
>>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>>
>> Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
>>
> 
> On second thought NACK. See my response to Michael earlier in the thread.
> 
> I think this is the better solution:
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 727c31dc11a0..c3cf05dd8733 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -2123,8 +2123,8 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data
> *hostdata)
> 
>         spin_lock_irqsave(hostdata->host->host_lock, flags);
>         switch (hostdata->action) {
> -       case IBMVSCSI_HOST_ACTION_NONE:
>         case IBMVSCSI_HOST_ACTION_UNBLOCK:
> +               rc = 0;
>                 break;
>         case IBMVSCSI_HOST_ACTION_RESET:
>                 spin_unlock_irqrestore(hostdata->host->host_lock, flags);
> @@ -2142,8 +2142,9 @@ static void ibmvscsi_do_work(struct ibmvscsi_host_data
> *hostdata)
>                 if (!rc)
>                         rc = ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0);
>                 break;
> +       case IBMVSCSI_HOST_ACTION_NONE:
>         default:
> -               break;

Need a spin_unlock_irqrestore() here before the return.

-Tyrel

> +               return;
>         }
> 
>         hostdata->action = IBMVSCSI_HOST_ACTION_NONE;
> 
