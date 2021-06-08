Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79372C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 07:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5884E61059
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 07:01:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhFHHC6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 03:02:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhFHHC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 03:02:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15870MUg162475
        for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2021 07:01:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=eWlITTtfKZWNjzGSx7lyivuYeThBO1qsAEoL22taxEk=;
 b=sRX2qr3+QBXUw/TagZbvJEHEtp0+zrsDLatsR4QgFF8DDA5uBEQf9I1bObvw/C4CIybJ
 jwo5J17qigAoCYcK/MKregg+lFzqrpw+VrtLYCigKNbn9gDtflkNK6EUAs4ICZiOsSes
 pvHVAUHbAD4n1KKPw+XnmVEO4E5Ipyyrf3o/BgvbowONRoNiJVoQNpwk1DD6krlddb9o
 Tf2fzbtbm9tkHDnC3pdp4o70CSRfh7BXy+YWnhfIYrM8WBAXCIqoBMDNG8KySFdrKYC6
 7ImRfzSiCMdLCdYhJMbb7w9SxFyPk+9wlbTGViQVhGsNtIUESM/ih1iStW/pxzHPYQhC yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3914qukhgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jun 2021 07:01:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15870XPX185672
        for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2021 07:01:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3922wr4me1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jun 2021 07:01:03 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15870u5Q190226
        for <linux-scsi@vger.kernel.org>; Tue, 8 Jun 2021 07:00:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3922wr4kv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 07:00:56 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15870jHu019252;
        Tue, 8 Jun 2021 07:00:45 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Jun 2021 00:00:44 -0700
Date:   Tue, 8 Jun 2021 10:00:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     michael.christie@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: iscsi: Drop suspend calls from ep_disconnect
Message-ID: <YL8Vl7HGiJhHkgHr@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-ORIG-GUID: WK1GFUAH4Q6XET6dJ__C4dxkAxBAklpb
X-Proofpoint-GUID: WK1GFUAH4Q6XET6dJ__C4dxkAxBAklpb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=968 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Mike Christie,

This is a semi-automatic email about new static checker warnings.

The patch 27e986289e73: "scsi: iscsi: Drop suspend calls from
ep_disconnect" from May 25, 2021, leads to the following Smatch
complaint:

    drivers/scsi/qedi/qedi_iscsi.c:1669 qedi_clear_session_ctx()
    warn: variable dereferenced before check 'conn' (see line 1666)

drivers/scsi/qedi/qedi_iscsi.c
  1665		struct iscsi_conn *conn = session->leadconn;
  1666		struct qedi_conn *qedi_conn = conn->dd_data;
                                              ^^^^^^^^^^^^^
Dereference

  1667	
  1668		if (iscsi_is_session_online(cls_sess)) {
  1669			if (conn)
                            ^^^^
This new NULL check is too late.

  1670				iscsi_suspend_queue(conn);
  1671			qedi_ep_disconnect(qedi_conn->iscsi_ep);

regards,
dan carpenter
