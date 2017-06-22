From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] qla2xxx: Protect access to qpair members with
 qpair->qp_lock
Date: Thu, 22 Jun 2017 16:23:20 +0200
Message-ID: <20170622142320.GP5670@linux-x5ow.site>
References: <20170622134325.26931-1-jthumshirn@suse.de>
 <dd855f97-49f3-17ef-1d3b-857effa50bc9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dd855f97-49f3-17ef-1d3b-857effa50bc9@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, qla2xxx-upstream@qlogic.com, Himanshu Madhani <himanshu.madhani@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 22, 2017 at 03:19:27PM +0100, John Garry wrote:
> On 22/06/2017 14:43, Johannes Thumshirn wrote:
> >In qla2xx_start_scsi_mq() and qla2xx_dif_start_scsi_mq() we grab the
> >qpair->qp_lock but do access members of the qpair before having the lock.
> >Re-order the locking sequence to have all read and write access to qpair
> >members under the qpair->qp_lock.
> >
> >Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> >---
> > drivers/scsi/qla2xxx/qla_iocb.c | 20 +++++++++++++-------
> > 1 file changed, 13 insertions(+), 7 deletions(-)
> >
> >diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> >index 8404f17f3c6c..425ca1646a9a 100644
> >--- a/drivers/scsi/qla2xxx/qla_iocb.c
> >+++ b/drivers/scsi/qla2xxx/qla_iocb.c
> >@@ -1770,10 +1770,6 @@ qla2xxx_start_scsi_mq(srb_t *sp)
> > 	struct qla_hw_data *ha = vha->hw;
> > 	struct qla_qpair *qpair = sp->qpair;
> >
> >-	/* Setup qpair pointers */
> >-	rsp = qpair->rsp;
> >-	req = qpair->req;
> 
> Can you check the call to qla2x00_marker() before the spinlock grab, which
> takes rsp and req as parameters?

Good catch, thanks.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
