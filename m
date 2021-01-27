Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A17C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 11:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE872075B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 11:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbhA0LP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 06:15:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:46056 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbhA0LNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 06:13:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RB9BNS105085;
        Wed, 27 Jan 2021 11:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=EX6HZJ9b9FxkPsQlItz08LigH9FcyVGJGsFJG3Nwfi0=;
 b=Vt6bjmu/tPSP9s2X/j949ozKDCJ2aHUO3rjoK+RxAMPTQ8vU/wU31+8/nJ1UYkEThCl3
 kZiXitynMxGr41cXm8/tZK+mXii8nd9CQSLJACivNKKokPyZh4bigKsH1QbwV86sIqe5
 QdYGaBnPRmorblxqogUNFYi8yq8i5uO74zpdlcrKd0UtQV0CTeLqQCk+fBj8LUSQ8icG
 7NE7GyPWX3uusycPSpeE4SD2sqtsiQoQAwF/dn8VHUKfqLXRufMJCiEI0qaQ79tDiG/y
 j/zMLLrovnMXTR64YKKt4esDQOB4x7EvQlZ0wA2vW6a2bG5/FCzTLk3YhJ+CB3ZkQGZM jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aapqda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 11:12:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RBAYdL131738;
        Wed, 27 Jan 2021 11:10:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 368wq04rp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 11:10:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10RBAYki006820;
        Wed, 27 Jan 2021 11:10:34 GMT
Received: from mwanda (/10.175.203.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 27 Jan 2021 03:10:33 -0800
Date:   Wed, 27 Jan 2021 14:10:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     adheer.chandravanshi@qlogic.com, QLogic-Storage-Upstream@qlogic.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] [SCSI] qla4xxx: Add flash node mgmt support
Message-ID: <YBFKI1rjC6opxDUa@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270060
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270060
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Adheer Chandravanshi,

The patch 1e9e2be3ee03: "[SCSI] qla4xxx: Add flash node mgmt support"
from Mar 22, 2013, leads to the following static checker warning:

	drivers/scsi/qla4xxx/ql4_os.c:3723 qla4xxx_copy_to_fwddb_param()
	warn: 'conn->redirect_ipaddr' sometimes too small '16' size = 32

