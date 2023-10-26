Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A7FC25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 12:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjJZMow (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 08:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjJZMov (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 08:44:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937CB194
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 05:44:48 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QCfdt0030927;
        Thu, 26 Oct 2023 12:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XD+qMlHNwLBsnMA+cDItNe4EX0kj6am8D6eszkZuepE=;
 b=LZtIq7Z7JijFNxS1UH7MLz7gcFc8/Kh9XZ82T+iC4oWEZsbip5QGHUaqZg2Z0hsUtZ3z
 jsBpsP/uxxGWj+hmep8FlNwjLkcb7lkCv5IefkfdkGmS/mkjMUBL2kWKKefAf9NO58jZ
 attLHvumj5YlIQWVcc4UPSky6LSkMtilSUf+BM480oWR+upvLLCxgY6oRIKKxKv7h9A6
 4tpPyttNFnQSOiatsxKRt0IAXbPS+18EHluczbTfYatGwVf1OxpAVo9lTvyEWz7kefh1
 rVAJgVhVqeukJQ3GIW3jJ8WHDp1A7q9iCvLXHHzzHqp7hnGUf+ueDsEprmZ40q85oVT1 jQ== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tyr048wsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:44:37 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QBM2SB010315;
        Thu, 26 Oct 2023 12:44:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsbyx9fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 12:44:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QCiXFu62915060
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 12:44:33 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C2762004B;
        Thu, 26 Oct 2023 12:44:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88FE120040;
        Thu, 26 Oct 2023 12:44:32 +0000 (GMT)
Received: from p1gen4-pw042f0m (unknown [9.152.212.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 26 Oct 2023 12:44:32 +0000 (GMT)
Received: from bblock by p1gen4-pw042f0m with local (Exim 4.96.1)
        (envelope-from <bblock@linux.ibm.com>)
        id 1qvziy-00Alq5-0j;
        Thu, 26 Oct 2023 14:44:32 +0200
Date:   Thu, 26 Oct 2023 14:44:32 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 04/10] scsi: Use scsi_device as argument to
 eh_device_reset_handler()
Message-ID: <20231026124432.GJ1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-5-hare@suse.de>
 <20231026122438.GI1917450@p1gen4-pw042f0m.boeblingen.de.ibm.com>
 <97271b99-e3a1-407d-a14e-14dccca58eb7@suse.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <97271b99-e3a1-407d-a14e-14dccca58eb7@suse.de>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qlqGl93iERSyT1BRfNlkq92EkY3uBbWx
X-Proofpoint-GUID: qlqGl93iERSyT1BRfNlkq92EkY3uBbWx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_10,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 priorityscore=1501 mlxlogscore=714 mlxscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310170001 definitions=main-2310260109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 26, 2023 at 02:39:43PM +0200, Hannes Reinecke wrote:
> On 10/26/23 14:24, Benjamin Block wrote:
> > On Mon, Oct 23, 2023 at 11:28:31AM +0200, Hannes Reinecke wrote:
> >> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> >> index 01c0d571de90..0d03b361ed72 100644
> >> --- a/drivers/scsi/pcmcia/nsp_cs.h
> >> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> >> @@ -297,8 +297,6 @@ static        int        nsp_show_info  (struct seq_file *m,
> >>   static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
> >>   
> >>   /* Error handler */
> >> -/*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
> >> -/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
> > 
> > Hmm, this is a bit off-topic; is it? You don't change anything else in this
> > header. Hmm, maybe because it's the old device-reset handler that still has
> > `scsi_cmnd` as arg.
> > 
> Yes. They've been commented out for ages, and will just serve to confuse 
> users if they remain in the code.
> But I can drop this bit if you insist.

Not particularly. The part about confusion because of the changed arg is true,
so we might as well remove it.

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
