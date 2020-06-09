Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BBBC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 03:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE52207C3
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 03:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bjA6cYEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgFIDNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 23:13:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgFIDNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 23:13:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0593CfHM168265;
        Tue, 9 Jun 2020 03:12:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=eQuz/vdxMTOJa9R+pWweSGhcTbaCa03/GR8NQG6cTCY=;
 b=bjA6cYEIOeWJCyFZOchc8SlK/qf+z0SHWaC0lAlHfa6owryBaLg3/49ZLlLBg3GQltCI
 FFLEaeWzZF0r8F8mo8v0FntGRu7BYvEf/c4bvuTj4tc9TihxiYn+br24a0uVrp9S7nHF
 Bfic4S+7X6je132uRxi+BrPR/HqYNbz99LLgyS3tDoXoBRHBmXH0TOh88mXttgwLda0p
 smfSYrWC3yJ0wLQDRio5TRu+XCgc3glFGNnqY/ertZgyW6sHNMRdeiPmbSpeOc5lRkY8
 TTSDazoWvkzoijIUuWQ0ZWBkIjQ3NAz7JbKvDWaIIZhnSkCHRa8IO6VMLEe7up0aeJ76 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31g3smt34d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 09 Jun 2020 03:12:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05937d64173676;
        Tue, 9 Jun 2020 03:10:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31gn2w0ua2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jun 2020 03:10:57 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0593As0O023731;
        Tue, 9 Jun 2020 03:10:54 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 20:10:54 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 11/17] target: add session sysfs class support
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <7598A2AE-B43F-41BB-82E0-8882FA7D66E0@oracle.com>
Date:   Mon, 8 Jun 2020 22:10:52 -0500
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3B8F389C-A12D-4222-863F-6A656AF4680F@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
 <75aa23e1-2194-31fb-ef12-90f868e12494@oracle.com>
 <7598A2AE-B43F-41BB-82E0-8882FA7D66E0@oracle.com>
To:     Hannes Reinecke <hare@suse.de>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006090023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=2
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006090023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 8, 2020, at 10:55 AM, Michael Christie =
<michael.christie@oracle.com> wrote:
>=20
>=20
>=20
>> On Jun 8, 2020, at 10:21 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>>=20
>> On 6/8/20 1:14 AM, Hannes Reinecke wrote:
>>>> +    se_sess->target_name =3D =
kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
>>>> +                       GFP_KERNEL);
>>>> +    if (!se_sess->target_name)
>>>> +        goto free_acl;
>>>> +
>>>> +    if (se_sess->tfo->fabric_alias)
>>>> +        se_sess->fabric_name =3D =
kstrdup(se_sess->tfo->fabric_alias,
>>>> +                           GFP_KERNEL);
>>>> +    else
>>>> +        se_sess->fabric_name =3D =
kstrdup(se_sess->tfo->fabric_name,
>>>> +                           GFP_KERNEL);
>>>> +    if (!se_sess->fabric_name)
>>>> +        goto free_target;
>>>> +
>>>> +    se_sess->tpg_name =3D =
kstrdup(se_tpg->tpg_group.cg_item.ci_name,
>>>> +                    GFP_KERNEL);
>>>> +    if (!se_sess->tpg_name)
>>>> +        goto free_fabric;
>>>> +
>>>> +    return 0;
>>> I wonder if we need to copy these variables.
>>> Why can't we display them directly, returning an error if the =
respective
>>> link is not available?
>>> If one is worried about the sysfs/configfs reference counting we can =
get the reference in the _show() functions; wouldn't that be a better =
solution?
>>=20
>> Do you mean in the sysfs show function do a configfs_depend_item() on =
the tpg, www, acl, etc? If so, I'm not sure that's safe, because for the =
tpg for example, we could do:
>>=20
>> 1. Userspace starts tpg removal with a rmdir.
>> 2. Userspace also opens sysfs session file and has a ref to the =
session, but not the tpg yet.
>> 3. kernel tears down tpg and sessions under it. The tpg is freed. The =
session is not because of the ref taken in #2.
>> 4. sysfs session show function starts to reference se_sess->se_tpg so =
it can do a configfs_depend_item on the tpg_group.cg_item, but the =
se_tpg is freed in #3.
>>=20
>> We either need to:
>> 1. cp like above.
>> 2. Handle both configfs and device struct refcounts for the same =
struct. So add a device struct to the www, tpg, acl and then coordinate =
the refcounting.
>> 3. take a reference to the se_tpg when the session is created then =
drop it in the session release.
>=20
>=20
> Ignore #3. That does not work. Userspace expects to be able to rmdir =
on a tpg and that will remove the underlying sessions. If the session =
takes a ref to the tpg, then it breaks userspace because something now =
has to do the session removal before the tpg rmdir.
>=20

I was thinking about this some more and we could do the following:

1. When userspace creates a target or tpg, it tells the kernel if it =
supports the updated session interface.
2. If userspace supports it, when we create a session we get a reference =
to the tpg with configfs_depend_item(). And create the sysfs interface. =
We might actually be able to do confifgfs.
3. On tpg deletion, if at #1 it has told us it supports the new =
interface then userspace just has to tear down the sessions by doing a =
rmdir on the sessions if we do configfs or write to some new delete file =
if we use sysfs.=
