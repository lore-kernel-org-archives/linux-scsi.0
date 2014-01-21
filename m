From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/17] target/iblock: Add blk_integrity + BIP
 passthrough support
Date: Tue, 21 Jan 2014 14:20:17 -0800
Message-ID: <1390342817.5567.778.camel@haakon3.risingtidesystems.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	 <1390099480-29013-12-git-send-email-nab@daterainc.com>
	 <52DBC32C.4060505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52DBC32C.4060505@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-01-19 at 14:21 +0200, Sagi Grimberg wrote:
> On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds blk_integrity passthrough support for block_device
> > backends using IBLOCK.
> 
> Nice!
> 
> > This includes iblock_alloc_bip() + setup of bio_integrity_payload
> > information that attaches to the leading struct bio once bio_list
> > is populated during fast-path iblock_execute_rw() I/O dispatch.
> >
> > It also updates setup in iblock_configure_device() to detect modes
> > of protection + se dev->dev_attrib.pi_prot_type accordingly, along
> > with creating required bio_set integrity mempools.
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/Kconfig              |    1 +
> >   drivers/target/target_core_iblock.c |   91 ++++++++++++++++++++++++++++++++++-
> >   2 files changed, 90 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
> > index 50aad2e..dc2d84a 100644
> > --- a/drivers/target/Kconfig
> > +++ b/drivers/target/Kconfig
> > @@ -14,6 +14,7 @@ if TARGET_CORE
> >   
> >   config TCM_IBLOCK
> >   	tristate "TCM/IBLOCK Subsystem Plugin for Linux/BLOCK"
> > +	select BLK_DEV_INTEGRITY
> >   	help
> >   	Say Y here to enable the TCM/IBLOCK subsystem plugin for non-buffered
> >   	access to Linux/Block devices using BIO
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> > index 15d9121..293d9b0 100644
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -91,6 +91,7 @@ static int iblock_configure_device(struct se_device *dev)
> >   	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
> >   	struct request_queue *q;
> >   	struct block_device *bd = NULL;
> > +	struct blk_integrity *bi;
> >   	fmode_t mode;
> >   	int ret = -ENOMEM;
> >   
> > @@ -155,8 +156,40 @@ static int iblock_configure_device(struct se_device *dev)
> >   	if (blk_queue_nonrot(q))
> >   		dev->dev_attrib.is_nonrot = 1;
> >   
> > +	bi = bdev_get_integrity(bd);
> > +	if (bi) {
> > +		struct bio_set *bs = ib_dev->ibd_bio_set;
> > +
> > +		if (!strcmp(bi->name, "T10-DIF-TYPE3-IP") ||
> > +		    !strcmp(bi->name, "T10-DIF-TYPE1-IP")) {
> > +			pr_err("IBLOCK export of blk_integrity: %s not"
> > +			       " supported\n", bi->name);
> > +			ret = -ENOSYS;
> > +			goto out_blkdev_put;
> > +		}
> 
> Please remind me why we ignore IP-CSUM guard type again?
> MKP, will this be irrelevant for the initiator as well? if so, I don't 
> see a reason to expose this in RDMA verbs.

My understanding is that this was used for pre-production prototyping,
and is not supported by any real backend storage hardware.

--nab
