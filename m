Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EEEC25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 14:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbjJZOJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 10:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjJZOJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 10:09:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153B2128
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 07:09:00 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QE4KhH003574;
        Thu, 26 Oct 2023 14:08:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dE95PXbKjFlD3v1f7vMK6BJcraVO8SA4q9gRfZB1sqA=;
 b=F/dwJOkSoH3SRiZ+5cxBgc/GEGIVL0DR6mnuUY0uTlbNSVHO3QG7qY68ka7yiF6pCvlo
 8Qux23Xpji2ffufBxLT0WX8AKYr+kjpAhu3IFRnRAdMKhPh44nOgNxAsocaoL4cRIv1k
 5bunNMVcgTC1frZO72teuwkZpdnZ3jfT2ZkjxsEV7/1iMJ5iTu34T5/EO1ybewAUW5pm
 sElIaWtE4JB3MvLdGPJREKk1W0QzfdoT3iVNbVDSnoIANBJuQ4DHHvrAq2v/Owhc3C25
 ZbfohG1QUIQqTK2/kzfdSbY8ho5/Lpk76ZCcuQgXg+ItwezQFKthV8NWUx4EKL86ewUc FA== 
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tys1h161s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:08:49 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QCAApw026883;
        Thu, 26 Oct 2023 14:08:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsyp6gat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:08:48 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QE8kxg15598150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 14:08:46 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D8DD20043;
        Thu, 26 Oct 2023 14:08:46 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DDBD20040;
        Thu, 26 Oct 2023 14:08:46 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.253])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 26 Oct 2023 14:08:46 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qw12U-00Arcv-0i;
        Thu, 26 Oct 2023 16:08:46 +0200
Date:   Thu, 26 Oct 2023 16:08:46 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 09/10] scsi_error: map FAST_IO_FAIL to -EAGAIN in SCSI EH
Message-ID: <20231026140846.GO1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-10-hare@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20231023092837.33786-10-hare@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7F46EJOhN7ri1PJ7UXSdYoA4YOB1Amie
X-Proofpoint-ORIG-GUID: 7F46EJOhN7ri1PJ7UXSdYoA4YOB1Amie
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_12,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 clxscore=1011 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 11:28:36AM +0200, Hannes Reinecke wrote:
> Returning FAST_IO_FAIL from any of the SCSI EH functions is perfectly
> valid, and indicates that the request could not be executed due to
> the transport being busy.
> But that is not an I/O error, and we should return -EAGAIN from
> scsi_ioctl_reset() to correctly inform userspace.

I've had a short look at at least one user of this interface `sg_reset`, and
that seems to handle this already:

    https://github.com/doug-gilbert/sg3_utils/blob/0e955c48621f7dc512e34554a060fe9f5cbc8d67/src/sg_reset.c#L251-L267

So this looks good to me.

> 
> Suggested-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
