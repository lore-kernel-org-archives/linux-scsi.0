Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB61BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 20:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354191AbiFUUgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 16:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiFUUgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 16:36:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED452EA0B;
        Tue, 21 Jun 2022 13:36:08 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LK3WXo024753;
        Tue, 21 Jun 2022 20:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YhxexC3qFA0lsN7cct24u94C+TAzCVX5camFQ11uZno=;
 b=B7gEfJ//iHg9q7OzVllWoCpseh7KEqGIaUdNuvOk9NbvG0+4H4LfZ2PvqulcRUG18w6b
 TTbO1QnnBRBRpgHUcSFKDO1ywFo3kpDKP6W0ETPGop2hNJYToql9bVTObo6omwtJolgh
 lq7Uw8ivPCPRoBJ+qw343G8dJPgvTXVv9PBjiRtoR8cLsFjdIYFOrnTdfkXdAfTTpHuf
 d/1+TwHO4LT5O3Zg2x/ua5oqgFCZJY6g3HkxpRXlfQ2lDEQ3bzzy1ih7L/HE+izsg5FP
 sNiVl/7uO4PM7xsPibkwGeKAVk964dR/TxXA+JVFbi61WdkGs6a4XZn6SFo7vInIorfR ig== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gumpm0s9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:36:03 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LKZRAX015395;
        Tue, 21 Jun 2022 20:36:03 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 3gs6ba68kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 20:36:03 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LKa2lt42991998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 20:36:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9006EB2066;
        Tue, 21 Jun 2022 20:36:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 127DDB2064;
        Tue, 21 Jun 2022 20:36:02 +0000 (GMT)
Received: from [9.211.124.46] (unknown [9.211.124.46])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 20:36:01 +0000 (GMT)
Message-ID: <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
Date:   Tue, 21 Jun 2022 15:36:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
From:   Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: myor5KQicn5aQA9H2L8LHv4P4e_1_pN8
X-Proofpoint-ORIG-GUID: myor5KQicn5aQA9H2L8LHv4P4e_1_pN8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_09,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 mlxlogscore=898 malwarescore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210086
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/22 11:48 PM, Damien Le Moal wrote:
> 
> Polling people here: Do we still need the scsi IPR driver for IBM Power
> Linux RAID adapters (IBM iSeries: 5702, 5703, 2780, 5709, 570A, 570B
> adapters) ?
> 
> The reason I am asking is because this driver is the *only* libsas/ata
> driver that does not define a ->error_handler port operation. If this
> driver is removed, or if it is modified to use a ->error_handler operation
> to handle failed commands, then a lot of code simplification can be done
> in libata, which I am trying to do to facilitate the processing of some
> special error completion for commands using a command duration limit.

We still need it around for now. IBM still sells these adapters
and they can still be ordered even on our latest Power 10 systems.
 
Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

