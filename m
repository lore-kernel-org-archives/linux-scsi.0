From: "Dev, Vasu" <vasu.dev@intel.com>
Subject: RE: Open-FCoE on linux-scsi
Date: Fri, 4 Jan 2008 14:07:28 -0800
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6E029FF0B8@fmsmsx411.amr.corp.intel.com>
References: <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com><477E1C69.9010203@s5r6.in-berlin.de> <20080104205938U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYADWJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 17:09:32 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080104205938U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stefanr@s5r6.in-berlin.de
Cc: "Love, Robert W" <robert.w.love@intel.com>, tomof@acm.org, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, linux-scsi@vger.kernel.org


>>
>> _If_ there will indeed be dedicated FCoE HBAs in the future, the
>> following stack could exist in addition to the one above:
>>
>>   - SCSI core,
>>     scsi_transport_fc
>>   - FCoE HBA driver(s)
>
>Agreed. My FCoE initiator design would be something like:
>
>scsi-ml
>fcoe initiator driver
>libfcoe
>fc_transport_class (inclusing fcoe support)
>
>And FCoE HBA LLDs work like:
>
>scsi-ml
>FCoE HBA LLDs (some of them might use libfcoe)
>fc_transport_class (inclusing fcoe support)
>
>
>That's the way that other transport classes do, I think. For me, the
>current code tries to invent another fc class. For example, the code
>newly defines:
>
>struct fc_remote_port {
>	struct list_head rp_list;	/* list under fc_virt_fab */
>	struct fc_virt_fab *rp_vf;	/* virtual fabric */
>	fc_wwn_t	rp_port_wwn;	/* remote port world wide name
*/
>	fc_wwn_t	rp_node_wwn;	/* remote node world wide name
*/
>	fc_fid_t	rp_fid;		/* F_ID for remote_port if known
*/
>	atomic_t	rp_refcnt;	/* reference count */
>	u_int		rp_disc_ver;	/* discovery instance */
>	u_int		rp_io_limit;	/* limit on outstanding I/Os */
>	u_int		rp_io_count;	/* count of outstanding I/Os */
>	u_int		rp_fcp_parm; 	/* remote FCP service parameters
*/
>	u_int		rp_local_fcp_parm; /* local FCP service
parameters */
>	void		*rp_client_priv; /* HBA driver private data */
>	void		*rp_fcs_priv;	/* FCS driver private data */
>	struct sa_event_list *rp_events; /* event list */
>	struct sa_hash_link rp_fid_hash_link;
>	struct sa_hash_link rp_wwpn_hash_link;
>
>	/*
>	 * For now, there's just one session per remote port.
>	 * Eventually, for multipathing, there will be more.
>	 */
>	u_char		rp_sess_ready;	/* session ready to be used */
>	struct fc_sess	*rp_sess;	/* session */
>	void		*dns_lookup;	/* private dns lookup */
>	int		dns_lookup_count; /* number of attempted lookups
*/
>};
>
>/*
> * remote ports are created and looked up by WWPN.
> */
>struct fc_remote_port *fc_remote_port_create(struct fc_virt_fab *,
fc_wwn_t);
>struct fc_remote_port *fc_remote_port_lookup(struct fc_virt_fab *,
>					     fc_fid_t, fc_wwn_t wwpn);
>struct fc_remote_port *fc_remote_port_lookup_create(struct fc_virt_fab
*,
>						    fc_fid_t,
>						    fc_wwn_t wwpn,
>						    fc_wwn_t wwnn);
>
>
>The FCoE LLD needs to exploit the exsting struct fc_rport and APIs.

The openfc is software implementation of FC services such as FC login
and target discovery and it is already using/exploiting  existing fc
transport class including fc_rport struct. You can see openfc using
fc_rport in openfc_queuecommand() and using fc transport API
fc_port_remote_add() for fc_rport.

The fcoe module is just a first example of possible openfc transport but
openfc can be used with other transports or HW HBAs also.

The openfc does provide generic transport interface using fcdev which is
currently used by FCoE module.

One can certainly implement partly or fully  openfc and fcoe modules in
FCoE HBA.
