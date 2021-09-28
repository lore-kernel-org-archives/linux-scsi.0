Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84335C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 16:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B9361262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 16:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241913AbhI1Q7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 12:59:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240713AbhI1Q7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 12:59:46 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SF8i1Z009231;
        Tue, 28 Sep 2021 12:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=WbUyBo1iUshV8tySDJbcJcF6t6ES3do0PYSjAu51OBw=;
 b=RDVodHxWvhdCrWI4lNDRLQ6gPwZhXD1ahfeD2CIB5MtPm5Jp69BycCXDsjBC1ccr92bg
 rx5MTpkwYc9E9w1B8nYNOgIUcMqRJrBQKUj7EHnLI72P21XfaEK6EZ493Yt7Y3Rc3oTF
 WoV6mw1PdIpcUpk2LPeiad4do4wyhS7AA2t1r7cXohx7KC2AjFiNtu9KF2L9/0Cm46Ry
 6qndbEXixeOwP/PzkA6es4hWs56CW0YkK8zYvb4tC5F8CL8iaC3GgB0u2mez3kYrVNSf
 4R95YG6zTwtJLoFacR6AmTG8wE7yF6FDi6iEceTVXY7cJ94Phg1RmwpLPMS7dt67ZNRl mg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bbktr087u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 12:58:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18SGvsJ3002031;
        Tue, 28 Sep 2021 16:58:01 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3b9uda02vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 16:58:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18SGvv9e2687490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 16:57:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8819A42047;
        Tue, 28 Sep 2021 16:57:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EF1942045;
        Tue, 28 Sep 2021 16:57:57 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.145.72.153])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 28 Sep 2021 16:57:57 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.94.2)
        (envelope-from <bblock@linux.ibm.com>)
        id 1mVGQW-000EPB-VS; Tue, 28 Sep 2021 18:57:56 +0200
Date:   Tue, 28 Sep 2021 18:57:56 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH 02/84] scsi: core: Rename scsi_mq_done() into scsi_done()
 and export it
Message-ID: <YVNJlEGMNg5T8a0h@t480-pf1aa2c2.linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-3-bvanassche@acm.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20210918000607.450448-3-bvanassche@acm.org>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: m-DeCvCr4O9u7nF-4NhUMgpIHFaZ73Eo
X-Proofpoint-GUID: m-DeCvCr4O9u7nF-4NhUMgpIHFaZ73Eo
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109280096
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 05:04:45PM -0700, Bart Van Assche wrote:
> Since the removal of the legacy block layer there is only one completion
> function left in the SCSI core, namely scsi_mq_done(). Rename it into
> scsi_done(). Export that function to allow SCSI LLDs to call it directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c  | 5 +++--
>  include/scsi/scsi_cmnd.h | 2 ++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block  / Linux on IBM Z Kernel Development / IBM Systems
IBM Deutschland Research & Development GmbH    /    https://www.ibm.com/privacy
Vorsitz. AufsR.: Gregor Pillen         /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
