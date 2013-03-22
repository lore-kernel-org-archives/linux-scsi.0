From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 02/11] iscsi-target: Initial traditional TCP conversion
 to iscsit_transport
Date: Fri, 22 Mar 2013 15:38:33 -0700
Message-ID: <1363991913.30339.31.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-3-git-send-email-nab@linux-iscsi.org>
	 <514C938A.70301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <514C938A.70301@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-03-22 at 10:23 -0700, Andy Grover wrote:
> On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch performs the initial conversion of existing traditional iscsi
> > to use iscsit_transport API callers.  This includes:
> >
> > - iscsi-np cleanups for iscsit_transport_type
> > - Add iscsi-np transport calls w/ ->iscsit_setup_up() and ->iscsit_free_np()
> > - Convert login thread process context to use ->iscsit_accept_np() for
> >    connections with pre-allocated struct iscsi_conn
> > - Convert existing socket accept code to iscsit_accept_np()
> > - Convert login RX/TX callers to use ->iscsit_get_login_rx() and
> >    ->iscsit_put_login_tx() to exchange request/response PDUs
> > - Convert existing socket login RX/TX calls into iscsit_get_login_rx()
> >    and iscsit_put_login_tx()
> > - Change iscsit_close_connection() to invoke ->iscsit_free_conn() +
> >    iscsit_put_transport() calls.
> > - Add iscsit_create_transport() + iscsit_destroy_transport() calls
> >    to module init/exit
> >
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/iscsi/iscsi_target.c            |   35 ++-
> >   drivers/target/iscsi/iscsi_target_core.h       |   15 +-
> >   drivers/target/iscsi/iscsi_target_login.c      |  411 ++++++++++++++++--------
> >   drivers/target/iscsi/iscsi_target_login.h      |    6 +
> >   drivers/target/iscsi/iscsi_target_nego.c       |  185 ++----------
> >   drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
> >   drivers/target/iscsi/iscsi_target_parameters.c |   12 +-
> >   drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
> >   drivers/target/iscsi/iscsi_target_util.c       |   27 +--
> >   9 files changed, 376 insertions(+), 332 deletions(-)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 23a98e6..4dc1c9b 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c

<SNIP>

> > @@ -4045,6 +4060,12 @@ int iscsit_close_connection(
> >
> >   	if (conn->sock)
> >   		sock_release(conn->sock);
> > +
> > +	if (conn->conn_transport->iscsit_free_conn)
> > +		conn->conn_transport->iscsit_free_conn(conn);
> 
> For all the function pointers in conn_transport, won't they always be 
> there? If so, can we just call them w/o checking?

For this case, no.  ->iscsit_free_conn() is currently present for only
ib_isert.ko code.


> > diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> > index fdb632f..9354a5f 100644
> > --- a/drivers/target/iscsi/iscsi_target_login.c
> > +++ b/drivers/target/iscsi/iscsi_target_login.c

<SNIP>

> > @@ -635,7 +677,13 @@ static int iscsi_post_login_handler(
> >   		spin_unlock_bh(&sess->conn_lock);
> >
> >   		iscsi_post_login_start_timers(conn);
> > -		iscsi_activate_thread_set(conn, ts);
> > +
> > +		if (conn->conn_transport == ISCSI_TCP) {
> > +			iscsi_activate_thread_set(conn, ts);
> 
> I thought conn_transport was a pointer? It looks like it's being 
> compared against an enum here.
> 

This has already been removed for RFC-v2 code.

> > +		} else {
> > +			printk("Not calling iscsi_activate_thread_set....\n");
> > +			dump_stack();
> 
> Left-in debug code?

Ditto here too..

> 

> > +int iscsit_get_login_rx(struct iscsi_conn *conn, struct iscsi_login *login)
> > +{
> > +	struct iscsi_login_req *login_req;
> > +	u32 padding = 0, payload_length;
> > +
> > +	if (iscsi_login_rx_data(conn, login->req, ISCSI_HDR_LEN) < 0)
> > +		return -1;
> > +
> > +	login_req = (struct iscsi_login_req *)login->req;
> > +	payload_length	= ntoh24(login_req->dlength);
> > +	padding = ((-payload_length) & 3);
> > +
> > +	pr_debug("Got Login Command, Flags 0x%02x, ITT: 0x%08x,"
> > +		" CmdSN: 0x%08x, ExpStatSN: 0x%08x, CID: %hu, Length: %u\n",
> > +		login_req->flags, login_req->itt, login_req->cmdsn,
> > +		login_req->exp_statsn, login_req->cid, payload_length);
> > +	/*
> > +	 * Setup the initial iscsi_login values from the leading
> > +	 * login request PDU.
> > +	 */
> > +	if (login->first_request) {
> > +		login_req = (struct iscsi_login_req *)login->req;
> > +		login->leading_connection = (!login_req->tsih) ? 1 : 0;
> > +		login->current_stage	=
> > +			(login_req->flags & ISCSI_FLAG_LOGIN_CURRENT_STAGE_MASK) >> 2;
> > +		login->version_min	= login_req->min_version;
> > +		login->version_max	= login_req->max_version;
> > +		memcpy(login->isid, login_req->isid, 6);
> > +		login->cmd_sn		= be32_to_cpu(login_req->cmdsn);
> > +		login->init_task_tag	= login_req->itt;
> > +		login->initial_exp_statsn = be32_to_cpu(login_req->exp_statsn);
> > +		login->cid		= be16_to_cpu(login_req->cid);
> > +		login->tsih		= be16_to_cpu(login_req->tsih);
> > +	}
> > +
> > +	if (iscsi_target_check_login_request(conn, login) < 0)
> > +		return -1;
> 
> Better return values?
> 

In the failure case here, iscsit_tx_login_rsp() will have already been
called to queue the login response with the appropriate status class +
non-zero status detail. 

				
> > @@ -737,7 +676,7 @@ static void iscsi_initiatorname_tolower(
> >   /*
> >    * Processes the first Login Request..
> >    */
> > -static int iscsi_target_locate_portal(
> > +int iscsi_target_locate_portal(
> >   	struct iscsi_np *np,
> >   	struct iscsi_conn *conn,
> >   	struct iscsi_login *login)
> > @@ -746,29 +685,13 @@ static int iscsi_target_locate_portal(
> >   	char *tmpbuf, *start = NULL, *end = NULL, *key, *value;
> >   	struct iscsi_session *sess = conn->sess;
> >   	struct iscsi_tiqn *tiqn;
> > -	struct iscsi_login_req *login_req;
> > +        struct iscsi_login_req *login_req;
> 
> tab got replaced by spaces?
> 

Fixed.

Thanks,

--nab
