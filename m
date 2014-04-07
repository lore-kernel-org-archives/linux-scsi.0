From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/9] target/sbc: Add sbc_dif_write_insert software
 emulation
Date: Mon, 07 Apr 2014 01:07:35 -0700
Message-ID: <1396858055.19888.5.camel@haakon3.risingtidesystems.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
	 <1396517753-23546-7-git-send-email-nab@daterainc.com>
	 <5342558A.9070205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5342558A.9070205@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2014-04-07 at 10:36 +0300, Sagi Grimberg wrote:
> On 4/3/2014 12:35 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds WRITE_INSERT emulation within target-core
> > using TYPE1 / TYPE3 PI modes.
> >
> > This is useful in order for existing legacy fabrics that do not
> > support protection offloads to interact with backend devices that
> > currently have T10 PI enabled.
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Cc: Quinn Tran <quinn.tran@qlogic.com>
> > Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_sbc.c     |   44 ++++++++++++++++++++++++++++++++++
> >   include/target/target_core_backend.h |    1 +
> >   2 files changed, 45 insertions(+)
> >
> > diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> > index f2d73dd..97b207d 100644
> > --- a/drivers/target/target_core_sbc.c
> > +++ b/drivers/target/target_core_sbc.c
> > @@ -1096,6 +1096,50 @@ err:
> >   }
> >   EXPORT_SYMBOL(sbc_execute_unmap);
> >   
> > +void
> > +sbc_dif_write_insert(struct se_cmd *cmd)
> 
> Better to call it sbc_dif_generate()

Changed to sbc_dif_generate().

> 
> > +{
> > +	struct se_device *dev = cmd->se_dev;
> > +	struct se_dif_v1_tuple *sdt;
> > +	struct scatterlist *dsg, *psg = cmd->t_prot_sg;
> > +	sector_t sector = cmd->t_task_lba;
> > +	void *daddr, *paddr;
> > +	int i, j, offset = 0;
> > +
> > +	for_each_sg(cmd->t_data_sg, dsg, cmd->t_data_nents, i) {
> > +		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
> > +		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
> > +
> > +		for (j = 0; j < dsg->length; j += dev->dev_attrib.block_size) {
> > +
> > +			if (offset >= psg->length) {
> > +				kunmap_atomic(paddr);
> > +				psg = sg_next(psg);
> > +				paddr = kmap_atomic(sg_page(psg)) + psg->offset;
> > +				offset = 0;
> > +			}
> > +
> > +			sdt = paddr + offset;
> > +			sdt->guard_tag = cpu_to_be16(crc_t10dif(daddr + j,
> > +						dev->dev_attrib.block_size));
> > +			if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
> > +				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
> > +			sdt->app_tag = 0;
> > +
> > +			pr_debug("DIF WRITE INSERT sector: %llu guard_tag: 0x%04x"
> > +				 " app_tag: 0x%04x ref_tag: %u\n",
> > +				 (unsigned long long)sector, sdt->guard_tag,
> > +				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
> > +
> > +			sector++;
> > +			offset += sizeof(struct se_dif_v1_tuple);
> > +		}
> > +
> > +		kunmap_atomic(paddr);
> > +		kunmap_atomic(daddr);
> > +	}
> > +}
> 
> Seems like a substantial code duplication here, can't you reuse the code 
> from verify?
> Maybe use this function also from verify (call generate() and then do 
> compare to t_prot_sg).

Yeah, there are a few differences between the two cases, and I stopped
short of merging them together for the moment.

Should be a pretty straight-forward post -rc1 change to make this into
common code.

--nab
