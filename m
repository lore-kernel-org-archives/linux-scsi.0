From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: libiscsi: fix shifting of DID_REQUEUE host byte
Date: Mon, 9 Oct 2017 14:35:06 +0200
Message-ID: <9105c7ef-0255-520c-3c90-e52a16fa5509@linux.vnet.ibm.com>
References: <20171009113319.9505-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751184AbdJIMfQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2017 08:35:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v99CYGBU061933
        for <linux-scsi@vger.kernel.org>; Mon, 9 Oct 2017 08:35:16 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dg3jd8rdd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Oct 2017 08:35:15 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Mon, 9 Oct 2017 13:35:11 +0100
In-Reply-To: <20171009113319.9505-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Chris Leech <cleech@redhat.com>

Use wrapper functions to advertize their use in an attempt to avoid 
wrong shifting in the future?

On 10/09/2017 01:33 PM, Johannes Thumshirn wrote:
> The SCSI host byte should be shifted left by 16 in order to have
> scsi_decide_disposition() do the right thing (.i.e. requeue the command).
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 661134ad3765 ("[SCSI] libiscsi, bnx2i: make bound ep check common")
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
> Cc: Chris Leech <cleech@redhat.com>
> ---
>   drivers/scsi/libiscsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index bd4605a34f54..9cba4913b43c 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1728,7 +1728,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
> 
>   	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
>   		reason = FAILURE_SESSION_IN_RECOVERY;
> -		sc->result = DID_REQUEUE;
> +		sc->result = DID_REQUEUE << 16;

not sure if this really wants to reset the other parts of result, but if 
so (and they are not 0 already anyway), preceed the set_host_byte() by:
		sc->result = 0;

		set_host_byte(sc, DID_REQUEUE);

>   		goto fault;
>   	}
> 

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
