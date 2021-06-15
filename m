Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FD3C48BE5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 09:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B1A96143E
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 09:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhFOJjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 05:39:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57390 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231736AbhFOJjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 05:39:24 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15F9YMNA152713;
        Tue, 15 Jun 2021 05:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=2ZdfK/zXwGU8t5XF3gpzad/lZaBO5qiBRsEcgeRoOHQ=;
 b=MStUqe51uS5Xv4XuducWVyhLHNZcXFLJveOTcjiC9KNfc0tuCFwu8fhxpTFPce9o7ffj
 WpbhZGo5sv9S8+cjGdU0QEW0BNFfj0n1/W50sxLg6vlTovoWZZdtyiyWal2MT3hh58gV
 LGAaBtUSKx3G08n6MUltt+Q6+mPXmMboezcfwwcr6Tevsg5iEzOfmcpKwZDTuWBE/aIy
 esKh7xBGSDBSgtXmN2Fv3r7iSmGll/EGED1vP7CqCH2alhof8NLvFLe6DcMskJN/iZLo
 6gwidDRY42/KgkJL+wk7KYu8x9dv3DDKdZoxrVF3hVE+9i59cgJgqXvHNH5kKUQr8Let 1Q== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 396rsu1ueu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 05:34:51 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15F9W9Sv028931;
        Tue, 15 Jun 2021 09:34:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 394mj8gs3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 09:34:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15F9YkrC19005824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Jun 2021 09:34:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDC9042041;
        Tue, 15 Jun 2021 09:34:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAB0A42049;
        Tue, 15 Jun 2021 09:34:46 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.173.127])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Jun 2021 09:34:46 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lt5T4-001XoS-7V; Tue, 15 Jun 2021 11:34:46 +0200
Date:   Tue, 15 Jun 2021 11:34:46 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/15] scsi: core: Make scsi_get_lba() return the LBA
Message-ID: <YMh0NrattChdK6ku@t480-pf1aa2c2.linux.ibm.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
 <20210609033929.3815-13-martin.petersen@oracle.com>
 <YMdspAy63qF1h8aI@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <YMdspAy63qF1h8aI@t480-pf1aa2c2.linux.ibm.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aEm9_Hg2wVF0gVLSXQ0KL8wGznRUKcHK
X-Proofpoint-GUID: aEm9_Hg2wVF0gVLSXQ0KL8wGznRUKcHK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106150058
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 14, 2021 at 04:50:12PM +0200, Benjamin Block wrote:
> On Tue, Jun 08, 2021 at 11:39:26PM -0400, Martin K. Petersen wrote:
> > scsi_get_lba() confusingly returned the block layer sector number
> > expressed in units of 512 bytes. Now that we have a more aptly named
> > scsi_get_sector() function, make scsi_get_lba() return the actual LBA.
> > 
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > ---
> >  include/scsi/scsi_cmnd.h | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> > index cba63377d46a..90da9617d28a 100644
> > --- a/include/scsi/scsi_cmnd.h
> > +++ b/include/scsi/scsi_cmnd.h
> > @@ -225,6 +225,13 @@ static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
> >  	return blk_rq_pos(scmd->request);
> >  }
> >  
> > +static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
> > +{
> > +	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
> > +
> > +	return blk_rq_pos(scmd->request) >> shift;
> 
> Hmm again, should it use `blk_mq_rq_from_pdu()`?
> 

I'm taking this is the same as with the other patch, Bart's series will
replace that as well.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
