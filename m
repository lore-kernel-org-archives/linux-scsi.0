From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v2 10/12] iser-target: Add logic for verbs
Date: Tue, 02 Apr 2013 15:27:27 -0700
Message-ID: <1364941647.3898.194.camel@haakon2.linux-iscsi.org>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
	 <1363996536-30644-11-git-send-email-nab@linux-iscsi.org>
	 <CAJZOPZL3WreQjbaeGgaUi3QxEuEAXFCcuMA6C3rEibzmRp7fUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJZOPZL3WreQjbaeGgaUi3QxEuEAXFCcuMA6C3rEibzmRp7fUQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-04-02 at 23:09 +0300, Or Gerlitz wrote:
> On Sat, Mar 23, 2013 at 1:55 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> [...]
> > +static void
> > +isert_qp_event_callback(struct ib_event *e, void *context)
> > +{
> > +       struct isert_conn *isert_conn = (struct isert_conn *)context;
> > +
> > +       pr_err("isert_qp_event_callback event: %d\n", e->event);
> > +       switch (e->event) {
> > +       case IB_EVENT_COMM_EST:
> > +               rdma_notify(isert_conn->conn_cm_id, IB_EVENT_COMM_EST);
> > +               break;
> > +       default:
> > +               break;
> > +       }
> > +}
> [...]
> > +static void
> > +isert_cq_event_callback(struct ib_event *e, void *context)
> > +{
> > +       pr_debug("isert_cq_event_callback event: %d\n", e->event);
> > +
> > +       switch (e->event) {
> > +       case IB_EVENT_QP_LAST_WQE_REACHED:
> > +               pr_warn("Reached TX IB_EVENT_QP_LAST_WQE_REACHED:\n");
> > +               break;
> > +       default:
> > +               pr_warn("Unknown e->event; %d\n", e->event);
> > +               break;
> > +       }
> > +}
> 
> This is QP not CQ event, move the case for it to QP event hander
> isert_qp_event_callback

Done.

Thanks Or!
