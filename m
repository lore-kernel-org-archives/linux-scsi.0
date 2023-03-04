Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458DFC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 01:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjCDBJ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 20:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCDBJh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 20:09:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2440A66D34
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 17:08:24 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323NZBqh027300;
        Sat, 4 Mar 2023 01:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kvHQ7LMmeOso7DUarZlT2dKmSan+PEXIehuvByAw6hg=;
 b=nDiZPBot9CfEv/Dbjaw3i1m1Jwg9SfyPe/lNjvlpfMWGpTDKwOtbFdUjj2/A8XSZxQjZ
 pZwlYUIqN1rwFEse+/tu3eb6I5RLGL+G4FXp1UKthmH/7Q1YzjYfvCskyAp2o6a8RT/4
 oGcibuqF/Xj2/ELLuWs3xPLzOw4Q7vA/OtMMvz7pfz3INqGbxHP15jzQ6HjxXR8T05CO
 enid1mKJzIspbrAZDL+rGRFoN0lC+3e72y7fW6xLlq64dzkeLxkTc+AcyWYB1rIyZJSh
 zmfolkjgaVrC2nZMcBcxjd+3SfhFShbswaf8ZFV8Tz19/qy18MOEWVR4UiarZID6PzM+ Ew== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p3tpdhhwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Mar 2023 01:02:45 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 323NEE70018818;
        Sat, 4 Mar 2023 01:02:45 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3nybcce551-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Mar 2023 01:02:45 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32412hPp38732126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 4 Mar 2023 01:02:44 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C452F58059;
        Sat,  4 Mar 2023 01:02:43 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D775958043;
        Sat,  4 Mar 2023 01:02:42 +0000 (GMT)
Received: from [9.160.41.61] (unknown [9.160.41.61])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Sat,  4 Mar 2023 01:02:42 +0000 (GMT)
Message-ID: <a897f127-53c8-95ea-1a36-deb72c8cb401@linux.ibm.com>
Date:   Fri, 3 Mar 2023 17:02:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 44/81] scsi: ibmvfc: Declare SCSI host template const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-45-bvanassche@acm.org>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20230304003103.2572793-45-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LtK60_kOubbGL3yM-VKB4-JkyyuWNhXw
X-Proofpoint-ORIG-GUID: LtK60_kOubbGL3yM-VKB4-JkyyuWNhXw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_06,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxlogscore=725 mlxscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303040000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 16:30, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

