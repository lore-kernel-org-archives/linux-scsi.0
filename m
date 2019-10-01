Return-Path: <SRS0=Efrx=X2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C81C388F3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 04:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87EF320842
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Oct 2019 04:29:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N1OyaYLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbfJAE3i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Oct 2019 00:29:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJAE3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2019 00:29:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x914TOsi185775;
        Tue, 1 Oct 2019 04:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Bz8c7y4f1RSpAFnZe8DRnShmhPSB64cUQi8eotXgtbk=;
 b=N1OyaYLwmelIdj8skimA/5GFrKlmJtXt47uFNbHbAmENX9m4+b9WeVoGT1yUFbopEZh3
 HZHOnkRd1/W/oTTgRYFUrHbAc99zMJP3c0+YBeqwFwaskRhf0ivFmlw4IAbkjd8eh1pA
 Ye1376T6/kCwGPS2/AZxQpIhXMhz+rJoGw6044JGcm/+kP8WRBMHfrerHBxZRwOJSa3n
 cCCzlsMukIeFEwKDQPnfv3ZtW+18O/4kys21/FNdE+6gzct4M/EdGH/UEjo30xtBvgd1
 93LjhRyJDnzE/rDl3iX5c15mbw/ViaXcur9gX7ZV8tQi8Wr8xY2wCtYyTSBQl97Pi3su 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05rk2gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 04:29:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x914TOsM011548;
        Tue, 1 Oct 2019 04:29:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vbmpxna44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 04:29:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x914SsrL010534;
        Tue, 1 Oct 2019 04:28:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 21:28:54 -0700
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, hare@suse.de
Subject: Re: [PATCH v2] scsi_debug: randomize command duration option + %p
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190927140425.18958-1-dgilbert@interlog.com>
        <743e705b-1314-c8cb-1a75-acc5029ee890@acm.org>
        <74305c57-1d8e-5829-9bcf-db02fc97a7fb@interlog.com>
Date:   Tue, 01 Oct 2019 00:28:52 -0400
In-Reply-To: <74305c57-1d8e-5829-9bcf-db02fc97a7fb@interlog.com> (Douglas
        Gilbert's message of "Mon, 30 Sep 2019 22:42:39 -0400")
Message-ID: <yq1v9t9um0r.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910010044
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010044
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Doug,

>> Since sdebug_random is either 0 or 1, is the "? 1 : 0" part necessary?
>
> No.
> Why didn't you complain when MKP wrote that? That is where I cut and
> pasted that code from (sdebug_removable).

[...]

> Again, copy and paste from MKP's code (which no doubt was a copy +
> paste from my earlier code).

I'll be the first to admit that I make mistakes and almost always
blindly copy surrounding plumbing when I hack on scsi_debug. However, I
am not responsible for the commit that introduced any of this code.

Also, in defense of the original author, our coding practices were
obviously different when this was written many years ago.

>>> @@ -5338,7 +5373,7 @@ static int __init scsi_debug_init(void)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dif_size =3D sde=
bug_store_sectors * sizeof(struct t10_pi_tuple);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dif_storep =3D v=
malloc(dif_size);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("dif_storep %u bytes=
 @ %p\n", dif_size, dif_storep);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("dif_storep %u bytes=
 @ %pK\n", dif_size, dif_storep);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (dif_storep =
=3D=3D NULL) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 pr_err("out of mem. (DIX)\n");
>>
>> Is it useful to print the kernel pointer 'dif_storep'?
>
> Ask MKP, it's his code. All I do know is that doing a printk("%p" ...)
> is useless in lk 5.3 (and probably lk 5.2). Taking the above snippet,
> if vmalloc() returned NULL then the existing pr_err() would print out
> a random number rather than <null>. Sick ...

This used to be somewhat useful for debugging purposes in combination
with the ability to dump the buffer to inspect the PI. In this day and
age with obfuscated kernel pointers, not so much. I suggest just
removing the line. Or--if people feel the size is valuable
information--just zap the pointer. Also, since this is unrelated to the
duration randomization it should be a separate patch.

Thanks!

--=20
Martin K. Petersen	Oracle Linux Engineering
