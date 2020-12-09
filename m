Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02DBC4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DBBE23A5A
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbgLIRZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:25:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34698 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732438AbgLIRYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJMiq058822;
        Wed, 9 Dec 2020 17:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=rMmfjPpxsr6u3sGGRuFzxzF7rzYtcwNYg6utZgeCcbo=;
 b=ZfWAyWE8xo9ePF1XSFwOvCkZo87iIeRxm/yWkDXRN/T7qL5JaXgwcQJAyJJEEw1EuAO6
 yLHpeJcRwyxv3bTSwIIMH9ZAsZ2bG4awXBICfOjsuUNNfRcP/24i/LlmPRXVGqn3PNXw
 MmgR+xP1Zx5sJzlbapByMIKhBmxYQ5geCZ5Q8QQvhp6zU9bhB41uI4xjOIDJ30EIaSfJ
 zL92ffeE/CxDzz42zKRN2HVHwlJ7xXVut68/vg4CNUVoGhQZxMEupS20pkpWYHCjue7z
 +7ogJ/yCLaC2XMwXl01lD57PYO9u8iyOc+s/PsnaUx3Hi56j/fgzX6ThbHPzwJOuhmiK KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqc1fne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJmkf075867;
        Wed, 9 Dec 2020 17:23:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m50wgyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:55 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HNsB9014315;
        Wed, 9 Dec 2020 17:23:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:54 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Lee Duncan <lduncan@suse.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        open-iscsi@googlegroups.com
Subject: Re: [PATCH] scsi: iscsi: fix inappropriate use of put_device
Date:   Wed,  9 Dec 2020 12:23:18 -0500
Message-Id: <160753457753.14816.8140218142483943973.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120074852.31658-1-miaoqinglang@huawei.com>
References: <20201120074852.31658-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=931
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=945
 clxscore=1011 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 15:48:52 +0800, Qinglang Miao wrote:

> kfree(conn) is called inside put_device(&conn->dev) so that
> another one would cause use-after-free. Besides, device_unregister
> should be used here rather than put_device.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: iscsi: fix inappropriate use of put_device
      https://git.kernel.org/mkp/scsi/c/6dc1c7ab6f04

-- 
Martin K. Petersen	Oracle Linux Engineering
