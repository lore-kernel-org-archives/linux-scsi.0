Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4685FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFCE20809
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 14:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgG2Oqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 10:46:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34998 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgG2Oqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 10:46:49 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TEk1TK181432;
        Wed, 29 Jul 2020 10:46:40 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32jqrt1vxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 10:46:40 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06TEjMvB017665;
        Wed, 29 Jul 2020 14:46:39 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 32gcy5th53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jul 2020 14:46:39 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06TEka1720971854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jul 2020 14:46:36 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B46707805C;
        Wed, 29 Jul 2020 14:46:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 155B57805E;
        Wed, 29 Jul 2020 14:46:36 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.80.208.235])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 29 Jul 2020 14:46:36 +0000 (GMT)
Message-ID: <1596033995.4356.15.camel@linux.ibm.com>
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Alan Stern <stern@rowland.harvard.edu>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Date:   Wed, 29 Jul 2020 07:46:35 -0700
In-Reply-To: <20200729143213.GC1530967@rowland.harvard.edu>
References: <20200706164135.GE704149@rowland.harvard.edu>
         <d0ed766b-88b0-5ad5-9c10-a4c3b2f994e3@puri.sm>
         <20200728200243.GA1511887@rowland.harvard.edu>
         <f3958758-afce-8add-1692-2a3bbcc49f73@puri.sm>
         <20200729143213.GC1530967@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_10:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0
 spamscore=0 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290095
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-29 at 10:32 -0400, Alan Stern wrote:
> On Wed, Jul 29, 2020 at 04:12:22PM +0200, Martin Kepplinger wrote:
> > On 28.07.20 22:02, Alan Stern wrote:
> > > On Tue, Jul 28, 2020 at 09:02:44AM +0200, Martin Kepplinger
> > > wrote:
> > > > Hi Alan,
> > > > 
> > > > Any API cleanup is of course welcome. I just wanted to remind
> > > > you that the underlying problem: broken block device runtime
> > > > pm. Your initial proposed fix "almost" did it and mounting
> > > > works but during file access, it still just looks like a
> > > > runtime_resume is missing somewhere.
> > > 
> > > Well, I have tested that proposed fix several times, and on my
> > > system it's working perfectly.  When I stop accessing a drive it
> > > autosuspends, and when I access it again it gets resumed and
> > > works -- as you would expect.
> > 
> > that's weird. when I mount, everything looks good, "sda1". But as
> > soon as I cd to the mountpoint and do "ls" (on another SD card "ls"
> > works but actual file reading leads to the exact same errors), I
> > get:
> > 
> > [   77.474632] sd 0:0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result:
> > hostbyte=0x00 driverbyte=0x08 cmd_age=0s
> > [   77.474647] sd 0:0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
> > [   77.474655] sd 0:0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
> > [   77.474667] sd 0:0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 00
> > 60 40 00 00 01 00
> 
> This error report comes from the SCSI layer, not the block layer.

That sense code means "NOT READY TO READY CHANGE, MEDIUM MAY HAVE
CHANGED" so it sounds like it something we should be ignoring.  Usually
this signals a problem, like you changed the medium manually (ejected
the CD).  But in this case you can tell us to expect this by setting

sdev->expecting_cc_ua

And we'll retry.  I think you need to set this on all resumed devices.

James

