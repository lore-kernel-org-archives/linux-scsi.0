From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Re: Patch to lsi rda  device handler
Date: Wed, 30 Jul 2008 08:04:26 +0900
Message-ID: <20080730080403Z.fujita.tomonori@lab.ntt.co.jp>
References: <00FE57DD11E3A94893D5BD54C3358BE884BE1F@AUSX3MPC128.aus.amer.dell.com>
	<1216333826.27507.272.camel@chandra-ubuntu>
	<1217364195.5911.59.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1217364195.5911.59.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Yanqing_Liu@Dell.com, Ahmad_Ali@Dell.com, Shyam_Iyer@Dell.com, Charles_Rose@Dell.com, Jacob_Cherian@Dell.com, mchristi@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 29 Jul 2008 13:43:15 -0700
Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> Hi Yanqing,
> 
> All the SCSI hardware handler patches are currently available in
> 2.6.27-rc1. If you could test it, that will be of great help.

(snip)

> > > The change is to zero out the area that the cmd pointer points to,
> > > instead of the pointer itself in the allocated request structure.
> > > 
> > > --- scsi_dh_rdac.c.orig 2008-07-17 01:53:10.000000000 -0400 
> > > +++ scsi_dh_rdac.c      2008-07-17 01:45:28.000000000 -0400 
> > > @@ -214,7 +214,7 @@ 
> > >                 return NULL; 
> > >         } 
> > >   
> > > -       memset(&rq->cmd, 0, BLK_MAX_CDB); 
> > > +       memset(rq->cmd, 0, BLK_MAX_CDB); 
> > >         rq->sense = h->sense; 
> > >         memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE); 
> > >         rq->sense_len = 0;

I've sent a patch to fix such bugs in scsi_dh twice:

http://marc.info/?l=linux-scsi&m=120914881720769&w=2
http://marc.info/?l=linux-scsi&m=121005693501288&w=2

rc1 looks fine but as I said twice, you don't need to initialize
rq->cmd. The block layer does.

Please apply.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi_dh: no need to initialize rq->cmd with blk_get_request

blk_get_request initializes rq->cmd (rq_init does) so the users don't
need to do that.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/device_handler/scsi_dh_emc.c   |    1 -
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    2 --
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    2 --
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index aa46b13..2b96865 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -278,7 +278,6 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 		return NULL;
 	}
 
-	memset(rq->cmd, 0, BLK_MAX_CDB);
 	rq->cmd_len = COMMAND_SIZE(cmd);
 	rq->cmd[0] = cmd;
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 9c7a1f8..ae576dc 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -114,7 +114,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
 	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
-	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = TEST_UNIT_READY;
 	req->timeout = HP_SW_TIMEOUT;
 	req->sense = h->sense;
@@ -207,7 +206,6 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_FAILFAST;
 	req->cmd_len = COMMAND_SIZE(START_STOP);
-	memset(req->cmd, 0, MAX_COMMAND_SIZE);
 	req->cmd[0] = START_STOP;
 	req->cmd[4] = 1;	/* Start spin cycle */
 	req->timeout = HP_SW_TIMEOUT;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b093a50..c93dbaf 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -225,8 +225,6 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 		return NULL;
 	}
 
-	memset(rq->cmd, 0, BLK_MAX_CDB);
-
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
 	rq->retries = RDAC_RETRIES;
-- 
1.5.5.GIT
