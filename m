From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] qla4xxx: Add flash node mgmt support
Date: Mon, 15 Apr 2013 21:55:13 +0300
Message-ID: <20130415185513.GA18542@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51917 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab3DOSzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Apr 2013 14:55:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adheer.chandravanshi@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hi Adheer,

The patch 1e9e2be3ee03: "[SCSI] qla4xxx: Add flash node mgmt support" 
from Mar 22, 2013, has several endian bugs.

drivers/scsi/qla4xxx/ql4_os.c
  2217          fw_ddb_entry->tgt_portal_grp = cpu_to_le16(sess->tpgt);
  2218          fw_ddb_entry->mss = cpu_to_le16(conn->max_segment_size);
  2219          fw_ddb_entry->tcp_xmt_wsf = cpu_to_le16(conn->tcp_xmit_wsf);
                              ^^^^^^^^^^^
This is u8.

  2220          fw_ddb_entry->tcp_rcv_wsf = cpu_to_le16(conn->tcp_recv_wsf);
                              ^^^^^^^^^^^
This is u8.

  2221          fw_ddb_entry->ipv4_tos = conn->ipv4_tos;
  2222          fw_ddb_entry->ipv6_flow_lbl = cpu_to_le16(conn->ipv6_flow_label);
  2223          fw_ddb_entry->ka_timeout = cpu_to_le16(conn->keepalive_timeout);
  2224          fw_ddb_entry->lcl_port = cpu_to_le16(conn->local_port);
  2225          fw_ddb_entry->stat_sn = cpu_to_le16(conn->statsn);
                              ^^^^^^^
This is u32.

  2226          fw_ddb_entry->exp_stat_sn = cpu_to_le16(conn->exp_statsn);
                              ^^^^^^^^^^^
This is u32.

  2227          fw_ddb_entry->ddb_link = cpu_to_le16(sess->discovery_parent_type);
  2228          fw_ddb_entry->chap_tbl_idx = cpu_to_le16(sess->chap_out_idx);
  2229          fw_ddb_entry->tsid = cpu_to_le16(sess->tsid);

Theoretically these should have been caught by Sparse:
http://lwn.net/Articles/205624/

But unfortunately, Sparse hits an error parsing the
external_hw_config_reg union because it uses bitfields as part of __le32
data.  After you hit a Sparse error then it doesn't bother to print
warnings.  This is arguably a UI problem in Sparse and it took me
forever to figure out why the warnings weren't being printed.  :/

If I changed the external_hw_config_reg to use u32 instead of __le32
then Sparse gives the max number of warnings.  I'm not sure that that's
the right thing to do.  Are those bitfields actually used?  Maybe we
should just delete it.

Anyway, I've attached the warnings below.

regards,
dan carpenter

