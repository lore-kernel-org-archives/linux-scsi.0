Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73CCC77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 02:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjDSCel (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 22:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjDSCek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 22:34:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56654EF6
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 19:34:38 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J1p8IH029091;
        Wed, 19 Apr 2023 02:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=d98LcUwOyed8THHj4JuaZu9tVBMmjI7KlhG1pCtdDG4=;
 b=X0POWumgU7HNxUSNOBivWDR8CB0SOra1hYBcnOB435Qyka0iLxlZRX1ZullsOY7SK8ZM
 TOLHu8a83HYmDFpFuxKGwgCF+czx5gSrZVLWxYVIXi/s3D6RtqGfXbacky6x+qP+7Rz8
 ew/Q4D0B5UMZUN7RLo39H64y2aGPRxH3u+Vu93iH4llkk9zIXTQf2B13MJR8Dgfwu5he
 LbiLChQK8Q+ZoCKptbu1lz7mkqKp+UvYsCKipf/eLrsKjSB7X29V8Wdb0c9lntIi7bxF
 z1Gf691l/e33KO7y9R02NfkHKSHsBmzGrrb1mMOIPC05aKWD8eg8+r0K8KMs/CYsAPtX fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1q35w2a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 02:34:23 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33J2SJkR032526;
        Wed, 19 Apr 2023 02:34:23 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1q35w29x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 02:34:23 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33J1PSBf026556;
        Wed, 19 Apr 2023 02:34:22 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3q1uxdbt1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 02:34:22 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33J2YLid15467112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 02:34:21 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E7258061;
        Wed, 19 Apr 2023 02:34:21 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3F4E58059;
        Wed, 19 Apr 2023 02:34:19 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.163.32.220])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 02:34:19 +0000 (GMT)
Message-ID: <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>
Date:   Tue, 18 Apr 2023 22:34:18 -0400
In-Reply-To: <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
         <20230417230656.523826-2-bvanassche@acm.org>
         <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
         <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HlG8KtaehfTJmMdtM1zKBlaaA--ZWgAH
X-Proofpoint-ORIG-GUID: 8vEN-Q7UXkwzGeeZHIohIUtbcUv16cwc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_17,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-04-18 at 11:37 -0700, Bart Van Assche wrote:
> On 4/18/23 07:36, James Bottomley wrote:
> > On Mon, 2023-04-17 at 16:06 -0700, Bart Van Assche wrote:
> > > System shutdown happens as follows (see e.g. the systemd source
> > > file src/shutdown/shutdown.c):
> > > * sync() is called.
> > > * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
> > > * If the reboot() system call returns, log an error message.
> > > 
> > > The reboot() system call causes the kernel to call
> > > kernel_restart(), kernel_halt() or kernel_power_off(). Each of
> > > these functions calls device_shutdown(). device_shutdown() calls
> > > sd_shutdown(). After sd_shutdown() has been called the
> > > .shutdown() callback of the LLD will be called. Hence, I/O
> > > submitted after sd_shutdown() will hang or may even cause a
> > > kernel crash.
> > > 
> > > Let sd_shutdown() fail future I/O such that LLD .shutdown()
> > > callbacks can be simplified.
> > 
> > What is the actual reason for this?  What is it you think might be
> > submitting I/O after the system gets into this state?  Current
> > sd_shutdown is constructed on the premise that it's the last thing
> > that ever happens to the device before reboot/power off which is
> > why it flushes the cache if necessary and stops the device if
> > required, but for most standard devices neither is required because
> > we don't expect Linux to go down with pending items in the block
> > queue and for a write through disk cache anything that's completed
> > on the block queue is safely durable on the device.
> 
> Hi James,
> 
> .shutdown() callbacks should quiesce I/O but the sd_shutdown()
> function doesn't do this. I see this as a bug.

Why? They're only called on reboot or shutdown.  In orderly cases, the
queues should have been stopped long ago, so there should be no I/O to
quiesce, and in the disorderly case, you obviously didn't care about
the data anyway, so the job of the shutdown routine is to salvage as
much as it can, which is why we flush the cache and stop the disk if
necessary.

> Regarding your question, I think that sd_check_events() can be called
> while sd_shutdown() is in progress or after sd_shutdown() has
> finished.  sd_check_events() may submit a TEST UNIT READY command.

If that's true, that would argue that the block layer caller should be
aware of the shutdown and not do this.  On the other hand, if the TUR
fails, what is the harm?

> In pci_device_shutdown() one can see that the PCI core clears the bus
> master bit for PCI devices during shutdown. In other words, it is not
> safe to submit I/O or to process completions during invocation of 
> shutdown callbacks. I think that also shows that this patch fixes a
> bug.

I don't think it does: in the orderly case, there should be no I/O
outstanding, so nothing to trigger and in the disorderly case, you have
no expectation of the I/O reaching the device, so what would the actual
bug be that this fixes?

James

