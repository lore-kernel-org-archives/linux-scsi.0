From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issue with fc_exch_alloc failing initiated by
 fc_queuecommand on NUMA or large configurations with Intel ixgbe running
 FCOE
Date: Sat, 8 Oct 2016 08:57:10 -0400 (EDT)
Message-ID: <209207528.804499.1475931430678.JavaMail.zimbra@redhat.com>
References: <1812349047.803888.1475929839972.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1812349047.803888.1475929839972.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
Cc: "Curtis Taylor (cjt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)" <cjt-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Bud Brown <bubrown-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello

This has been a tough problem to chase down but was finally reproduced.
This issue is apparent on RHEL kernels and upstream so justified reporting here.

Its out there and some may not be aware its even happening other than very slow performance using ixgbe and software FCOE on large configurations.

Upstream Kernel used for reproducing is 4.8.0

I/O performance was noted to be very impacted on a large NUMA test system (64 CPUS 4 NUMA nodes) running the software fcoe stack with Intel ixgbe interfaces.
After capturing blktraces we saw for every I/O there was at least one blk_requeue_request and sometimes hundreds or more.
This resulted in IOPS rates being marginal at best with queuing and high wait times.
After narrowing this down with systemtap and trace-cmd we added further debug and it was apparent this was dues to SCSI_MLQUEUE_HOST_BUSY being returned.
So I/O passes but very slowly as it constantly having to be requeued.

The identical configuration in our lab with a single NUMA node and 4 CPUS does not see this issue at all.
The same large system that reproduces this was booted with numa=off and still sees the issue.

The flow is as follows:

>From with fc_queuecommand
          fc_fcp_pkt_send() calls fc_fcp_cmd_send() calls tt.exch_seq_send() which calls fc_exch_seq_send

this fails and returns NULL in fc_exch_alloc() as the list traveral never creates a match.

static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
				       struct fc_frame *fp,
				       void (*resp)(struct fc_seq *,
						    struct fc_frame *fp,
						    void *arg),
				       void (*destructor)(struct fc_seq *,
							  void *),
				       void *arg, u32 timer_msec)
{
	struct fc_exch *ep;
	struct fc_seq *sp = NULL;
	struct fc_frame_header *fh;
	struct fc_fcp_pkt *fsp = NULL;
	int rc = 1;

	ep = fc_exch_alloc(lport, fp);     ***** Called Here and fails
	if (!ep) {
		fc_frame_free(fp);
		printk("RHDEBUG: In fc_exch_seq_send returned NULL because !ep with ep = %p\n",ep);
		return NULL;
	}
..
..
]


 fc_exch_alloc() - Allocate an exchange from an EM on a
 *	/**
 *	     local port's list of EMs.
 * @lport: The local port that will own the exchange
 * @fp:	   The FC frame that the exchange will be for
 *
 * This function walks the list of exchange manager(EM)
 * anchors to select an EM for a new exchange allocation. The
 * EM is selected when a NULL match function pointer is encountered
 * or when a call to a match function returns true.
 */
static inline struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
					    struct fc_frame *fp)
{
	struct fc_exch_mgr_anchor *ema;

	list_for_each_entry(ema, &lport->ema_list, ema_list)
		if (!ema->match || ema->match(fp))
			return fc_exch_em_alloc(lport, ema->mp);
	return NULL;                                 ***** Never matches so returns NULL
}


RHDEBUG: In fc_exch_seq_send returned NULL because !ep with ep = (null)
RHDEBUG: rc -1 with !seq = (null) after calling tt.exch_seq_send  within fc_fcp_cmd_send
RHDEBUG: rc non zero in :unlock within fc_fcp_cmd_send = -1
RHDEBUG: In fc_fcp_pkt_send, we returned from  rc = lport->tt.fcp_cmd_send with rc = -1

RHDEBUG: We hit SCSI_MLQUEUE_HOST_BUSY in fc_queuecommand with rval in fc_fcp_pkt_send=-1

I am trying to get my head around why a large multi-node system sees this issue even with NUMA disabled.
Has anybody seen this or is aware of this with configurations (using fc_queuecommand)

I am continuing to add debug to narrow this down.

Thanks
Laurence 
