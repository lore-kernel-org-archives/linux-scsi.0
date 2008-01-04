From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Open-FCoE on linux-scsi
Date: Fri, 04 Jan 2008 20:59:38 +0900
Message-ID: <20080104205938U.fujita.tomonori@lab.ntt.co.jp>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp>
	<10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
	<477E1C69.9010203@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:60384 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYADMAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 07:00:22 -0500
In-Reply-To: <477E1C69.9010203@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: robert.w.love@intel.com, tomof@acm.org, yi.zou@intel.com, christopher.leech@intel.com, vasu.dev@intel.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 04 Jan 2008 12:45:45 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> On 1/3/2008 10:58 PM, Love, Robert W wrote:
> [FUJITA Tomonori wrote]
> >>I would add one TODO item, better integration with scsi_transport_fc.
> >>If we have HW FCoE HBAs in the future, we need FCoE support in the fc
> >>transport class (you could use its netlink mechanism for event
> >>notification).
> > 
> > What do you have in mind in particular? Our layers are, 
> > 
> > SCSI
> > Openfc
> > FCoE
> > net_devive
> > NIC driver
> > 
> > So, it makes sense to me that we fit under scsi_transport_fc. I like our
> > layering- we clearly have SCSI on our top edge and net_dev at our bottom
> > edge. My initial reaction would be to resist merging openfc and fcoe and
> > creating a scsi_transport_fcoe.h interface.
> 
> AFAIU the stack should be:
> 
>   - SCSI core,
>     scsi_transport_fc
>   - Openfc (an FCoE implementation)
>   - net_device
>   - NIC driver
> 
> _If_ there will indeed be dedicated FCoE HBAs in the future, the
> following stack could exist in addition to the one above:
> 
>   - SCSI core,
>     scsi_transport_fc
>   - FCoE HBA driver(s)

Agreed. My FCoE initiator design would be something like:

scsi-ml
fcoe initiator driver
libfcoe
fc_transport_class (inclusing fcoe support)

And FCoE HBA LLDs work like:

scsi-ml
FCoE HBA LLDs (some of them might use libfcoe)
fc_transport_class (inclusing fcoe support)


That's the way that other transport classes do, I think. For me, the
current code tries to invent another fc class. For example, the code
newly defines:

struct fc_remote_port {
	struct list_head rp_list;	/* list under fc_virt_fab */
	struct fc_virt_fab *rp_vf;	/* virtual fabric */
	fc_wwn_t	rp_port_wwn;	/* remote port world wide name */
	fc_wwn_t	rp_node_wwn;	/* remote node world wide name */
	fc_fid_t	rp_fid;		/* F_ID for remote_port if known */
	atomic_t	rp_refcnt;	/* reference count */
	u_int		rp_disc_ver;	/* discovery instance */
	u_int		rp_io_limit;	/* limit on outstanding I/Os */
	u_int		rp_io_count;	/* count of outstanding I/Os */
	u_int		rp_fcp_parm; 	/* remote FCP service parameters */
	u_int		rp_local_fcp_parm; /* local FCP service parameters */
	void		*rp_client_priv; /* HBA driver private data */
	void		*rp_fcs_priv;	/* FCS driver private data */
	struct sa_event_list *rp_events; /* event list */
	struct sa_hash_link rp_fid_hash_link;
	struct sa_hash_link rp_wwpn_hash_link;

	/*
	 * For now, there's just one session per remote port.
	 * Eventually, for multipathing, there will be more.
	 */
	u_char		rp_sess_ready;	/* session ready to be used */
	struct fc_sess	*rp_sess;	/* session */
	void		*dns_lookup;	/* private dns lookup */
	int		dns_lookup_count; /* number of attempted lookups */
};

/*
 * remote ports are created and looked up by WWPN.
 */
struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *, fc_wwn_t);
struct fc_remote_port *fc_remote_port_lookup(struct fc_virt_fab *,
					     fc_fid_t, fc_wwn_t wwpn);
struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab *,
						    fc_fid_t,
						    fc_wwn_t wwpn,
						    fc_wwn_t wwnn);


The FCoE LLD needs to exploit the exsting struct fc_rport and APIs.
