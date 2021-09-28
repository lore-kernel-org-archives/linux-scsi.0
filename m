Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050CBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 17:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74C460F4A
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 17:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241848AbhI1RDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 13:03:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241907AbhI1RDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 13:03:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SF8RmH027315;
        Tue, 28 Sep 2021 13:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=n4M5qxYQwxEvwXWfT0WLF4/TMIty3N9rdx+Y2SuCJgQ=;
 b=BEo8Ikl4geEtmz2e0AACyg/WxW4/+CYZAx1XT4vKE8i/Ru2yCrsOmVW7RHDey7JZOxKO
 6OWiCsWx2cyr0Q9RsCVD+GbNYIQqpfqXhBeAvziIq9+dCy+OKxbj4WOwMBf7iv4kBf57
 uaMHnmZ4N4+VE71sCZqBa0fEsxnrxs7O8N1G4KTsL65UW4b9xs1j1mmP1mPGXYq5EMd8
 JN+h0oA2uP0yD8zra/FxAROtts0R+cqqYDgi2tPdhkQYZA3au3FHpCp7NUdmwyazs13T
 KXywYr92uNCrOs+/XgKa30HZ7gFrGL6NQ57cdOqC/pLMkyfWpAqJhkoUcFTqnM55aK8k +Q== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbxyfuv46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 13:01:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SGxS8L015881;
        Tue, 28 Sep 2021 17:01:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3b9ud9r2ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 17:01:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SH160x5767708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 17:01:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B9EA42049;
        Tue, 28 Sep 2021 17:01:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37D8F42045;
        Tue, 28 Sep 2021 17:01:06 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.153])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Sep 2021 17:01:06 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mVGTZ-000Egh-M7; Tue, 28 Sep 2021 19:01:05 +0200
Date:   Tue, 28 Sep 2021 19:01:05 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 08/84] zfcp_scsi: Call scsi_done() directly
Message-ID: <YVNKUbCnN3VtnSPr@t480-pf1aa2c2.linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-9-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210918000607.450448-9-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IJxE6jYvyacS9Zi6ytkcj2vjEmG_XOEt
X-Proofpoint-ORIG-GUID: IJxE6jYvyacS9Zi6ytkcj2vjEmG_XOEt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 05:04:51PM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/s390/scsi/zfcp_fsf.c  | 2 +-
>  drivers/s390/scsi/zfcp_scsi.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