drivers/scsi/qla4xxx/ql4_os.c
  3637  static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
  3638                                         struct iscsi_bus_flash_conn *conn,
  3639                                         struct dev_db_entry *fw_ddb_entry)
  3640  {
  3641          uint16_t options;
  3642          int rc = 0;
  3643  
  3644          options = le16_to_cpu(fw_ddb_entry->options);
  3645          SET_BITVAL(conn->is_fw_assigned_ipv6,  options, BIT_11);
  3646          if (!strncmp(sess->portal_type, PORTAL_TYPE_IPV6, 4))
  3647                  options |= BIT_8;
  3648          else
  3649                  options &= ~BIT_8;
  3650  
  3651          SET_BITVAL(sess->auto_snd_tgt_disable, options, BIT_6);
  3652          SET_BITVAL(sess->discovery_sess, options, BIT_4);
  3653          SET_BITVAL(sess->entry_state, options, BIT_3);
  3654          fw_ddb_entry->options = cpu_to_le16(options);
  3655  
  3656          options = le16_to_cpu(fw_ddb_entry->iscsi_options);
  3657          SET_BITVAL(conn->hdrdgst_en, options, BIT_13);
  3658          SET_BITVAL(conn->datadgst_en, options, BIT_12);
  3659          SET_BITVAL(sess->imm_data_en, options, BIT_11);
  3660          SET_BITVAL(sess->initial_r2t_en, options, BIT_10);
  3661          SET_BITVAL(sess->dataseq_inorder_en, options, BIT_9);
  3662          SET_BITVAL(sess->pdu_inorder_en, options, BIT_8);
  3663          SET_BITVAL(sess->chap_auth_en, options, BIT_7);
  3664          SET_BITVAL(conn->snack_req_en, options, BIT_6);
  3665          SET_BITVAL(sess->discovery_logout_en, options, BIT_5);
  3666          SET_BITVAL(sess->bidi_chap_en, options, BIT_4);
  3667          SET_BITVAL(sess->discovery_auth_optional, options, BIT_3);
  3668          SET_BITVAL(sess->erl & BIT_1, options, BIT_1);
  3669          SET_BITVAL(sess->erl & BIT_0, options, BIT_0);
  3670          fw_ddb_entry->iscsi_options = cpu_to_le16(options);
  3671  
  3672          options = le16_to_cpu(fw_ddb_entry->tcp_options);
  3673          SET_BITVAL(conn->tcp_timestamp_stat, options, BIT_6);
  3674          SET_BITVAL(conn->tcp_nagle_disable, options, BIT_5);
  3675          SET_BITVAL(conn->tcp_wsf_disable, options, BIT_4);
  3676          SET_BITVAL(conn->tcp_timer_scale & BIT_2, options, BIT_3);
  3677          SET_BITVAL(conn->tcp_timer_scale & BIT_1, options, BIT_2);
  3678          SET_BITVAL(conn->tcp_timer_scale & BIT_0, options, BIT_1);
  3679          SET_BITVAL(conn->tcp_timestamp_en, options, BIT_0);
  3680          fw_ddb_entry->tcp_options = cpu_to_le16(options);
  3681  
  3682          options = le16_to_cpu(fw_ddb_entry->ip_options);
  3683          SET_BITVAL(conn->fragment_disable, options, BIT_4);
  3684          fw_ddb_entry->ip_options = cpu_to_le16(options);
  3685  
  3686          fw_ddb_entry->iscsi_max_outsnd_r2t = cpu_to_le16(sess->max_r2t);
  3687          fw_ddb_entry->iscsi_max_rcv_data_seg_len =
  3688                                 cpu_to_le16(conn->max_recv_dlength / BYTE_UNITS);
  3689          fw_ddb_entry->iscsi_max_snd_data_seg_len =
  3690                                 cpu_to_le16(conn->max_xmit_dlength / BYTE_UNITS);
  3691          fw_ddb_entry->iscsi_first_burst_len =
  3692                                  cpu_to_le16(sess->first_burst / BYTE_UNITS);
  3693          fw_ddb_entry->iscsi_max_burst_len = cpu_to_le16(sess->max_burst /
  3694                                              BYTE_UNITS);
  3695          fw_ddb_entry->iscsi_def_time2wait = cpu_to_le16(sess->time2wait);
  3696          fw_ddb_entry->iscsi_def_time2retain = cpu_to_le16(sess->time2retain);
  3697          fw_ddb_entry->tgt_portal_grp = cpu_to_le16(sess->tpgt);
  3698          fw_ddb_entry->mss = cpu_to_le16(conn->max_segment_size);
  3699          fw_ddb_entry->tcp_xmt_wsf = (uint8_t) cpu_to_le32(conn->tcp_xmit_wsf);
  3700          fw_ddb_entry->tcp_rcv_wsf = (uint8_t) cpu_to_le32(conn->tcp_recv_wsf);
  3701          fw_ddb_entry->ipv6_flow_lbl = cpu_to_le16(conn->ipv6_flow_label);
  3702          fw_ddb_entry->ka_timeout = cpu_to_le16(conn->keepalive_timeout);
  3703          fw_ddb_entry->lcl_port = cpu_to_le16(conn->local_port);
  3704          fw_ddb_entry->stat_sn = cpu_to_le32(conn->statsn);
  3705          fw_ddb_entry->exp_stat_sn = cpu_to_le32(conn->exp_statsn);
  3706          fw_ddb_entry->ddb_link = cpu_to_le16(sess->discovery_parent_idx);
  3707          fw_ddb_entry->chap_tbl_idx = cpu_to_le16(sess->chap_out_idx);
  3708          fw_ddb_entry->tsid = cpu_to_le16(sess->tsid);
  3709          fw_ddb_entry->port = cpu_to_le16(conn->port);
  3710          fw_ddb_entry->def_timeout =
  3711                                  cpu_to_le16(sess->default_taskmgmt_timeout);
  3712  
  3713          if (!strncmp(sess->portal_type, PORTAL_TYPE_IPV6, 4))
  3714                  fw_ddb_entry->ipv4_tos = conn->ipv6_traffic_class;
  3715          else
  3716                  fw_ddb_entry->ipv4_tos = conn->ipv4_tos;
  3717  
  3718          if (conn->ipaddress)
  3719                  memcpy(fw_ddb_entry->ip_addr, conn->ipaddress,
  3720                         sizeof(fw_ddb_entry->ip_addr));
  3721  
  3722          if (conn->redirect_ipaddr)
  3723                  memcpy(fw_ddb_entry->tgt_addr, conn->redirect_ipaddr,
  3724                         sizeof(fw_ddb_entry->tgt_addr));

The conn->redirect_ipaddr is IPv6_ADDR_LEN (16) bytes.  It is allocated
in qla4xxx_copy_from_fwddb_param().  The w_ddb_entry->tgt_addr[] is a
32 byte buffer.  So this is definitely a read overflow and copying
garbage from beyond the end of the buffer.

I guess ->redirect_ipaddr has the first part of fw_ddb_entry->tgt_addr?

  3725  
  3726          if (conn->link_local_ipv6_addr)
  3727                  memcpy(fw_ddb_entry->link_local_ipv6_addr,
  3728                         conn->link_local_ipv6_addr,
  3729                         sizeof(fw_ddb_entry->link_local_ipv6_addr));
  3730  
  3731          if (sess->targetname)
  3732                  memcpy(fw_ddb_entry->iscsi_name, sess->targetname,
  3733                         sizeof(fw_ddb_entry->iscsi_name));
  3734  
  3735          if (sess->targetalias)
  3736                  memcpy(fw_ddb_entry->iscsi_alias, sess->targetalias,
  3737                         sizeof(fw_ddb_entry->iscsi_alias));
  3738  
  3739          COPY_ISID(fw_ddb_entry->isid, sess->isid);
  3740  
  3741          return rc;
  3742  }

regards,
dan carpenter