<stdin>:1223:2: warning: #warning syscall finit_module not implemented [-Wcpp]
devel/drivers/scsi/qla4xxx/ql4_os.c:1370:28: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1370:28:    expected unsigned int [unsigned] [usertype] cookie
devel/drivers/scsi/qla4xxx/ql4_os.c:1370:28:    got restricted __le32 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1890:21: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1890:21:    expected restricted itt_t [usertype] itt
devel/drivers/scsi/qla4xxx/ql4_os.c:1890:21:    got unsigned int [unsigned] [usertype] handle
devel/drivers/scsi/qla4xxx/ql4_os.c:901:32: warning: cast to restricted __le64
devel/drivers/scsi/qla4xxx/ql4_os.c:902:32: warning: cast to restricted __le64
devel/drivers/scsi/qla4xxx/ql4_os.c:904:29: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:905:31: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:906:30: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:907:29: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:908:28: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:909:31: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:910:30: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:911:29: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:913:29: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:914:31: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:915:30: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:916:31: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:917:30: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:919:25: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:920:27: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:921:29: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:922:27: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:502:21: warning: restricted __le16 degrades to integer
devel/drivers/scsi/qla4xxx/ql4_os.c:627:9: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:630:13: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:635:28: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:635:28:    expected unsigned short [unsigned] [usertype] cookie
devel/drivers/scsi/qla4xxx/ql4_os.c:635:28:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1126:53: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1126:53:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1126:53:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1130:53: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1130:53:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1130:53:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1144:53: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1144:53:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1144:53:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1148:53: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1148:53:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1148:53:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1165:47: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1165:47:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1165:47:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1169:47: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1169:47:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1169:47:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1178:43: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1178:43:    expected unsigned short [unsigned] [usertype] ipv6_vlan_tag
devel/drivers/scsi/qla4xxx/ql4_os.c:1178:43:    got restricted __be16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1183:47: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1183:47:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1183:47:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1186:47: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1186:47:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1186:47:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1190:42: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1190:42:    expected unsigned short [unsigned] [usertype] eth_mtu_size
devel/drivers/scsi/qla4xxx/ql4_os.c:1190:42:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1198:39: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1198:39:    expected unsigned short [unsigned] [usertype] ipv6_port
devel/drivers/scsi/qla4xxx/ql4_os.c:1198:39:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1227:51: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1227:51:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1227:51:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1230:51: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1230:51:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1230:51:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1237:50: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1237:50:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1237:50:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1241:50: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1241:50:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1241:50:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1250:43: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1250:43:    expected unsigned short [unsigned] [usertype] ipv4_vlan_tag
devel/drivers/scsi/qla4xxx/ql4_os.c:1250:43:    got restricted __be16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1255:50: warning: invalid assignment: |=
devel/drivers/scsi/qla4xxx/ql4_os.c:1255:50:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1255:50:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1258:50: warning: invalid assignment: &=
devel/drivers/scsi/qla4xxx/ql4_os.c:1258:50:    left side has type unsigned short
devel/drivers/scsi/qla4xxx/ql4_os.c:1258:50:    right side has type restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:1262:42: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1262:42:    expected unsigned short [unsigned] [usertype] eth_mtu_size
devel/drivers/scsi/qla4xxx/ql4_os.c:1262:42:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:1266:39: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:1266:39:    expected unsigned short [unsigned] [usertype] ipv4_port
devel/drivers/scsi/qla4xxx/ql4_os.c:1266:39:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2021:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2040:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2060:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2074:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2078:27: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2080:27: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2082:32: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2084:34: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2085:25: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2086:27: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2087:29: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2088:22: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:2089:34: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2092:33: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2093:35: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2094:28: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2095:24: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:2096:28: warning: cast to restricted __le32
devel/drivers/scsi/qla4xxx/ql4_os.c:2097:38: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2098:39: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2099:30: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2100:22: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2103:33: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2104:22: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2106:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2164:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2174:31: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2174:31:    expected unsigned short [unsigned] [usertype] options
devel/drivers/scsi/qla4xxx/ql4_os.c:2174:31:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2176:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2190:37: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2190:37:    expected unsigned short [unsigned] [usertype] iscsi_options
devel/drivers/scsi/qla4xxx/ql4_os.c:2190:37:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2192:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2200:35: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2200:35:    expected unsigned short [unsigned] [usertype] tcp_options
devel/drivers/scsi/qla4xxx/ql4_os.c:2200:35:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2202:19: warning: cast to restricted __le16
devel/drivers/scsi/qla4xxx/ql4_os.c:2204:34: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2204:34:    expected unsigned short [unsigned] [usertype] ip_options
devel/drivers/scsi/qla4xxx/ql4_os.c:2204:34:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2206:44: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2206:44:    expected unsigned short [unsigned] [usertype] iscsi_max_outsnd_r2t
devel/drivers/scsi/qla4xxx/ql4_os.c:2206:44:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2207:50: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2207:50:    expected unsigned short [unsigned] [usertype] iscsi_max_rcv_data_seg_len
devel/drivers/scsi/qla4xxx/ql4_os.c:2207:50:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2209:50: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2209:50:    expected unsigned short [unsigned] [usertype] iscsi_max_snd_data_seg_len
devel/drivers/scsi/qla4xxx/ql4_os.c:2209:50:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2211:45: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2211:45:    expected unsigned short [unsigned] [usertype] iscsi_first_burst_len
devel/drivers/scsi/qla4xxx/ql4_os.c:2211:45:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2213:43: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2213:43:    expected unsigned short [unsigned] [usertype] iscsi_max_burst_len
devel/drivers/scsi/qla4xxx/ql4_os.c:2213:43:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2215:43: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2215:43:    expected unsigned short [unsigned] [usertype] iscsi_def_time2wait
devel/drivers/scsi/qla4xxx/ql4_os.c:2215:43:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2216:45: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2216:45:    expected unsigned short [unsigned] [usertype] iscsi_def_time2retain
devel/drivers/scsi/qla4xxx/ql4_os.c:2216:45:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2217:38: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2217:38:    expected unsigned short [unsigned] [usertype] tgt_portal_grp
devel/drivers/scsi/qla4xxx/ql4_os.c:2217:38:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2218:27: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2218:27:    expected unsigned short [unsigned] [usertype] mss
devel/drivers/scsi/qla4xxx/ql4_os.c:2218:27:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2219:35: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2219:35:    expected unsigned char [unsigned] [usertype] tcp_xmt_wsf
devel/drivers/scsi/qla4xxx/ql4_os.c:2219:35:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2220:35: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2220:35:    expected unsigned char [unsigned] [usertype] tcp_rcv_wsf
devel/drivers/scsi/qla4xxx/ql4_os.c:2220:35:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2222:37: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2222:37:    expected unsigned short [unsigned] [usertype] ipv6_flow_lbl
devel/drivers/scsi/qla4xxx/ql4_os.c:2222:37:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2223:34: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2223:34:    expected unsigned short [unsigned] [usertype] ka_timeout
devel/drivers/scsi/qla4xxx/ql4_os.c:2223:34:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2224:32: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2224:32:    expected unsigned short [unsigned] [usertype] lcl_port
devel/drivers/scsi/qla4xxx/ql4_os.c:2224:32:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2225:31: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2225:31:    expected unsigned int [unsigned] [usertype] stat_sn
devel/drivers/scsi/qla4xxx/ql4_os.c:2225:31:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2226:35: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2226:35:    expected unsigned int [unsigned] [usertype] exp_stat_sn
devel/drivers/scsi/qla4xxx/ql4_os.c:2226:35:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2227:32: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2227:32:    expected unsigned short [unsigned] [usertype] ddb_link
devel/drivers/scsi/qla4xxx/ql4_os.c:2227:32:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2228:36: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2228:36:    expected unsigned short [unsigned] [usertype] chap_tbl_idx
devel/drivers/scsi/qla4xxx/ql4_os.c:2228:36:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2229:28: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2229:28:    expected unsigned short [unsigned] [usertype] tsid
devel/drivers/scsi/qla4xxx/ql4_os.c:2229:28:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2230:28: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2230:28:    expected unsigned short [unsigned] [usertype] port
devel/drivers/scsi/qla4xxx/ql4_os.c:2230:28:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2231:35: warning: incorrect type in assignment (different base types)
devel/drivers/scsi/qla4xxx/ql4_os.c:2231:35:    expected unsigned short [unsigned] [usertype] def_timeout
devel/drivers/scsi/qla4xxx/ql4_os.c:2231:35:    got restricted __le16 [usertype] <noident>
devel/drivers/scsi/qla4xxx/ql4_os.c:2276:35: warning: too many warnings
