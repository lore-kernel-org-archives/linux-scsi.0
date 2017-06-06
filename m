From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [PATCH 1/7] scsi/scsi_transport_iscsi: Add iface struct to kernel.
Date: Tue,  6 Jun 2017 12:07:11 -0600
Message-ID: <20170606180717.5007-2-robert@leblancnet.us>
References: <20170606180717.5007-1-robert@leblancnet.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606180717.5007-1-robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lduncan-IBi9RG/b67k@public.gmane.org
Cc: cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Allow the userspace iscsiadm to pass the iface struct of the connection
so that the underlying driver can use what is most appropriate to create
the iSCSI connection.

Signed-off-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
---
 include/scsi/scsi_transport_iscsi.h | 95 +++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 6183d20a01fb..26fe284daf9a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -37,6 +37,7 @@ struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_task;
 struct sockaddr;
+struct iface_rec;
 struct iscsi_iface;
 struct bsg_job;
 struct iscsi_bus_flash_session;
@@ -291,6 +292,100 @@ struct iscsi_endpoint {
 	struct iscsi_cls_conn *conn;
 };
 
+/* max len of interface */
+#define ISCSI_MAX_IFACE_LEN	65
+#define NI_MAXHOST 1025
+#define ISCSI_HWADDRESS_BUF_SIZE 18
+#define ISCSI_TRANSPORT_NAME_MAXLEN 16
+#define ISCSI_MAX_STR_LEN 80
+
+struct iface_rec {
+	struct list_head	list;
+	/* iscsi iface record name */
+	char			name[ISCSI_MAX_IFACE_LEN];
+	uint32_t		iface_num;
+	/* network layer iface name (eth0) */
+	char			netdev[IFNAMSIZ];
+	char			ipaddress[NI_MAXHOST];
+	char			subnet_mask[NI_MAXHOST];
+	char			gateway[NI_MAXHOST];
+	char			bootproto[ISCSI_MAX_STR_LEN];
+	char			ipv6_linklocal[NI_MAXHOST];
+	char			ipv6_router[NI_MAXHOST];
+	char			ipv6_autocfg[NI_MAXHOST];
+	char			linklocal_autocfg[NI_MAXHOST];
+	char			router_autocfg[NI_MAXHOST];
+	uint16_t		vlan_id;
+	uint8_t			vlan_priority;
+	char			vlan_state[ISCSI_MAX_STR_LEN];
+	char			state[ISCSI_MAX_STR_LEN]; /* 0 = disable,
+							   * 1 = enable */
+	uint16_t		mtu;
+	uint16_t		port;
+	char			delayed_ack[ISCSI_MAX_STR_LEN];
+	char			nagle[ISCSI_MAX_STR_LEN];
+	char			tcp_wsf_state[ISCSI_MAX_STR_LEN];
+	uint8_t			tcp_wsf;
+	uint8_t			tcp_timer_scale;
+	char			tcp_timestamp[ISCSI_MAX_STR_LEN];
+	char			dhcp_dns[ISCSI_MAX_STR_LEN];
+	char			dhcp_slp_da[ISCSI_MAX_STR_LEN];
+	char			tos_state[ISCSI_MAX_STR_LEN];
+	uint8_t			tos;
+	char			gratuitous_arp[ISCSI_MAX_STR_LEN];
+	char			dhcp_alt_client_id_state[ISCSI_MAX_STR_LEN];
+	char			dhcp_alt_client_id[ISCSI_MAX_STR_LEN];
+	char			dhcp_req_vendor_id_state[ISCSI_MAX_STR_LEN];
+	char			dhcp_vendor_id_state[ISCSI_MAX_STR_LEN];
+	char			dhcp_vendor_id[ISCSI_MAX_STR_LEN];
+	char			dhcp_learn_iqn[ISCSI_MAX_STR_LEN];
+	char			fragmentation[ISCSI_MAX_STR_LEN];
+	char			incoming_forwarding[ISCSI_MAX_STR_LEN];
+	uint8_t			ttl;
+	char			gratuitous_neighbor_adv[ISCSI_MAX_STR_LEN];
+	char			redirect[ISCSI_MAX_STR_LEN];
+	char			mld[ISCSI_MAX_STR_LEN];
+	uint32_t		flow_label;
+	uint32_t		traffic_class;
+	uint8_t			hop_limit;
+	uint32_t		nd_reachable_tmo;
+	uint32_t		nd_rexmit_time;
+	uint32_t		nd_stale_tmo;
+	uint8_t			dup_addr_detect_cnt;
+	uint32_t		router_adv_link_mtu;
+	uint16_t		def_task_mgmt_tmo;
+	char			header_digest[ISCSI_MAX_STR_LEN];
+	char			data_digest[ISCSI_MAX_STR_LEN];
+	char			immediate_data[ISCSI_MAX_STR_LEN];
+	char			initial_r2t[ISCSI_MAX_STR_LEN];
+	char			data_seq_inorder[ISCSI_MAX_STR_LEN];
+	char			data_pdu_inorder[ISCSI_MAX_STR_LEN];
+	uint8_t			erl;
+	uint32_t		max_recv_dlength;
+	uint32_t		first_burst_len;
+	uint16_t		max_out_r2t;
+	uint32_t		max_burst_len;
+	char			chap_auth[ISCSI_MAX_STR_LEN];
+	char			bidi_chap[ISCSI_MAX_STR_LEN];
+	char			strict_login_comp[ISCSI_MAX_STR_LEN];
+	char			discovery_auth[ISCSI_MAX_STR_LEN];
+	char			discovery_logout[ISCSI_MAX_STR_LEN];
+	char			port_state[ISCSI_MAX_STR_LEN];
+	char			port_speed[ISCSI_MAX_STR_LEN];
+	/*
+	 * TODO: we may have to make this bigger and interconnect
+	 * specific for infiniband
+	 */
+	char			hwaddress[ISCSI_HWADDRESS_BUF_SIZE];
+	char			transport_name[ISCSI_TRANSPORT_NAME_MAXLEN];
+	/*
+	 * This is only used for boot now, but the iser guys
+	 * can use this for their virtualization idea.
+	 */
+	char			alias[TARGET_NAME_MAXLEN + 1];
+	char			iname[TARGET_NAME_MAXLEN + 1];
+};
+
 struct iscsi_iface {
 	struct device dev;
 	struct iscsi_transport *transport;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
