Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEB2C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 09:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiGHJFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 05:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHJFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 05:05:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24867C05;
        Fri,  8 Jul 2022 02:05:32 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2688oiSS020124;
        Fri, 8 Jul 2022 09:05:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XkARPEYVGEWhIFw6qJEb/Z2vhxP5S+elQY5DtiOkqVM=;
 b=CyKRBTV8L4J8FDpLGevtpbFAkFV9zFvh4sFF/2ez0CGJafXKFCDClbJ3+/GJx0YDAJG2
 24iieRQ7aUeCgW0H/UUndPFSX77YA70WsvcgjP5iUTP14l3AmCgYxsHx9vzdXOd3bomX
 Moxp1BaFGa97NobiIQ1b40NK/G65sT/VGqGLoRQK/C8v9u4YYaV6xLrk/6+I6MqWl2R4
 vFPjlaCn8t5ob9HtZsqxXRLkSh4DxwLVfnPq/1MWr2UlxUAR15eJlWVmm70RnoSjgvUA
 ASuGcfscNdyv++X2QLzPMbCmoZjPGjWf8ZwCPHPWynJfeGMwtVX/EhtCv/nFmRb1w6i+ uw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6he88b0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 09:05:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2688Zoui006503;
        Fri, 8 Jul 2022 09:05:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3h4v4jurfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 09:05:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26895LeF12779852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 09:05:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00674A405C;
        Fri,  8 Jul 2022 09:05:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1961A405B;
        Fri,  8 Jul 2022 09:05:20 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.39.141])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 Jul 2022 09:05:20 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.95)
        (envelope-from <bblock@linux.ibm.com>)
        id 1o9jvM-005n5n-Hf;
        Fri, 08 Jul 2022 11:05:20 +0200
Date:   Fri, 8 Jul 2022 09:05:20 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Jiang Jian <jiangjian@cdjrlc.com>, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/2] zfcp changes for v5.20
Message-ID: <YsfzUCBsWyyvXICL@t480-pf1aa2c2.fritz.box>
References: <cover.1657122360.git.bblock@linux.ibm.com>
 <yq11quw620k.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <yq11quw620k.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xeOjw2d7w11PPGMiXwC951XhlhvJpzVP
X-Proofpoint-ORIG-GUID: xeOjw2d7w11PPGMiXwC951XhlhvJpzVP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=840 impostorscore=0
 phishscore=0 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 07, 2022 at 05:34:11PM -0400, Martin K. Petersen wrote:
> 
> Benjamin,
> 
> > here is a (very) small set of changes for the zFCP device driver. The
> > change from Jiang Jian came in recently, and Julian's patch has been
> > laying around for quite a while now, so I didn't want to let them
> > linger any longer in anticipation of any bigger change that might
> > come.
> 
> Applied to 5.20/scsi-staging, thanks!
> 

Thanks Martin.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
