Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4759EC7EE2F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 13:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbjFGNLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 09:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239921AbjFGNLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 09:11:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A23BA;
        Wed,  7 Jun 2023 06:11:14 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357Cphtr003314;
        Wed, 7 Jun 2023 13:11:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=t5s8RebZeR00TqgLkYt4kLHrJpmY40DsQes4jCSKcTs=;
 b=HQVCD3qf/SA2wWsIXON1U144fo3iNxMPRKw8BSJeQ377NJwltKdnCrjTwzEjRg7GKF2D
 iDGW8wDLG+k/AWOw20Rls9s5avq34V0KaUzKwQhyA9r+xybt4SfBSTY6vucJOqhSrwwA
 scalROf2UzlO0TEecPGYus2Yhpw7ibAObRvS6pUs0JffWugE/pGMDiVrd0L/6JVMDXE/
 t2tu9clnFQMe0jW24s+nZmQUsJnjSL+TScMpL/ilvcv7+7y9nUeNaJ5lhCvHtKFWIISV
 z9DWyLg4mBRxvYROuTvMPoXNTbaqBlkkrBj4Z+FOFDyuMybGIdT1HoSbb2YB2uGoyUr1 hw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r2t8yggnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 13:11:06 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3573VE8L027497;
        Wed, 7 Jun 2023 13:11:04 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3r2a77gfjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jun 2023 13:11:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 357DB2HT11862664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jun 2023 13:11:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E28A120043;
        Wed,  7 Jun 2023 13:11:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4A5020040;
        Wed,  7 Jun 2023 13:11:01 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  7 Jun 2023 13:11:01 +0000 (GMT)
Date:   Wed, 7 Jun 2023 15:10:59 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v7 1/19] ioprio: cleanup interface definition
Message-ID: <ZICB45/Mghr/rr6/@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20230511011356.227789-2-nks@flawful.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511011356.227789-2-nks@flawful.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VU_hE1d8PxkvcNs4xkhFy9wqJLkYo9Km
X-Proofpoint-ORIG-GUID: VU_hE1d8PxkvcNs4xkhFy9wqJLkYo9Km
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_06,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=996
 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306070109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 11, 2023 at 03:13:34AM +0200, Damien Le Moal wrote:
...
Hi Damien et al,

This patch aka commit eca2040972b4 ("scsi: block: ioprio:
Clean up interface definition") in -next breaks LTP test
(at least on s390):

# ./ioprio_set03
tst_test.c:1558: TINFO: Timeout per run is 0h 00m 30s
ioprio_set03.c:39: TFAIL: ioprio_set IOPRIO_CLASS_BE prio 8 should not work
ioprio_set03.c:47: TINFO: tested illegal priority with class NONE
ioprio_set03.c:50: TPASS: returned correct error for wrong prio: EINVAL (22)

Summary:
passed   1
failed   1
broken   0
skipped  0
warnings 0

Thanks!
