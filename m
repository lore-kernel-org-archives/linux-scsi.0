Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D381C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 19:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjDSTaC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 15:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjDSTaB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 15:30:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682A4192
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 12:30:00 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JJQUbm008523;
        Wed, 19 Apr 2023 19:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=Tn/w2IBzxd0qGZrp0F6GohgYGy1wvUG2Kugce1sfdcU=;
 b=HS2eHg/MJqpKEEyQ5DLo6Z/37khNp2HmgRBRMq1r2iAIloh6G+AWaEbCJyjal21WNSAy
 5qsB14YRsKjpoU++HbGekkkkZEuMX3muEMN1QYVYQC/TdPh32twBFdIAEXKguMRspv1Z
 eajP6Ny4KtXffIBPO3F26YstKNGh8aDi8bX1+/CVXVFofbQTGa6PiyVzyzpw19rQ4fG6
 krv7+I4nVuN07JM16qiSKA5A/x1TGztbWk2MyRgDq3efOWKb+RRWL5iJy3Rbe0cssVVD
 MbyO2t05gQIJHLevAxZnQGQ4cv4Dr7sez/znUdt6f5qV6tEFHx5J9q7GM4b4xsyb+5pS 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1ntvk0gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 19:29:34 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JIZV32010941;
        Wed, 19 Apr 2023 19:29:34 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1ntvk0gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 19:29:34 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33JI1JC0024249;
        Wed, 19 Apr 2023 19:29:33 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3pykj7r796-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 19:29:33 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33JJTWSR28967512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 19:29:32 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F6C258059;
        Wed, 19 Apr 2023 19:29:32 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB6E858057;
        Wed, 19 Apr 2023 19:29:30 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.163.32.220])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 19:29:30 +0000 (GMT)
Message-ID: <e035791d5d06d21068d94a0228ada207ee0d96b7.camel@linux.ibm.com>
Subject: Re: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        Tomas Henzl <thenzl@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>
Date:   Wed, 19 Apr 2023 15:29:29 -0400
In-Reply-To: <257074db-72c7-a04f-bdf3-f5b90ea2781e@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
         <20230417230656.523826-2-bvanassche@acm.org>
         <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
         <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
         <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
         <a2195da6-5d41-789f-091c-6d38c9d7d7b0@redhat.com>
         <392c0fc3412bd39d37a6b87ba58b505095c56f7e.camel@linux.ibm.com>
         <5429f579-1512-b6b5-771a-70f3d27959b2@acm.org>
         <3f1cb05d70ea9a060951b8b2cd4ce84d8fb62174.camel@linux.ibm.com>
         <257074db-72c7-a04f-bdf3-f5b90ea2781e@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TDZ237_bDvNmIGw8YHrLOwt1adlLrWbO
X-Proofpoint-ORIG-GUID: dvwetjyrXwtkqJoRa2RksJbuCD5OHMfG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_13,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=620
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304190167
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-04-19 at 12:24 -0700, Bart Van Assche wrote:
> On 4/19/23 11:33, James Bottomley wrote:
> > So if we can't reliably get it right, let's not do it at all.  The
> > previous argument you made was about problems with I/O to shutdown
> > PCI devices.  That's not SCSI specific, so either we fix it for
> > everything or decide it's not really a problem for anything.
> 
> The reference to PCI devices was an example only. As mentioned
> elsewhere in this email thread, sd_shutdown() does not do what it
> should do, namely to quiesce I/O. From include/linux/bus.h:
> 
>   * @shutdown:  Called at shut-down time to quiesce the device.

Shutdown seems to be one of the most ill documented device hooks.  I
really don't think we should be declaring existing code to be buggy
based on this single comment.  But the fact remains that if you want to
act on it, block is the correct place to shut down the queues.

James

