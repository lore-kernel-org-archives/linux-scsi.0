Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6AFC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 16:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1510E61008
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Apr 2021 16:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhDRQFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Apr 2021 12:05:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230038AbhDRQFP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Apr 2021 12:05:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13IG3xub135948;
        Sun, 18 Apr 2021 12:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=h7T08wnUE0ixIRvNfJCzZw2Q67J5u3A1Md9c6HjLV8A=;
 b=qMhLRBE7xJRQ2UdViRZB7FFgvLNTFpRySNMmL2Il+C1fUzGkoQ5lwAgqU+ocogju0Nb0
 5J6Um8TNo5qTIBRs7NVifcNvzVj4FiPLiYYospUcV01GpLaLUeqld/mqAKRZsLomiXXq
 ASJicsi0Q6p4uo7U3wwzChx/2wo7Lh4Lc/vMKZVRrleqN4SBmTQki00vL7LTVTzrax6a
 JmUtT9MAuMyIqDMLLUwlGE81SwM7TCSjTXb8UuWzqImV5wVBEuVBTSsMuwP0O+iVgPwv
 tsOlaMtJASDYulEXWb6j9enM1ACFZ3skapMeYT226BqTYVPD7J5huS5rFb7btNp8d2vq QQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380d6u1aep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Apr 2021 12:04:37 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13IG4WXP136710;
        Sun, 18 Apr 2021 12:04:37 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380d6u1aeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Apr 2021 12:04:37 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13IFquaZ026511;
        Sun, 18 Apr 2021 16:04:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 37yqa8gk34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 18 Apr 2021 16:04:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13IG49Cc28377548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 18 Apr 2021 16:04:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEAF211C04C;
        Sun, 18 Apr 2021 16:04:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBAC211C04A;
        Sun, 18 Apr 2021 16:04:31 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.175.103])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 18 Apr 2021 16:04:31 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lY9uR-0038gP-98; Sun, 18 Apr 2021 18:04:31 +0200
Date:   Sun, 18 Apr 2021 18:04:31 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Yevhen Viktorov <yevhen.viktorov@virginmedia.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/6] zfcp: cleanups and qdio code refactor for 5.13/5.14
Message-ID: <YHxYj9puknZP/anG@t480-pf1aa2c2.linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
 <yq1v98nynqw.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <yq1v98nynqw.fsf@ca-mkp.ca.oracle.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P-z3g_sb-KjiHKqpOtIw3Ai7Uk_ObwDq
X-Proofpoint-ORIG-GUID: pOxmFEkL4uSRwJXQFmdMQccz0uNcl1BL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-18_10:2021-04-16,2021-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 phishscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104180112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 15, 2021 at 10:20:55PM -0400, Martin K. Petersen wrote:
> 
> Benjamin,
> 
> > I know I am pretty late; we have some patches queued that I didn't
> > come around posting yet; its nothing world-changing, so if you don't
> > want to pull them for 5.13 anymore, no worries.
> 
> Applied to 5.13/scsi-staging, thanks! We'll see whether we get an -rc8
> or not.
> 

Alright, thanks Martin.

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
