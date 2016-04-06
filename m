From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] bnx2fc: Fix locking requirements in bnx2fc_init_tgt
Date: Tue, 05 Apr 2016 21:16:26 -0400
Message-ID: <1459905386.2315.69.camel@linux.vnet.ibm.com>
References: <1459867006-19605-1-git-send-email-bastienphilbert@gmail.com>
	 <alpine.OSX.2.00.1604051341370.1272@administrators-macbook-pro.local>
	 <CACJ9a8Rz7wrLtFttHXvNCc-AcvnAahVOcE4=GNdo61F_4MK3QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACJ9a8Rz7wrLtFttHXvNCc-AcvnAahVOcE4=GNdo61F_4MK3QA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bastien Bastien Philbert <bastienphilbert@gmail.com>, Chad Dupuis <chad.dupuis@qlogic.com>
Cc: QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-04-05 at 13:50 -0400, Bastien Bastien Philbert wrote:
> On Tue, Apr 5, 2016 at 1:43 PM, Chad Dupuis <chad.dupuis@qlogic.com>
> wrote:
> > 
> > 
> > On Tue, 5 Apr 2016, Bastien Philbert wrote:
> > 
> > > This fixes the locking around the call to bnx2fc_alloc_id to
> > > comply
> > > with the comments about this particular function's definition
> > > about
> > > requiring the need to hold the hba mutex before and after calling
> > > it.
> > > Signed-off-by: Bastien Philbert <bastienphilbert@gmail.com>
> > > ---
> > > drivers/scsi/bnx2fc/bnx2fc_tgt.c | 6 +++++-
> > > 1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> > > b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> > > index 08ec318..f2988cd 100644
> > > --- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> > > +++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
> > > @@ -368,9 +368,13 @@ static int bnx2fc_init_tgt(struct
> > > bnx2fc_rport *tgt,
> > >                 return -1;
> > >         }
> > > 
> > > +       mutex_lock(&hba->hba_mutex);
> > >         tgt->fcoe_conn_id = bnx2fc_alloc_conn_id(hba, tgt);
> > > -       if (tgt->fcoe_conn_id == -1)
> > > +       if (tgt->fcoe_conn_id == -1) {
> > > +               mutex_unlock(&hba->hba_mutex);
> > >                 return -1;
> > > +       }
> > > +       mutex_unlock(&hba->hba_mutex);
> > > 
> > >         BNX2FC_TGT_DBG(tgt, "init_tgt - conn_id = 0x%x\n",
> > > tgt->fcoe_conn_id);
> > > 
> > > 
> > 
> > Taking the mutex here is not needed as it is already taken in
> > bnx2fc_rport_event_handler() in the call chain
> > bnx2fc_rport_event_handler->bnx2fc_offload_session->bnx2fc_init_tgt
> > ->bnx2fc_alloc_conn_id
> Ok thanks and good to known.

Since the mutex was already taken, the patch you propose would produce
an immediate deadlock if applied, meaning you didn't actually test it
out.  If you're going to propose patches like this, please understand
the driver you're patching, *test* the patches on actual hardware and
describe the problem you're solving in the changelog.

Thanks,

James
