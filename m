Return-Path: <SRS0=mfkc=YF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43D4C47404
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Oct 2019 02:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B778220679
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Oct 2019 02:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfJLCGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Oct 2019 22:06:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfJLCGU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Oct 2019 22:06:20 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9C22WgA090264;
        Fri, 11 Oct 2019 22:06:11 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vk1hmpesa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 22:06:11 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x9C22Wmc024014;
        Sat, 12 Oct 2019 02:06:10 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 2vejt8ed83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Oct 2019 02:06:10 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9C2699Z54919612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 02:06:09 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55D3FAE060;
        Sat, 12 Oct 2019 02:06:09 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F264AE05C;
        Sat, 12 Oct 2019 02:06:08 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.184.117])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 12 Oct 2019 02:06:08 +0000 (GMT)
Message-ID: <1570845968.17735.28.camel@linux.ibm.com>
Subject: Re: [PATCH v2] scsi: core: fix uninit-value access of variable sshdr
From:   James Bottomley <jejb@linux.ibm.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Date:   Fri, 11 Oct 2019 19:06:08 -0700
In-Reply-To: <783b66dc-e7e9-3780-3041-7ab03491def5@huawei.com>
References: <1570843610-63645-1-git-send-email-zhengbin13@huawei.com>
         <1570845482.17735.27.camel@linux.ibm.com>
         <783b66dc-e7e9-3780-3041-7ab03491def5@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-11_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=765 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910120012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2019-10-12 at 10:03 +0800, zhengbin (A) wrote:
> On 2019/10/12 9:58, James Bottomley wrote:
> > On Sat, 2019-10-12 at 09:26 +0800, zhengbin wrote:
> > > BTW: we can't just init sshdr->response_code, sr_do_ioctl use
> > > sshdr->sense_key
> > 
> > That's an actual bug, isn't it?
> 
> If we init sshdr in __scsi_execute, this will be ok

No I mean it's a bug because sr_do_ioctl shouldn't be acting on sense
that isn't valid.  So all uses of sshdr should be gated on a validity
check.

James

