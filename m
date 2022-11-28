Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6827CC43217
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 12:52:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiK1Mw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 07:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiK1Mwz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 07:52:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DEFB7DE
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 04:52:55 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASBk3cc022528;
        Mon, 28 Nov 2022 12:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : content-transfer-encoding : mime-version; s=pp1;
 bh=CZaOdcnZPuYH2Qo9lNrxl6ctZ5VbTOwAGCEUfkxCK9k=;
 b=ZO9OY11UQI16AMO+Z7rok0axZLhJfQvvAKFdm6nhsxu8gK97h+QYhRh02pdWw5rX81Lh
 arYoK8Gs+c1f5/KMbNAcDLgD23HCJP12aQGLUvtbP7NDDDGHxBV1im7GP03c5B4LhIxZ
 Ixn0ukMx6YOuhB/PGM90amRCttpNh30HMMCD6kyGFRuOQEvtYXtZVIIPfd0fdKaSyeku
 NvadK1w3AindwbrddXTMpJ3o239bUN5rZ0aOsJwSwOWWcqh51qaucnVspZFuOB9kXl7K
 q1ne4VW/9ovqGjXL6s9CwuAfN4pXL3btVQ25EH0uxc6pEcYf2aI7MSYmKJu0wL1e9XdH 0Q== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vmrfqdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 12:52:39 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASCpqu1003567;
        Mon, 28 Nov 2022 12:52:38 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 3m3ae98xdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 12:52:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASCqdij37159476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 12:52:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 358317805E;
        Mon, 28 Nov 2022 13:59:43 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE0D37805C;
        Mon, 28 Nov 2022 13:59:41 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.83.181])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 13:59:41 +0000 (GMT)
Message-ID: <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Wenchao Hao <haowenchao@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linfeilong@huawei.com,
        yanaijie@huawei.com, xuhujie@huawei.com, lijinlin3@huawei.com
Date:   Mon, 28 Nov 2022 07:52:34 -0500
In-Reply-To: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7ipf3KGV3fvHlEo3PLPvipnOLO9Zz8it
X-Proofpoint-ORIG-GUID: 7ipf3KGV3fvHlEo3PLPvipnOLO9Zz8it
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_09,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211280096
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
> static inline bool scsi_status_is_good(int
> status)                                                              
>                                                                      
>                           
> {
>         if (status < 0)
>                 return false;
> 
>         if (host_byte(status) == DID_NO_CONNECT)
>                 return false;
> 
>         /*  
>          * FIXME: bit0 is listed as reserved in SCSI-2, but is
>          * significant in SCSI-3.  For now, we follow the SCSI-2
>          * behaviour and ignore reserved bits.
>          */
>         status &= 0xfe;
>         return ((status == SAM_STAT_GOOD) ||
>                 (status == SAM_STAT_CONDITION_MET) ||
>                 /* Next two "intermediate" statuses are obsolete in
> SAM-4 */
>                 (status == SAM_STAT_INTERMEDIATE) ||
>                 (status == SAM_STAT_INTERMEDIATE_CONDITION_MET) ||
>                 /* FIXME: this is obsolete in SAM-3 */
>                 (status == SAM_STAT_COMMAND_TERMINATED));
> }
> We have function defined in include/scsi/scsi.h as above, which is
> used to check if the status in result is good.
> 
> But the function cleared the lowest bit of SCSI command's status,
> which would translate an undefined status to good in some condition,
> for example the status is 0x1.
> 
> This code seems introduced in this patch:
> https://lore.kernel.org/all/1052403312.2097.35.camel@mulgrave/
> 
> Is anyone who knows why did we clear the lowest bit? 

It says why in the comment you quote above ... what is unclear about
it?

> We found some firmware or drivers would return status which did not
> defined in SAM. Now SCSI middle level do not have an uniform behavior
> for these undefined status. I want to change the logic to return
> error for all status which did not defined in SAM or define a method
> in host template to let drivers to judge what to do in this
> condition.

Why? The general rule of thumb is be strict in what you emit and
generous in what you receive (which is why reserved bits are ignored).
Is the drive you refer to above not working in some way, in which case
detail it so people can understand the actual problem.

James

