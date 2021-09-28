Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE2CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 17:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2E5F61352
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 17:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241883AbhI1RGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 13:06:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240713AbhI1RGm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 13:06:42 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SF8iA8009211;
        Tue, 28 Sep 2021 13:04:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dxjZ3wRMA+YACBVV1GJXcT86/u6ZEP3LPs3owk9QmeA=;
 b=LgjS9w41CDWGI6jCvHu/OvimAE87bGwT2O4Hmwydb+gy5ZZczwPWOjKo+XYlERnMOBul
 LMpx0xXn9RB4c6V8D2mx59c1iRiWwWvmSrD+KyIofC28A8uqtI03JKbq3Kv9H8WsjkEQ
 1sd1Zf2ZpFBQ9kKl+8oPfpPPERphDfSfYYVttuFpsSEhXn/IbhXBy4bc29E3H1XL5YTF
 RQ8wU8RupfSPkPW+fWskbTp+/NeHbOFIW0IOYc+IauhktAMoGJk4+ULcjzQsCXN+vu/N
 UEiu3PCZ5uZ9BRMrAwbelQDsL1BNFX+QwK3NpQUi4ArY46NqVxlFUKKR10I84OI+U4PS 1A== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktr0cub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 13:04:57 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SH415h011583;
        Tue, 28 Sep 2021 17:04:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3b9ud9xgu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 17:04:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SH4p9846137692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 17:04:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B059A4062;
        Tue, 28 Sep 2021 17:04:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77B52A405C;
        Tue, 28 Sep 2021 17:04:51 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.153])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Sep 2021 17:04:51 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mVGXC-000Ggu-U4; Tue, 28 Sep 2021 19:04:50 +0200
Date:   Tue, 28 Sep 2021 19:04:50 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 84/84] scsi_lib: Call scsi_done() directly
Message-ID: <YVNLMg2cqWteTU6x@t480-pf1aa2c2.linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210922162603.476745-1-bvanassche@acm.org>
 <20210922162603.476745-6-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210922162603.476745-6-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dvIws0hetm0drpDPwsPh9XRwgXLiPuLy
X-Proofpoint-GUID: dvIws0hetm0drpDPwsPh9XRwgXLiPuLy
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 22, 2021 at 09:26:02AM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly. Since this patch removes the last user of the
> scsi_done member, also remove that data structure member.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c  | 3 +--
>  include/scsi/scsi_cmnd.h | 4 ----
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
