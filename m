Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99311C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75C67208C9
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZmFcI8pU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgH1PDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:03:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726197AbgH1PC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 11:02:56 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SF2iO6091018;
        Fri, 28 Aug 2020 11:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=u3GT3t+mVGFoG2/sqsKNjy5riCz5nFHuHpPP2z4ZR3I=;
 b=ZmFcI8pUgFx1JLHvnT4qA0k/I3dnkZLrRBdyGVLnat88gzCweVLFRWFfpm2KKn+zo8k1
 WQdlNn8/tOOkeQB7tmAYcQzaEirJpzHNdW8hk4OWhNE6Oj6OdmtJMrYRKbCToFuwlPaK
 19t1NW+sonoI+rBseMAIf5DpiCik0qPS6muwa3Re2vfcx26L+TQEQNx6kPW7TMHVE6uC
 DggHTQzfg0sarlYvqRu0/bKxoqN3iQtaXB0m2jmXyEVFjHf+GkXszTX32DJ10DiSBcsy
 Y6ytBSdUk+Hfu/9RHY8aAkXF95YoCRK9ZUFwpGR29eGQRh/yykFojlGn6sLFYzRseOe1 Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33703xykvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 11:02:49 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07SF2l2g091351;
        Fri, 28 Aug 2020 11:02:47 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33703xykrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 11:02:47 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07SEvpbt022587;
        Fri, 28 Aug 2020 15:02:41 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 332utufcyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 15:02:41 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07SF2eU757016640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 15:02:40 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 512AF78060;
        Fri, 28 Aug 2020 15:02:40 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D67D7805C;
        Fri, 28 Aug 2020 15:02:38 +0000 (GMT)
Received: from [153.66.254.174] (unknown [9.80.230.238])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Aug 2020 15:02:38 +0000 (GMT)
Message-ID: <1598626957.3883.17.camel@linux.ibm.com>
Subject: Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com group alias
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Arun Easi <aeasi@marvell.com>
Date:   Fri, 28 Aug 2020 08:02:37 -0700
In-Reply-To: <alpine.DEB.2.21.2008281524360.11562@felia>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
         <20200828091758.GF54274@SPB-NB-133.local>
         <alpine.DEB.2.21.2008281524360.11562@felia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_09:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 malwarescore=0 clxscore=1011 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280112
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-08-28 at 15:30 +0200, Lukas Bulwahn wrote:
> 
> On Fri, 28 Aug 2020, Roman Bolshakov wrote:
> 
> > On Fri, Aug 28, 2020 at 09:08:24AM +0200, Lukas Bulwahn wrote:
> > > Previous attempts of getting an answer from the qlogic.com group
> > > alias, i.e., QLogic-Storage-Upstream@qlogic.com, have remained
> > > unanswered; see links below.
> > > 
> > > Mark those sections Orphan to prepare their deletion or give an
> > > actual person a chance to step up to maintain those drivers.
> > > 
> > > Link: https://lore.kernel.org/linux-spdx/20190606205526.447558989
> > > @linutronix.de
> > > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.20063006
> > > 44130.4919@felia
> > > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.20082707
> > > 40140.31123@felia
> > > 
> > 
> > CC'd Arun,
> > 
> > I think it's worth to update the alias to:
> > 
> > GR-QLogic-Storage-Upstream@marvell.com
> > 
> 
> So, if these drivers are not orphans, you can answer Thomas
> Gleixner's original email from 2019. If you can quickly ack that
> patch set, I am happy to do the donkey work to get this apply nicely
> on the current master (please CC me on that response).

I have to wonder what the object is here: to get the problem fixed or
to make a public spectacle?

Because if the object had been to get the issue fixed, waiting a year
before escalating to the SCSI list isn't the best way to achieve
outcomes, nor is now demanding that the drivers be orphaned for lack of
response to you ... particularly as you've seen the drivers updated
over that time if you actually follow kernel releases.

Qlogic or now Marvell tends to rely somewhat heavily on outsourcing for
driver maintenance and support.  Outsourcers, fairly obviously, aren't
going to respond to legal issues like this which are outside of their
remit.  What needs to happen is that someone needs to find a person
within the Qlogic org who can get this fixed ... possibly involving
explaining the actual issue along the way.  Would you like us to use
our contacts to do that?

James

