From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: remove incorrect byte swap
Date: Fri, 30 Jun 2017 09:41:57 -0700
Message-ID: <1498840917.8086.3.camel@linux.vnet.ibm.com>
References: <20170630161056.30630-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751918AbdF3Qmo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 12:42:44 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5UGgaE7100171
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 12:42:43 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bdqvsedsa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 12:42:40 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Fri, 30 Jun 2017 10:42:04 -0600
In-Reply-To: <20170630161056.30630-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, qla2xxx-upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, Darren Trapp <darren.trapp@cavium.com>, Giridhar Malavali <giridhar.malavali@cavium.com>, Duane Grigsby <duane.grigsby@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2017-06-30 at 18:10 +0200, Arnd Bergmann wrote:
> cont_pkt->entry_type is an 8-bit field, so doing a 32-bit byteswap
> on it will store incorrect data:
> 
> drivers/scsi/qla2xxx/qla_nvme.c: In function 'qla2x00_start_nvme_mq':
> include/uapi/linux/byteorder/big_endian.h:32:26: error: large integer
> implicitly truncated to unsigned type [-Werror=overflow]
> drivers/scsi/qla2xxx/qla_nvme.c:444:27: note: in expansion of macro
> 'cpu_to_le32'
>     cont_pkt->entry_type = cpu_to_le32(CONTINUE_A64_TYPE);
> 
> This removes the erroneous cpu_to_le32().
> 
> Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization
> and transport registration")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c
> b/drivers/scsi/qla2xxx/qla_nvme.c
> index 1da8fa8f641d..14e25e32e622 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -441,7 +441,7 @@ static int qla2x00_start_nvme_mq(srb_t *sp)
>  				req->ring_ptr++;
>  			}
>  			cont_pkt = (cont_a64_entry_t *)req-
> >ring_ptr;
> -			cont_pkt->entry_type =
> cpu_to_le32(CONTINUE_A64_TYPE);
> +			cont_pkt->entry_type = CONTINUE_A64_TYPE;
> 

We already have a patch proposed for this, but I think it may be wrong
(it's the same as yours, so yours may be wrong too) see the handling in
qla_iocb.c

James
