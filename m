Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732AAC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 16:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiKRQEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 11:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiKRQEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 11:04:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7DF716E2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 08:04:04 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AIE7twY016517;
        Fri, 18 Nov 2022 16:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type : subject :
 from : in-reply-to : date : cc : message-id : references : to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YJtd0xNd+TedCwLrOfQzbWGOiKCTifxL1EMDPVweJaw=;
 b=rzeggwaxpM0SapDwovUtG7+dI6I9MwjxsHsb5JxRiSfsI6IQcLSGprxvhV3/guDkVMsw
 5R4VDg0w+d5IlAY9wtrhTMh4N2o28xytbBH9pMDBg5bE6ws/A2edClyREeR/XgSSLzQJ
 xgbusuX9ZQgBvqbUrvXWq5y/ujW2IVjXviSs5kukdPJhE+stwzPmmYh8hOrfI2ma7PeL
 vJR81q1HQuExRxgv64Rw4ezjlQXDM+5W6ZMeXswGbDSXkQSYc506B0wMfWuVxWnlt8O9
 oU73dTBaSr89dDNxzICePSojISmrcz13hasPMhF7ImrDghYsePWlfJQKrB5de37Dl9Zo Gw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kx6wqt3m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 16:03:50 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AIFoCMM007783;
        Fri, 18 Nov 2022 16:03:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kwthe1607-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 16:03:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AIG4Qak44106038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Nov 2022 16:04:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F7AAE04D;
        Fri, 18 Nov 2022 16:03:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93958AE051;
        Fri, 18 Nov 2022 16:03:44 +0000 (GMT)
Received: from smtpclient.apple (unknown [9.43.91.231])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Nov 2022 16:03:44 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Subject: Re: [PATCH 1/2] scsi: alua: Revert "Move a scsi_device_put() call out
 of alua_check_vpd()"
From:   Sachin Sant <sachinp@linux.ibm.com>
In-Reply-To: <2cb6d6aa-965c-e716-6110-5b90b634f59a@acm.org>
Date:   Fri, 18 Nov 2022 21:33:33 +0530
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>
Message-Id: <AB48CAF8-B327-4A35-9807-89372F73E8D3@linux.ibm.com>
References: <20221117183626.2656196-1-bvanassche@acm.org>
 <20221117183626.2656196-2-bvanassche@acm.org>
 <621BAA12-689E-4420-9D63-CC53E77370D5@linux.ibm.com>
 <2cb6d6aa-965c-e716-6110-5b90b634f59a@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Tcz0_pmZRJPu0Frj_aG3-1FLCL-8zISM
X-Proofpoint-GUID: Tcz0_pmZRJPu0Frj_aG3-1FLCL-8zISM
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 18-Nov-2022, at 8:37 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 11/17/22 22:11, Sachin Sant wrote:
>> Tested it on top of next-20221117. The reported warning is not seen.
>> Tested-by: Sachin Sant <sachinp@linux.ibm.com <mailto:sachinp@linux.ibm.=
com>>
>=20
> Hi Sachin,
>=20
> Thank you for the help with testing.
>=20
> Can you also test patch 2/2 from this series (https://lore.kernel.org/all=
/20221117183626.2656196-3-bvanassche@acm.org/)?

I tested with both the patches applied on top of next-20221117.

- Sachin

