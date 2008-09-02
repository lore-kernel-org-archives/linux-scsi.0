From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 01/14] block: separate failfast into multiple bits.
Date: Tue, 02 Sep 2008 11:59:18 -0500
Message-ID: <48BD70E6.5020702@cs.wisc.edu>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>	 <1220371543-15099-2-git-send-email-andmike@linux.vnet.ibm.com> <da824cf30809020935k6a05df54yf0a2eda1ecc9e65e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33051 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYIBRFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 13:05:23 -0400
In-Reply-To: <da824cf30809020935k6a05df54yf0a2eda1ecc9e65e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>

Grant Grundler wrote:
> On Tue, Sep 2, 2008 at 9:05 AM, Mike Anderson
> <andmike@linux.vnet.ibm.com> wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> Multipath is best at handling transport errors. If it gets a device
>> error then there is not much the multipath layer can do. It will just
>> access the same device but from a different path.
>>
>> This patch breaks up failfast into device, transport and driver errors.
> 
> Is there any document that describes what those errors are for each
> class of transport?



Not yet. For SCSI I was still trying to classify the host byte errors, 
because drivers are using them differently. I had sent patches in the 
thread here
http://marc.info/?l=linux-scsi&m=121918956332584&w=2
  that just start syncing up the transport errors for SCSI by adding 
some new transport host byte errors and converting drivers and transport 
classes to them.



> 
> This great work though...I'm looking forward to a storage subsystem
> where each level
> can cooperate with the ones above it.
> 
>> The multipath layers (md and dm mutlipath) only ask the lower levels to
>> fast fail transport errors. The user of failfast, read ahead, will ask
>> to fast fail on all errors.
>>
>> Note that blk_noretry_request will return true if any failfast bit
>> is set. This allows drivers that do not support the multipath failfast
>> bits to continue to fail on any failfast error like before. Drivers
>> like scsi that are able to fail fast specific errors can check
>> for the specific fail fast type. In the next patch I will convert
>> scsi.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> Cc: Jens Axboe <jens.axboe@oracle.com>
>> Cc: Alasdair G Kergon <agk@redhat.com>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
>> ---
>>  block/blk-core.c                            |   11 +++++++++--
>>  drivers/md/dm-mpath.c                       |    2 +-
>>  drivers/md/multipath.c                      |    4 ++--
>>  drivers/s390/block/dasd_diag.c              |    2 +-
>>  drivers/s390/block/dasd_eckd.c              |    2 +-
>>  drivers/s390/block/dasd_fba.c               |    2 +-
>>  drivers/scsi/device_handler/scsi_dh_alua.c  |    3 ++-
>>  drivers/scsi/device_handler/scsi_dh_emc.c   |    3 ++-
>>  drivers/scsi/device_handler/scsi_dh_hp_sw.c |    6 ++++--
>>  drivers/scsi/device_handler/scsi_dh_rdac.c  |    3 ++-
>>  drivers/scsi/scsi_transport_spi.c           |    4 +++-
>>  include/linux/bio.h                         |   26 +++++++++++++++++---------
>>  include/linux/blkdev.h                      |   15 ++++++++++++---
>>  13 files changed, 57 insertions(+), 26 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 4889eb8..f3c29d0 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1073,8 +1073,15 @@ void init_request_from_bio(struct request *req, struct bio *bio)
>>        /*
>>         * inherit FAILFAST from bio (for read-ahead, and explicit FAILFAST)
>>         */
>> -       if (bio_rw_ahead(bio) || bio_failfast(bio))
>> -               req->cmd_flags |= REQ_FAILFAST;
>> +       if (bio_rw_ahead(bio))
>> +               req->cmd_flags |= (REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +                                  REQ_FAILFAST_DRIVER);
>> +       if (bio_failfast_dev(bio))
>> +               req->cmd_flags |= REQ_FAILFAST_DEV;
>> +       if (bio_failfast_transport(bio))
>> +               req->cmd_flags |= REQ_FAILFAST_TRANSPORT;
>> +       if (bio_failfast_driver(bio))
>> +               req->cmd_flags |= REQ_FAILFAST_DRIVER;
> 
> This is open source.
> Why can't something like this be done?
>     req->cmd_flags |= bio_failfast_flags(bio);


We used to do that when it was just 1 bit for failfast, and it kept 
getting messed up. I fixed it once before and Tomo or someone else had 
to fix it again later when it got messed up again, so I thought this is 
more clear and would prevent future screw ups.



> 
> I'm assuming the REQ_FAILFAST_* flags can be equated to the same bits
> in the bio layer.

