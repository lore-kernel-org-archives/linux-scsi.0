Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF20BC2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 10:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E392395B
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 10:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U8/jxPZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIVKFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 06:05:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64822 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgIVKFm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Sep 2020 06:05:42 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MA3Uvs023543;
        Tue, 22 Sep 2020 06:05:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to : sender; s=pp1;
 bh=tDnVg5R8NbDuTgFyY82/UmIpQB8FASy8rzMuZwSzmcM=;
 b=U8/jxPZQevcnuxfMNtfV8HVIPb9piqqr6PozbvJ7VfSdSEylflFgRIKOegdgZS0MEyAe
 vb7uen++dphsbQ43WCXf6z/MRNYHQ1LnmILGZOBLS43oSlbZQE/5KSl8liPSaQmBntKn
 BOZaUQAAbHd8OHIguymFD0ZKxQGVlk0sRYpHE5hfQ9WCyRs6iwGF72bFfP1oN/fYyU/d
 tGTx7yIXUrF8DGDBEfOktSZt9I9ILdVXuuYule2sXaWomAe6RZHjOSGOzYBC0aWBTBgD
 WCFvijJFvBR4ZnpoMzmSzsi8EB1UkTglDzOx1j+bew2MP3FXgrSGE1A/Lm251mJYW7Z6 eg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33qdcytxtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 06:05:38 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08MA3vOX003630;
        Tue, 22 Sep 2020 10:05:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 33n9m7sh1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 10:05:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08MA5VNV30409162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 10:05:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7C324C05A;
        Tue, 22 Sep 2020 10:05:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D27C64C050;
        Tue, 22 Sep 2020 10:05:32 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.36.123])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Sep 2020 10:05:32 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1kKfAx-0002Jg-Kk; Tue, 22 Sep 2020 12:05:31 +0200
Date:   Tue, 22 Sep 2020 12:05:31 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 0/2] zfcp: small changes for 5.10
Message-ID: <20200922100531.GA6903@t480-pf1aa2c2>
References: <cover.1599765652.git.bblock@linux.ibm.com>
 <160074695008.411.13328105917017372358.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160074695008.411.13328105917017372358.b4-ty@oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_06:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220082
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 21, 2020 at 11:56:45PM -0400, Martin K. Petersen wrote:
> On Thu, 10 Sep 2020 21:49:14 +0200, Benjamin Block wrote:
> 
> > here are some small changes for zfcp I'd like to include in 5.10 if
> > possible. They apply cleanly on Martin's `scsi-queue`, and James' `misc`
> > branches.
> > 
> > Both patches make the driver a bit cleaner, and hopefully easier to
> > maintain.
> > 
> > [...]
> 
> Applied to 5.10/scsi-queue, thanks!
> 
> [1/2] scsi: zfcp: Use list_first_entry_or_null() in zfcp_erp_thread()
>       https://git.kernel.org/mkp/scsi/c/addf13729615
> [2/2] scsi: zfcp: Clarify access to erp_action in zfcp_fsf_req_complete()
>       https://git.kernel.org/mkp/scsi/c/d251193d1732
> 

Thanks Martin!

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
