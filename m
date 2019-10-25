Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E34CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C73E02053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505159AbfJYQND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505145AbfJYQNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG9R1G178593
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vv205wsqw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:59 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsJo58523664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 321AC11C052;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ED1C11C04C;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-000743-R6; Fri, 25 Oct 2019 18:12:53 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 00/11] zfcp: retrieve local RDP data, fix and cleanup
Date:   Fri, 25 Oct 2019 18:12:42 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0028-0000-0000-000003AF90D3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0029-0000-0000-00002471C7A7
Message-Id: <cover.1571934247.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello all,

this is the second version of my RDP patchset for zfcp, after I noticed
a memory-leak in the first version earlier this year. Here is the
original description, which remains valid:

    With FC-LS-3 Fibre Channel got support for the RDP Extended Link
    Service, which we can use to gather diagnostics data (health values
    from the optics and such). To gather those data from our local link,
    the FCP Channel firmware (for FCP and Ficon Express adapters) added
    some new fields in our Exchange Port Data firmware command
    (primarily SFP data).
        This patchset adds a new sysfs-directory below our
    adapter-object and several files in that to read those new fields.
        Additionally this also adds a file to read the buffer-to-buffer
    credit value from our local port (also something that can be
    gathered using the RDP ELS).
    
    The main purpose of the data from RDP requests (at least in my mind)
    are to catch some otherwise hard to track down errors, like dirt on
    the fibre and such (I would expect optics data to degraded with such
    conditions). These things are a pain to track down because it
    doesn't cause the link to go away, just some sporadic errors that
    can result in incomplete exchanges and such.
    
    The patchset is somewhat big because I don't want to issue a single
    Exchange Port/Config Data command for each read of those files,
    which would generate unnecessary traffic (and possibly inconsistent
    data) on our command-queue (we don't have an admin-queue or some
    such). So it also adds a (time-based) mechanism to cache data from
    Exchange Config/Port Data.
        We also want to prevent our adapter-structure from growing,
    which would further grow Scsi_Host, which is already too damn big,
    so these data are decoupled.
    
    More details are in the patches themselves.

Additionally to this, there are two more patches from Steffen that we
want to include, the first (patch 10) is just a cleanup for better
readability, the second (patch 11) is a fix/improvement for our
tracing-feature to make traces of failed FCP requests better. Even
though Steffen flagged the later as fix, I don't think we need extra
handling for it, if it goes in with the rest, thats fine - its nothing
pressing.

Reviews are highly welcome :-).

James, Martin, if there are no objections, it would be nice if you could
still include this in the merge for 5.5.

FYI: I also plan to/am in the middle of writing a simple command-line
     tool to send RDP to all/certain available remote/local FC-Ports in
     the System and present them in a sane format (sane to me ;-) ).
     This could be used for logging, or while gathering debug-data from
     a system.

     The RDP ELS' to remote ports will be send using BSG. Local data
     (for zFCP) would be read using this new interface.

     If anyone is interested, I can point it out on the list once I have
     something that has at least a minimum set of functionality.

Benjamin Block (9):
  zfcp: signal incomplete or error for sync exchange config/port data
  zfcp: diagnostics buffer caching and use for exchange port data
  zfcp: add diagnostics buffer for exchange config data
  zfcp: support retrieval of SFP Data via Exchange Port Data
  zfcp: introduce SysFS interface for diagnostics of local SFP
    transceiver
  zfcp: implicitly refresh port-data diagnostics when reading SysFS
  zfcp: introduce SysFS interface to read the local B2B-Credit
  zfcp: implicitly refresh config-data diagnostics when reading SysFS
  zfcp: move maximum age of diagnostic buffers into a per-adapter
    variable

Steffen Maier (2):
  zfcp: proper indentation to reduce confusion in zfcp_erp_required_act
  zfcp: trace channel log even for FCP command responses

 drivers/s390/scsi/Makefile     |   2 +-
 drivers/s390/scsi/zfcp_aux.c   |  12 +-
 drivers/s390/scsi/zfcp_dbf.c   |   8 +-
 drivers/s390/scsi/zfcp_def.h   |   4 +-
 drivers/s390/scsi/zfcp_diag.c  | 305 +++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_diag.h  | 101 +++++++++++
 drivers/s390/scsi/zfcp_erp.c   |   4 +-
 drivers/s390/scsi/zfcp_ext.h   |   1 +
 drivers/s390/scsi/zfcp_fsf.c   |  73 +++++++-
 drivers/s390/scsi/zfcp_fsf.h   |  21 ++-
 drivers/s390/scsi/zfcp_scsi.c  |   4 +-
 drivers/s390/scsi/zfcp_sysfs.c | 170 +++++++++++++++++-
 12 files changed, 683 insertions(+), 22 deletions(-)
 create mode 100644 drivers/s390/scsi/zfcp_diag.c
 create mode 100644 drivers/s390/scsi/zfcp_diag.h

-- 
2.21.0

