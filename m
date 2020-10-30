Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772CFC4363A
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 12:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1568D20756
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 12:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RR1Bg0HQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgJ3MtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 08:49:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:58376 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgJ3MtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2020 08:49:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UCnMKJ088686;
        Fri, 30 Oct 2020 12:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=2zoUeCKmAqC8L2sq5ZICt2V68MBr0xkWCW69/rkFN8k=;
 b=RR1Bg0HQEZ0VPmh0GN+Jsh0lmBku/juN2WaEqhKq04yMNL3U+rALSka5uvOmNH5ywDL2
 /LLoq0BlmKzvl8/ybL5aRWaUf+ilmtzW/DJMDyTK0pTTtUMdznErgvkDM4ed0HY9T6p4
 JHOyK+vyscqSJROtVApok0SBaeE/uJ/oC8oCCcRZIch1Nwde8dbRuTIRRjNRo2FvJMSY
 RMeU6oTEI1l04WIx9hqgv20AhY4IJtByfICwZpv8bBTAdu178nZUo5nI786XRvvRDLv9
 QxL2MXwuC4c9pR79Gle+x76zs3LpAyoNWTbZCCG7pio1PApnJYAFgCT5skPTcVM3nwJ9 Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9sb9nys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 12:49:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09UCjTHV184817;
        Fri, 30 Oct 2020 12:49:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34cx70nmpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 12:49:21 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09UCnKNm010658;
        Fri, 30 Oct 2020 12:49:20 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Oct 2020 05:49:20 -0700
Date:   Fri, 30 Oct 2020 15:49:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     abjoglek@cisco.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] [SCSI] fnic: Add new Cisco PCI-Express FCoE HBA
Message-ID: <20201030124914.GA3265258@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011 suspectscore=3
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300097
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Abhijeet Joglekar,

The patch 5df6d737dd4b: "[SCSI] fnic: Add new Cisco PCI-Express FCoE
HBA" from Apr 17, 2009, leads to the following static checker warning:

    drivers/scsi/fnic/fnic_res.c:96 fnic_get_vnic_config()
    warn: '__UNIQUE_ID___x1297' 255000 can't fit into 65535 'c->ed_tov'

    drivers/scsi/fnic/fnic_res.c:101 fnic_get_vnic_config()
    warn: '__UNIQUE_ID___x1301' 255000 can't fit into 65535 'c->ra_tov'

drivers/scsi/fnic/fnic_res.c
    89          c->rq_desc_count = ALIGN(c->rq_desc_count, 16);
    90  
    91          c->maxdatafieldsize =
    92                  min_t(u16, VNIC_FNIC_MAXDATAFIELDSIZE_MAX,
    93                        max_t(u16, VNIC_FNIC_MAXDATAFIELDSIZE_MIN,
    94                              c->maxdatafieldsize));
    95          c->ed_tov =
    96                  min_t(u32, VNIC_FNIC_EDTOV_MAX,
    97                        max_t(u32, VNIC_FNIC_EDTOV_MIN,
    98                              c->ed_tov));

The VNIC_FNIC_EDTOV_MAX is 255000 but c->ed_tov is a u16 so the max is
way outside of the maximum that the type says it can be.

    99  
   100          c->ra_tov =
   101                  min_t(u32, VNIC_FNIC_RATOV_MAX,
                                    ^^^^^^^^^^^^^^^^^^
Same.

   102                        max_t(u32, VNIC_FNIC_RATOV_MIN,
   103                              c->ra_tov));
   104  
   105          c->flogi_retries =
   106                  min_t(u32, VNIC_FNIC_FLOGI_RETRIES_MAX, c->flogi_retries);

regards,
dan carpenter
