Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01641C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Nov 2022 15:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiK1PVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 10:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiK1PVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 10:21:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2652B1C3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2022 07:21:47 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASDfXnk001422;
        Mon, 28 Nov 2022 15:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=+DCb/4dtXyMQEGOUxg8I5uh8mCPBfM02h4n+c/onuQM=;
 b=nyJEY1WTO7bIRzIdF8kQjd92AzU20fFv3boa5ZApAmFGEU3vR9pEl8J9uMN3IZr22T3g
 6nIwZsS2Hdh0NIYv9twEnMacIpIKkqgevA91RnY0zOel0H7LwDStct3yYIaQ1M66AUjl
 RQ2BH/i+3HR+2aHltsoYo7CW90AdKsueUpMKenha/R9OCQOD+MCztTepMEN+dS6jhNlA
 a9Sm/tH3CuABa1zjvBHCjNPK1Y2FmNWmxtvVlUuYYuGjjgaS9+l+vt/Y/kFa6PAL5bEp
 s0CHsxDIEHa38AUPhKLyG6K9h94ElNOZmwxI7zAmRgSFTaweWp+PG2Tt6fgRW48Lzi1H YQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vmrkg4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:21:28 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASFK22h004308;
        Mon, 28 Nov 2022 15:21:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02dal.us.ibm.com with ESMTP id 3m3ae99vxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 15:21:27 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASFLPfx22151860
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 15:21:25 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B36F87805E;
        Mon, 28 Nov 2022 16:28:36 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C0D77805C;
        Mon, 28 Nov 2022 16:28:35 +0000 (GMT)
Received: from lingrow.int.hansenpartnership.com (unknown [9.211.83.181])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 28 Nov 2022 16:28:35 +0000 (GMT)
Message-ID: <70f4d744d64bc075138128a7a98b7186375170d8.camel@linux.ibm.com>
Subject: Re: [QUESTION]: Why did we clear the lowest bit of SCSI command's
 status in scsi_status_is_good
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Wenchao Hao <haowenchao@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linfeilong@huawei.com,
        yanaijie@huawei.com, xuhujie@huawei.com, lijinlin3@huawei.com
Date:   Mon, 28 Nov 2022 10:21:24 -0500
In-Reply-To: <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com>
References: <6e9ea80e-d4e0-6d52-47c1-8939c13d60a8@huawei.com>
         <ca7e2aba5db5bd6e15182070f26e0c2c77c70927.camel@linux.ibm.com>
         <ada12c1d-b732-59a9-8dba-1662673b6a5d@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V5UvaQV9KryPh4-6vSoF1VqnoHwQzpLy
X-Proofpoint-ORIG-GUID: V5UvaQV9KryPh4-6vSoF1VqnoHwQzpLy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_13,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211280112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-11-28 at 22:41 +0800, Wenchao Hao wrote:
> On 2022/11/28 20:52, James Bottomley wrote:
> > On Mon, 2022-11-28 at 11:58 +0800, Wenchao Hao wrote:
[...]
> > > We found some firmware or drivers would return status which did
> > > not defined in SAM. Now SCSI middle level do not have an uniform
> > > behavior for these undefined status. I want to change the logic
> > > to return error for all status which did not defined in SAM or
> > > define a method in host template to let drivers to judge what to
> > > do in this condition.
> > 
> > Why? The general rule of thumb is be strict in what you emit and
> > generous in what you receive (which is why reserved bits are
> > ignored). Is the drive you refer to above not working in some way,
> > in which case detail it so people can understand the actual
> > problem.
> > 
> > James
> > 
> > .
> 
> 
> We come with an issue with megaraid_sas driver. Where scsi_cmnd is
> completed with result's status byte set to 1, 

Megaraid_sas is an emulation driver for the most part, so it sounds
like this is in the RAID emulation firmware, correct?  The driver can
correct for emulation failures, if you can figure out what it's trying
to signal and convert it to the correct SAM error code. There's no need
to change anything in the layers above.  If you can't figure out the
translation and you want the transfer to error, then add DID_ERROR,
which is a nice catch all.  If this is transient and could be fixed by
a retry, then do DID_SOFT_ERROR instead.

James

