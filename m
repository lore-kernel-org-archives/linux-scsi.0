Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789E9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 06:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240959AbiKRGML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 01:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRGMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 01:12:09 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B9C4090D
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 22:12:08 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI63W2s007760;
        Fri, 18 Nov 2022 06:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type : subject :
 from : in-reply-to : date : cc : message-id : references : to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CsGeXSyDs2LnWe70EY/LaGLYmrv8OWpZU8aeRvEG3x4=;
 b=aif2augx8bGh93u1p/oIJSQkoheoWh7nI2X6ZgihV/NCOR9CWoRDjdV6i6UfHyXjh7bx
 TwWVgsCrmDF8EDAE8VbznloEFVlyuXfVXBKwOfvjkdhbMHEAceWheRyIlW6EPSeIVO1T
 YRFi4VyzaLO5c/wG97ULG0ataF3PRbmlhveEfjXZazFzzoWDa22nONQx/QgeraJ5hf72
 6iBFpfypNRwe8CVD5zLOBJ/8vaws6ma6pJX9sKrcsNHFnKXF9U7Z75a/VNMDmT8hTbu/
 TKfmUzfeNrRThy26znblkHMQ0CL45zJiaBNuAoOqWs4phQ2Yc/gR/qqgPJGIPwUwvyut BQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kx4evg5w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 06:12:00 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AI66BKw000541;
        Fri, 18 Nov 2022 06:11:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3kwsse0e8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 06:11:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AI65qjo39125264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 06:05:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30BB8AE045;
        Fri, 18 Nov 2022 06:11:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA4AFAE04D;
        Fri, 18 Nov 2022 06:11:54 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.39.245])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Nov 2022 06:11:54 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Subject: Re: [PATCH 1/2] scsi: alua: Revert "Move a scsi_device_put() call out
 of alua_check_vpd()"
From:   Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <20221117183626.2656196-2-bvanassche@acm.org>
Date:   Fri, 18 Nov 2022 11:41:43 +0530
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>
Message-Id: <621BAA12-689E-4420-9D63-CC53E77370D5@linux.ibm.com>
References: <20221117183626.2656196-1-bvanassche@acm.org>
 <20221117183626.2656196-2-bvanassche@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MCxTAbuXWPgwm88GY10HgYR4QhaHbqgb
X-Proofpoint-ORIG-GUID: MCxTAbuXWPgwm88GY10HgYR4QhaHbqgb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=950
 adultscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180041
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 18-Nov-2022, at 12:06 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> There is a bug in commit 0b25e17e9018 ("scsi: alua: Move a
> scsi_device_put() call out of alua_check_vpd()"): that patch may cause
> alua_rtpg_queue() callers to call scsi_device_put() even if that function
> should not be called. Revert that commit to prepare for a different
> solution.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Sachin Sant <sachinp@linux.ibm.com>
> Cc: Benjamin Block <bblock@linux.ibm.com>
> Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> Reported-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/device_handler/scsi_dh_alua.c | 23 ++++++++--------------
> 1 file changed, 8 insertions(+), 15 deletions(-)

Thanks for the patch. 
Tested it on top of next-20221117. The reported warning is not seen.

Tested-by: Sachin Sant <sachinp@linux.ibm.com <mailto:sachinp@linux.ibm.com>>

- Sachin
