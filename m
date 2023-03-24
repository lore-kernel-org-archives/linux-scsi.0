Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6152AC6FD20
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 21:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjCXVHR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 17:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCXVHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 17:07:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23298A5A;
        Fri, 24 Mar 2023 14:07:13 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OL4GHM006330;
        Fri, 24 Mar 2023 21:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=ZYkLJMRhJY4qw35vNSRwie4Rav7RnV7Isp6xRDDUWeY=;
 b=FN3ZMDLkEylIE9gb56Z0NZa/nq+1Y0u4wTDdrapIwd4DxpP+rZPloCGhiNXT73F2X01Y
 nA+WfCc1TOYrGmsXKv2IkPsyLHTn6/dyLKjYgshJf5V9aw9TI2c81iZxgvJCKJWPIJaZ
 0iKaPvANlM0zRC0X0q86jYvZ322xym0WYT+2mwDDPfkceKKVBXBswUJsEtzM80buEk6t
 Z8ZQPbLUcehF+H/jQU4sxF1CscM+ggt71UjEHn5QpaEwT8pankRczinRngc8pdNa4sIr
 5zLh+4IYJaxaBhLRAl7pTOPzOfUlHUa+VM0wAIwcVLJ44cabzA/dHFnqhSL7/kBMr8RG ZQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phkey806w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OK2tIb027807;
        Fri, 24 Mar 2023 21:07:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4se4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:07:09 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OL76fE017159;
        Fri, 24 Mar 2023 21:07:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4se2p-7;
        Fri, 24 Mar 2023 21:07:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Rob Herring <robh@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Use of_property_read_bool() for boolean properties
Date:   Fri, 24 Mar 2023 17:06:58 -0400
Message-Id: <167969123972.59527.9275208094784239456.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230310144723.1544999-1-robh@kernel.org>
References: <20230310144723.1544999-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=970 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240160
X-Proofpoint-GUID: KM-s2L3zjaMmV7MBrkma3sN4RGJ9fU1x
X-Proofpoint-ORIG-GUID: KM-s2L3zjaMmV7MBrkma3sN4RGJ9fU1x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 10 Mar 2023 08:47:23 -0600, Rob Herring wrote:

> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
> 
> 

Applied to 6.4/scsi-queue, thanks!

[1/1] scsi: Use of_property_read_bool() for boolean properties
      https://git.kernel.org/mkp/scsi/c/06f8e0714c9f

-- 
Martin K. Petersen	Oracle Linux Engineering
