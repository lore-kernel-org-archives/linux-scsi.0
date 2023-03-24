Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A470EC6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 13:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCXNxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 09:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCXNxj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 09:53:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374F312CEE
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 06:53:38 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ODqA33038362;
        Fri, 24 Mar 2023 13:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to : sender :
 content-transfer-encoding : mime-version; s=pp1;
 bh=IBKYCG/Vkno8PCrhAjpczXnz4iLl5t2AMSy90x6Bwrs=;
 b=l09YCeFtPu6sP6zOd1d2WzXy+zPzj3Y77IR3iqrj254Cts9lVnPfPTwCtyu8NP0FK6vP
 27E4bbCPaEFaQbyB6/jXeuMWoFCMrydrGqWs1WPj1Ohnk9xeav7U9vdPPFBqBhs/7w/m
 n1X6YmQe0qHZFyQ4/OGWaRLZva11Dea64xS0ZKoR8Uf8uoGwYhiGxmcOgxmrE9FkzSw3
 /jdquZfzcG7py0tag88eWhngUYpdw/GcdmIOsNgOaH1IZa8sO7rnffFPJWY86HogfqJa
 A4v0EMqf/XYedSCpCWm/js8W3iYkdWof4hD8xaFzAy0JjBECsfFBTTh8c6S1My+hZbDD lA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3phd4c00jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 13:53:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLrLKs024568;
        Fri, 24 Mar 2023 13:53:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3pgy2t8r8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 13:53:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32ODrSlS29557484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 13:53:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E694D20040;
        Fri, 24 Mar 2023 13:53:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D13D320043;
        Fri, 24 Mar 2023 13:53:27 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.171.7.28])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Fri, 24 Mar 2023 13:53:27 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.96)
        (envelope-from <bblock@linux.ibm.com>)
        id 1pfhrD-0055my-0y;
        Fri, 24 Mar 2023 14:53:27 +0100
Date:   Fri, 24 Mar 2023 13:53:27 +0000
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Improves scsi_vpd_inquiry() checks
Message-ID: <20230324135327.GA1027618@t480-pf1aa2c2>
References: <20230322022211.116327-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20230322022211.116327-1-damien.lemoal@opensource.wdc.com>
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yZfmGbBnuWop8BIDK_GugAoqxPm7q5Wq
X-Proofpoint-ORIG-GUID: yZfmGbBnuWop8BIDK_GugAoqxPm7q5Wq
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_08,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303240109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 22, 2023 at 11:22:11AM +0900, Damien Le Moal wrote:
> Some USB-SATA adapters have a broken behavior when a non supported VPD
> page is probed: depending on the VPD page number, a 4 byte header with a
> valid VPD page number but with a 0 lenghth is returned. Currently,
> scsi_vpd_inquiry() only checks that the page number is valid to
> determine if the page is supported, which results in VPD page users
> receiving only the 4 B header for the non existent page. This error
> manifests itself very often with page 0xb9 for the concurrent
> Positioning Ranges detection done by sd_read_cpr(), resulting in the
> error message:
> 
> sd 0:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page
> 
> Prevent such misleading error message by adding a check in
> scsi_vpd_inquiry() to verify that the page length is not 0.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  drivers/scsi/scsi.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

Looks good to me.


Reviewed-by: Benjamin Block <bblock@linux.ibm.com>

-- 
Best Regards, Benjamin Block        /        Linux on IBM Z Kernel Development
IBM Deutschland Research & Development GmbH    /   https://www.ibm.com/privacy
Vors. Aufs.-R.: Gregor Pillen         /         Geschäftsführung: David Faller
Sitz der Ges.: Böblingen     /    Registergericht: AmtsG Stuttgart, HRB 243294
