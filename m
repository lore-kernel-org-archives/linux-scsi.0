Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27541C636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 18:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjBBSrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 13:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjBBSrh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 13:47:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A7322A23
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 10:47:32 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312IBn0g028054;
        Thu, 2 Feb 2023 18:46:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=+Yt+Uib83vP2vpROCpMzWMxVzwcgLbOlkziO4rwpI8o=;
 b=oTcs9Q0XvmJQIgsvK8MkghU+BqKSpY+fVy/YJ24+AEbz4zPYv+rxTdx8F73qE1knIgzb
 RRsF1x+2Os61bH+vQ39S874bm+WLfkw0nzT/QO3yVE3IH8thX1ujjNO0xouko83gSpLx
 IVDGscGHrvWWKst1PYZq1yctJSqHm6TIDZojCPCZfw/0zHxEtQzdsrFScOXQsT4MfzaL
 jEUbtn4oUJGJnSQE0NW2GWQXBgKBdOPQJMvnL/1jcEkXpXaqhZGlUXPyxEaiYvX+3uMt
 jPdVQmM9AoDb7yyfQRZp9y/HmSHSuC6+eSp3wv9YrSaPJgixkLXiYuCppcu83wr01sk5 7g== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngegwf05t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 18:46:49 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312Fg4uS004994;
        Thu, 2 Feb 2023 18:46:49 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3ncvv24x5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 18:46:49 +0000
Received: from b03ledav001.gho.boulder.ibm.com ([9.17.130.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312Ikmej9306876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 18:46:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB3866E050;
        Thu,  2 Feb 2023 18:48:58 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 228A56E04E;
        Thu,  2 Feb 2023 18:48:56 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.110.248])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 18:48:56 +0000 (GMT)
Message-ID: <9d784606dfd75feefe653694d920b15e9dfcaff0.camel@linux.ibm.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Date:   Thu, 02 Feb 2023 13:46:14 -0500
In-Reply-To: <941ac8ba-8814-f3d5-ddc7-712058ea91ef@acm.org>
References: <20230201180637.2102556-1-bvanassche@acm.org>
         <20230201180637.2102556-3-bvanassche@acm.org>
         <fdbaf66c-b04b-2477-e778-6f6f054f0db2@intel.com>
         <941ac8ba-8814-f3d5-ddc7-712058ea91ef@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zDEGMyAYgq982mpGKxyzwZPOqkabhvrg
X-Proofpoint-GUID: zDEGMyAYgq982mpGKxyzwZPOqkabhvrg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_12,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=716 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020166
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-02-02 at 10:09 -0800, Bart Van Assche wrote:
> On 2/1/23 23:52, Adrian Hunter wrote:
> > On 1/02/23 20:06, Bart Van Assche wrote:
> > > UFS devices perform better when using SYNCHRONIZE CACHE command
> > > instead of the FUA flag. Hence this patch.
> > 
> > It would be nice to get some clarification on what is
> > going on for this case.
> > 
> > This includes with Data Reliability enabled?
> > 
> > In theory, WRITE+FUA should be at least as fast as
> > WRITE+SYNCHRONIZE CACHE, right?
> > 
> > Do we have any explanation for why that would not
> > be true?
> > 
> > In particular, is SYNCHRONIZE CACHE faster because
> > it is not, in fact, providing Reliable Writes?
>   Hi Adrian,
> 
> Setting the FUA bit in a WRITE command is functionally equivalent to 
> submitting a WRITE command without FUA and submitting a SYNCHRONIZE 
> CACHE command afterwards. For both sequences the storage device has
> to guarantee that the written data will survive a sudden power loss
> event.

Well, that may not be true in all situations.  Semantically FUA is a
barrier: it can be implemented such that it destages only the current
write plus the cache writes that occurred before the write with the
FUA.  It could also be implemented as you suggest above, which simply
destages the entire cache, but it doesn't have to be.  One of the
reasons for FUA to exist is the potential difference between the two.

James

