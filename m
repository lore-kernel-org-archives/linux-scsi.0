Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E78DC6379F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 09:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjBVJxU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Feb 2023 04:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbjBVJxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2023 04:53:02 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990053B22E;
        Wed, 22 Feb 2023 01:51:29 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31M9fXIr030155;
        Wed, 22 Feb 2023 09:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=L6IGEN+fF4/ym4wJaEPRvWeE9P48usuwSm/tmBx8Vao=;
 b=B1GCGgM9802GYFl1tRkz0dC/NP/oy+Z/0UsgRcgg05QPXD4we6MTtXHMrsDX/8otMB6X
 ulTMK5bKkLCsi+Rh9E5+wrkbra7vc8vxVVSXCfYIrcOvWdR666QKhG9crpO82XdL7h7e
 xp4vR8AWLw1prDcSDmMdy1E7jQ7lQGiIbWzQgTmKP1loyeSR+CQi5ZkxgA8Z3kEn/KRC
 c42213wTC9tsZAuwQ1jR+ymL7UnooByC3RvTLTQVMVvaIN+TpF++fbtbD3CJfXudaALw
 QbDNunUmXgCEk7c9Bmo4j6hYjCDfPg3P44WjV3vxa7JjXUktJUrz6wfYgawR0KL1p3MI Aw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nwgmtg8ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 09:51:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31LNuqhr016606;
        Wed, 22 Feb 2023 09:51:02 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6d54t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Feb 2023 09:51:02 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31M9oxMQ16188128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 09:50:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 346C920040;
        Wed, 22 Feb 2023 09:50:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E4532004D;
        Wed, 22 Feb 2023 09:50:59 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.14.57])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 22 Feb 2023 09:50:59 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pUlm6-004fzS-20;
        Wed, 22 Feb 2023 10:50:58 +0100
Date:   Wed, 22 Feb 2023 09:50:58 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: zfcp changes for v6.3
Message-ID: <Y/XlgrZvvxDlPvRZ@t480-pf1aa2c2>
References: <cover.1677000450.git.bblock@linux.ibm.com>
 <yq1cz62pj7t.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <yq1cz62pj7t.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2SWz8Ighz7xVvbZ7HHYqbqc9oC1Ai0Q5
X-Proofpoint-ORIG-GUID: 2SWz8Ighz7xVvbZ7HHYqbqc9oC1Ai0Q5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-22_04,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302220083
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 21, 2023 at 08:46:17PM -0500, Martin K. Petersen wrote:
> > here is a small set of changes for the zFCP device driver. These are
> > basically follow-up changes I made after the fix I send in
> > <979f6e6019d15f91ba56182f1aaf68d61bf37fc6.1668595505.git.bblock@linux.ibm.com>
> > that refactor some related areas in the driver, and add some
> > additional tracing if we ever should run into a similar situation
> > somehow.
> >
> > It would be nice, if you could still include them for v6.3. Not sure if
> > I'm too late already.
> 
> It's a bit late. I merged them to 6.3/scsi-staging for now but may defer
> to 6.4 depending on how busy the various code checking robots are.
> 

Alright, sounds good. Thanks.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
