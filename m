Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C329C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 19:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 183CF6108D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 19:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhHSTZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 15:25:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233919AbhHSTZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Aug 2021 15:25:25 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JJ4ZsS044323;
        Thu, 19 Aug 2021 15:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=OGAhYv1KSyzhXvai4Q1Eg1XJ3MtmcnjRGGent1VmPOQ=;
 b=k/ZomyALtN9NIOrNkMuc/fX+TopuSKpD8ayzsGgyZ1uw7GHrZt+oceYhQ8Vk64WeWUMO
 2LWit4UOKY085qrl4OlWmvPJFD5/yWXf4V/JNYCNcBORzuurf8+3o7iY7oKZIlKfw/y6
 wDQ9XCHM+ZoegFbDm6Suj0YZF2b4dpZG5q4dkGSG1dWTQ/H7elz+tpfoKkSDlZ5eujCY
 2mlmOdHhRhVO+YxCpaVipJt+sFzR+oCnv8kIrbAxH9DVTQMCkLnQKL1Gl1H6+AUVHXh1
 LKuOI7SlOeu0OB9z6fmAOkHhHLcufXH7o0vmYtUmMRr+SyjrlPIgrEmIT4h4Vq9qKlj0 UQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ahkabm5km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 15:24:36 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17JJ8cvb001783;
        Thu, 19 Aug 2021 19:24:35 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3ae5fgdrrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 19:24:35 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17JJOYrv50004246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Aug 2021 19:24:34 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2D2778069;
        Thu, 19 Aug 2021 19:24:33 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9151378068;
        Thu, 19 Aug 2021 19:24:32 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.160.128.138])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Aug 2021 19:24:32 +0000 (GMT)
Message-ID: <5b66128e04e9a88cb8f67eae1ff4ee49e79441e3.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation
 issues
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, mdr@sgi.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de
Date:   Thu, 19 Aug 2021 12:24:31 -0700
In-Reply-To: <7107778e-8e20-22ab-bf94-d26aca09bd93@acm.org>
References: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
         <1629365549-190391-3-git-send-email-john.garry@huawei.com>
         <7107778e-8e20-22ab-bf94-d26aca09bd93@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Dww2G8tmkgtSSYXt-nqAHIxw-xKPeNxU
X-Proofpoint-ORIG-GUID: Dww2G8tmkgtSSYXt-nqAHIxw-xKPeNxU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_07:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1011 mlxlogscore=999 suspectscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108190112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-08-19 at 11:07 -0700, Bart Van Assche wrote:
> On 8/19/21 2:32 AM, John Garry wrote:
> > The driver does not compile under DEBUG_QLA1280 flag:
> > - Debug statements expect an integer for printing a SCSI lun value,
> > but
> >    its size is 64b. So change SCSI_LUN_32() to cast to an int, as
> > would be
> >    expected from a "_32" function.
> > - lower_32_bits() expects %x, as opposed to %lx, so fix that.
> > 
> > Also delete ql1280_dump_device(), which looks to have never been
> > referenced.
> > 
> > Signed-off-by: John Garry <john.garry@huawei.com>
> > ---
> >   drivers/scsi/qla1280.c | 27 ++-------------------------
> >   1 file changed, 2 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> > index b4f7d8d7a01c..9a7e84b49d41 100644
> > --- a/drivers/scsi/qla1280.c
> > +++ b/drivers/scsi/qla1280.c
> > @@ -494,7 +494,7 @@ __setup("qla1280=", qla1280_setup);
> >   #define CMD_HOST(Cmnd)		Cmnd->device->host
> >   #define SCSI_BUS_32(Cmnd)	Cmnd->device->channel
> >   #define SCSI_TCN_32(Cmnd)	Cmnd->device->id
> > -#define SCSI_LUN_32(Cmnd)	Cmnd->device->lun
> > +#define SCSI_LUN_32(Cmnd)	((int)Cmnd->device->lun)
> 
> How about using 'unsigned int' instead of 'int' since LUN numbers
> are positive integers?

All the use points in the driver are ints currently so matching the use
makes more sense than matching the standard and risking signed to
unsigned conversion warnings.

James


