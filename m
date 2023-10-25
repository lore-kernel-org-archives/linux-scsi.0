Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A82C07545
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 15:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343986AbjJYPt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 11:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjJYPt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 11:49:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B374E12F
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 08:49:26 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39PFh456012666;
        Wed, 25 Oct 2023 15:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YB+rf1jQOlW59tGx2poNHV7VQlQ4dAgxaD1vXEo7FiA=;
 b=KCOTEVeQc4EZKMrMWOtQe+c+AWHgosKHq6Hcmc6yNlkXeVoFRWV9vgNQefg4Mp7Z+ICp
 HKHbraaevCdFSm0b8alOLxi+hf42AufRaI/gSO/QHERID5Qo0Vs8Ejfov4vPlVDIy/hM
 t+JRed756vR7uv9f89KnY/MvJOdwEqwmZ2RWPgvwvR0Y9hKthROlfc2FsnqIsKxkZ3cJ
 h83g+a69IBhABhLfLX7egoz2PASwpNlhzeHvOeMzO+vKpRAJ6uZt2TK8CEqzkaq5TDQ7
 IVKkWKvuOdrIP4uQ2jwFx0hU0UXXxTHZphPcb8Ym/e2x398vJmM0bdShk0VRpUswPRm6 4w== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ty5p48wup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:49:16 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39PFIBjx023782;
        Wed, 25 Oct 2023 15:49:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tvryt7vvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:49:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39PFnDoA10814048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Oct 2023 15:49:13 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA3032004B;
        Wed, 25 Oct 2023 15:49:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D449C20043;
        Wed, 25 Oct 2023 15:49:12 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.171.40.191])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 25 Oct 2023 15:49:12 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvg88-00AXNk-1P;
        Wed, 25 Oct 2023 17:49:12 +0200
Date:   Wed, 25 Oct 2023 17:49:12 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 03/10] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Message-ID: <20231025154912.GH1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-4-hare@suse.de>
 <20231025151111.GF1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
 <c8eda29e-05ad-4292-b694-8349fb8cb995@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <c8eda29e-05ad-4292-b694-8349fb8cb995@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gaUQcUe2FYUpyLVoSuQn_FrZTXA2c8tR
X-Proofpoint-ORIG-GUID: gaUQcUe2FYUpyLVoSuQn_FrZTXA2c8tR
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-25_05,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1011 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310250137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2023 at 05:35:53PM +0200, Hannes Reinecke wrote:
> On 10/25/23 17:11, Benjamin Block wrote:
> > On Mon, Oct 23, 2023 at 11:28:30AM +0200, Hannes Reinecke wrote:
> >> -	unsigned tgt_id = cmnd->device->id;
> >> -	uint64_t lun_id = cmnd->device->lun;
> >> +	unsigned tgt_id = starget->id;
> >> +	uint64_t lun_id = 0;
> > 
> > Well, hopefully storage targets for LPFC can deal with LUN 0 :)
>
> Sad to say, but it's only with zfcp where I've seen the 'WLUN' thingie 
> being deployed. But alright, I'll check if I can grab a valid LUN ID.

I mean, I don't actually know whether this is a problem in practice; sending a
TMF to LUN 0. If this works for the LPFC folks, I don't mind.

> >> -		retval = SUCCESS;
> >> -		goto out;
> >> -	}
> >> +	starget_printk(KERN_INFO, starget,
> >> +	    "Attempting Target Reset!\n");
> > 
> > Nitpick: you can remove the line-break.
> > 
> Yes, and no. I had been debating with me whether I really wanted
> to do that. Linebreaks are in nearly all of the debugging messages

I meant the line-break in the source-code, not message :)

    starget_printk(KERN_INFO, starget, "Attempting Target Reset!\n");

> in this driver, so once I start removing them here questions will
> be asked why I removed it _just_ here, or, why I removed it at all.
> 
> I'd prefer doing that in a separate patch.
> 

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
