From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iser-target: Disable TX completion interrupt coalescing
Date: Tue, 07 Oct 2014 23:01:28 -0700
Message-ID: <1412748088.31947.35.camel@haakon3.risingtidesystems.com>
References: <1412561711-31344-1-git-send-email-nab@daterainc.com>
	 <54338F00.8050902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54338F00.8050902@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Moussa Ba <moussaba@micron.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-10-07 at 09:58 +0300, Sagi Grimberg wrote:
> On 10/6/2014 5:15 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch explicitly disables TX completion interrupt coalescing logic
> > in isert_put_response() and isert_put_datain() that was originally added
> > as an efficiency optimization in commit 95b60f07.
> >
> > It has been reported that this change can trigger ABORT_TASK timeouts
> > under certain small block workloads, where disabling coalescing was
> > required for stability.  According to Sagi, this doesn't impact
> > overall performance, so go ahead and disable it for now.
> >
> > Reported-by: Moussa Ba <moussaba@micron.com>
> > Cc: Moussa Ba <moussaba@micron.com>
> > Reported-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
> > Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> > Cc: <stable@vger.kernel.org> # 3.13+
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/infiniband/ulp/isert/ib_isert.c |    4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> > index 40969b6..f719112 100644
> > --- a/drivers/infiniband/ulp/isert/ib_isert.c
> > +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> > @@ -2183,7 +2183,7 @@ isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> >   		isert_cmd->tx_desc.num_sge = 2;
> >   	}
> >
> > -	isert_init_send_wr(isert_conn, isert_cmd, send_wr, true);
> > +	isert_init_send_wr(isert_conn, isert_cmd, send_wr, false);
> 
> I Would like to avoid taking the conn_mutex in the IO path.

Yes, please.

> Care to respin this with avoiding taking the mutex? Or you want me to?

Let's keep this patch as is for -rc1 so it can be easily picked up for
stable, especially considering that it's been verified by Moussa for
some time.

> I have a couple of patches in the pipe anyway...
> 

Thank you Sagi.

--nab
