From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/2] Documentation/scsi: update scsi_eh.txt about
 ->host_failed
Date: Thu, 02 Jun 2016 09:59:52 -0400
Message-ID: <1464875992.11969.19.camel@linux.vnet.ibm.com>
References: <1464856958-30647-1-git-send-email-fangwei1@huawei.com>
	 <1464856958-30647-2-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1464856958-30647-2-git-send-email-fangwei1@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, tj@kernel.org, martin.petersen@oracle.com, corbet@lwn.net
Cc: hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2016-06-02 at 16:42 +0800, Wei Fang wrote:
> Update the new rules of ->host_failed.
> 
> Signed-off-by: Wei Fang <fangwei1@huawei.com>

Changes look fine, but I was wondering if we could also add a note
about the new concurrency rules:

> ---
>  Documentation/scsi/scsi_eh.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/scsi/scsi_eh.txt
> b/Documentation/scsi/scsi_eh.txt
> index 8638f61..9702c78 100644
> --- a/Documentation/scsi/scsi_eh.txt
> +++ b/Documentation/scsi/scsi_eh.txt
> @@ -263,7 +263,6 @@ scmd->allowed.
>  
>   3. scmd recovered
>      ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
> -	- shost->host_failed--
>  	- clear scmd->eh_eflags
>  	- scsi_setup_cmd_retry()
>  	- move from local eh_work_q to local eh_done_q

+	CONCURRENCY: at most one thread per separate eh_work_q to
+                    keep queue manipulation lockless

And the same addition in

   4. EH Completes

Probably

    ACTION: scsi_eh_flush_done_q() retries scmds or notifies upper
	    layer of failure. May be called concurrently but must have
            a no more than one thread per eh_work_q to manipulate the
            queue locklessly

> @@ -276,6 +275,7 @@ scmd->allowed.
>  	- if retry is necessary, scmd is requeued using
>            scsi_queue_insert()
>  	- otherwise, scsi_finish_command() is invoked for scmd
> +	- zero shost->host_failed
>      LOCKING: queue or finish function performs appropriate locking
>  
>  

