From: <vikas.chaudhary@qlogic.com>
Subject: =?UTF-8?q?=5BPATCH=203/8=5D=20qla4xxx=3A=20Add=20host=20statistics=20support?=
Date: Fri, 22 Nov 2013 05:28:19 -0500
Message-ID: <1385116104-19784-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:5385 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755248Ab3KVLBP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Nov 2013 06:01:15 -0500
In-Reply-To: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

=46rom: Lalit Chandivade <lalit.chandivade@qlogic.com>

The statistics include MAC, TCP/IP & iSCSI statistics.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h |  83 ++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_os.c | 205 ++++++++++++++++++++++++++++++++++=
++++++++
 2 files changed, 287 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_f=
w.h
index fef311d..8d4092b 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -1297,7 +1297,88 @@ struct response {
 };
=20
 struct ql_iscsi_stats {
-	uint8_t reserved1[656]; /* 0000-028F */
+	uint64_t mac_tx_frames; /* 0000=E2=80=930007 */
+	uint64_t mac_tx_bytes; /* 0008=E2=80=93000F */
+	uint64_t mac_tx_multicast_frames; /* 0010=E2=80=930017 */
+	uint64_t mac_tx_broadcast_frames; /* 0018=E2=80=93001F */
+	uint64_t mac_tx_pause_frames; /* 0020=E2=80=930027 */
+	uint64_t mac_tx_control_frames; /* 0028=E2=80=93002F */
+	uint64_t mac_tx_deferral; /* 0030=E2=80=930037 */
+	uint64_t mac_tx_excess_deferral; /* 0038=E2=80=93003F */
+	uint64_t mac_tx_late_collision; /* 0040=E2=80=930047 */
+	uint64_t mac_tx_abort; /* 0048=E2=80=93004F */
+	uint64_t mac_tx_single_collision; /* 0050=E2=80=930057 */
+	uint64_t mac_tx_multiple_collision; /* 0058=E2=80=93005F */
+	uint64_t mac_tx_collision; /* 0060=E2=80=930067 */
+	uint64_t mac_tx_frames_dropped; /* 0068=E2=80=93006F */
+	uint64_t mac_tx_jumbo_frames; /* 0070=E2=80=930077 */
+	uint64_t mac_rx_frames; /* 0078=E2=80=93007F */
+	uint64_t mac_rx_bytes; /* 0080=E2=80=930087 */
+	uint64_t mac_rx_unknown_control_frames; /* 0088=E2=80=93008F */
+	uint64_t mac_rx_pause_frames; /* 0090=E2=80=930097 */
+	uint64_t mac_rx_control_frames; /* 0098=E2=80=93009F */
+	uint64_t mac_rx_dribble; /* 00A0=E2=80=9300A7 */
+	uint64_t mac_rx_frame_length_error; /* 00A8=E2=80=9300AF */
+	uint64_t mac_rx_jabber; /* 00B0=E2=80=9300B7 */
+	uint64_t mac_rx_carrier_sense_error; /* 00B8=E2=80=9300BF */
+	uint64_t mac_rx_frame_discarded; /* 00C0=E2=80=9300C7 */
+	uint64_t mac_rx_frames_dropped; /* 00C8=E2=80=9300CF */
+	uint64_t mac_crc_error; /* 00D0=E2=80=9300D7 */
+	uint64_t mac_encoding_error; /* 00D8=E2=80=9300DF */
+	uint64_t mac_rx_length_error_large; /* 00E0=E2=80=9300E7 */
+	uint64_t mac_rx_length_error_small; /* 00E8=E2=80=9300EF */
+	uint64_t mac_rx_multicast_frames; /* 00F0=E2=80=9300F7 */
+	uint64_t mac_rx_broadcast_frames; /* 00F8=E2=80=9300FF */
+	uint64_t ip_tx_packets; /* 0100=E2=80=930107 */
+	uint64_t ip_tx_bytes; /* 0108=E2=80=93010F */
+	uint64_t ip_tx_fragments; /* 0110=E2=80=930117 */
+	uint64_t ip_rx_packets; /* 0118=E2=80=93011F */
+	uint64_t ip_rx_bytes; /* 0120=E2=80=930127 */
+	uint64_t ip_rx_fragments; /* 0128=E2=80=93012F */
+	uint64_t ip_datagram_reassembly; /* 0130=E2=80=930137 */
+	uint64_t ip_invalid_address_error; /* 0138=E2=80=93013F */
+	uint64_t ip_error_packets; /* 0140=E2=80=930147 */
+	uint64_t ip_fragrx_overlap; /* 0148=E2=80=93014F */
+	uint64_t ip_fragrx_outoforder; /* 0150=E2=80=930157 */
+	uint64_t ip_datagram_reassembly_timeout; /* 0158=E2=80=93015F */
+	uint64_t ipv6_tx_packets; /* 0160=E2=80=930167 */
+	uint64_t ipv6_tx_bytes; /* 0168=E2=80=93016F */
+	uint64_t ipv6_tx_fragments; /* 0170=E2=80=930177 */
+	uint64_t ipv6_rx_packets; /* 0178=E2=80=93017F */
+	uint64_t ipv6_rx_bytes; /* 0180=E2=80=930187 */
+	uint64_t ipv6_rx_fragments; /* 0188=E2=80=93018F */
+	uint64_t ipv6_datagram_reassembly; /* 0190=E2=80=930197 */
+	uint64_t ipv6_invalid_address_error; /* 0198=E2=80=93019F */
+	uint64_t ipv6_error_packets; /* 01A0=E2=80=9301A7 */
+	uint64_t ipv6_fragrx_overlap; /* 01A8=E2=80=9301AF */
+	uint64_t ipv6_fragrx_outoforder; /* 01B0=E2=80=9301B7 */
+	uint64_t ipv6_datagram_reassembly_timeout; /* 01B8=E2=80=9301BF */
+	uint64_t tcp_tx_segments; /* 01C0=E2=80=9301C7 */
+	uint64_t tcp_tx_bytes; /* 01C8=E2=80=9301CF */
+	uint64_t tcp_rx_segments; /* 01D0=E2=80=9301D7 */
+	uint64_t tcp_rx_byte; /* 01D8=E2=80=9301DF */
+	uint64_t tcp_duplicate_ack_retx; /* 01E0=E2=80=9301E7 */
+	uint64_t tcp_retx_timer_expired; /* 01E8=E2=80=9301EF */
+	uint64_t tcp_rx_duplicate_ack; /* 01F0=E2=80=9301F7 */
+	uint64_t tcp_rx_pure_ackr; /* 01F8=E2=80=9301FF */
+	uint64_t tcp_tx_delayed_ack; /* 0200=E2=80=930207 */
+	uint64_t tcp_tx_pure_ack; /* 0208=E2=80=93020F */
+	uint64_t tcp_rx_segment_error; /* 0210=E2=80=930217 */
+	uint64_t tcp_rx_segment_outoforder; /* 0218=E2=80=93021F */
+	uint64_t tcp_rx_window_probe; /* 0220=E2=80=930227 */
+	uint64_t tcp_rx_window_update; /* 0228=E2=80=93022F */
+	uint64_t tcp_tx_window_probe_persist; /* 0230=E2=80=930237 */
+	uint64_t ecc_error_correction; /* 0238=E2=80=93023F */
+	uint64_t iscsi_pdu_tx; /* 0240-0247 */
+	uint64_t iscsi_data_bytes_tx; /* 0248-024F */
+	uint64_t iscsi_pdu_rx; /* 0250-0257 */
+	uint64_t iscsi_data_bytes_rx; /* 0258-025F */
+	uint64_t iscsi_io_completed; /* 0260-0267 */
+	uint64_t iscsi_unexpected_io_rx; /* 0268-026F */
+	uint64_t iscsi_format_error; /* 0270-0277 */
+	uint64_t iscsi_hdr_digest_error; /* 0278-027F */
+	uint64_t iscsi_data_digest_error; /* 0280-0287 */
+	uint64_t iscsi_sequence_error; /* 0288-028F */
 	uint32_t tx_cmd_pdu; /* 0290-0293 */
 	uint32_t tx_resp_pdu; /* 0294-0297 */
 	uint32_t rx_cmd_pdu; /* 0298-029B */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_o=
s.c
index 60d050e..aa438f2 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -151,6 +151,7 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *=
shost, uint16_t chap_tbl_idx,
 static int qla4xxx_delete_chap(struct Scsi_Host *shost, uint16_t chap_=
tbl_idx);
 static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void  *data=
,
 				  int len);
