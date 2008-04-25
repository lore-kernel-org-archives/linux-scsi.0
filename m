From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/6] block: no need to initialize rq->cmd
	with blk_get_request
Date: Sat, 26 Apr 2008 03:35:11 +0900
Message-ID: <20080426033504U.tomof@acm.org>
References: <1209141901.3087.17.camel@localhost.localdomain>
	<20080426015440M.tomof@acm.org>
	<1209142784.3087.25.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1209142784.3087.25.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com, dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org, bharrosh@panasas.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 25 Apr 2008 11:59:44 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2008-04-26 at 01:54 +0900, FUJITA Tomonori wrote:
> > On Fri, 25 Apr 2008 11:45:01 -0500
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > On Sat, 2008-04-26 at 01:23 +0900, FUJITA Tomonori wrote:
> > > > blk_get_request initializes rq->cmd (rq_init does) so the users don't
> > > > need to do that.
> > > > 
> > > > The purpose of this patch is to remove sizeof(rq->cmd) and &rq->cmd,
> > > > as a preparation for large command support, which changes rq->cmd from
> > > > the static array to a pointer. sizeof(rq->cmd) will not make sense and
> > > > &rq->cmd won't work.
> > > > 
> > > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > Cc: Alasdair G Kergon <agk@redhat.com>
> > > > Cc: Jens Axboe <jens.axboe@oracle.com>
> > > > ---
> > > >  block/scsi_ioctl.c          |    3 ---
> > > >  drivers/block/pktcdvd.c     |    2 --
> > > >  drivers/cdrom/cdrom.c       |    1 -
> > > 
> > > These:
> > > 
> > > >  drivers/md/dm-emc.c         |    2 --
> > > >  drivers/md/dm-mpath-hp-sw.c |    1 -
> > > >  drivers/md/dm-mpath-rdac.c  |    1 -
> > > 
> > > Conflict with this set of patches:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-pending-2.6.git;a=summary
> > > 
> > > Which move the dm pieces to being request based.  The patch series
> > > hasn't had an ACK yet from Alasdair, but it would be nice if you could
> > > look it over and see if it needs the memsets pulling out.
> > 
> > Seems that it needs the memsets pulling out. For example,
> > 
> > [PATCH 2/7] scsi_dh: add lsi rdac device handler has:
> > 
> > +	memset(&rq->cmd, 0, BLK_MAX_CDB);
> > 
> > 
> > Do you want a patch against scsi-pending?
> 
> Yes please ...

You can apply this for scsi-pending now.

scsi_dh will not be merge for 2.6.26, the original patch needs to be
merged. If scsi_dh will, then we can drop the original patch since we
can live without the changes to scsi_ioctl.c, pktcdvd.c, and cdrom.c
(sizeof(rq->cmd) doesn't make sense but it doesn't hurt us).

==
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_dh: no need to initialize rq->cmd with blk_get_request

blk_get_request initializes rq->cmd (rq_init does) so the users don't
need to do that.

The purpose of this patch is to remove &rq->cmd, as a preparation for
large command support, which changes rq->cmd from the static array to
a pointer. &rq->cmd won't work.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/device_handler/scsi_dh_emc.c   |    1 -
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    1 -
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 71d20c8..df7992c 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -258,7 +258,6 @@ static struct request *get_req(struct scsi_device *sdev, int cmd)
 		return NULL;
 	}
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
 	rq->cmd[0] = cmd;
 	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index d1b66c3..7abea59 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -91,7 +91,6 @@ static int hp_sw_activate(struct scsi_device *sdev)
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
 	req->cmd_len = COMMAND_SIZE(START_STOP);
-	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = START_STOP;
 	req->cmd[4] = 1;	/* Start spin cycle */
 	req->timeout = HP_SW_TIMEOUT;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1bf9cf8..3af8fa9 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -214,7 +214,6 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	memset(&rq->cmd, 0, BLK_MAX_CDB);
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
-- 
1.5.4.2
