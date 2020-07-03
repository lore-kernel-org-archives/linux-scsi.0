Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5801EC433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 22:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30AE420782
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 22:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gO0EoRau"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGCWNm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 18:13:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57440 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgGCWNm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 18:13:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063M9DxQ167585;
        Fri, 3 Jul 2020 22:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=K8jAkNG+lwZGI453XPGGB5MPAGaYPo6zw4j3n48Ugzs=;
 b=gO0EoRauhydIrIx/lkG+iC4ROpPxKlzC4wEAINN1noj3NGEUSVEbsr7zeaWdHgINmYI5
 QgqMpmO8bvOCU0RvRgH+sfpcWGEobM3LHq96YJydZ1lqgiFR/bQDTnKdoZSbajNXgryK
 a87zuUv4FpDheR7Q+6Np9+f++wXMiusTD7tnKFtfx6dcxv6xMmBcP6zV8nr3Iq24LN2k
 Hlu9K2j7z2+OoOlpeT1pqq8nU0zI11uFTjfumV5/TZknXb4WKzSDECJ2CKBOK2UzNKs5
 C92rkpBYM4fyk013Vl2ywPr2OZYwtHkj+n+FppNY7+TXo2djEfQVepqVvzcSEvbaBh0G fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1ec1uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 22:13:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063MCs6G070961;
        Fri, 3 Jul 2020 22:13:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31xg1dhrxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 22:13:24 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063MDMu5012182;
        Fri, 3 Jul 2020 22:13:22 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 22:12:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC PATCH 00/10] target: add configfs interface
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <0b59d643-61bf-6876-cc42-83ee8040da10@acm.org>
Date:   Fri, 3 Jul 2020 17:12:26 -0500
Cc:     Hannes Reinecke <hare@suse.de>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <16CCC5B0-A73C-44D3-A413-DBFE23989D26@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <0b59d643-61bf-6876-cc42-83ee8040da10@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030152
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 3, 2020, at 12:37 PM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> On 2020-06-26 21:34, Mike Christie wrote:
>> With Hannes not liking the refcounting/tricks in the sysfs approach
>> I took another stab at configfs. This approach works similar to the
>> loop/vhost/usb/xen nexus interface where there is a special file
>> that allows userspace to add/remove sessions.
>=20
> Hi Mike,
>=20
> Are you perhaps referring to the comment in the following message?
> =
https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/f0bd2a33-c0=
84-6c9b-faa1-9d92bdb2df7a@suse.de/__;!!GqivPVa7Brio!L7jRHXS-8N1S4DIyD7kLwn=
1WPta5_ANJgQpJrI-fdmRlub6ViFCvtW0VCqwhN37bZMtc$=20

Yes.

> The duplication of strings in that patch also looks weird to me.
> I think kobject_del() waits for ongoing sysfs show and store callbacks =
to finish.

Nice!

I didn=E2=80=99t know that. I added that free_session callback for that =
reason. When testing I was just verifying that the callback was called =
when all refs to the file had dropped and didn=E2=80=99t check that it =
was actually device_del.


> Since patch 12/15 adds a kobject_del() call in =
target_sysfs_remove_session(), is
> that call perhaps sufficient to guarantee that the

Yes. It=E2=80=99s doable. There might be an issue with one driver, but I =
can fix that up.


> se_sess->se_node_acl->initiatorname pointer and similar pointers are =
all valid
> at least as long the session sysfs object exists?
>=20
> Thanks,
>=20
> Bart.