> 
> 
>>        /*
>>         * REQ_BARRIER implies no merging, but lets make it explicit
>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>> index 71dd65a..b48e201 100644
>> --- a/drivers/md/dm-mpath.c
>> +++ b/drivers/md/dm-mpath.c
>> @@ -827,7 +827,7 @@ static int multipath_map(struct dm_target *ti, struct bio *bio,
>>        dm_bio_record(&mpio->details, bio);
>>
>>        map_context->ptr = mpio;
>> -       bio->bi_rw |= (1 << BIO_RW_FAILFAST);
>> +       bio->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
>>        r = map_io(m, bio, mpio, 0);
>>        if (r < 0 || r == DM_MAPIO_REQUEUE)
>>                mempool_free(mpio, m->mpio_pool);
>> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
>> index c4779cc..2426201 100644
>> --- a/drivers/md/multipath.c
>> +++ b/drivers/md/multipath.c
>> @@ -172,7 +172,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
>>        mp_bh->bio = *bio;
>>        mp_bh->bio.bi_sector += multipath->rdev->data_offset;
>>        mp_bh->bio.bi_bdev = multipath->rdev->bdev;
>> -       mp_bh->bio.bi_rw |= (1 << BIO_RW_FAILFAST);
>> +       mp_bh->bio.bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
>>        mp_bh->bio.bi_end_io = multipath_end_request;
>>        mp_bh->bio.bi_private = mp_bh;
>>        generic_make_request(&mp_bh->bio);
>> @@ -398,7 +398,7 @@ static void multipathd (mddev_t *mddev)
>>                        *bio = *(mp_bh->master_bio);
>>                        bio->bi_sector += conf->multipaths[mp_bh->path].rdev->data_offset;
>>                        bio->bi_bdev = conf->multipaths[mp_bh->path].rdev->bdev;
>> -                       bio->bi_rw |= (1 << BIO_RW_FAILFAST);
>> +                       bio->bi_rw |= (1 << BIO_RW_FAILFAST_TRANSPORT);
>>                        bio->bi_end_io = multipath_end_request;
>>                        bio->bi_private = mp_bh;
>>                        generic_make_request(bio);
>> diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
>> index 85fcb43..7844461 100644
>> --- a/drivers/s390/block/dasd_diag.c
>> +++ b/drivers/s390/block/dasd_diag.c
>> @@ -544,7 +544,7 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
>>        }
>>        cqr->retries = DIAG_MAX_RETRIES;
>>        cqr->buildclk = get_clock();
>> -       if (req->cmd_flags & REQ_FAILFAST)
>> +       if (blk_noretry_request(req))
>>                set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
>>        cqr->startdev = memdev;
>>        cqr->memdev = memdev;
>> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
>> index 773b3fe..b11a221 100644
>> --- a/drivers/s390/block/dasd_eckd.c
>> +++ b/drivers/s390/block/dasd_eckd.c
>> @@ -1683,7 +1683,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,
>>                        recid++;
>>                }
>>        }
>> -       if (req->cmd_flags & REQ_FAILFAST)
>> +       if (blk_noretry_request(req))
>>                set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
>>        cqr->startdev = startdev;
>>        cqr->memdev = startdev;
>> diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
>> index aa0c533..115e032 100644
>> --- a/drivers/s390/block/dasd_fba.c
>> +++ b/drivers/s390/block/dasd_fba.c
>> @@ -355,7 +355,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
>>                        recid++;
>>                }
>>        }
>> -       if (req->cmd_flags & REQ_FAILFAST)
>> +       if (blk_noretry_request(req))
>>                set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags);
>>        cqr->startdev = memdev;
>>        cqr->memdev = memdev;
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 994da56..6bc55a6 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -109,7 +109,8 @@ static struct request *get_alua_req(struct scsi_device *sdev,
>>        }
>>
>>        rq->cmd_type = REQ_TYPE_BLOCK_PC;
>> -       rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
>> +       rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +                        REQ_FAILFAST_DRIVER | REQ_NOMERGE;
>>        rq->retries = ALUA_FAILOVER_RETRIES;
>>        rq->timeout = ALUA_FAILOVER_TIMEOUT;
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
>> index b9d23e9..64a56e5 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
>> @@ -304,7 +304,8 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
>>
>>        rq->cmd[4] = len;
>>        rq->cmd_type = REQ_TYPE_BLOCK_PC;
>> -       rq->cmd_flags |= REQ_FAILFAST;
>> +       rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +                        REQ_FAILFAST_DRIVER;
>>        rq->timeout = CLARIION_TIMEOUT;
>>        rq->retries = CLARIION_RETRIES;
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
>> index a6a4ef3..08ba1ce 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
>> @@ -112,7 +112,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>>                return SCSI_DH_RES_TEMP_UNAVAIL;
>>
>>        req->cmd_type = REQ_TYPE_BLOCK_PC;
>> -       req->cmd_flags |= REQ_FAILFAST;
>> +       req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +                         REQ_FAILFAST_DRIVER;
>>        req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
>>        memset(req->cmd, 0, MAX_COMMAND_SIZE);
>>        req->cmd[0] = TEST_UNIT_READY;
>> @@ -205,7 +206,8 @@ static int hp_sw_start_stop(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>>                return SCSI_DH_RES_TEMP_UNAVAIL;
>>
>>        req->cmd_type = REQ_TYPE_BLOCK_PC;
>> -       req->cmd_flags |= REQ_FAILFAST;
>> +       req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +                         REQ_FAILFAST_DRIVER;
>>        req->cmd_len = COMMAND_SIZE(START_STOP);
>>        memset(req->cmd, 0, MAX_COMMAND_SIZE);
>>        req->cmd[0] = START_STOP;
>> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
>> index 2dee69d..c504afe 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
>> @@ -228,7 +228,8 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
>>        memset(rq->cmd, 0, BLK_MAX_CDB);
>>
>>        rq->cmd_type = REQ_TYPE_BLOCK_PC;
>> -       rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
>> +       rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
>> +                        REQ_FAILFAST_DRIVER;
> 
> Was dropping the REQ_NOMERGE intentional?

Yes, and no.

> Everywhere else it seems REQ_FAILFAST was simply replaced with the
> three new flag bits.

We do not need it, because blk_execute_rq_nowait sets it for us, so I 
dropped it when I first made the patches a long time ago. It was a 
different patch for a while, but I think it got merged with this one a 
while back by accident (the alua NOMERGE setting did not get dropped 
when it could have, because it was added to scsi-misc at a different time).

Thanks for the review.
