Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111B7C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7B896105A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 13:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbhIPNDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:03:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9620 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239574AbhIPNDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 09:03:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18GCUJvl027919;
        Thu, 16 Sep 2021 09:01:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=Xc0IFJsm4c5Joa75hpTgGyIX90u/Wq9tzQLT/BG1NCM=;
 b=okqljXf3JaawZRLejkkufix1ltktyYyHs7+nOzC4Sx3utI5WvI2xyG6AB+DwT/L0deq+
 /Sw2ZEIl27b61waOIgae5S0wsTAnZSEgx/+fVEJ9hLtpoVfhYv9MNsuQOh/Q5SBa9vZz
 HjmAp59B/XGPbtDniIOfr/rzfBrMpQ4OfxE6EeP7J2ve45gWbQqyVRcEIc6sPUqtIfyB
 HxdidFHsFpjvmPfzVcUq+C1oNvUTmJKbeGyJHumYyhBk5uZbqv9ncHxlSHmFrET9kegJ
 1eFmiF6Npd1TkRB3elAxbBBTHfX6YUh9eaUD4yknu7rfdc+/guzy5PMkm1ea2EsG/kia iA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4605gp0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Sep 2021 09:01:29 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18GCqpdU030160;
        Thu, 16 Sep 2021 13:01:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 3b0m3b20x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Sep 2021 13:01:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18GD1Q1h43843926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 13:01:26 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50F75780AE;
        Thu, 16 Sep 2021 13:01:26 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DC7178082;
        Thu, 16 Sep 2021 13:01:25 +0000 (GMT)
Received: from jarvis.lan (unknown [9.211.54.195])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 16 Sep 2021 13:01:25 +0000 (GMT)
Message-ID: <b89cf2d046e4817fbc7978069ce22683b6ad0bcd.camel@linux.ibm.com>
Subject: Re: [PATCH V3 1/1] scsi/ses: Saw "Failed to get diagnostic page 0x1"
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     dgilbert@interlog.com, wenxiong@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org, brking1@linux.vnet.ibm.com,
        martin.petersen@oracle.com, wenxiong@us.ibm.com
Date:   Thu, 16 Sep 2021 09:01:23 -0400
In-Reply-To: <1365506b-c31e-250e-e120-8fe54c94a068@interlog.com>
References: <1631711048-6177-1-git-send-email-wenxiong@linux.vnet.ibm.com>
         <0912982133a254770a27b780cd2c5771739ced3b.camel@linux.ibm.com>
         <1365506b-c31e-250e-e120-8fe54c94a068@interlog.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _-9fb7vvuZZ8g4cBi6O-tFBIR8JpBn4q
X-Proofpoint-ORIG-GUID: _-9fb7vvuZZ8g4cBi6O-tFBIR8JpBn4q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 spamscore=0 adultscore=0 clxscore=1011 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160072
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-15 at 13:55 -0400, Douglas Gilbert wrote:
> On 2021-09-15 10:43 a.m., James Bottomley wrote:
> > On Wed, 2021-09-15 at 08:04 -0500, wenxiong@linux.vnet.ibm.com
> > wrote:
> > > From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> > > 
> > > Setting scsi logging level with error=3, we saw some errors from
> > > enclosues:
> > > 
> > > [108017.360833] ses 0:0:9:0: tag#641 Done: NEEDS_RETRY Result:
> > > hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
> > > [108017.360838] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c
> > > 01 01
> > > 00 20 00
> > > [108017.427778] ses 0:0:9:0: Power-on or device reset occurred
> > > [108017.427784] ses 0:0:9:0: tag#641 Done: SUCCESS Result:
> > > hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> > > [108017.427788] ses 0:0:9:0: tag#641 CDB: Receive Diagnostic 1c
> > > 01 01
> > > 00 20 00
> > > [108017.427791] ses 0:0:9:0: tag#641 Sense Key : Unit Attention
> > > [current]
> > > [108017.427793] ses 0:0:9:0: tag#641 Add. Sense: Bus device reset
> > > function occurred
> > > [108017.427801] ses 0:0:9:0: Failed to get diagnostic page 0x1
> > > [108017.427804] ses 0:0:9:0: Failed to bind enclosure -19
> > > [108017.427895] ses 0:0:10:0: Attached Enclosure device
> > > [108017.427942] ses 0:0:10:0: Attached scsi generic sg18 type 13
> > > 
> > > As Martin's suggestion, the patch checks to retry on NOT_READY as
> > > well as UNIT_ATTENTION with ASC 0x29.
> > 
> > This looks fine to me.  I think the reason expecting_cc_ua doesn't
> > work for you is that you're getting > 1 reset per
> > command.  expecting_cc_ua automatically resets after eating the
> > first unit attention.
> 
> Rather that simply consuming UAs, what do you think of a fixed length
> FIFO, say 8 entries, that holds the asc,ascq of the last 8 UAs
> together with a timestamp of when it was received (with a boot time
> epoch).  Then allow the user space to see that FIFO via sysfs (e.g.
> under /sys/class/scsi_device/<hctl>). Remembering the previous UA may
> also be useful for the mid-level UA processing. For example after a
> firmware upgrade, there may be UAs for both INQUIRY data change and
> device reset.

I don't really see how it would be useful.  On the available debugging
information (which is a bit scant) it looks like a single device
problem (as usual) ... possibly not clearing the condition after the
REQUEST_SENSE because I can't believe another reset went over the bus
immediately after the first UA/CC was received.

> Also the first device reset after a reboot (power cycle) is expected,
> having one later, for example when part of a disk is mounted, is a
> bit more suspicious.

It's definitely hugely suspicious, but tying it to ASC/ASQC 0x29/0x00
should limit the fallout considerably.

James


