From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 10/13] IB/iser: Support T10-PI operations
Date: Tue, 4 Mar 2014 11:38:17 +0200
Message-ID: <53159F09.6050802@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-11-git-send-email-sagig@mellanox.com> <531408C8.10107@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <531408C8.10107-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 03/03/2014 06:44, Mike Christie wrote:
> The xmit_task callout does handle failures like EINVAL. If the above map
> calls fail then you would get infinite retries. You would currently want
> to do the mapping in the init_task callout instead.
>
> If it makes it easier on the driver implementation then it is ok to
> modify the xmit_task callers so that they handle multiple error codes
> for drivers like iser that have the xmit_task callout called from
> iscsi_queuecommand.

Mike,

After looking on the code with Sagi,  it seems to us that the correct 
way to go here, would be to enhance in iscsi_queuecommand the processing 
of the result returned by session->tt->xmit_task(task) to behave in a 
similar manner to how the return value of iscsi_prep_scsi_cmd_pdu() is 
treated. E.g for errors such as ENOMEM and EGAIN take the "reject" flow 
which would cause the SCSI midlayer to retry the command and for other 
return values go to the "fault" flow which will cause the ML to abort 
the command.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