+static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, =
int len);
=20
 /*
  * SCSI host template entry points
@@ -262,6 +263,7 @@ static struct iscsi_transport qla4xxx_iscsi_transpo=
rt =3D {
 	.login_flashnode	=3D qla4xxx_sysfs_ddb_login,
 	.logout_flashnode	=3D qla4xxx_sysfs_ddb_logout,
 	.logout_flashnode_sid	=3D qla4xxx_sysfs_ddb_logout_sid,
+	.get_host_stats		=3D qla4xxx_get_host_stats,
 };
=20
 static struct scsi_transport_template *qla4xxx_scsi_transport;
@@ -947,6 +949,209 @@ exit_set_chap:
 	return rc;
 }
=20
+
+static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, =
int len)
+{
+	struct scsi_qla_host *ha =3D to_qla_host(shost);
+	struct iscsi_offload_host_stats *host_stats =3D NULL;
+	int host_stats_size;
+	int ret =3D 0;
+	int ddb_idx =3D 0;
+	struct ql_iscsi_stats *ql_iscsi_stats =3D NULL;
+	int stats_size;
+	dma_addr_t iscsi_stats_dma;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "Func: %s\n", __func__));
+
+	host_stats_size =3D sizeof(struct iscsi_offload_host_stats);
+
+	if (host_stats_size !=3D len) {
+		ql4_printk(KERN_INFO, ha, "%s: host_stats size mismatch expected =3D=
 %d, is =3D %d\n",
+			   __func__, len, host_stats_size);
+		ret =3D -EINVAL;
+		goto exit_host_stats;
+	}
+	host_stats =3D (struct iscsi_offload_host_stats *)buf;
+
+	if (!buf) {
+		ret =3D -ENOMEM;
+		goto exit_host_stats;
+	}
+
+	stats_size =3D PAGE_ALIGN(sizeof(struct ql_iscsi_stats));
+
+	ql_iscsi_stats =3D dma_alloc_coherent(&ha->pdev->dev, stats_size,
+					    &iscsi_stats_dma, GFP_KERNEL);
+	if (!ql_iscsi_stats) {
+		ql4_printk(KERN_ERR, ha,
+			   "Unable to allocate memory for iscsi stats\n");
+		goto exit_host_stats;
+	}
+
+	ret =3D  qla4xxx_get_mgmt_data(ha, ddb_idx, stats_size,
+				     iscsi_stats_dma);
+	if (ret !=3D QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha,
+			   "Unable to retrieve iscsi stats\n");
+		goto exit_host_stats;
+	}
+	host_stats->mactx_frames =3D le64_to_cpu(ql_iscsi_stats->mac_tx_frame=
s);
+	host_stats->mactx_bytes =3D le64_to_cpu(ql_iscsi_stats->mac_tx_bytes)=
;
+	host_stats->mactx_multicast_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_multicast_frames);
+	host_stats->mactx_broadcast_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_broadcast_frames);
+	host_stats->mactx_pause_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_pause_frames);
+	host_stats->mactx_control_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_control_frames);
+	host_stats->mactx_deferral =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_deferral);
+	host_stats->mactx_excess_deferral =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_excess_deferral);
+	host_stats->mactx_late_collision =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_late_collision);
+	host_stats->mactx_abort	=3D le64_to_cpu(ql_iscsi_stats->mac_tx_abort)=
;
+	host_stats->mactx_single_collision =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_single_collision);
+	host_stats->mactx_multiple_collision =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_multiple_collision);
+	host_stats->mactx_collision =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_collision);
+	host_stats->mactx_frames_dropped =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_frames_dropped);
+	host_stats->mactx_jumbo_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_tx_jumbo_frames);
+	host_stats->macrx_frames =3D le64_to_cpu(ql_iscsi_stats->mac_rx_frame=
s);
+	host_stats->macrx_bytes =3D le64_to_cpu(ql_iscsi_stats->mac_rx_bytes)=
;
+	host_stats->macrx_unknown_control_frames =3D
+		le64_to_cpu(ql_iscsi_stats->mac_rx_unknown_control_frames);
+	host_stats->macrx_pause_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_pause_frames);
+	host_stats->macrx_control_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_control_frames);
+	host_stats->macrx_dribble =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_dribble);
+	host_stats->macrx_frame_length_error =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_frame_length_error);
+	host_stats->macrx_jabber =3D le64_to_cpu(ql_iscsi_stats->mac_rx_jabbe=
r);
+	host_stats->macrx_carrier_sense_error =3D
+		le64_to_cpu(ql_iscsi_stats->mac_rx_carrier_sense_error);
+	host_stats->macrx_frame_discarded =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_frame_discarded);
+	host_stats->macrx_frames_dropped =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_frames_dropped);
+	host_stats->mac_crc_error =3D le64_to_cpu(ql_iscsi_stats->mac_crc_err=
or);
+	host_stats->mac_encoding_error =3D
+			le64_to_cpu(ql_iscsi_stats->mac_encoding_error);
+	host_stats->macrx_length_error_large =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_length_error_large);
+	host_stats->macrx_length_error_small =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_length_error_small);
+	host_stats->macrx_multicast_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_multicast_frames);
+	host_stats->macrx_broadcast_frames =3D
+			le64_to_cpu(ql_iscsi_stats->mac_rx_broadcast_frames);
+	host_stats->iptx_packets =3D le64_to_cpu(ql_iscsi_stats->ip_tx_packet=
s);
+	host_stats->iptx_bytes =3D le64_to_cpu(ql_iscsi_stats->ip_tx_bytes);
+	host_stats->iptx_fragments =3D
+			le64_to_cpu(ql_iscsi_stats->ip_tx_fragments);
+	host_stats->iprx_packets =3D le64_to_cpu(ql_iscsi_stats->ip_rx_packet=
s);
+	host_stats->iprx_bytes =3D le64_to_cpu(ql_iscsi_stats->ip_rx_bytes);
+	host_stats->iprx_fragments =3D
+			le64_to_cpu(ql_iscsi_stats->ip_rx_fragments);
+	host_stats->ip_datagram_reassembly =3D
+			le64_to_cpu(ql_iscsi_stats->ip_datagram_reassembly);
+	host_stats->ip_invalid_address_error =3D
+			le64_to_cpu(ql_iscsi_stats->ip_invalid_address_error);
+	host_stats->ip_error_packets =3D
+			le64_to_cpu(ql_iscsi_stats->ip_error_packets);
+	host_stats->ip_fragrx_overlap =3D
+			le64_to_cpu(ql_iscsi_stats->ip_fragrx_overlap);
+	host_stats->ip_fragrx_outoforder =3D
+			le64_to_cpu(ql_iscsi_stats->ip_fragrx_outoforder);
+	host_stats->ip_datagram_reassembly_timeout =3D
+		le64_to_cpu(ql_iscsi_stats->ip_datagram_reassembly_timeout);
+	host_stats->ipv6tx_packets =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_tx_packets);
+	host_stats->ipv6tx_bytes =3D le64_to_cpu(ql_iscsi_stats->ipv6_tx_byte=
s);
+	host_stats->ipv6tx_fragments =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_tx_fragments);
+	host_stats->ipv6rx_packets =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_rx_packets);
+	host_stats->ipv6rx_bytes =3D le64_to_cpu(ql_iscsi_stats->ipv6_rx_byte=
s);
+	host_stats->ipv6rx_fragments =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_rx_fragments);
+	host_stats->ipv6_datagram_reassembly =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_datagram_reassembly);
+	host_stats->ipv6_invalid_address_error =3D
+		le64_to_cpu(ql_iscsi_stats->ipv6_invalid_address_error);
+	host_stats->ipv6_error_packets =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_error_packets);
+	host_stats->ipv6_fragrx_overlap =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_fragrx_overlap);
+	host_stats->ipv6_fragrx_outoforder =3D
+			le64_to_cpu(ql_iscsi_stats->ipv6_fragrx_outoforder);
+	host_stats->ipv6_datagram_reassembly_timeout =3D
+		le64_to_cpu(ql_iscsi_stats->ipv6_datagram_reassembly_timeout);
+	host_stats->tcptx_segments =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_tx_segments);
+	host_stats->tcptx_bytes	=3D le64_to_cpu(ql_iscsi_stats->tcp_tx_bytes)=
;
+	host_stats->tcprx_segments =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_segments);
+	host_stats->tcprx_byte =3D le64_to_cpu(ql_iscsi_stats->tcp_rx_byte);
+	host_stats->tcp_duplicate_ack_retx =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_duplicate_ack_retx);
+	host_stats->tcp_retx_timer_expired =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_retx_timer_expired);
+	host_stats->tcprx_duplicate_ack	=3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_duplicate_ack);
+	host_stats->tcprx_pure_ackr =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_pure_ackr);
+	host_stats->tcptx_delayed_ack =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_tx_delayed_ack);
+	host_stats->tcptx_pure_ack =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_tx_pure_ack);
+	host_stats->tcprx_segment_error =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_segment_error);
+	host_stats->tcprx_segment_outoforder =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_segment_outoforder);
+	host_stats->tcprx_window_probe =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_window_probe);
+	host_stats->tcprx_window_update =3D
+			le64_to_cpu(ql_iscsi_stats->tcp_rx_window_update);
+	host_stats->tcptx_window_probe_persist =3D
+		le64_to_cpu(ql_iscsi_stats->tcp_tx_window_probe_persist);
+	host_stats->ecc_error_correction =3D
+			le64_to_cpu(ql_iscsi_stats->ecc_error_correction);
+	host_stats->iscsi_pdu_tx =3D le64_to_cpu(ql_iscsi_stats->iscsi_pdu_tx=
);
+	host_stats->iscsi_data_bytes_tx =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_data_bytes_tx);
+	host_stats->iscsi_pdu_rx =3D le64_to_cpu(ql_iscsi_stats->iscsi_pdu_rx=
);
+	host_stats->iscsi_data_bytes_rx	=3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_data_bytes_rx);
+	host_stats->iscsi_io_completed =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_io_completed);
+	host_stats->iscsi_unexpected_io_rx =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_unexpected_io_rx);
+	host_stats->iscsi_format_error =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_format_error);
+	host_stats->iscsi_hdr_digest_error =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_hdr_digest_error);
+	host_stats->iscsi_data_digest_error =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_data_digest_error);
+	host_stats->iscsi_sequence_error =3D
+			le64_to_cpu(ql_iscsi_stats->iscsi_sequence_error);
+exit_host_stats:
+	if (ql_iscsi_stats)
+		dma_free_coherent(&ha->pdev->dev, host_stats_size,
+				  ql_iscsi_stats, iscsi_stats_dma);
+
+	ql4_printk(KERN_INFO, ha, "%s: Get host stats done\n",
+		   __func__);
+	return ret;
+}
+
 static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 				   enum iscsi_param_type param_type,
 				   int param, char *buf)
--=20
1.8.2.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
