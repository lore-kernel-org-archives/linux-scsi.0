Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E77EC0032E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 15:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbjJYPP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjJYPP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 11:15:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF13131
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 08:15:22 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PF9WVY006246;
        Wed, 25 Oct 2023 15:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WapMEjxCrbPMWbQ1bwisIXdG4DpdOQ3Y6tKC79FGyBA=;
 b=E7roks9jl417z7tJeEP7Oxjt/L22HbEg0oBtJq9FL49ucuTAaqQnSdYYBZp3QysoFHUS
 6V8Fw00R491wgzLop+KL7G+bR4nmK+Uau9wZxaXCrTJ4JAXlioRxuXkifRR+wxOVyRo6
 t13S1Y3KNbrtgRAngYsaUmWuzGvnSPa4uD6PqkthUCxXqFv8oy7bEU3U9LMIMBQJbw+t
 YHWi+3mcnSCf71psGyRnIMOP4LS/BvCIvrb8L2ZE/YK2AwXPkoqMJVWgjIhpc19VmV0n
 qU4l8kq9rmzHXTLWqYeZpDGRjw+raVKOJdfRR3np4/aqdYJDAkB8aHIU0hWnIvIA74n6 QQ== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty5dpg7bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:15:15 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PCltPv010224;
        Wed, 25 Oct 2023 15:15:14 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsbyqmqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:15:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PFFC6R37290412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 15:15:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47CEA20043;
        Wed, 25 Oct 2023 15:15:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30BF320040;
        Wed, 25 Oct 2023 15:15:12 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.40.191])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Oct 2023 15:15:12 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvfbD-00AVdN-2D;
        Wed, 25 Oct 2023 17:15:11 +0200
Date:   Wed, 25 Oct 2023 17:15:11 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 02/10] scsi: Use Scsi_Host and channel number as argument
 for eh_bus_reset_handler()
Message-ID: <20231025151511.GG1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-3-hare@suse.de>
 <20231025133342.GE1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
 <0879f7eb-72ec-41bf-ac23-9e1e8a669b68@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <0879f7eb-72ec-41bf-ac23-9e1e8a669b68@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vTU0_5v0Lw2ud4WP1qwZu-Yz1Ir77sc7
X-Proofpoint-GUID: vTU0_5v0Lw2ud4WP1qwZu-Yz1Ir77sc7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_04,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310250132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2023 at 03:36:57PM +0200, Hannes Reinecke wrote:
> On 10/25/23 15:33, Benjamin Block wrote:
> > On Mon, Oct 23, 2023 at 11:28:29AM +0200, Hannes Reinecke wrote:
> >> diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
> >> index 96983bb1cc45..43083efc554b 100644
> >> --- a/Documentation/scsi/scsi_mid_low_api.rst
> >> +++ b/Documentation/scsi/scsi_mid_low_api.rst
> >> @@ -741,7 +741,8 @@ Details::
> >>   
> >>       /**
> >>       *      eh_bus_reset_handler - issue SCSI bus reset
> >> -    *      @scp: SCSI bus that contains this device should be reset
> >> +    *      @host: SCSI Host that contains the channel which should be reset
> >> +    *      @channel: channel to be reset
> >>       *
> >>       *      Returns SUCCESS if command aborted else FAILED
> > 
> > Same as in Patch 1. Although I don't know how relevant FAST_IO_FAIL is for bus
> > reset, we don't implement that for zFCP.
> 
> I'd rather delegate that to the later patch where I update scsi_error to 
> factor in FAST_IO_FAIL for ioctl reset.

Ok, that works as well.

> >>       *
> >> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
> >> index 77c91a405d20..ee8bb7985d09 100644
> >> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> >> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> >> @@ -863,21 +863,21 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
> >>    * Reset the SCSI bus.
> >>    */
> >>   static int
> >> -ahd_linux_bus_reset(struct scsi_cmnd *cmd)
> >> +ahd_linux_bus_reset(struct Scsi_Host *shost, unsigned int channel)
> >>   {
> >>   	struct ahd_softc *ahd;
> >>   	int    found;
> >>   	unsigned long flags;
> >>   
> >> -	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
> >> +	ahd = *(struct ahd_softc **)shost->hostdata;
> > 
> > Not `shost_priv(shost)`? The pointer casts end up at `struct ahd_softc *`, so
> > `void *` as return type should be fine.
> > 
> Ah, no. The adaptec driver is storing the _pointer_ to 'ahd_softc' in 
> hostdata[0]. So shost_priv() won't work here.
> Or, rather, not without an additional cast, but then we might as well 
> keep it for now.
> 

Ah yeah, ofc, we need the extra de-reference. I was confused. Never mind.
I Don't see anything else then.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
