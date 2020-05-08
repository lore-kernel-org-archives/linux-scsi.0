Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E29C54E4B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F9020731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 17:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgEHRXv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 13:23:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727830AbgEHRXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 13:23:49 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048H2xAG121444;
        Fri, 8 May 2020 13:23:47 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30vtxqatug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 13:23:46 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 048H4vZv024845;
        Fri, 8 May 2020 17:23:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5nkh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 17:23:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 048HNcIH58655200
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 May 2020 17:23:38 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9CFFAE055;
        Fri,  8 May 2020 17:23:38 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96A09AE045;
        Fri,  8 May 2020 17:23:38 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.54.185])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 May 2020 17:23:38 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1jX6in-002wrM-P2; Fri, 08 May 2020 19:23:37 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 0/8] zfcp: fix DIF/DIX support with scsi-mq host-wide tag-set
Date:   Fri,  8 May 2020 19:23:27 +0200
Message-Id: <cover.1588956679.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_15:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080144
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin, James, linux-scsi folks,

some time ago we noticed - Fedor did - that our DIV and DIX support in
zfcp broke at some point. I tracked that down to a commit made for v5.4
(737eb78e82d5), but we didn't notice it back than, because our CI
doesn't currently run with either DIV, nor DIX enabled (time allowing
this is something we want to improve so we catch stuff like this
earlier). It also turned out that the commit in v5.4 was not really the
root-cause, and was only making the problem visible more easy.

I wrote a rather verbose description/analysis of the problem in patch 8.

In short: zfcp used to allocate/add the shost object for a HBA before
knowing all the HBA's capabilities, and we later patched the shost
object to make more of the capabilities known - including the protection
capabilities. Back when we still had the old blk queue, this worked
fine; after scsi_mod switched to blk-mq and because requests are now
all allocated during allocation time of the blk-mq tag-set, this doesn't
work anymore. Changes we make later to the protection capabilities don't
get reflected into the tag-set's requests, and they are missing parts.
When we then try to send I/O, scsi_mod tries to access the protection
payload data, who are not there, and it crashes the kernel.
    So instead, I now want to allocate/add the shost object for a HBA
after we know all of its base capabilities. This solves the
bug.
    For more details, please see patch 8.

I guess one could say this is a regression, but after thinking about it
for a bit I thought its reasonable to assume that zfcp behaves rather
different here than other drivers, because no one else seems to have
this issue, and so I tried to fix it in zfcp - also with the thought
that this hopefully reduces the risk of further such regressions in the
future.

Because we had this modus operandi for a very long time, I had to touch
many places that assume the shost object was already allocated -
explaining the rather big patchset for a 'fix'. Patches 1 to 7 are
preparations that fix all those places, so we don't access invalid
memory, and we don't loose any information during the HBA
initialization. Patch 8 finally moves the shost object allocation/add.


I assume we can't have this in stable, because the new code depends on a
feature from v5.5 that won't be in all release that would need this
fix... making it rather complicated. Its also too big for stable I
assume.


I tested this extensively internally to hopefully catch any bugs, so far
I have not seen any. I ran our regression-suite with DIV/DIX/NONE; with
I/O, and local/remote cable pulls, switched and p-t-p. Additionally I
had some inject running that would make early initialization fail in
places where we usually already had the shost object allocated; and I
made the shost object allocation/add fail; to see we don't crash, and
can recovery fine once the injects are turned off.


The patches apply fine on both Martin's `5.7/scsi-fixes`, and James'
`fixes` branches. It would be great if you could still get them into 5.7
somehow, but I realise its late in the cycle, and the series might be
too big at this point.


Any comments and reviews are appreciated :)


Benjamin Block (8):
  zfcp: move shost modification after QDIO (re-)open into fenced
    function
  zfcp: move shost updates during xconfig data handling into fenced
    function
  zfcp: move fc_host updates during xport data handling into fenced
    function
  zfcp: fence fc_host updates during link-down handling
  zfcp: move p-t-p port allocation to after xport data
  zfcp: fence adapter status propagation for common statuses
  zfcp: fence early sysfs interfaces for accesses of shost objects
  zfcp: move allocation of the shost object to after xconf- and
    xport-data

 drivers/s390/scsi/zfcp_aux.c   |   5 +-
 drivers/s390/scsi/zfcp_diag.h  |   6 +-
 drivers/s390/scsi/zfcp_erp.c   |  84 ++++++++++++++++++++-
 drivers/s390/scsi/zfcp_ext.h   |  11 +++
 drivers/s390/scsi/zfcp_fsf.c   |  76 +++++--------------
 drivers/s390/scsi/zfcp_qdio.c  |  19 +++--
 drivers/s390/scsi/zfcp_scsi.c  | 131 ++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_sysfs.c |  16 +++-
 8 files changed, 265 insertions(+), 83 deletions(-)

-- 
2.17.1

