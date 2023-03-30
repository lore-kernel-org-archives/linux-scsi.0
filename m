Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111D1C6FD1D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 14:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbjC3OrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Mar 2023 10:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjC3OrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2023 10:47:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72CEA5D8
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2023 07:46:50 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UEDVGR020167;
        Thu, 30 Mar 2023 14:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/G7RiH/nn1e8rBRpaeTbW+UzjLPO58gGe2bKPk7I7y4=;
 b=qj3MRVNHhOOEks9av8gxqjLkKbrkrCQUwuf8ivYt1aJtHAKIfJ3M5qV97WBQVs25f0nN
 Ix6Uk7GuornBmOKR7TKdvkytDSkciqjPfTXH2241C9dWTuRPl7n4eYZVinVHE8gJgm1h
 /MHqZ8qY/1nZl7Ju9YfpCnfcKKluqp5IvoCWmTxfNuFGKkKb1TAZpfBXWq6DKIuDsAiU
 fuxKXlmgkzGRcPI0h0yNN7GjuWtTD3RMdal3VKW4KXakaVijl3n674JKtnmijJKI6HrD
 qk9d74VJOE9pyuUPN/HE/J5MPxAb75IEhukN8ZZSokfF1iM+2Ez2Fj6IoOBPn8zEVuur ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn84c63j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 14:46:37 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32UEDhDp020932;
        Thu, 30 Mar 2023 14:46:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn84c62t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 14:46:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32UAtC30003455;
        Thu, 30 Mar 2023 14:46:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3phrk6vvx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Mar 2023 14:46:34 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32UEkVpX31457834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 14:46:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4070F2004E;
        Thu, 30 Mar 2023 14:46:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3060D20040;
        Thu, 30 Mar 2023 14:46:31 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.191])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 30 Mar 2023 14:46:31 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1phtXq-002ukx-2l;
        Thu, 30 Mar 2023 16:46:30 +0200
Date:   Thu, 30 Mar 2023 14:46:30 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Enze Li <lienze@kylinos.cn>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, enze.li@gmx.com
Subject: Re: [PATCH] scsi: sr: simplify the sr_open function
Message-ID: <20230330144630.GD10558@t480-pf1aa2c2.fritz.box>
References: <20230327030237.3407253-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230327030237.3407253-1-lienze@kylinos.cn>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AruO_09cOtcGKw70j27ZUtU4kVrujnaL
X-Proofpoint-GUID: cwoJzk3NWFZZ2yXQAT3H7qQHHcsBpdBP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_09,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1011 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303300114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 27, 2023 at 11:02:37AM +0800, Enze Li wrote:
> Simplify the sr_open function by removing the goto label as it does only
> return one error code.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  drivers/scsi/sr.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 

Looks good to me.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
