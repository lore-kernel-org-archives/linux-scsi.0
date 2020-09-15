Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E626DC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45AC2080C
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:24:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zuAracgP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgIOUXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:23:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33462 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgIOUWg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 16:22:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKIKWe005289;
        Tue, 15 Sep 2020 20:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TnDy68QXwHqhErgx7hW/B1RJIBUXJT65ykDE+gQ4vdc=;
 b=zuAracgPYWMqCuMLq/5WXTa9CFgSuSPkO/5AFp/Y5RS9O/0q/e+i0+eSN7GE4h8fcac9
 By63AzXNOJvZm/R4sHJKNJPgsAu/FCiBqLqY/7skPCG3m5qf9PqV+KfWnngQVbhbzJGS
 mjRwjgUsLR9z8uTrcxMT2LCY2AUiII7TRgRZJWgvQHMpUV8xck0VFb4v3sg96GJkp8hO
 FniuwtpwMC0Of0S7SWRGuuqFTqRWlWlLzPr+3qXJHaPOJrDdzbP9GJ7dFjcVmSeeo/gX
 5y/sNHqy4i7P0UDbDtsEPjyVYt75IRqQQHOHVxR2Yb3ZhLsaOmZgm8Rk+QPLTtzkGP9n 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dh1nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:21:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKFpfb106804;
        Tue, 15 Sep 2020 20:21:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm3171h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:21:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FKLb47018439;
        Tue, 15 Sep 2020 20:21:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:21:36 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     Bean Huo <huobean@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Abort tasks before clear them from
 doorbell
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wo0u6bdw.fsf@ca-mkp.ca.oracle.com>
References: <1599099873-32579-1-git-send-email-cang@codeaurora.org>
        <1599099873-32579-2-git-send-email-cang@codeaurora.org>
        <1599627906.10803.65.camel@linux.ibm.com>
        <yq14ko62wn5.fsf@ca-mkp.ca.oracle.com>
        <1599706080.10649.30.camel@mtkswgap22>
        <1599718697.3851.3.camel@HansenPartnership.com>
        <1599725880.10649.35.camel@mtkswgap22>
        <1599754148.3575.4.camel@HansenPartnership.com>
        <010101747af387e9-f68ac6fa-1bc6-461d-92ec-dc0ee4486728-000000@us-west-2.amazonses.com>
        <d151d6a2b53cfbd7bf3f9c9313b49c4c404c4c5a.camel@gmail.com>
        <4017d039fa323a63f89f01b5bf4cf714@codeaurora.org>
Date:   Tue, 15 Sep 2020 16:21:32 -0400
In-Reply-To: <4017d039fa323a63f89f01b5bf4cf714@codeaurora.org> (Can Guo's
        message of "Tue, 15 Sep 2020 11:14:17 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150158
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> Do you know when can this change be picked up in scsi-queue-5.10?
> If I push my fixes to ufshcd_abort() on scsi-queue-5.10, they will
> run into conflicts with this one again, right? How should I move
> forward now?

You should be able to use 5.10/scsi-queue as baseline now.

For 5.11 I think I'll do a separate branch for UFS.

-- 
Martin K. Petersen	Oracle Linux Engineering
