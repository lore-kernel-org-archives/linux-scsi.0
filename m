Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C605EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A397261212
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhKEM4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:56:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229740AbhKEM4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 08:56:50 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5AlTw1019999;
        Fri, 5 Nov 2021 12:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=mBDX/RJg1VWvFterAiaSlLzTEMntgc5Q/D5mpl4aS5c=;
 b=YdhpLi32HbvVqTK/6bVZBmoSNsD8Ru8j8IUw4fYUDQt97icn7hbpg0ptbF/kavoKKbO4
 8TkFbTaxz5+f+d3cPUr5f5R6uRzPgnRIOssl9Lvber/OHXXl7k3BPOv6BrJiEyBhoZOY
 Yi3jBvDQvlnLicAU4YtWVkqpShv4Tm+V+Gd9bMvTR8GiDxIpeo9GdXfSixs99iBRrtaL
 AldJLh3CQiGNW3F2AwsTsOK/Z+4IzdhxSWl1G7PUeCUV//nbho3zvfbyrzKC9gBkUSgS
 rfHWavs6t9c5qIy7ODIeii7hlaCzOJm2K1DF7oZ3fS2uGr1fb3jNfYdS7dm9iZa+LJgX Rw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4yn16jyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 12:54:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A5CnIJ7010007;
        Fri, 5 Nov 2021 12:54:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3c4t4dcssy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 12:54:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A5CrxpB55837120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Nov 2021 12:53:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 838274C040;
        Fri,  5 Nov 2021 12:53:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29FC14C058;
        Fri,  5 Nov 2021 12:53:59 +0000 (GMT)
Received: from [9.145.172.52] (unknown [9.145.172.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Nov 2021 12:53:59 +0000 (GMT)
Message-ID: <5e98cb7e-699e-a643-57ec-eff19275fb28@linux.ibm.com>
Date:   Fri, 5 Nov 2021 13:53:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.15+ merge window
Content-Language: en-US
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
 <f5900f54-dddd-6dd4-ce13-a8bdfa58b6ad@linux.ibm.com>
 <1a031eaec5f867380e8aeabef57e5cecff70e701.camel@HansenPartnership.com>
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <1a031eaec5f867380e8aeabef57e5cecff70e701.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r_SkCEJHNFJS8mN6nMxXnDMsAL3lCVRx
X-Proofpoint-ORIG-GUID: r_SkCEJHNFJS8mN6nMxXnDMsAL3lCVRx
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/21 13:43, James Bottomley wrote:
> On Fri, 2021-11-05 at 13:37 +0100, Steffen Maier wrote:
>> On 11/5/21 13:14, James Bottomley wrote:
>>> a move to register core sysfs files
>>> earlier, which means they're available to KOBJ_ADD processing,
>>> which
>>> necessitates switching all drivers to using attribute groups.
>>
>> I seem to be missing?:
>>
>> https://lore.kernel.org/linux-scsi/163478764102.7011.9375895285870786953.b4-ty@oracle.com/t/#mab0eeb4a8d8db95c3ace0013bfef775736e124cb
>> ("scsi: core: Fix early registration of sysfs attributes for
>> scsi_device")
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-queue&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
> 
> We have quite a list of patches that came in just before the merge
> window opened.  They get incubated in linux-next for as long as
> possible and then sent in the final pull request.

I think that would break our CI with Linus' vanilla kernel between when Linus 
merges this and until he merges your final pull request. Daily test fails for 
about a week or so? I tried to avoid that by coming up with a regression fix as 
fast as possible.

We're covered with linux-next already via Martin's for-next.


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
