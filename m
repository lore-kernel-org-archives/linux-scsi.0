From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RFC PATCH] lpfc: Add lockdep assertions
Date: Thu, 17 Dec 2015 08:19:38 +0100
Message-ID: <5672620A.4060104@sandisk.com>
References: <1448023037-43391-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448023037-43391-1-git-send-email-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, Dick Kennedy <dick.kennedy@avagotech.com>, James Smart <james.smart@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 01:37 PM, Johannes Thumshirn wrote:
> Several functions in lpfc have comments stating that the function must be
> called with the hbalock (or hostlock, or ringlock) held. Add
> lockdep_assert_held() annotations to these functions, so one can actually
> verify the locks are held.
>
> [ ... ]
>
> @@ -2647,6 +2675,7 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
>   {
>   	struct lpfc_iocbq *cmd_iocb = NULL;
>   	uint16_t iotag;
> +	lockdep_assert_held(&phba->hbalock);
>
>   	iotag = prspiocb->iocb.ulpIoTag;

(replying to an e-mail of one month ago)

Please leave a blank line after declarations. Checkpatch should have 
reported this. Anyway:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
