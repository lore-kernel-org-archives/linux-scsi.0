From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 1/2] RFC: Proposal for BSG Interface
Date: Sun, 9 May 2010 17:37:00 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA870D35B7958@AVEXMB1.qlogic.org>
References: <20100317180557.GA25841@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:36730 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0EJAhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 May 2010 20:37:03 -0400
In-Reply-To: <20100317180557.GA25841@serverengines.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@serverengines.com>

Sorry for late response. Please see our comments inline.
We are trying to figure out how we can leverage this interface
for our offload solution.

Thanks,
Vikas.


>+/*
>+ * iSCSI Host Messages
>+ */
>+
>+struct ip_address_subnet_format {
>+	u16 sizeofstructure;

Why do we need this field ?

>+	u8  iptype;
>+	u8  ipv6_prefix_length;
>+	u8  ipaddress[16];
>+	u8  subnetmask[16];
>+	u32 rsvd0;
>+} __packed;
>+
>+struct iscsi_ip_addr_record {
>+	u32  action;

What's does this field implies ? Looks like be2iscsi specific ?

>+	u32  interface_hndl;

Again what this interface handle for ?

>+	struct ip_address_subnet_format ip_address;
>+	u32  status;

Why do we need *status* ? And its status of what ?

>+} __packed;
>+
>+struct iscsi_ip_addr_record_params {
>+	u32 record_entry_count;
>+	struct iscsi_ip_addr_record ip_record[1];
>+} __packed;
>+
>+struct ip_address_format {
>+	u16	sizeofstructure;
>+	u8	reserved;
>+	u8	ip_type;
>+	u8	ip_address[16];
>+	u32	rsvd0;
>+} __packed;
>+

So this structure is needed to distinguish between IPV4 and IPV6. Correct ?
Once we have a better understanding we can really assess whether it will
work for our interface or not, or it will require further changes to make it generic
so that it will work for us.

>+struct iscsi_bsg_common_format {
>+	u8 opcode;		/* dword 0 */
>+	u8 subsystem;		/* dword 0 */
>+	u8 port_number;		/* dword 0 */
>+	u8 domain;		/* dword 0 */

What does *port_number* and *domain* indicate ?

>+	u32 timeout;		/* dword 1 */

Is it bsg command time out?

>+	u32 request_length;	/* dword 2 */
>+	u32 rsvd0;		/* dword 3 */

Why *rsvd0* here? Why not at end of struct.

>+	u32    action;

What is expected data here ? So at the app's level what *action*
is supposed to be set to ?

>+	struct ip_address_format gateway;
>+	u32  interface_hndl;

What is expected data here? Why we need *interface_hndl* here.
We also have a *port_number* as struct member.

>+	u32  vlan_priority;
>+	u32  flags;

Again *flags* is supposed to be set to what ?

>+	u8   iscsiname[224];
>+	u8   iscsialias[32];
>+	u32  ip_type;
>+	u32  retry_count;
>+	struct iscsi_ip_addr_record_params ip_params;

Can we add *u32 vendor_data[0]* for vendor specific data?

>+} __packed;
>+
>+/* ISCSI_BSG_HST_NET_CONFIG : */
>+
>+/* bsg network parameter ids */
>+enum iscsi_bsg_netparam {
>+	BSG_NETPARAM_UNKNOWN		= 0x00000000,
>+	BSG_NETPARAM_MAC		= BSG_NETPARAM_UNKNOWN + 1,
>+	BSG_NETPARAM_MTU		= BSG_NETPARAM_UNKNOWN + 2,
>+	BSG_NETPARAM_VLAN		= BSG_NETPARAM_UNKNOWN + 3,
>+	BSG_NETPARAM_BOOTPROTO		= BSG_NETPARAM_UNKNOWN + 4,
>+	BSG_NETPARAM_IPV4_ADDR		= BSG_NETPARAM_UNKNOWN + 5,
>+	BSG_NETPARAM_IPV4_MASK		= BSG_NETPARAM_UNKNOWN + 6,
>+	BSG_NETPARAM_IPV4_GW		= BSG_NETPARAM_UNKNOWN + 7,
>+	BSG_NETPARAM_IPV6_ADDR		= BSG_NETPARAM_UNKNOWN + 8,
>+	BSG_NETPARAM_IPV6_MASK		= BSG_NETPARAM_UNKNOWN + 9,
>+	BSG_NETPARAM_IPV6_GW		= BSG_NETPARAM_UNKNOWN + 10,
>+	BSG_NETPARAM_IPV6_AUTO_PARAM	= BSG_NETPARAM_UNKNOWN + 11,
>+};
>+
>+/* network parameter TLV (type, length, value) structure */
>+struct iscsi_bsg_netparam_tlv {
>+	uint32_t	netparam;
>+	uint32_t	length;
>+	uint8_t		value[1];
>+};

So *value[1]* you mean *value[0]*, just to be consistent ? Also the idea behind
this TLV is for App's to set whatever network param needs to be set or get in one
or multiple shot, can be configured and passed back & forth ? Is that how
you guys envisioned it ?

>+
>+/* Request:
>+ * This message sets or gets Network configuration parameters on/from the
>+ * iscsi host network interface.
>+ *
>+ * On set operations, the request payload buffer contains a set of
>+ * netparam tlv's with the values to be set.
>+ *
>+ * On get operations, the request payload is unused.
>+ */
>+struct iscsi_bsg_host_net_config {
>+	/*
>+	 * Specifies the operation type:  0x0 = GET;  0x1 = SET
>+	 */
>+	uint8_t		set_op;

Looking at the implementation, looks like *set_op*  is set to ISCSI_SET_IP_ADDR
for ex, ? Basically not consistent  as outlined in the comment.

>+
>+	/*
>+	 * If SET operation, contains the total number of netparam tlv's
>+	 * in the request payload.
>+	 */
>+	uint8_t		netparam_count;
>+};

