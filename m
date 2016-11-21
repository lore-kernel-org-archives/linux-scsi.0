From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND v4 02/15] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Mon, 21 Nov 2016 11:14:18 -0800
Message-ID: <ab8ba289-f102-dee1-9c04-44849f867c12@linux.vnet.ibm.com>
References: <cover.1479374719.git.jthumshirn@suse.de>
 <70cda0c20ecedf82323ff96e62ed6250a4cb575d.1479374719.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58353 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754726AbcKUTO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 14:14:29 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uALJE8ax126796
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 14:14:28 -0500
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26v5j4mauv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 14:14:28 -0500
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Mon, 21 Nov 2016 12:14:28 -0700
In-Reply-To: <70cda0c20ecedf82323ff96e62ed6250a4cb575d.1479374719.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>, Dick Kennedy <dick.kennedy@avagotech.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel@open-fcoe.org>, Christoph Hellwig <hch@infradead.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, James Smart <james.smart@avagotech.com>, Paul Mackerras <paulus@samba.org>, Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, Johannes Thumshirn <jth@kernel.>

On 11/17/2016 07:09 AM, Johannes Thumshirn wrote:
> Don't use fc_bsg_job::request and fc_bsg_job::reply directly, but use
> helper variables bsg_request and bsg_reply. This will be helpfull  when
> transitioning to bsg-lib.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/s390/scsi/zfcp_fc.c      |   9 +-
>  drivers/scsi/bfa/bfad_bsg.c      |  40 +++---
>  drivers/scsi/ibmvscsi/ibmvfc.c   |  22 ++--
>  drivers/scsi/libfc/fc_lport.c    |  23 ++--
>  drivers/scsi/lpfc/lpfc_bsg.c     | 199 ++++++++++++++++++-----------
>  drivers/scsi/qla2xxx/qla_bsg.c   | 264 ++++++++++++++++++++++-----------------
>  drivers/scsi/qla2xxx/qla_iocb.c  |   5 +-
>  drivers/scsi/qla2xxx/qla_isr.c   |  46 ++++---
>  drivers/scsi/qla2xxx/qla_mr.c    |  10 +-
>  drivers/scsi/scsi_transport_fc.c |  55 ++++----
>  10 files changed, 398 insertions(+), 275 deletions(-)

For ibmvfc portion...

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

