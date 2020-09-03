Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2DBC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FD620773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Iqv/SUjN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgICDB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:01:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51184 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgICDBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:01:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 083303P2044417;
        Thu, 3 Sep 2020 03:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=gJebapv7HbKLtogWG/ssdZsKojIkNMvNOHZgmpDXYo8=;
 b=Iqv/SUjNmtDrOg7DmyI3zIr74GIog7cQtOeO8lKj3dJUJ0lqdfdzezb9mY3q/cHyx8Qp
 3IjUfHQFF68PaNwvgbWziA4j8MQpKOKqyn4dxRuWJ5et+MajtzrmiU4Mn7mfJVKKwYQX
 auiTZ9ZiiVBzkZU3roMyINVN8I72r8sLKUgNxNGddRMV7galcM4qbljRonuJ5LmiFwP4
 AMRhY8woqJQMoPSSUH7+j1YOVFBogRGwUs9tW2zSkwDuD6GlVbS5hkkhlVaOzrk32LAQ
 TvqdGYYh2DiBqwKK/7Jh9FoUrtPmaa2i5cIDa1U4K/W3TX7YczKu4q1ps6yVU0FN6j+L pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eer67m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:01:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832tqr4153150;
        Thu, 3 Sep 2020 03:01:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3380y10h2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08331ChU031534;
        Thu, 3 Sep 2020 03:01:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:12 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        shivasharan.srikanteshwara@broadcom.com, sumit.saxena@broadcom.com,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] scsi: megaraid_sas: Don't call disable_irq from process IRQ poll
Date:   Wed,  2 Sep 2020 23:01:03 -0400
Message-Id: <159910202092.23499.14124269730579133176.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827165332.8432-1-thenzl@redhat.com>
References: <20200827165332.8432-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=820 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=833 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Aug 2020 18:53:32 +0200, Tomas Henzl wrote:

> disable_irq might sleep, replace it with disable_irq_nosync which is sufficient,
> irq_poll_scheduled protects againt running complete_cmd_fusion in parallel
> from megasas_irqpoll and megasas_isr_fusion.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Don't call disable_irq from process IRQ poll
      https://git.kernel.org/mkp/scsi/c/d2af39141eea

-- 
Martin K. Petersen	Oracle Linux Engineering
