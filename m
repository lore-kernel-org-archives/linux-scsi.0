Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3942C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 18:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDSSee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 14:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjDSSed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 14:34:33 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E44122
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 11:34:31 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JIJTlX032506;
        Wed, 19 Apr 2023 18:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=uBE1+6xs3cQkkn4Q8GH2s5k3x2FsDem7gOvPEWpK4iw=;
 b=di3//7V/S+tDsWzzNPVKc2tQJueC5SuZ4DkqTMxTwPUOFJhhPBtDpfaRpzIh4OD01fTO
 IfehRY0pqdWtA2jXZRxFNFgoK0wid3o6TWJ/mPVLoowYMU/B1qWTK27YtAX6Zwz75vmN
 hY4/mD/5NXchankozTiGQqyl/hLdRoYULyBNq+yqpPZ6ka7NtLrphQsXg+xVoe4fI7DA
 QBaw1mhmOoxfXt5VeVUmpSSYqZrRy36iYI0dj7W02CzFoQRngaN1XXHTHQfX/QHXjGSU
 wmC6YqUsXqCzXnTQ067EbMnTNN0RBhlNwCJY1RdtTXE8HMwnP4qArKNZKkdfkvLZfcv1 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q20x1mfj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 18:33:57 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JHu6DA021966;
        Wed, 19 Apr 2023 18:33:56 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q20x1mffp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 18:33:56 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33JI5mbA027051;
        Wed, 19 Apr 2023 18:33:50 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3pykj700ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 18:33:50 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33JIXn1M22675998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 18:33:49 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BAF458064;
        Wed, 19 Apr 2023 18:33:49 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B4958058;
        Wed, 19 Apr 2023 18:33:47 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.163.32.220])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 19 Apr 2023 18:33:47 +0000 (GMT)
Message-ID: <3f1cb05d70ea9a060951b8b2cd4ce84d8fb62174.camel@linux.ibm.com>
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
Date:   Wed, 19 Apr 2023 14:33:46 -0400
In-Reply-To: <5429f579-1512-b6b5-771a-70f3d27959b2@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
         <20230417230656.523826-2-bvanassche@acm.org>
         <cdd6b413085dc606c351f3c10ea82774498171e1.camel@linux.ibm.com>
         <4f59864e-d5cb-2590-99a3-2314873216f4@acm.org>
         <2ecb60b5a17bd15a90d0a4a1718c202f3a1374e4.camel@linux.ibm.com>
         <a2195da6-5d41-789f-091c-6d38c9d7d7b0@redhat.com>
         <392c0fc3412bd39d37a6b87ba58b505095c56f7e.camel@linux.ibm.com>
         <5429f579-1512-b6b5-771a-70f3d27959b2@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x1ObWZMTnLgzSF3_fz_nwH_ekDmjd7FI
X-Proofpoint-GUID: WsmeiNHsoGjH0DG2Fp9N8YqMK5x1rUHT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_12,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 adultscore=0 impostorscore=0 mlxlogscore=774
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304190162
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-04-19 at 10:58 -0700, Bart Van Assche wrote:
> On 4/19/23 07:02, James Bottomley wrote:
> > device_shutdown() goes in reverse devices_kset->list order, so it
> > looks like it would do the PCI device then the SCSI device then the
> > ULD then block, so we can use the queues in SCSI for emergency
> > actions (like flush or stop) before block goes down.  Although this
> > isn't guaranteed; there are things, like device_link_add, which
> > reorder this kset, so we'd need to make sure the above assumption
> > is correct.
> 
> Hi James,
> 
> My understanding is that both the block device associated with 
> /dev/sd<x> and the struct scsi_disk associated with the same SCSI
> device have the sdev_gendev member of struct scsi_device as parent.
> In other words, without creating device links, there are no
> guarantees about the order in which the .shutdown() methods of struct
> block_device.bd_device  and struct scsi_disk.disk_dev are called.
> Adding device links seems like an unnecessary complexity to me. Hence
> my preference to make sd_shutdown() responsible for quiescing future
> SCSI command activity.

So if we can't reliably get it right, let's not do it at all.  The
previous argument you made was about problems with I/O to shutdown PCI
devices.  That's not SCSI specific, so either we fix it for everything
or decide it's not really a problem for anything.

James

