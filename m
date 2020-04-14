Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D02EC2BBC7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 00:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D96CA2087E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 00:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bMlhcscJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390517AbgDNAfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 20:35:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390511AbgDNAfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 20:35:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E0Y6c5019882;
        Tue, 14 Apr 2020 00:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7Iq+/u+CFj3ODeGE1pDD3GmlLAy1/msf+XdyG2CFVCA=;
 b=bMlhcscJvBFPIwgiNh7aaO2CTU0+h5KAVq53aEufNmeGwMxCTwwm4g5PFMJ97m1r9jri
 r02soCGjNanDaUwB+WpRpS1sDN1xwhhZ9if+tz210eLAiKsGoUketuunwXFpgIYLwcqs
 GgAEa8K7dW8da+t9xt0wQL96bfxBj2im6xGTiDZ3UY7DpkjeFyAIXJ9C6+g2EKtWO8CV
 iL96k7dyC4ccUyBRaN8Txk6G/i1rhqUMF3SDxGkJPIPTll1BhMXgX5C3U8cT03I8+KGC
 x4dho1v00Tn9PGY1lxKhmtJKxYAGZa3GpW2YpfBw1Gid1zDevbWxJ8bAchymDYvThbjD QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30b6hphg15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 00:34:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E0VuSe135929;
        Tue, 14 Apr 2020 00:34:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30bqpe1ujc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 00:34:47 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03E0YiQK022067;
        Tue, 14 Apr 2020 00:34:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 17:34:44 -0700
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list),
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was off
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
Date:   Mon, 13 Apr 2020 20:34:40 -0400
In-Reply-To: <1585362454-5413-1-git-send-email-cang@codeaurora.org> (Can Guo's
        message of "Fri, 27 Mar 2020 19:27:31 -0700")
Message-ID: <yq1imi2vra7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> During suspend, if the link is put to off, it would require a full
> initialization during resume. This patch resets and restores both the
> hba and the card during initialization.

Avri, Alim: Any opinions on this change in behavior wrt. your
controllers? Would a quirk or callback be preferred to changing this for
everyone?

-- 
Martin K. Petersen	Oracle Linux Engineering
