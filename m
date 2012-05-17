From: mengcong <mc@linux.vnet.ibm.com>
Subject: Re: [PATCH] target: Handle ATA_PASS_THROUGH_16 passthrough
Date: Thu, 17 May 2012 14:22:30 +0800
Message-ID: <1337235750.18244.16.camel@mengcong>
References: <1337146409.18429.11.camel@mengcong>
	 <1337211709.32217.100.camel@haakon2.linux-iscsi.org>
Reply-To: mc@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1337211709.32217.100.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-16 at 16:41 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2012-05-16 at 13:33 +0800, mengcong wrote:
> > The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
> > with a SATA CD-ROM. This patch adds support to it so that PSCSI 
> > CD-ROM passthrough works with the cdrecord.
> > 
> > Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> > ---
> >  drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
> >  include/scsi/scsi.h                    |    1 +
> >  2 files changed, 31 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 2d75c29..41439b3 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -2926,6 +2926,36 @@ static int transport_generic_cmd_sequencer(
> >  		size = (cdb[7] << 8) | cdb[8];
> >  		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
> >  		break;
> > +	case ATA_PASS_THROUGH_16:
> > +		// T_LENGTH
> > +		switch (cdb[2] & 0x3) {
> > +		case 0x0:
> > +			sectors = 0;
> > +			break;
> > +		case 0x1:
> > +			sectors = (((cdb[1] & 0x1) ? cdb[3] : 0) << 8) | cdb[4];
> > +			break;
> > +		case 0x2:
> > +			sectors = (((cdb[1] & 0x1) ? cdb[5] : 0) << 8) | cdb[6];
> > +			break;
> > +		case 0x3:
> > +			pr_err("T_LENGTH=0x3 not supported\n");
> > +			goto out_invalid_cdb_field;
> > +			break;
> > +		}
> > +		
> > +		// BYTE_BLOCK
> > +		if (cdb[2] & 0x4) {
> > +			// BLOCK
> > +			// T_TYPE: 512 or sector
> > +			size = sectors * ((cdb[2] & 0x10) ? 
> > +				dev->se_sub_dev->se_dev_attrib.block_size : 512);
> > +		} else {
> > +			// BYTE
> > +			size = sectors;
> > +		}
> > +		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
> 
> Mmmm, I think using SCF_SCSI_CONTROL_SG_IO_CDB here for all ATA
> passthrough cases should be OK with pSCSI, but you'll want to fail this
> type of cdb when if (!passthrough) for non pSCSI type devices to be safe
> with virtual backends..


(passthrough) has made sure the backend is non-virtual already. 

As I doesn't set cmd->execute_task and SCF_SCSI_DATA_SG_IO_CDB flag, so
the below piece of code should guarantee that my patch only works with
pSCSI, at least, currently. Is it right?

---
passthrough =                                                          
        (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV);
...

if (!(passthrough || cmd->execute_task ||           
     (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)))
        goto out_unsupported_cdb;                   
---
> 
> Also just an FYI, checkpatch.pl will complain here using '//' style
> comments, so you'll want to always use '/* ... */' style comments when
> submitting a target patch.
Sure, I will change it. 

Thanks.
mc

> 
> So please go ahead and fix up these two bits + use ATA_16 following
> jejb's comment, and I'm fine with including your v2 into the for-3.5
> target queue..
> 
> Thanks!
> 
> --nab
> 
