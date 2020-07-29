Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07CEC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC6420768
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 04:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MK33h8Nl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgG2ENM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:13:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgG2ENM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 00:13:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T4BeT6185262;
        Wed, 29 Jul 2020 04:12:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EqfBF+/AfsEOvyuJfrvD5JwsEZvjCJZWDmFxbEAViGo=;
 b=MK33h8NlvyxdrZJo6Q5SThfSRn8ANeZiueREJY8JEDRW2bIGUb6Ip6UkNGzX/xNCq/j6
 +oy4ny4X0cOVFDzk97/v74n014vbryKqC7k56wYKgL+hffq12QJn8IoQcR/8H9vtMSKs
 rV1anPNVvjvnVHgyGKzY5k2QYehTkAtQsrBZ01U/Y+W15rPTFR3lyQGAnacrGy1EZGpv
 ABYCX2EiHCFgx+RAScqto5HFX6O4TFweBkEEgmaJTV1F2dICMUBGipuk5RoYx2eZHum4
 NtMr20k+sJBw3/k4coRE87Kf9CYqM/hvOzlAEJ2fxea23ZDeN3maFV994PeX9ue726cY 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32hu1jk664-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Jul 2020 04:12:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T42jgo150869;
        Wed, 29 Jul 2020 04:10:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 32hu5v59pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 04:10:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06T4AioN011196;
        Wed, 29 Jul 2020 04:10:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:10:43 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hch@infradead.org, gerry.morong@microchip.com,
        Justin.Lindley@microchip.com, joseph.szczypek@hpe.com,
        scott.benesh@microchip.com, mahesh.rajashekhara@microchip.com,
        POSWALD@suse.com, scott.teel@microchip.com,
        jejb@linux.vnet.ibm.com, Kevin.Barnett@microchip.com,
        Don Brace <don.brace@microsemi.com>,
        bader.alisaleh@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] hpsa: correct ctrl queue depth
Date:   Wed, 29 Jul 2020 00:10:35 -0400
Message-Id: <159599579268.11289.13032481347420305993.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <159562590819.17915.12766718094041027754.stgit@brunhilda>
References: <159562590819.17915.12766718094041027754.stgit@brunhilda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=830
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=846
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Jul 2020 16:25:08 -0500, Don Brace wrote:

>  - need to set queue depth for controller devices.
>  - corrects compiler warning in patch:
>    hpsa-increase-ctlr-eh-timeout

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: hpsa: Correct ctrl queue depth
      https://git.kernel.org/mkp/scsi/c/5759ff1131cd

-- 
Martin K. Petersen	Oracle Linux Engineering
