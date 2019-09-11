Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A8BC49ED7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 01:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC3C206CD
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 01:32:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qtYO+AHE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfIKBcS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 21:32:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49790 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfIKBcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 21:32:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B1TRda149121;
        Wed, 11 Sep 2019 01:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=/gEiZw6HxMYIapBA0xw+xW7vNlgRM4eqlo8x2K2gVTQ=;
 b=qtYO+AHESPESCXiVE9+ZhO5m8af15YvA+7rS2+Li4SzxUiazPF8mwRD3In3HV1V3djH1
 lH+m0MIN4gzBw7bFM4xY9Dbce3lWfSU1yN5Jr/yb4+SaOsSJ129J7R6Wir/B12sHz0Zy
 4gYvcNJxkjEACbsCyej9qQXIumPC9T9Btz/A4G/pVpPZVU1ltpTGOLnaF/PyusiO93OI
 PpoHeqzu2gP195T9rOse6zUBzBqj52TV6hX3RyPprtgqpDkzay4EMw7u6Gcws2ecyuEl
 sFDO9fHVyJG8sDmvH8aBoTdhPsS+KxLuArJ3/5G/W44ehgkFPDN6TRDdgB9weh7rympL Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uw1m8xupv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 01:31:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B1T2VN089759;
        Wed, 11 Sep 2019 01:31:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uxj887kmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 01:31:47 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8B1Vj6t031933;
        Wed, 11 Sep 2019 01:31:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 18:31:45 -0700
To:     Martin Wilck <Martin.Wilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Ales Novak <alnovak@suse.cz>
Subject: Re: [PATCH] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190904155205.1666-1-martin.wilck@suse.com>
Date:   Tue, 10 Sep 2019 21:31:40 -0400
In-Reply-To: <20190904155205.1666-1-martin.wilck@suse.com> (Martin Wilck's
        message of "Wed, 4 Sep 2019 15:52:29 +0000")
Message-ID: <yq1blvrfwjn.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=876
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=947 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110007
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Martin,

> cdb in send_mode_select() is not zeroed and is only partially filled
> in rdac_failover_get(), which leads to some random data getting to the
> device. Users have reported storage responding to such commands with
> INVALID FIELD IN CDB. Code before commit 327825574132 was not
> affected, as it called blk_rq_set_block_pc().

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
