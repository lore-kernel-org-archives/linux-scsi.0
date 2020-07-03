Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56688C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 21:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29A5320885
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 21:23:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mQTIAIkq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGCVXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 17:23:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgGCVXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 17:23:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063LHqrQ170617;
        Fri, 3 Jul 2020 21:23:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=1J26SPPY7Pmad1V7ufxbTsaE4kg2tFs2PqmJ6PI7Nho=;
 b=mQTIAIkqxigRIdFcHXsMlmSaIBXdc73o/7991UdDY3nFf8pX0RApeirEOExEA5olJE0q
 wlkP1p/SkAjOghmaDNZ9Pdp1X9FwondNG6MFEoT3ZoChoTkbrypIX+tBVJ7XqgkM65SB
 hewt3CCHQaykF7vhloY5bmMLv0OHfk8q1xoN8c/bytCgrwJakX3MGMJCZLdhC14U6Ot5
 K6HgZ0X9zhTu3Ehz/nCzFOWhg869b9SPQBR41ea50k+Ah5Xrz/2k32zmZoc4mcNw31QZ
 F57bKT1CZTameAQIvVsHFzX8rWGyPrU124mUQ8dfzoKjGj8att73WoMBxPdqZNOBbjl5 bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31ywrc5bmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 03 Jul 2020 21:23:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 063LHwTd090547;
        Fri, 3 Jul 2020 21:23:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31xg2384xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jul 2020 21:23:08 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 063LN3ug026514;
        Fri, 3 Jul 2020 21:23:06 GMT
Received: from dhcp-10-154-152-80.vpn.oracle.com (/10.154.152.80)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jul 2020 21:19:28 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
From:   Michael Christie <michael.christie@oracle.com>
In-Reply-To: <2e70df6e-560f-590f-721c-2532f7af3d50@ts.fujitsu.com>
Date:   Fri, 3 Jul 2020 16:19:27 -0500
Cc:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7642F0BE-2E98-47FA-B1B9-00CA083B6530@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
 <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
 <2e70df6e-560f-590f-721c-2532f7af3d50@ts.fujitsu.com>
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=3 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007030146
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 3, 2020, at 11:57 AM, Bodo Stroesser =
<bstroesser@ts.fujitsu.com> wrote:
>=20
> On 2020-07-03 18:27, Mike Christie wrote:
>> On 7/3/20 7:51 AM, Bodo Stroesser wrote:
>>> On 2020-06-27 06:35, Mike Christie wrote:
>>>> This patch exports the LIO sessions via configfs. If userspace =
makes
>>>> a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
>>>> supports the new interface on that TPG, then the kernel will make a
>>>> dir per session in the tpg/sessions or tpg/acls/alc/sessions dir
>>>=20
>>> I someone creates a new ACL on a running tpg, can it happen that a
>>> session already is created before user can create the sessions =
folder?
>>=20
>> Right now yes. In the patch I started to try to support a per tpg =
mix. If a session exists then you do mkdir sessions, then before you can =
delete the tpg you have to delete the sessions that were created after =
the mkdir.
>>=20
>> But to handle all the side cases, it becomes a pain, and I don't =
think anyone will ever use that feature, so I plan to make it either on =
or off for all sessions on the tpg and no mixing. I think normally we =
see different tools at the per target or per fabric level, so we should =
be ok.
>=20
> Maybe I don't get it. What I meant is:
>=20
> Creation of the "sessions" folders in tpg and acl has to be done by
> user.
> If user creates a new acl while tpg is active, the acl immediately
> becomes active, I think.
> If user then creates the "sessions" folder, it could happen that
> a session already is started meanwhile. That session would be
> invisible then.
> Maybe an "enable" attr for acl would help?

I see what you are saying. See below.


>> No. It works the same as today. When you do a tpg removal like when =
you do
>>=20
>> targetlci clearconfig
>>=20
>> rtslib disables the tpg which prevents the target from creating new =
sessions. We then bring down the objects under it like luns, portals, =
etc. When we get to sessions, if the target has not yet brought them =
down (some targets do this on tpg disablement and some do not), then =
with that github patch rtslib will kill them like it does for the other =
objects.
>>=20
>=20
> Ahh, I see.
>=20
>=20
>=20
>=20
> Let me resend another part of my response, that was far down:
>=20
>>  }
>>  +int target_cfgfs_register_session(struct se_portal_group *se_tpg,
>> +                  struct se_session *se_sess)
>> +{
>> +    struct se_node_acl *se_nacl;
>> +    int ret;
>> +
>> +    /*
>> +     * If the fabric doesn't support close_session, there's no way =
for
>> +     * userspace to clean up the session during nacl/tpg deletion.
>> +     */
>> +    if (!se_tpg->cfgfs_sess_supp || =
!se_tpg->se_tpg_tfo->close_session)
>> +        return 0;
>=20
> Why is the cfgfs_sess_supp flag per tpg? It seems to be set if either
> tpg/sessions or any acl/sessions folder is created.
> So what will happen here if e.g session for an acl is created while
> only tpg/sessions exists?

Ah yeah, that is bogus. I am still working on an issue in this code. I =
wasn=E2=80=99t expecting a line by line and just a general review of =
cfgfs vs sysfs :) Sorry about that.

I originally made it so when we make the tpg and before it is enabled =
you had to do mkdir sessions on the tpg to signal the kernel that the =
app supports the new interface. The kernel would then make the acl =
sessions dir for you.

I was tracking down a bug in that though, and for the posting I made it =
so userspace had to create the acl sessions dir. While cutting and =
pasting the code I forgot to fix up that code.



> Do we need an similar flag per acl also?
> And if we have a per acl and the tpg flag I think they should be =
removed
> when user removes an empty sessions folder.

It=E2=80=99s just a lot easier to leave it set if userspace has enabled =
it once. You actually need to take into account if the tpg is enabled, =
and then you have some issues with the drivers that have their own nexus =
interface, and then there are different userspace code paths that handle =
this.

I don=E2=80=99t think it=E2=80=99s going to be common to mix and match =
updated and non-updated tools, so once its set, it=E2=80=99s set. If you =
disagree let me know. It can be done.





>=20
>> +
>> +    se_nacl =3D se_sess->se_node_acl;
>> +    if (se_nacl->dynamic_node_acl) {
>> +        ret =3D configfs_register_group(&se_tpg->tpg_sess_group,
>> +                          &se_sess->group);
>> +    } else {
>> +        ret =3D configfs_register_group(&se_nacl->acl_sess_group,
>> +                          &se_sess->group);
>> +    }
>> +    if (ret)
>> +        goto fail;
>=20
> Do we have a possible race here? I think it would be better to first
> call target_depend_item() and then register the new session's group.

Yes. Will fix.

>=20
>> +
>> +    /*
>> +     * The session is not created via a mkdir like other objects. A
>> +     * transport event like a login or userspace used the nexus file =
to
>> +     * initiate creation. However, we want the same behavior as =
other
>> +     * objects where we must remove the children before removing the
>> +     * parent dir, so do a depend on the parent that is released =
when the
>> +     * session is removed.
>> +     */
>> +    if (se_nacl->dynamic_node_acl) {
>> +        ret =3D target_depend_item(&se_tpg->tpg_sess_group.cg_item);
>> +    } else {
>> +        ret =3D =
target_depend_item(&se_nacl->acl_sess_group.cg_item);
>> +    }
>> +    if (ret)
>> +        goto unreg_cfgfs;
>> +
>> +    se_sess->added_to_cfgfs =3D true;
>> +    return 0;

