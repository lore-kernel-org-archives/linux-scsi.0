Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAF5C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96AD7238E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgLGS4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:56:11 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbgLGS4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:56:11 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7I3Phd152935;
        Mon, 7 Dec 2020 13:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=JaQ6d5gPXOrXzFIOSaCCdluJPsexvUeqVt6OvMx+lOI=;
 b=eeNO1myBlzfhZqbX+7+pN2a6d+0lJxfxspsO/E0gbE/Nrx199fBm93xXOLhUc3tThLS4
 +QT8O/9KaUOgCx82qrX9ym47TqMH3rB6lGo+d5iof3MECF0bCZ+72ApKB8yQuYBX55HZ
 cWf4rHGp1ZUb7oVMeNdqKAsvYFwUGhbc5A9yD3cUcz4OOHy6p/1X1sM+Fs9x7LF33RsP
 pZOrAkWNMYJCsGQSQnuS0XXntx6xCqJSSgROQEQv0vWsq9kUWQNdxkPjSZfomjmKu1Cg
 235PTo9BPWU9O7+1AomLzzflinpHL6RRxTHYdrT+FLaPIi15DCOPLDr4uUhz86AqS8J5 yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359s1dj1su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:55:06 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7IlZTP136279;
        Mon, 7 Dec 2020 13:55:05 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359s1dj1s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 13:55:05 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7IS1Ek009022;
        Mon, 7 Dec 2020 18:55:04 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u8vys3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 18:55:04 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B7It3a320119834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 18:55:03 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F24378060;
        Mon,  7 Dec 2020 18:55:03 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95BB07805C;
        Mon,  7 Dec 2020 18:54:59 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.183.17])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Dec 2020 18:54:59 +0000 (GMT)
Message-ID: <fa89e2a960e98b016d4935490fa2905aab0868f7.camel@linux.ibm.com>
Subject: Re: [PATCH v13 0/3] scsi: ufs: Add Host Performance Booster Support
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "gregkh@google.com" <gregkh@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Mon, 07 Dec 2020 10:54:58 -0800
In-Reply-To: <X85116BXkgTtRDKV@kroah.com>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
         <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
         <X85sxxgpdtFXiKsg@kroah.com> <20201207180655.GA30657@infradead.org>
         <X85zEFduHeUr4YKR@kroah.com> <20201207182603.GA2499@infradead.org>
         <X85116BXkgTtRDKV@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1011 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-07 at 19:35 +0100, Greg KH wrote:
> On Mon, Dec 07, 2020 at 06:26:03PM +0000, Christoph Hellwig wrote:
> > On Mon, Dec 07, 2020 at 07:23:12PM +0100, Greg KH wrote:
> > > What "real workload" test can be run on this to help show if it
> > > is useful or not?  These vendors seem to think it helps for some
> > > reason, otherwise they wouldn't have added it to their silicon :)
> > > 
> > > Should they run fio?  If so, any hints on a config that would be
> > > good to show any performance increases?
> > 
> > A real actual workload that matters.  Then again that was Martins
> > request to even justify it.  I don't think the broken addressing
> > that breaks a whole in the SCSI addressing has absolutely not
> > business being supported in Linux ever.  The vendors should have
> > thought about the design before committing transistors to something
> > that fundamentally does not make sense.

Actually, that's not the way it works: vendors add commands because
standards mandate.  That's why people who want weird commands go and
join standard committees.  Unfortunately this means that a lot of the
commands the standard mandates end up not being very useful in
practice.  For instance in SCSI we really only implement a fraction of
the commands in the standard.

In this case, the industry already tried a very similar approach with
GEN 1 hybrid drives and it turned into a complete disaster, which is
why the mode became optional in shingle drives and much better modes,
which didn't have the huge shared state problem, superseded it.  Plus
truncating the LBA of a READ 16 to 4 bytes is asking for capacity
problems down the line, so even the actual implementation seems to be
problematic.

All in all, this looks like a short term fix which will go away when
the drive capacity improves and thus all the effort changing the driver
will eventually be wasted.

> So "time to boot an android system with this enabled and disabled"
> would be a valid workload, right?  I'm guessing that's what the
> vendors here actually care about, otherwise there is no real stress-
> test on a UFS system that I know of.

Um, does it?  I don't believe even the UFS people have claimed this. 
The problem is that HPB creates a shared state between the driver and
the device.  That shared state has to be populated, which has to happen
at start of day, so it's entirely unclear if this is a win or a slow
down for boot.

James


