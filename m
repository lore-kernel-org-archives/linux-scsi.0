From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 06/15] target: Move cmd->prot_op check into
 target_check_read_prot
Date: Tue, 31 Mar 2015 23:03:33 -0700
Message-ID: <1427868213.9176.201.camel@haakon3.risingtidesystems.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
	 <1427686104-14231-7-git-send-email-nab@daterainc.com>
	 <55190305.7060108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <55190305.7060108@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-03-30 at 11:02 +0300, Sagi Grimberg wrote:
> On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch moves the existing target_complete_ok_work() check for
> > cmd->prot_op into it's own function, so it's easier to add future
> > support for READ INSERT.
> >
> > Cc: Martin Petersen <martin.petersen@oracle.com>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_transport.c | 21 +++++++++++++--------
> >   1 file changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 51b62bd..e603e34 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -1980,16 +1980,22 @@ static void transport_handle_queue_full(
> >   	schedule_work(&cmd->se_dev->qf_work_queue);
> >   }
> >
> > -static bool target_check_read_strip(struct se_cmd *cmd)
> > +static bool target_check_read_prot(struct se_cmd *cmd)
> 
> Same comment on naming.

Fixed.
