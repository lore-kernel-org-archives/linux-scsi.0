Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BACC433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A7E2087C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 19:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vz6NMw/p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgHLTbZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 15:31:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39060 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgHLTbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 15:31:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJS8rg044095;
        Wed, 12 Aug 2020 19:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Bn7SQJAUYaJl+AHmqz+fZi1kM3t2/jgPQ8XSNOvvZKk=;
 b=vz6NMw/pvc8QrdEb27weauQzVmrGSteBWlY7PRqoyjm/IUiyTh00u4PaVx9o1Py4JA0T
 wlkOcVs4F4kiAm4bcvSYULOtiLfR+7cIqvIUfbatl6J0l1uabND0P2BVASjNZBByQ+i+
 AwjNnpbrkOTzQoK7fNDwxtQfg+ZwEUuq2eh4M2d5KnB6IVbPtgXv5OiUHxX9G/KVHDzo
 Ap7bF1CbzV5qBj68T02xyZVq3Y7pl/sIg0B9QcfXzCRtwR4tK8IT+ZfCNxwzc4KJ+ofz
 UGFQWzxbhRLj/IYKV6SGzQDFlX0vFUjcWMV/eFL1QVxMRxif/mqWZkociuMgM79Fv3nJ Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32t2ydu3td-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 19:31:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07CJTapk056188;
        Wed, 12 Aug 2020 19:31:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32t5y7p2ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 19:31:12 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07CJVBAn026084;
        Wed, 12 Aug 2020 19:31:11 GMT
Received: from dhcp-10-154-152-217.vpn.oracle.com (/10.154.152.217)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 19:31:11 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
 qla2x00_mailbox_command"
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <DM6PR18MB303407CDC145F69390C28F5AD2440@DM6PR18MB3034.namprd18.prod.outlook.com>
Date:   Wed, 12 Aug 2020 14:31:10 -0500
Cc:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A1A2F11-3BC8-485A-9893-F91AE63DD4ED@oracle.com>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-11-njavali@marvell.com>
 <20200807075428.bzrhqwllvt5ajfhl@beryllium.lan>
 <DM6PR18MB303407CDC145F69390C28F5AD2440@DM6PR18MB3034.namprd18.prod.outlook.com>
To:     Saurav Kashyap <skashyap@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=3 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=3 phishscore=0 adultscore=0 spamscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120120
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 10, 2020, at 4:55 AM, Saurav Kashyap <skashyap@marvell.com> =
wrote:
>=20
> Hi Daniel,
>=20
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org =
<linux-scsi-owner@vger.kernel.org>
>> On Behalf Of Daniel Wagner
>> Sent: Friday, August 7, 2020 1:24 PM
>> To: Nilesh Javali <njavali@marvell.com>
>> Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; =
GR-QLogic-
>> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
>> Subject: Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
>> qla2x00_mailbox_command"
>>=20
>> On Thu, Aug 06, 2020 at 04:10:13AM -0700, Nilesh Javali wrote:
>>> FCoE adapter initialization failed for ISP8021.
>>>=20
>>> This reverts commit 3cb182b3fa8b7a61f05c671525494697cba39c6a.
>>=20
>> But wouldn't this revert not also bring back the crash from =
3cb182b3fa8b
>> ("scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"):
>=20
> This patch was never there in OOT driver, and we never hit an original =
problem. I have tested this patch myself
> and this have gone through test cycles as well. If an original issue =
is hit again, we will do an analysis and provide
> the fix. This revert fixes a load issues with ISP82XX.
>=20
> Thanks,
> ~Saurav
>>=20
>>    This patch fixes a crash on qla2x00_mailbox_command caused when =
the
>> driver
>>    is on UNLOADING state and tries to call qla2x00_poll, which =
triggers a
>>    NULL pointer dereference.
>=20

If my memory serves me right. This crash reported was never reproduced =
during my testing when this patch was submitted and nor did it cause any =
issue. So I am fine with this change being reverted.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

