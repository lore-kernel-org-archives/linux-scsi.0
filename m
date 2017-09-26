From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/1] scsi: fc: check for rport presence in
 fc_block_scsi_eh
Date: Tue, 26 Sep 2017 11:09:13 +0200
Message-ID: <65ae4ea5-8892-38fa-4477-36c766d8fc13@linux.vnet.ibm.com>
References: <20170926065809.7980-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751840AbdIZJJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Sep 2017 05:09:22 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8Q99AJp040150
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2017 05:09:21 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2d7jaj6qhx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 26 Sep 2017 05:09:21 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 26 Sep 2017 10:09:19 +0100
In-Reply-To: <20170926065809.7980-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@lst.de>

On 09/26/2017 08:58 AM, Johannes Thumshirn wrote:
> Coverity-scan recently found a possible NULL pointer dereference in
> fc_block_scsi_eh() as starget_to_rport() either returns the rport for
> the startget or NULL.
> 
> While it is rather unlikely to have fc_block_scsi_eh() called without
> an rport associated it's a good idea to catch potential misuses of the
> API gracefully.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> ---
> 
> Changes since v1:
> - s/WARN_ON/WARN_ON_ONCE/ (Bart)
> 
> ---
>   drivers/scsi/scsi_transport_fc.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index ba9d70f8a6a1..38abff7b5dbc 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3328,6 +3328,9 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
>   {
>   	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
> 
> +	if (WARN_ON_ONCE(!rport))
> +		return 0;

Good idea.

However, return 0 or FAST_IO_FAIL?
I mean the callchains to this function (and of fc_block_rport()) react 
differently depending on the return value.
Returning 0 means that the rport left the blocked state, i.e. is usable 
for traffic again.
If there is no rport at all, I suppose one cannot use it for traffic.
If there is any I/O pending on this scope and we return 0, scsi_eh 
escalates; and if this happens for a host_reset we end up with offlined 
scsi_devices.
I wonder if returning FAST_IO_FAIL would be more appropriate here in 
this case, in order to have scsi_eh let the pending I/O bubble up for a 
timely path failover?

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
