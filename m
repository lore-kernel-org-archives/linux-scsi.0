From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/qla2xxx: Honor max_data_sg_nents I/O transfer
 limit
Date: Wed, 09 Sep 2015 16:44:15 -0700
Message-ID: <1441842255.6836.13.camel@haakon3.risingtidesystems.com>
References: <1439455550-2626-1-git-send-email-nab@daterainc.com>
	 <alpine.LRH.2.00.1508171724150.19116@mvluser04.mv.qlogic.com>
	 <1440112633.14304.23.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1440112633.14304.23.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Arun Easi <arun.easi@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Craig Watson <craig.watson@vanguard-rugged.com>, Roland Dreier <roland@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Hi Arun & Co,

On Thu, 2015-08-20 at 16:17 -0700, Nicholas A. Bellinger wrote:
> On Wed, 2015-08-19 at 17:48 -0700, Arun Easi wrote:
> > Hi nab,
> > 
> > On Thu, 13 Aug 2015, 1:45am -0700, Nicholas A. Bellinger wrote:
> > 
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > >
> > > Hi Arun, Roland & Co,
> > >
> > > Based upon the feedback from last week, here is a proper
> > > patch for target-core to honor a fabric provided SGL limit
> > > using residual count plus underflow response bit.
> > >
> > > Everything appears to be working as expected with tcm-loop
> > > LUNs with basic I/O and sg_raw to test CDB underflow, but
> > > still needs to be verified on real qla2xxx hardware over
> > > the next days for v4.2.0 code.
> > >
> > > Please review + test.
> > 
> > Changes look good. I could not test the changes, though. I have requested 
> > internally to test this patch. Himanshu (copied) will get back with the 
> > test results (Thanks Himanshu).
> > 
> 
> Thanks for the update.  Btw, this patch has been pushed to
> refs/heads/queue, atop the other recent v4.2-rc fixes here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue
> 
> Just an FYI for Himanshu, for testing against Linux hosts that do honor
> EVPD block-limits, you'll want to include the following small hack to
> report a larger block-limits value so the new residual handling can
> actually get invoked.
> 
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index 01421e9..f02767b 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -523,6 +523,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
>         if (cmd->se_tfo->max_data_sg_nents) {
>                 mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
>                        dev->dev_attrib.block_size;
> +               mtl *= 2;
>         }
>         put_unaligned_be32(min_not_zero(mtl, dev->dev_attrib.hw_max_sectors), &buf[8]);
> 
> Also for testing, I'd recommend lowering tcm_qla2xxx's max_data_sg_nents
> to something arbitrarily small to exercise the new code.
> 
> Craig, have you had a chance to test the new logic on your setup with
> hosts that don't honor EVPD block-limits..?
> 

I've not seen any testing feedback on this patch over the last weeks
from Himanshu or Craig.

So barring any specific objections, I think it's safe enough to include
in the upcoming v4.3-rc1 PULL request, minus the stable CC'.

Himanshu + Craig, please let me know how your testing is going.

Based upon your feedback we can address any regressions post merge, and
subsequently get the patch (plus any other bugfixes) picked up for
stable code.

Thank you,

--nab
