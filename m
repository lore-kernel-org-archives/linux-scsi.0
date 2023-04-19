Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199C5C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 14:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjDSOII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 10:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjDSOIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 10:08:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9142D67
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 07:08:05 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JE7fkL026639;
        Wed, 19 Apr 2023 14:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=jF4XMy3y4joJ49h2xk/bUfwCwxm3SUX3NUITQ5n2tuQ=;
 b=AYUyBWYehPq5nQke4ogeEq19BxUCOg7RTRlJioTCJFlFgS/RoZMl2OGaG/WGAFdMlnmE
 s2D3ouMbg+LgXCBD9odx/6t5++/m9zJ8rPRTBPt/tfNhDuWYigAyJ62gWbopLvPxCNBZ
 VI9vNllyInoFXD96fk4+ODEEEeE9wP8kDyYJt92TzTsxj5e9z9d130VBgxoywMpahEIG
 5281WHlCrwXZxme5S3abmQfVS77OU4FGBDeVUsIXlijHLYYhQHXl4/n54HLqZz0y29mt
 GU+lG4JqZmpaGVw+64tQAwwBYotkkHgcnDQ8io4VaK+b8Uz1rMELYLGUiJU3v0PsYf2j rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q20hdn0uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 14:07:47 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JBn4e6001197;
        Wed, 19 Apr 2023 14:07:46 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q20hdn0tr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 14:07:46 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33JAxa0g010108;
        Wed, 19 Apr 2023 14:02:45 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3pykj7eqjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 14:02:45 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33JE2iAP10158712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 14:02:44 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F1C758057;
        Wed, 19 Apr 2023 14:02:44 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13B7E58059;
        Wed, 19 Apr 2023 14:02:43 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.163.32.220])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 14:02:42 +0000 (GMT)
Message-ID: <392c0fc3412bd39d37a6b87ba58b505095c56f7e.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Tomas Henzl <thenzl@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>
Date:   Wed, 19 Apr 2023 10:02:41 -0400
In-Reply-To: <a2195da6-5d41-789f-091c-6d38c9d7d7b0@redhat.com>
References: <20230417230656.523826-1-bvanassche@acm.org>
         <20230417230656.523826-2-bvanassche@acm.org>
         <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
         <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
         <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
         <a2195da6-5d41-789f-091c-6d38c9d7d7b0@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C7zLM_Vt8TwAiB2WN3hX35IzohDE3PAJ
X-Proofpoint-GUID: _GZXPkAZLimnVw5GxFU7s4HloJAp6Ghm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_08,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-04-19 at 15:36 +0200, Tomas Henzl wrote:
> On 4/19/23 04:34, James Bottomley wrote:
> > On Tue, 2023-04-18 at 11:37 -0700, Bart Van Assche wrote:
> > > On 4/18/23 07:36, James Bottomley wrote:
> > > > On Mon, 2023-04-17 at 16:06 -0700, Bart Van Assche wrote:
> > > > > System shutdown happens as follows (see e.g. the systemd
> > > > > source
> > > > > file src/shutdown/shutdown.c):
> > > > > * sync() is called.
> > > > > * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
> > > > > * If the reboot() system call returns, log an error message.
> > > > > 
> > > > > The reboot() system call causes the kernel to call
> > > > > kernel_restart(), kernel_halt() or kernel_power_off(). Each
> > > > > of these functions calls device_shutdown(). device_shutdown()
> > > > > calls sd_shutdown(). After sd_shutdown() has been called the
> > > > > .shutdown() callback of the LLD will be called. Hence, I/O
> > > > > submitted after sd_shutdown() will hang or may even cause a
> > > > > kernel crash.
> > > > > 
> > > > > Let sd_shutdown() fail future I/O such that LLD .shutdown()
> > > > > callbacks can be simplified.
> > > > 
> > > > What is the actual reason for this?  What is it you think might
> > > > be submitting I/O after the system gets into this state? 
> > > > Current sd_shutdown is constructed on the premise that it's the
> > > > last thing that ever happens to the device before reboot/power
> > > > off which is why it flushes the cache if necessary and stops
> > > > the device if required, but for most standard devices neither
> > > > is required because we don't expect Linux to go down with
> > > > pending items in the block queue and for a write through disk
> > > > cache anything that's completed on the block queue is safely
> > > > durable on the device.
> > > 
> > > Hi James,
> > > 
> > > .shutdown() callbacks should quiesce I/O but the sd_shutdown()
> > > function doesn't do this. I see this as a bug.
> > 
> > Why? They're only called on reboot or shutdown.  In orderly cases,
> > the queues should have been stopped long ago, so there should be no
> > I/O to quiesce, and in the disorderly case, you obviously didn't
> > care about the data anyway, so the job of the shutdown routine is
> > to salvage as much as it can, which is why we flush the cache and
> > stop the disk if necessary.
> 
> A kernel panic has been reported caused by I/O arriving after
> driver's shutdown (the driver is fixed now so just scsi exception
> handling is logged). All drivers should have a protection against
> late commands queued, with a block after sd.shutdown that could be
> dropped  and so well written drivers could enjoy a bit easier/faster
> code and and those not well written wouldn't be waiting for issues
> yet to come.
> 
> What actually is the downside of blocking further I/O in sd shutdown?

Well, it's a layering problem: if all queues should be stopped on
shutdown, then this should be done from block (for all queues including
those outside SCSI).

device_shutdown() goes in reverse devices_kset->list order, so it looks
like it would do the PCI device then the SCSI device then the ULD then
block, so we can use the queues in SCSI for emergency actions (like
flush or stop) before block goes down.  Although this isn't guaranteed;
there are things, like device_link_add, which reorder this kset, so
we'd need to make sure the above assumption is correct.

James

