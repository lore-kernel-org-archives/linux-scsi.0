Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B38C77B78
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 14:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjDROhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 10:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDROht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 10:37:49 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0032A448E
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 07:37:48 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IECBVP023393;
        Tue, 18 Apr 2023 14:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=XVaTKcRuKM6GrFxgD6N0lARYeTnhan+cbZzrGbwe8YI=;
 b=DblMX3hdThOMpn27AkxYNm22HjLPk/Fbpxm/mlZWpoHIUpzYfy6SlKxRRXBtHtG1LE5V
 tnhq4jbgtDUDF+76mQjyYQbuXrhbGMdpURL0bekeW0pqZkOJCRslLhew/yRYzOJ0oNuo
 pszTeOkuKmikozsAxG8SXNZjK6KL6bGAv4pAqnVBzvTzg2gNTark+CUESsvdDDxP6EGo
 MjjcUJgVudrBXbZotNUEv1fhH/ZmWFUJOEGZIHdyn7gja/VFHb9AhhEhZar8ObmjGfaI
 e2vWFhB25AQtp6GzhFv5yQ55f3BohNC0NNzmuWs4SmqcBufppzrSoX3HKOOjh7Gtq1qE Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1ntu6dac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 14:36:58 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33ID2885022625;
        Tue, 18 Apr 2023 14:36:57 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1ntu6da0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 14:36:57 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33ICdJi2003699;
        Tue, 18 Apr 2023 14:36:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3pykj7wqsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 14:36:56 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33IEatp530409366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 14:36:55 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29AA258059;
        Tue, 18 Apr 2023 14:36:55 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD63D58062;
        Tue, 18 Apr 2023 14:36:53 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.163.32.220])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Apr 2023 14:36:53 +0000 (GMT)
Message-ID: <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
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
Date:   Tue, 18 Apr 2023 10:36:52 -0400
In-Reply-To: <20230417230656.523826-2-bvanassche@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
         <20230417230656.523826-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4QDf3k2OBuOjbvKzb9lvAltxKQSXeOYU
X-Proofpoint-ORIG-GUID: T-2pJeeRXJutz1ZYUBDwdZwSwqAjEjT4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_09,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011 mlxlogscore=884
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180123
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-04-17 at 16:06 -0700, Bart Van Assche wrote:
> System shutdown happens as follows (see e.g. the systemd source file
> src/shutdown/shutdown.c):
> * sync() is called.
> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
> * If the reboot() system call returns, log an error message.
> 
> The reboot() system call causes the kernel to call kernel_restart(),
> kernel_halt() or kernel_power_off(). Each of these functions calls
> device_shutdown(). device_shutdown() calls sd_shutdown(). After
> sd_shutdown() has been called the .shutdown() callback of the LLD
> will be called. Hence, I/O submitted after sd_shutdown() will hang or
> may even cause a kernel crash.
> 
> Let sd_shutdown() fail future I/O such that LLD .shutdown() callbacks
> can be simplified.

What is the actual reason for this?  What is it you think might be
submitting I/O after the system gets into this state?  Current
sd_shutdown is constructed on the premise that it's the last thing that
ever happens to the device before reboot/power off which is why it
flushes the cache if necessary and stops the device if required, but
for most standard devices neither is required because we don't expect
Linux to go down with pending items in the block queue and for a write
through disk cache anything that's completed on the block queue is
safely durable on the device.

James

