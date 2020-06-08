Return-Path: <SRS0=xyUR=7V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FDFC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 15:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB783206C3
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Jun 2020 15:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GGdGPihq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgFHPzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Jun 2020 11:55:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52880 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730358AbgFHPzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2020 11:55:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058FmC2H021402;
        Mon, 8 Jun 2020 15:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=jHzPMxdflcJ8RaUDW+QwwNkHdTzdH+Hknj8c0QrFYxs=;
 b=GGdGPihqD4JdJ6SFuADJv/LIOkX0zRE+Zz/UTw7PNlN6RgpRXRHIE9mrUMjJlA0wJ138
 GP7YcTEehRhMVNMXX6Kd+5SbfdM1o+VCB3MflpYgi+P64EcCicFziXe/xdHCqJHzjTlf
 aki9/ITngzkq7lfmCz66YhMS4xM/YTaP5z0EvAC1C6s+wkHNzKzV0CpfV6rvePsJ2VQZ
 dfl0tNoYblo2VKtdb3gihe4MQJjmcrP8Vb9zO3/b5CphSYqojDJZ3//Pb8snlzrTidK7
 /0UWm1nUFb3YLCRNkDZtCPxxPMBrEWQjfJ7vS7wuNMPYTPH1v/6Wy1kJjePZM7uzJoyE 4Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31g2jqynnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 15:55:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058FlcQa023024;
        Mon, 8 Jun 2020 15:55:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31gn2vdden-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 15:55:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058Ft1wL020217;
        Mon, 8 Jun 2020 15:55:01 GMT
Received: from [20.15.0.6] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 08:55:01 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 11/17] target: add session sysfs class support
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <75aa23e1-2194-31fb-ef12-90f868e12494@oracle.com>
Date:   Mon, 8 Jun 2020 10:55:00 -0500
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7598A2AE-B43F-41BB-82E0-8882FA7D66E0@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
 <75aa23e1-2194-31fb-ef12-90f868e12494@oracle.com>
To:     Hannes Reinecke <hare@suse.de>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=2
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080115
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 8, 2020, at 10:21 AM, Mike Christie =
<michael.christie@oracle.com> wrote:
>=20
> On 6/8/20 1:14 AM, Hannes Reinecke wrote:
>>> +    se_sess->target_name =3D =
kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
>>> +                       GFP_KERNEL);
>>> +    if (!se_sess->target_name)
>>> +        goto free_acl;
>>> +
>>> +    if (se_sess->tfo->fabric_alias)
>>> +        se_sess->fabric_name =3D =
kstrdup(se_sess->tfo->fabric_alias,
>>> +                           GFP_KERNEL);
>>> +    else
>>> +        se_sess->fabric_name =3D kstrdup(se_sess->tfo->fabric_name,
>>> +                           GFP_KERNEL);
>>> +    if (!se_sess->fabric_name)
>>> +        goto free_target;
>>> +
>>> +    se_sess->tpg_name =3D =
kstrdup(se_tpg->tpg_group.cg_item.ci_name,
>>> +                    GFP_KERNEL);
>>> +    if (!se_sess->tpg_name)
>>> +        goto free_fabric;
>>> +
>>> +    return 0;
>> I wonder if we need to copy these variables.
>> Why can't we display them directly, returning an error if the =
respective
>> link is not available?
>> If one is worried about the sysfs/configfs reference counting we can =
get the reference in the _show() functions; wouldn't that be a better =
solution?
>=20
> Do you mean in the sysfs show function do a configfs_depend_item() on =
the tpg, www, acl, etc? If so, I'm not sure that's safe, because for the =
tpg for example, we could do:
>=20
> 1. Userspace starts tpg removal with a rmdir.
> 2. Userspace also opens sysfs session file and has a ref to the =
session, but not the tpg yet.
> 3. kernel tears down tpg and sessions under it. The tpg is freed. The =
session is not because of the ref taken in #2.
> 4. sysfs session show function starts to reference se_sess->se_tpg so =
it can do a configfs_depend_item on the tpg_group.cg_item, but the =
se_tpg is freed in #3.
>=20
> We either need to:
> 1. cp like above.
> 2. Handle both configfs and device struct refcounts for the same =
struct. So add a device struct to the www, tpg, acl and then coordinate =
the refcounting.
> 3. take a reference to the se_tpg when the session is created then =
drop it in the session release.


Ignore #3. That does not work. Userspace expects to be able to rmdir on =
a tpg and that will remove the underlying sessions. If the session takes =
a ref to the tpg, then it breaks userspace because something now has to =
do the session removal before the tpg rmdir.




> 4. add some code and end up mix locking and state checks with =
refcounts. For example the tpg would have its configfs refcount like it =
does today (no new device struct in it), and when it deletes the =
sessions under it make sure the se_sess->se_tpg is NULL'd in a way that =
the session show function can do
>=20
> lock()
> if (!se_sess->se_tpg)
> 	return
>=20
> se_sess->se_tpg access
> unlock()
>=20
> And then you have to do that up the stack for the other structs we =
want to ref.

