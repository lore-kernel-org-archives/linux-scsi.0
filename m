Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC80EC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0DA20B1F
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 10:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dr4nu+jq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGTK25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 06:28:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGTK24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 06:28:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KACQWk060983;
        Mon, 20 Jul 2020 10:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=esBcoJpaxZ6yrU4HizS/OVql8TsuPJLBuAFpB/XEg3U=;
 b=dr4nu+jq4/hwja+xRYdByUbrXqXVqeHHSTbTTdm3HrCxhnNteC5DJzCWo1yhtre4OJRn
 qpDbnBOi33NFFMUUtT2inKA32MhJDUVnN2GXm3C+i+bFbUl6ers6qD7VLAMzFPizquad
 tNIawMYAGiTU2Kh3DFq1opEMXAxqIr5+FzNVDplx6Z59ajRFekdb2vUlae1DpoNXnV5Q
 sLCVnyj9fj3PH2cXCQYVeJ26I8uHB+Sn92KhSCwWr1slrxheM8jZd7n1XkgLdJIsT/C0
 8kZ+ziCXmPE3Q1aKp96YMg6XnIoSkYS02CHMEKJwr7ylNAPxI2RwOdw7yTSzjGZvr/W5 +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr63hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 10:28:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06KADuni185237;
        Mon, 20 Jul 2020 10:28:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32d8kyw327-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 10:28:53 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06KASqdd017096;
        Mon, 20 Jul 2020 10:28:52 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 10:28:51 +0000
Date:   Mon, 20 Jul 2020 13:28:46 +0300
From:   <dan.carpenter@oracle.com>
To:     varun@chelsio.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: cxgb4i: Add support for iSCSI segmentation offload
Message-ID: <20200720102846.GA29932@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9687 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=3 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=996
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200075
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9687 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=3 adultscore=0 clxscore=1015 mlxlogscore=987
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200075
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Varun Prakash,

The patch e33c2482289b: "scsi: cxgb4i: Add support for iSCSI
segmentation offload" from Jun 29, 2020, leads to the following
static checker warning:

drivers/scsi/cxgbi/libcxgbi.c:1902 cxgbi_conn_alloc_pdu() warn: 'tdata' can't be NULL.
drivers/scsi/cxgbi/libcxgbi.c:2158 cxgbi_conn_init_pdu() warn: 'tdata' can't be NULL.
drivers/scsi/cxgbi/libcxgbi.c:2374 cxgbi_conn_xmit_pdu() warn: 'tdata' can't be NULL.

drivers/scsi/cxgbi/libcxgbi.c
  1885  int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 op)
  1886  {
  1887          struct iscsi_conn *conn = task->conn;
  1888          struct iscsi_session *session = task->conn->session;
  1889          struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
  1890          struct cxgbi_conn *cconn = tcp_conn->dd_data;
  1891          struct cxgbi_device *cdev = cconn->chba->cdev;
  1892          struct cxgbi_sock *csk = cconn->cep ? cconn->cep->csk : NULL;
  1893          struct iscsi_tcp_task *tcp_task = task->dd_data;
  1894          struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#define iscsi_task_cxgbi_data(task) \
        ((task)->dd_data + sizeof(struct iscsi_tcp_task))

  1895          struct scsi_cmnd *sc = task->sc;
  1896          u32 headroom = SKB_TX_ISCSI_PDU_HEADER_MAX;
  1897          u32 max_txdata_len = conn->max_xmit_dlength;
  1898          u32 iso_tx_rsvd = 0, local_iso_info = 0;
  1899          u32 last_tdata_offset, last_tdata_count;
  1900          int err = 0;
  1901  
  1902          if (!tcp_task || !tdata) {
                                 ^^^^^^
If ->dd_data is negative sizeof(struct iscsi_tcp_task) then we are
toasted.  That's an error pointer.  These sorts of extra NULL checking
generate a warning because maybe we intended to check a different
variable or IS_ERR(task->dd_data) or something.  The checker can't know.

  1903                  pr_err("task 0x%p, tcp_task 0x%p, tdata 0x%p.\n",
  1904                         task, tcp_task, tdata);
  1905                  return -ENOMEM;
  1906          }

regards,
dan carpenter
