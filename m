From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 10/13] IB/iser: Support T10-PI operations
Date: Tue, 4 Mar 2014 18:16:36 +0200
Message-ID: <5315FC64.2020207@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-11-git-send-email-sagig@mellanox.com> <531408C8.10107@cs.wisc.edu> <53159F09.6050802@mellanox.com> <5315A3E4.508@dev.mellanox.co.il> <5315B83D.6060503@mellanox.com> <5315E6DD.4060909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5315E6DD.4060909-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 04/03/2014 16:44, Sagi Grimberg wrote:
>>> @@ -1707,10 +1707,17 @@ int iscsi_queuecommand(struct Scsi_Host 
>>> *host, struct scsi_cmnd *sc)
>>>                                 goto prepd_fault;
>>>                         }
>>>                 }
>>> -               if (session->tt->xmit_task(task)) {
>>> -                       session->cmdsn--;
>>> -                       reason = FAILURE_SESSION_NOT_READY;
>>> -                       goto prepd_reject;
>>> +
>>> +               reason = session->tt->xmit_task(task);
>>> +               if (reason) {
>>> +                       if (reason == -ENOMEM || reason == -EAGAIN) {
>>> +                               session->cmdsn--;
>>
>> I am pretty sure this has to be done anyway, no matter why the 
>> xmit_task callback failed
>
> Even if we abort? this just follows the same logic as 
> iscsi_prep_scsi_cmd_pdu error flow.

yes, take a 2nd look on iscsi_prep_scsi_cmd_pdu and you'll see that all 
the possible error cases take place **before** session->cmdsn is 
incremented
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
