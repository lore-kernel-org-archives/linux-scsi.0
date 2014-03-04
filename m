From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 10/13] IB/iser: Support T10-PI operations
Date: Tue, 4 Mar 2014 13:25:49 +0200
Message-ID: <5315B83D.6060503@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-11-git-send-email-sagig@mellanox.com> <531408C8.10107@cs.wisc.edu> <53159F09.6050802@mellanox.com> <5315A3E4.508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5315A3E4.508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 04/03/2014 11:59, Sagi Grimberg wrote:
> On 3/4/2014 11:38 AM, Or Gerlitz wrote:
>> On 03/03/2014 06:44, Mike Christie wrote:
>>> The xmit_task callout does handle failures like EINVAL. If the above 
>>> map
>>> calls fail then you would get infinite retries. You would currently 
>>> want
>>> to do the mapping in the init_task callout instead.
>>>
>>> If it makes it easier on the driver implementation then it is ok to
>>> modify the xmit_task callers so that they handle multiple error codes
>>> for drivers like iser that have the xmit_task callout called from
>>> iscsi_queuecommand.
>>
>> Mike,
>>
>> After looking on the code with Sagi,  it seems to us that the correct 
>> way to go here, would be to enhance in iscsi_queuecommand the 
>> processing of the result returned by session->tt->xmit_task(task) to 
>> behave in a similar manner to how the return value of 
>> iscsi_prep_scsi_cmd_pdu() is treated. E.g for errors such as ENOMEM 
>> and EGAIN take the "reject" flow which would cause the SCSI midlayer 
>> to retry the command and for other return values go to the "fault" 
>> flow which will cause the ML to abort the command.
>>
>> Or.
>>
>
> Yes, we were thinking about the following:
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1707,10 +1707,17 @@ int iscsi_queuecommand(struct Scsi_Host *host, 
> struct scsi_cmnd *sc)
>                                 goto prepd_fault;
>                         }
>                 }
> -               if (session->tt->xmit_task(task)) {
> -                       session->cmdsn--;
> -                       reason = FAILURE_SESSION_NOT_READY;
> -                       goto prepd_reject;
> +
> +               reason = session->tt->xmit_task(task);
> +               if (reason) {
> +                       if (reason == -ENOMEM || reason == -EAGAIN) {
> +                               session->cmdsn--;

I am pretty sure this has to be done anyway, no matter why the xmit_task 
callback failed

> + reason = FAILURE_SESSION_NOT_READY;
> +                               goto prepd_reject;
> +                       } else {
> +                               sc->result = DID_ABORT << 16;
> +                               goto prepd_fault;
> +                       }
>                 }
>         } else {
>                 list_add_tail(&task->running, &conn->cmdqueue);
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
