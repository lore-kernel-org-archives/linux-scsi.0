From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 04/11] iscsi-target: Add per transport iscsi_cmd
 alloc/free
Date: Fri, 08 Mar 2013 12:47:42 -0800
Message-ID: <1362775662.7905.294.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-5-git-send-email-nab@linux-iscsi.org>
	 <CAFO3S439XJt3O8CuoE+ZNJjHz5Mum59RqN2ps+cfXtZOrWq0ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAFO3S439XJt3O8CuoE+ZNJjHz5Mum59RqN2ps+cfXtZOrWq0ew@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Asias He <asias.hejun@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-03-08 at 22:29 +0800, Asias He wrote:
> On Fri, Mar 8, 2013 at 9:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch converts struct iscsi_cmd memory allocation + free to use
> > ->iscsit_alloc_cmd() + ->iscsit_free_cmd() iscsit_transport API caller,
> > and export iscsit_allocate_cmd() + iscsit_free_cmd() symbols
> >
> > Also update iscsit_free_cmd() to include a final ->iscsit_unmap_cmd()
> > API call.
> >
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/iscsi/iscsi_target.c      |    2 +
> >  drivers/target/iscsi/iscsi_target_util.c |   34 ++++++++++++++++++++++++++---
> >  drivers/target/iscsi/iscsi_target_util.h |    2 +
> >  3 files changed, 34 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 4dc1c9b..9cd7b7b 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -488,6 +488,8 @@ static struct iscsit_transport iscsi_target_transport = {
> >         .iscsit_setup_np        = iscsit_setup_np,
> >         .iscsit_accept_np       = iscsit_accept_np,
> >         .iscsit_free_np         = iscsit_free_np,
> > +       .iscsit_alloc_cmd       = iscsit_alloc_cmd,
> > +       .iscsit_free_cmd        = iscsit_cache_free_cmd,
> >         .iscsit_get_login_rx    = iscsit_get_login_rx,
> >         .iscsit_put_login_tx    = iscsit_put_login_tx,
> >  };
> > diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> > index 4cf1e7f..4a86034 100644
> > --- a/drivers/target/iscsi/iscsi_target_util.c
> > +++ b/drivers/target/iscsi/iscsi_target_util.c
> > @@ -149,6 +149,17 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
> >         spin_unlock_bh(&cmd->r2t_lock);
> >  }
> >
> > +struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
> > +{
> > +       struct iscsi_cmd *cmd;
> > +
> > +       cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
> > +       if (!cmd)
> > +               return NULL;
> 
> Is this check necessary?
> 

Nope, dropping this now.

Thanks for reviewing!

--nab
