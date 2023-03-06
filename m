Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618CFC678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 10:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjCFK6y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 05:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCFK6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 05:58:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83532659A
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 02:58:46 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3268epuf008595;
        Mon, 6 Mar 2023 10:58:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=gEW65SAnOFtZcaDsbZ9ALFrNV2sT5xF1jjGPVf66I4o=;
 b=DOUW1W+mGprwdAnXtEF2zE/0WG7PB3hyNvNQ5or1TPoK341TTOdcbIb8vSPTT5fnH1Fy
 0fZ0ONHWHUKppJLJ876wrel21AuKI9Er8FGC17X+X5HtdHVxfa/gWq6Imu9Z5CWUGLvy
 /0m88EhiP3SwqV/+0qB6sD3CM463Zpz46aQpRA7ggYXaPTH6n7wEHJmCQpNfi4HsIIMX
 SHYkUHpPU8IhUeDPMkgQveg9t4bK9yB+riOZAeYhHwY87TZydsry70qepw3Te5lKOYzq
 rB/x34iw8Qyn5BNu+lYFsSo8f7NEJbbstY8b90MM3u9ZuoqcAMsKwcHlUrnE+8l7nUrW 1g== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p4wsw32n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:58:43 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 325GqRDb004261;
        Mon, 6 Mar 2023 10:58:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3p41b0t2mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:58:41 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326AwcxW2687618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 10:58:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 458DB2004B;
        Mon,  6 Mar 2023 10:58:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CF5920043;
        Mon,  6 Mar 2023 10:58:38 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.78.75])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  6 Mar 2023 10:58:38 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pZ8Y9-000A94-1z;
        Mon, 06 Mar 2023 11:58:37 +0100
Date:   Mon, 6 Mar 2023 10:58:37 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH 08/81] scsi: zfcp: Declare SCSI host template const
Message-ID: <20230306105837.GD8597@t480-pf1aa2c2.fritz.box>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-9-bvanassche@acm.org>
 <20230306105152.GC8597@t480-pf1aa2c2.fritz.box>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230306105152.GC8597@t480-pf1aa2c2.fritz.box>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: siq56ELHqM-kAFH5ivuRwdMIKezhkg6p
X-Proofpoint-GUID: siq56ELHqM-kAFH5ivuRwdMIKezhkg6p
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 06, 2023 at 10:51:52AM +0000, Benjamin Block wrote:
> On Fri, Mar 03, 2023 at 04:29:50PM -0800, Bart Van Assche wrote:
> > Make it explicit that the SCSI host template is not modified.
> > 
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  drivers/s390/scsi/zfcp_scsi.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> > index 3dbf4b21d127..b2a8cd792266 100644
> > --- a/drivers/s390/scsi/zfcp_scsi.c
> > +++ b/drivers/s390/scsi/zfcp_scsi.c
> > @@ -418,7 +418,7 @@ static int zfcp_scsi_sysfs_host_reset(struct Scsi_Host *shost, int reset_type)
> >  
> >  struct scsi_transport_template *zfcp_scsi_transport_template;
> >  
> > -static struct scsi_host_template zfcp_scsi_host_template = {
> > +static const struct scsi_host_template zfcp_scsi_host_template = {
> >  	.module			 = THIS_MODULE,
> >  	.name			 = "zfcp",
> >  	.queuecommand		 = zfcp_scsi_queuecommand,
> 
> Yup, good change IMO.
> 
> 
> Acked-by: Benjamin Block <bblock@de.ibm.com>
> 

Oups. Sorry. That's the wrong email address.

Acked-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
