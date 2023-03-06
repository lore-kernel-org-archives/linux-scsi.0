Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78CBC678D4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 10:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCFKkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 05:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjCFKkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 05:40:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF56625BA5
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 02:40:43 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326A3CQh032119;
        Mon, 6 Mar 2023 10:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=4CaDNd63FsDOOsYBvqTTVBXyw6bXcWJmZMRXpXzS9Uc=;
 b=sPHFnPw9vml5Sz3iveCn/QkhTKTk7N05sWNqSFj+1W6xS8R7/oAhrefdESkspVAg1g6d
 e0qezLsg/29Aa+waM7fZP4/Mgv4N66X1gpDo1+I/6GYZXF0RNY26fuWI8qHHgwYt6x/M
 pLBQxxesWHMylGp+yXwO654fouOqVGkVRVz64ZhfI//QDJiBNVB8Z8nK/1TAw3u3OJgE
 y8oOdsiMcP/RkGptqcnkvc85f1vja2NJb1c2jitw1aSDvxn+mKPIq24Lm2cYC7zoWGW7
 b2sjp1jLTmj4NJWe4OPM+St2QRnTJdOm1RSgbQ+AupHykwscWYrtUTJZYOXSKv1M3hNU jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p500dghh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:40:25 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 326AbDWJ026459;
        Mon, 6 Mar 2023 10:40:25 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p500dghgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:40:25 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3265Q2OP002533;
        Mon, 6 Mar 2023 10:40:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3p41c3t1nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Mar 2023 10:40:22 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 326AeJAf43450778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Mar 2023 10:40:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 007D420040;
        Mon,  6 Mar 2023 10:40:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEE5E2004B;
        Mon,  6 Mar 2023 10:40:18 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.78.75])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon,  6 Mar 2023 10:40:18 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pZ8GQ-0008jW-1Q;
        Mon, 06 Mar 2023 11:40:18 +0100
Date:   Mon, 6 Mar 2023 10:40:18 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template
 pointers const
Message-ID: <20230306104018.GA8597@t480-pf1aa2c2.fritz.box>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-3-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230304003103.2572793-3-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LFaPTF-XO-RVTnROsh_4I6u2Vs6OaJ3q
X-Proofpoint-GUID: dfBALnkeodScf5Hv9KseI-WrgO4sgksJ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_03,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 03, 2023 at 04:29:44PM -0800, Bart Van Assche wrote:
> Prepare for constifying most SCSI host template pointers by constifying
> the SCSI host template pointer arguments and variables in the SCSI core.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 16 ++++++++--------
>  drivers/scsi/scsi_sysfs.c |  6 +++---
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 

Looks good to me.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
