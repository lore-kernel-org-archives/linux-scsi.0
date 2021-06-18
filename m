Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE549C48BE8
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 12:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 811BF613EB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Jun 2021 12:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhFRMRC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 08:17:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230491AbhFRMRC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 08:17:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15IC2pEe112599;
        Fri, 18 Jun 2021 08:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qvwS2lFbRm53kH580JKIETN5K7kz0+fX5Gito+fMXjo=;
 b=lNHFZmThZggoDL6FRl58egK9XBZlt3JRFIra+ZUR/sNSR/gb76HiC+RZyFUa3ZxR+LXE
 +oelQFqvMJxqppBYx/f0s7lbHeDOC4d6hTqMGUexTrtq10susKxOYpqNgP6wa6Br1Ctl
 5LDa3+FftpRilLEeigz8AoFNmESlWhgHGusWn0hxloANey1wbldVms5rbCmD1EYHrccR
 qGsHS0qeGwflaYPEOgbOHFEUdhbDCpo6HEuXRiWdZfzc9k5sM9JbVkGe9AdEifs09D4z
 HTlbqfJFbYnXTFa1/6KPkC5huirBvgA5kPYK/9FS8PVVR2n3ji5zIt5VNkHMHsI03/Fl iA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 398ph7rp4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 08:14:42 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15ICDCNo030769;
        Fri, 18 Jun 2021 12:14:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 394m6hu9m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 12:14:41 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15ICEcbT16318788
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Jun 2021 12:14:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A903EA4066;
        Fri, 18 Jun 2021 12:14:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92BC4A4054;
        Fri, 18 Jun 2021 12:14:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 18 Jun 2021 12:14:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 4A043E0657; Fri, 18 Jun 2021 14:14:38 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     hare@suse.de
Cc:     hch@lst.de, james.bottomley@hansenpartnership.com, jslaby@suse.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        borntraeger@de.ibm.com
Subject: Re: [Patch 1/2] virtio_scsi: do not overwrite SCSI status
Date:   Fri, 18 Jun 2021 14:14:37 +0200
Message-Id: <20210618121437.761050-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610135833.46663-1-hare@suse.de>
References: <20210610135833.46663-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VjKXz-wGQDDQ2O50HF1ooN5di0h_HixM
X-Proofpoint-GUID: VjKXz-wGQDDQ2O50HF1ooN5di0h_HixM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-18_07:2021-06-18,2021-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=565 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106180071
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FWIW,
I have just bisected a virtio-scsi failure to "scsi: Kill DRIVER_SENSE"
and this patch "repairs" the problem.
