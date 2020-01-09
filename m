Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88359C33CA1
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61FF72067D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 01:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgAIBFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 20:05:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726913AbgAIBFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2020 20:05:05 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00912O10035646;
        Wed, 8 Jan 2020 20:04:25 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xdcdhbv65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 20:04:25 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 00912QvP035861;
        Wed, 8 Jan 2020 20:04:25 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xdcdhbv5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jan 2020 20:04:25 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 0090xp1b003470;
        Thu, 9 Jan 2020 01:04:30 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 2xajb6sa18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jan 2020 01:04:30 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00914OvB12518100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jan 2020 01:04:24 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E98D0124052;
        Thu,  9 Jan 2020 01:04:23 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8094124054;
        Thu,  9 Jan 2020 01:04:21 +0000 (GMT)
Received: from jarvis.ext.hansenpartnership.com (unknown [9.85.182.239])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jan 2020 01:04:21 +0000 (GMT)
Message-ID: <1578531860.3852.7.camel@linux.ibm.com>
Subject: Re: [PATCH v1] driver core: Use list_del_init to replace list_del
 at device_links_purge()
From:   James Bottomley <jejb@linux.ibm.com>
To:     John Garry <john.garry@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "saravanak@google.com" <saravanak@google.com>,
        Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 17:04:20 -0800
In-Reply-To: <3826a83d-a220-2f7d-59f6-efe8a4b995d7@huawei.com>
References: <1578483244-50723-1-git-send-email-luojiaxing@huawei.com>
         <20200108122658.GA2365903@kroah.com>
         <73252c08-ac46-5d0d-23ec-16c209bd9b9a@huawei.com>
         <1578498695.3260.5.camel@linux.ibm.com>
         <20200108155700.GA2459586@kroah.com>
         <1578499287.3260.7.camel@linux.ibm.com>
         <4b185c9f-7fa2-349d-9f72-3c787ac30377@huawei.com>
         <3826a83d-a220-2f7d-59f6-efe8a4b995d7@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 suspectscore=0 clxscore=1011 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090008
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-01-08 at 17:10 +0000, John Garry wrote:
> On 08/01/2020 16:08, John Garry wrote:
> > On 08/01/2020 16:01, James Bottomley wrote:
> > > > > >     cdev->dev = NULL;
> > > > > >             return device_add(&cdev->cdev);
> > > > > >         }
> > > > > >     }
> > > > > >     return -ENODEV;
> > > > > > }
> > > > > 
> > > > > The design of the code is simply to remove the link to the
> > > > > inserted device which has been removed.
> > > > > 
> > > > > I*think*  this means the calls to device_del and device_add
> > > > > are unnecessary and should go.  enclosure_remove_links and
> > > > > the put of the enclosed device should be sufficient.
> > > > 
> > > > That would make more sense than trying to "reuse" the device
> > > > structure here by tearing it down and adding it back.
> > > 
> > > OK, let's try that.  This should be the patch if someone can try
> > > it (I've compile tested it, but the enclosure system is under a
> > > heap of stuff in the garage).
> > 
> > I can test it now.
> > 
> 
> Yeah, that looks to have worked ok. SES disk locate was also fine
> after losing and rediscovering the disk.

OK, I'll spin up a patch with fixes/reported and tested tags.

> Thanks,
> John
> 
> > But it is a bit suspicious that we had the device_del() and
> > device_add() at all, especially since the code change makes it look
> > a bit more like pre-43d8eb9cfd0 ("ses: add support for enclosure
> > component hot removal")

I think the original reason was to clean out the links.  I vaguely
remember there was once a time when you couldn't clear all the links
simply with sysfs_remove_link.  However, nowadays you can.

James

