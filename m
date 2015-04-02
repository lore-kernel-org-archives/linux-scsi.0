From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 02/15] target: Add protected fabric + unprotected
 device support
Date: Wed, 01 Apr 2015 21:40:02 -0700
Message-ID: <1427949602.9176.253.camel@haakon3.risingtidesystems.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	 <1427686104-14231-3-git-send-email-nab@daterainc.com>
	 <55190088.6040301@dev.mellanox.co.il>
	 <1427867366.9176.196.camel@haakon3.risingtidesystems.com>
	 <551BB4B8.8050603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <551BB4B8.8050603@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-04-01 at 12:04 +0300, Sagi Grimberg wrote:
> On 4/1/2015 8:49 AM, Nicholas A. Bellinger wrote:
> > On Mon, 2015-03-30 at 10:51 +0300, Sagi Grimberg wrote:
> >> On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> >>> From: Nicholas Bellinger <nab@linux-iscsi.org>
> >>>
> >>> This patch adds a new target_core_fabric_ops callback for allowing fabric
> >>> drivers to expose a TPG attribute for signaling when a T10-PI protected
> >>> fabric wants to function with an un-protected device without T10-PI.
> >>>
> >>> This specifically is to allow LIO to perform WRITE_STRIP + READ_INSERT
> >>> operations when functioning with non T10-PI enabled devices, seperate
> >>> from any available hw offloads the fabric supports.
> >>>
> >>> This is done using a new se_sess->sess_prot_type that is set at fabric
> >>> session creation time based upon the TPG attribute.  It currently cannot
> >>> be changed for individual sessions after initial creation.
> >>>
> >>> Also, update existing target_core_sbc.c code to honor sess_prot_type when
> >>> setting up cmd->prot_op + cmd->prot_type assignments.
> >>>
> >>> Cc: Martin Petersen <martin.petersen@oracle.com>
> >>> Cc: Sagi Grimberg <sagig@mellanox.com>
> >>> Cc: Christoph Hellwig <hch@lst.de>
> >>> Cc: Doug Gilbert <dgilbert@interlog.com>
> >>> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> >>> ---
> >>>    drivers/target/target_core_sbc.c       | 44 +++++++++++++++++++++++++---------
> >>>    drivers/target/target_core_transport.c |  8 +++++++
> >>>    include/target/target_core_base.h      |  1 +
> >>>    include/target/target_core_fabric.h    |  8 +++++++
> >>>    4 files changed, 50 insertions(+), 11 deletions(-)
> >>>
> >>> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> >>> index 95a7a74..5b3564a 100644
> >>> --- a/drivers/target/target_core_sbc.c
> >>> +++ b/drivers/target/target_core_sbc.c
> >>> @@ -581,12 +581,13 @@ sbc_compare_and_write(struct se_cmd *cmd)
> >>>    }
> >>>
> >>>    static int
> >>> -sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
> >>> +sbc_set_prot_op_checks(u8 protect, bool fabric_prot, enum target_prot_type prot_type,
> >>>    		       bool is_write, struct se_cmd *cmd)
> >>>    {
> >>>    	if (is_write) {
> >>> -		cmd->prot_op = protect ? TARGET_PROT_DOUT_PASS :
> >>> -					 TARGET_PROT_DOUT_INSERT;
> >>> +		cmd->prot_op = fabric_prot ? TARGET_PROT_DOUT_STRIP :
> >>> +			       protect ? TARGET_PROT_DOUT_PASS :
> >>> +			       TARGET_PROT_DOUT_INSERT;
> >>
> >> In this case, if the protect=1 and fabric_prot=1 we will strip won't we?
> >> I think that the protect condition should come first.
> >>
> >
> > Mmm, not sure I follow..
> >
> > sbc_check_prot() is only ever passing fabric_prot=1 when se_cmd prot
> > SGLs are present and se_dev does not accept PI, regardless of protect.
> >
> 
> It's a little confusing that fabric_prot is set if the backend device
> does not support PI.

Well, it's supposed to signal that fabric supports PI, but the backend
device does not.

Seems like a reasonable name to me..  Any ideas for a better one..?  ;)

--nab
