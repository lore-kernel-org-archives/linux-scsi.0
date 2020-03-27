Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283C5C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 03:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2A1C2082D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 03:00:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sIJbJpgh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgC0DAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 23:00:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58284 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0DAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 23:00:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2rHX1004219;
        Fri, 27 Mar 2020 03:00:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=/wkiygzUoOpQBZUiBLbZ9w4yqD+TzEh+mMQY5zK1otU=;
 b=sIJbJpghTsia/bckgGbtItBDEBVkW9TRgAuZC7bFdltY1zbJLzeEiQOJv2dSHv6/jwSb
 fCholSEZT/lkSRaaQ8cannQizUMbBtamdhViGb0E98zl7rcZpRZkc8RT8pUvTsPXU2dE
 8ycZ8S0GlFp0zq2Y8Yc0BTwJT3Mr7+wbyhO2zP03CvwfZsuP4KRNC1WC/QWzsWH/F5g+
 2eCJkjtJVb38yXu/ZySfDEJAf3+3tC9yTDgnut5RkiOpGRj6PCRBdUPVEgqIW/QY/3L4
 7lSSCEjBybBH11c2danVRGFX9BBu/K8N0jQuv7b+YD2VSNdbi3h/nskmNspjnCZzDBpP Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3014598rng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 03:00:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2qrxu127717;
        Fri, 27 Mar 2020 02:58:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4uvbn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:58:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R2wOrN014275;
        Fri, 27 Mar 2020 02:58:24 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:58:24 -0700
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: Re: [PATCH v6 2/2] scsi: ufs: Do not rely on prefetched data
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1585214742-5466-1-git-send-email-cang@codeaurora.org>
        <1585214742-5466-3-git-send-email-cang@codeaurora.org>
Date:   Thu, 26 Mar 2020 22:58:19 -0400
In-Reply-To: <1585214742-5466-3-git-send-email-cang@codeaurora.org> (Can Guo's
        message of "Thu, 26 Mar 2020 02:25:41 -0700")
Message-ID: <yq1lfnmcxmc.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> We were setting bActiveICCLevel attribute for UFS device only once but
> type of this attribute has changed from persistent to volatile since
> UFS device specification v2.1. This attribute is set to the default
> value after power cycle or hardware reset event. It isn't safe to rely
> on prefetched data (only used for bActiveICCLevel attribute
> now). Hence this change removes the code related to data prefetching
> and set this parameter on every attempt to probe the UFS device.

Applied patch #2 to 5.7/scsi-queue. Awaiting Avri's feedback on patch
#1. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
