From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] virtio_scsi: implement request batching
Date: Thu, 30 May 2019 10:28:32 -0700
Message-ID: <79490df1-0145-5b40-027a-7e8fb96854d4@acm.org>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-3-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-3-pbonzini@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 5/30/19 4:28 AM, Paolo Bonzini wrote:
> @@ -531,7 +547,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *shost,
>   		req_size = sizeof(cmd->req.cmd);
>   	}
>   
> -	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
> +	kick = (sc->flags & SCMD_LAST) != 0;
> +	ret = virtscsi_add_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd), kick);

Have you considered to have the SCSI core call commit_rqs() if bd->last 
is true? I think that would avoid that we need to introduce the 
SCMD_LAST flag and that would also avoid that every SCSI LLD that 
supports a commit_rqs callback has to introduce code to test the 
SCMD_LAST flag.

Thanks,

Bart.
