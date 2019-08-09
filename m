Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F956C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 23:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15932166E
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 23:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfHIXPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Aug 2019 19:15:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7526 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726125AbfHIXPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Aug 2019 19:15:23 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79NCChv051810;
        Fri, 9 Aug 2019 19:15:15 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u9hb69trn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 19:15:14 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x79NF8gD016811;
        Fri, 9 Aug 2019 23:15:14 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 2u51w67smj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 23:15:14 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x79NFCCr35389832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Aug 2019 23:15:12 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98F836A058;
        Fri,  9 Aug 2019 23:15:12 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DB856A057;
        Fri,  9 Aug 2019 23:15:11 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.173.245])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  9 Aug 2019 23:15:11 +0000 (GMT)
Message-ID: <1565392510.17449.18.camel@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 17/20] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
From:   James Bottomley <jejb@linux.vnet.ibm.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org,
        kbuild test robot <lkp@intel.com>
Date:   Fri, 09 Aug 2019 16:15:10 -0700
In-Reply-To: <20190807114252.2565-18-dgilbert@interlog.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
         <20190807114252.2565-18-dgilbert@interlog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=894 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090227
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2019-08-07 at 13:42 +0200, Douglas Gilbert wrote:
> Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
> are meant to be (almost) drop-in replacements for the write()/read()
> async version 3 interface. They only accept the version 3 interface.

I don't think we should do this at all.  Anyone who wants to use the
new async interfaces should use the v4 headers.  As Tony Battersby
already said, the legacy v3 users aren't going to update, so there's no
point at all introducing new interfaces for v3.  We simply keep the v3
only read/write interface until there are no users left and it can be
eliminated.

James

