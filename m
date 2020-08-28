Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C24C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F5120825
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sbSVp9U5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgH1Pib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:38:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbgH1PiZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Aug 2020 11:38:25 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SFXm9H032719;
        Fri, 28 Aug 2020 11:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=4O7jU/JeUGU2ScBG6qa9r57tXTBkHtgYPRSpVbwrZUM=;
 b=sbSVp9U5U/WE4PSAqrwgkTuvfVlR3e8UjHcYdPvtqHUHtm0gGwtKoZvNGucpQUoAPDk9
 Vz/udeZ/VQZpjqPWPg/6Mfvo4bq34u2BtnPHhXdvJYETA3exn1nTnYYO5zHuC51AkQub
 5T4F+5JNbsRD8MxWm4HCNiEctEic2NJAXdl3zaJPKpPd5FKWEWZ7W6lxnlEWnwX9mz3x
 bQaSfsWJYZL9pAMxKVPMedBgsUJPUi108pn01OvfnZQY8RpwJnSEXnNUZXWUNVhNq7VU
 pz14CwexVISDFfleqpYJWUxgCM+Pgfe33NKVn0g/ReoDfmh9Bgc9ii0ahIkhsZ+gZU4/ EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3374c98pgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 11:38:14 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07SFZFw4038301;
        Fri, 28 Aug 2020 11:38:13 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3374c98pgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 11:38:13 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07SFRuWB024303;
        Fri, 28 Aug 2020 15:38:13 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 335kvcypfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 15:38:13 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07SFc8kw36831534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 15:38:08 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D42C7805E;
        Fri, 28 Aug 2020 15:38:11 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 935D07805C;
        Fri, 28 Aug 2020 15:38:09 +0000 (GMT)
Received: from [153.66.254.174] (unknown [9.80.230.238])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Aug 2020 15:38:09 +0000 (GMT)
Message-ID: <1598629088.3883.27.camel@linux.ibm.com>
Subject: Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com group alias
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Arun Easi <aeasi@marvell.com>
Date:   Fri, 28 Aug 2020 08:38:08 -0700
In-Reply-To: <alpine.DEB.2.21.2008281719290.11677@felia>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com>
         <20200828091758.GF54274@SPB-NB-133.local>
         <alpine.DEB.2.21.2008281524360.11562@felia>
         <1598626957.3883.17.camel@linux.ibm.com>
         <alpine.DEB.2.21.2008281719290.11677@felia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_09:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280116
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-08-28 at 17:28 +0200, Lukas Bulwahn wrote:
> 
> On Fri, 28 Aug 2020, James Bottomley wrote:
> 
> > On Fri, 2020-08-28 at 15:30 +0200, Lukas Bulwahn wrote:
> > > 
> > > On Fri, 28 Aug 2020, Roman Bolshakov wrote:
> > > 
> > > > On Fri, Aug 28, 2020 at 09:08:24AM +0200, Lukas Bulwahn wrote:
> > > > > Previous attempts of getting an answer from the qlogic.com
> > > > > group alias, i.e., QLogic-Storage-Upstream@qlogic.com, have
> > > > > remained unanswered; see links below.
> > > > > 
> > > > > Mark those sections Orphan to prepare their deletion or give
> > > > > an actual person a chance to step up to maintain those
> > > > > drivers.
> > > > > 
> > > > > Link: https://lore.kernel.org/linux-spdx/20190606205526.44755
> > > > > 8989
> > > > > @linutronix.de
> > > > > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2006
> > > > > 3006
> > > > > 44130.4919@felia
> > > > > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2008
> > > > > 2707
> > > > > 40140.31123@felia
> > > > > 
> > > > 
> > > > CC'd Arun,
> > > > 
> > > > I think it's worth to update the alias to:
> > > > 
> > > > GR-QLogic-Storage-Upstream@marvell.com
> > > > 
> > > 
> > > So, if these drivers are not orphans, you can answer Thomas
> > > Gleixner's original email from 2019. If you can quickly ack that
> > > patch set, I am happy to do the donkey work to get this apply
> > > nicely on the current master (please CC me on that response).
> > 
> > I have to wonder what the object is here: to get the problem fixed
> > or to make a public spectacle?
> > 
> 
> Let us get the problem fixed; no spectacle here.
> 
> > Because if the object had been to get the issue fixed, waiting a
> > year before escalating to the SCSI list isn't the best way to
> > achieve outcomes, nor is now demanding that the drivers be orphaned
> > for lack of response to you ... particularly as you've seen the
> > drivers updated over that time if you actually follow kernel
> > releases.
> > 
> 
> I just followed Greg KH's advice; spdx licensing clean-up is not the
> top most priority thing; so it just happened to be laying around for
> a year.  Feel free to ignore this patch and we solve the problem
> instead.

OK, that's the plan then.

> > Qlogic or now Marvell tends to rely somewhat heavily on outsourcing
> > for driver maintenance and support.  Outsourcers, fairly obviously,
> > aren't going to respond to legal issues like this which are outside
> > of their remit.  What needs to happen is that someone needs to find
> > a person
> > within the Qlogic org who can get this fixed ... possibly involving
> > explaining the actual issue along the way.  Would you like us to
> > use
> > our contacts to do that?
> > 
> 
> Yes, I (and I will bet the licensing clean-up janitors) welcome if
> that legal question can be resolved and the kernel can be cleaned up
> from unneeded files.

OK, because of the high turn over at the Qlogic division due to the
takeover, this will take us some time, but we'll try to find the right
people at least to explain the issue to.

James

