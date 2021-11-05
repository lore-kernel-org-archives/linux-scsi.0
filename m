Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6097C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91BE46023B
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhKEMk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:40:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41626 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232105AbhKEMk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 08:40:26 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5At6DX010911;
        Fri, 5 Nov 2021 12:37:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=9drYEcXEq6zZaWI008kJPs30ze5KOTC8euBavc55udU=;
 b=HGu1sDk7C0W2uNYQViRPjml6TProcLWgJcGmdax3l30RURfRbVOGvMxY/YMhWc7i3q0d
 8LLWsfUEzQsat+MHdOm2MTOWBJ0SiixCyharhfgBcisdHy6zjrRHqYGcv5/18iynHDn4
 Ck5Ipl42XZGFYJvaqNAlPU4zZmT8vS6bOzP4GTDCoy/fTU8S4lo5Zc5aPjd8uwobQ8R5
 yQZVNVGttZQQYr7x1ujRkjTC7sp/iNUvIG73GaWjBy36LuEt6mYzxYI9ITntOMVPoh8q
 1V91n2J/5YtxqcQJdTTVg6YI0uUZdH2w0jVCuXidFMWGlWCcvfPCS8Afv56monmDuA6F Ng== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c505bdj4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 12:37:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A5CDXxo001899;
        Fri, 5 Nov 2021 12:37:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3c4t4fm6wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Nov 2021 12:37:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A5CVA5749611080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Nov 2021 12:31:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 096D84C04E;
        Fri,  5 Nov 2021 12:37:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A25114C040;
        Fri,  5 Nov 2021 12:37:37 +0000 (GMT)
Received: from [9.145.172.52] (unknown [9.145.172.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  5 Nov 2021 12:37:37 +0000 (GMT)
Message-ID: <f5900f54-dddd-6dd4-ce13-a8bdfa58b6ad@linux.ibm.com>
Date:   Fri, 5 Nov 2021 13:37:37 +0100
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
From:   Steffen Maier <maier@linux.ibm.com>
In-Reply-To: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lENRK02SPdI9NKaTZWDJe3USpDVzEdMk
X-Proofpoint-ORIG-GUID: lENRK02SPdI9NKaTZWDJe3USpDVzEdMk
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-05_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 clxscore=1011 mlxscore=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050071
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On 11/5/21 13:14, James Bottomley wrote:
> a move to register core sysfs files
> earlier, which means they're available to KOBJ_ADD processing, which
> necessitates switching all drivers to using attribute groups.

I seem to be missing?:

https://lore.kernel.org/linux-scsi/163478764102.7011.9375895285870786953.b4-ty@oracle.com/t/#mab0eeb4a8d8db95c3ace0013bfef775736e124cb
("scsi: core: Fix early registration of sysfs attributes for scsi_device")
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-queue&id=3a71f0f7a51259b3cb95d79cac1e19dcc5e89ce9

Without that, v5.16-rc1 will have a sysfs regression in 14 low level drivers 
(quoted below).

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
> 
> The short changelog is:

> Bart Van Assche (143):
>        scsi: core: Remove two host template members that are no longer used
>        scsi: usb: Switch to attribute groups

>        scsi: smartpqi: Switch to attribute groups

>        scsi: myrs: Switch to attribute groups
>        scsi: myrb: Switch to attribute groups

>        scsi: mpt3sas: Switch to attribute groups
>        scsi: megaraid_sas: Switch to attribute groups

>        scsi: ipr: Switch to attribute groups

>        scsi: hpsa: Switch to attribute groups

>        scsi: cxlflash: Switch to attribute groups

>        scsi: aacraid: Switch to attribute groups
>        scsi: 53c700: Switch to attribute groups

>        scsi: zfcp: Switch to attribute groups

>        scsi: firewire: sbp2: Switch to attribute groups
>        scsi: ata: Switch to attribute groups
>        scsi: core: Register sysfs attributes earlier

> And the diffstat:

>   drivers/scsi/scsi_sysfs.c                       |  54 +--

>   include/scsi/scsi_device.h                      |   7 +-


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
