Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139BAC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 16:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAD3E22243
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 16:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nc2lMn5m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgIQQbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 12:31:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47932 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbgIQQa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 12:30:58 -0400
X-Greylist: delayed 5503 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 12:30:57 EDT
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HEwSVb140268;
        Thu, 17 Sep 2020 14:58:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=7fEqpc+LfVJEHrEfflpjieXGLJc3mJHMnTgLzqlBiA8=;
 b=nc2lMn5m7zFfL3aq8z3rAPkWaOqrWpRoXZqMIdbV8iyt6b93BLRdjnMjqO1fGAJfcGjf
 Kc58Sf3naB41YNOIg6UV5LrqaxlC04k/cDNDP5FgAt2taRXBdHZS1Shwxv9AmprRvvx+
 rLwDyNqoCsK47Vy1snWkV8gByNnRv0Znd1kaIRN6FTzCDwO7Yz68/GDEdCKhUqFZ9u4x
 I2zZFr1g1Ba43zZ4kFi8axtjfRkxTW+KrKjbXH5+kHwyvGmwQUkH/ZdRBuKM/Um8dqPw
 enMcZArC2XyriWiWFZ8MQx3glwi+kiORLDNSGpcu2tMAI08aEUkxRzyojfWzUsWPFP2Y eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrr9w2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 14:58:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HEtYOP024407;
        Thu, 17 Sep 2020 14:58:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33h88bkh3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 14:58:49 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08HEwjqu030993;
        Thu, 17 Sep 2020 14:58:46 GMT
Received: from [192.168.1.18] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 14:58:45 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: qla2xxx panic with 4.19-stable
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <CAOOPZo473qY3WHphi=4N730kyGPzMG1nw7S+HVU9Fu1pKHUGOQ@mail.gmail.com>
Date:   Thu, 17 Sep 2020 09:58:45 -0500
Cc:     linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        liuzhengyuan@tj.kylinos.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <E91A00CB-387C-435E-BA61-3F196E470335@oracle.com>
References: <CAOOPZo448A7-qg6gpJqMF6TmnUWVXL3=A4nEo2pKVRt3iEkGrA@mail.gmail.com>
 <2420F4B8-5DAE-4A8D-B519-70F3665C41E8@oracle.com>
 <CAOOPZo5y8XHXKTgyG3nsguOeipL62uKJxKx0HSC8t7uS5hxH=A@mail.gmail.com>
 <D01377DD-2E86-427B-BA0C-8D7649E37870@oracle.com>
 <CAOOPZo473qY3WHphi=4N730kyGPzMG1nw7S+HVU9Fu1pKHUGOQ@mail.gmail.com>
To:     Zhengyuan Liu <liuzhengyuang521@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sounds like you need to follow option 2 from this stable submission =
rules doc

=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/stable-kernel-rules.rst


> On Sep 16, 2020, at 2:49 AM, Zhengyuan Liu =
<liuzhengyuang521@gmail.com> wrote:
>=20
> On Tue, Sep 15, 2020 at 11:16 PM Himanshu Madhani
> <himanshu.madhani@oracle.com> wrote:
>>=20
>>=20
>>=20
>>> On Sep 13, 2020, at 9:36 PM, Zhengyuan Liu =
<liuzhengyuang521@gmail.com> wrote:
>>>=20
>>> On Sat, Sep 12, 2020 at 1:37 AM Himanshu Madhani
>>> <himanshu.madhani@oracle.com> wrote:
>>>>=20
>>>> Hi,
>>>>=20
>>>>> On Sep 10, 2020, at 9:26 PM, Zhengyuan Liu =
<liuzhengyuang521@gmail.com> wrote:
>>>>>=20
>>>>> Hi,
>>>>>=20
>>>>> There is a panic of NULL pointer dereference on my arm64 server =
when
>>>>> boot  with the fabric line  plugged into the HBA of QLE2692. After
>>>>> binary-search with git bisect I found this panic is introduced by
>>>>> commit 4984a06bf094 ("scsi: qla2xxx: Remove all rports if fabric =
scan
>>>>> retry fails"). The upstream and 4.19-stable both had the same =
problem
>>>>> when reset to this point. but the upstream had fix this
>>>>> unintentionally after commit da61ef053bcf ("scsi: qla2xxx: Reduce
>>>>> holding sess_lock to prevent CPU") while the latest 4.19-stable =
still
>>>>> has this issue. the panic showed as following:
>>>>>=20
>>>>> [   13.380405][  0] Unable to handle kernel NULL pointer =
dereference
>>>>> at virtual address 0000000000000000
>>>>> [   13.390947][  0] Mem abort info:
>>>>> [   13.395535][  0]   ESR =3D 0x96000045
>>>>> [   13.400390][  0]   Exception class =3D DABT (current EL), IL =3D =
32 bits
>>>>> [   13.408089][  0]   SET =3D 0, FnV =3D 0
>>>>> .
>>>>> [   13.412941][  0]   EA =3D 0, S1PTW =3D 0
>>>>> [   13.416747][  0] Data abort info:
>>>>> [   13.420048][  0]   ISV =3D 0, ISS =3D 0x00000045
>>>>> [   13.424293][  0]   CM =3D 0, WnR =3D 1
>>>>> [   13.427676][  0] user pgtable: 64k pages, 48-bit VAs, pgdp =3D =
(____ptrval____)
>>>>> [   13.434778][  0] [0000000000000000] pgd=3D0000000000000000,
>>>>> pud=3D0000000000000000
>>>>> [   13.441968][  0] Internal error: Oops: 96000045 [#1] SMP
>>>>> [   13.447250][  0] Modules linked in: qla2xxx nvme_fc =
nvme_fabrics
>>>>> scsi_transport_fc igb megaraid_sas dm_snapshot iscsi_tcp =
libiscsi_tcp
>>>>> libs
>>>>> [   13.472588][  0] Process kworker/0:2 (pid: 343, stack limit =3D
>>>>> 0x(____ptrval____))
>>>>> [   13.472675][  5] audit: type=3D1130 audit(1599118767.260:14): =
pid=3D1
>>>>> uid=3D0 auid=3D4294967295 ses=3D4294967295 =
msg=3D'unit=3Dinitrd-parse-etc
>>>>> comm=3D"sy'
>>>>> [   13.480032][  0] CPU: 0 PID: 343 Comm: kworker/0:2 Tainted: G
>>>>> W         4.19.90-19.ky10.aarch64 #1
>>>>> [   13.480033][  5] Hardware name: GreatWall, BIOS 601FBE28 =
2020/04/20
>>>>> [   13.480045][  0] Workqueue: qla2xxx_wq qla2x00_iocb_work_fn =
[qla2xxx]
>>>>> [   13.499248][  0] audit: type=3D1131 audit(1599118767.260:15): =
pid=3D1
>>>>> uid=3D0 auid=3D4294967295 ses=3D4294967295 =
msg=3D'unit=3Dinitrd-parse-etc
>>>>> comm=3D"sy'
>>>>> [   13.508759][  0] pstate: 40000005 (nZcv daif -PAN -UAO)
>>>>> [   13.547687][ 24] pc : __memset+0x16c/0x188
>>>>> [   13.547697][  0] lr : qla24xx_async_gpnft+0x194/0x950 [qla2xxx]
>>>>> [   13.547701][  0] sp : ffffb2158236bc60
>>>>> [   13.561388][  0] x29: ffffb2158236bc60 x28: 0000000000000000
>>>>> [   13.567104][  0] x27: ffff3be824ac0148 x26: ffff3be824ac00b8
>>>>> [   13.572820][  0] x25: ffff3be824b031e0 x24: 0000000000000028
>>>>> [   13.578535][  0] x23: ffffb2158600d188 x22: ffffb21586d3ea38
>>>>> [   13.584251][  0] x21: 0000000000008010 x20: ffffb21586d3ea08
>>>>> [   13.589968][  0] x19: ffffb2158600d040 x18: 0000000000000400
>>>>> [   13.595683][  0] x17: 0000000000000000 x16: ffff3be83f9a9500
>>>>> [   13.601398][  0] x15: 0000000000000400 x14: 0000000000000400
>>>>> [   13.607114][  0] x13: 0000000000000189 x12: 0000000000000001
>>>>> [   13.612829][  0] x11: 0000000000000000 x10: 0000000000000b40
>>>>> [   13.618544][  0] x9 : 0000000000000000 x8 : 0000000000000000
>>>>> [   13.624259][  0] x7 : 0000000000000000 x6 : 000000000000003f
>>>>> [   13.629974][  0] x5 : 0000000000000040 x4 : 0000000000000000
>>>>> [   13.635689][  0] x3 : 0000000000000004 x2 : 0000000000007fd0
>>>>> [   13.641404][  0] x1 : 0000000000000000 x0 : 0000000000000000
>>>>> [   13.647119][  0] Call trace:
>>>>> [   13.649983][  0]  __memset+0x16c/0x188
>>>>> [   13.653718][  0]  qla2x00_do_work+0x398/0x440 [qla2xxx]
>>>>> [   13.658920][  0]  qla2x00_iocb_work_fn+0x50/0xe8 [qla2xxx]
>>>>> [   13.664378][  0]  process_one_work+0x1f0/0x3c8
>>>>> [   13.668797][  0]  worker_thread+0x48/0x4d0
>>>>> [   13.672871][  0]  kthread+0x128/0x130
>>>>> [   13.676514][  0]  ret_from_fork+0x10/0x18
>>>>> [   13.680503][  0] Code: 91010108 54ffff4a 8b040108 cb050042 =
(d50b7428)
>>>>> [   13.687027][  0] ---[ end trace 258cdcdd74a25238 ]---
>>>>> [   13.692051][  0] Kernel panic - not syncing: Fatal exception
>>>>=20
>>>> Have you tried applying commit da61ef053bcf ("scsi: qla2xxx: Reduce =
holding sess_lock to prevent CPU=E2=80=9D) to confirm if it resolves =
your panic. It does look like the panic should resolve with the changes =
in that patch.
>>>>=20
>>>> If you are able to verify then we can request for sable back port =
with your reported-by and tested-by tags.
>>>=20
>>> Yes, it did resolve my panic after backporting that commit to
>>> 4.19-stable. But I cannot apply that commit directly, in order to
>>> resolve the conflict I also backported commit:
>>> 3b1e23aacf80 ("scsi: qla2xxx: Update rscn_rcvd field to more =
meaningful").
>>> a4863b16c31e ("scsi: qla2xxx: Move rport registration out of =
internal").
>>>=20
>>=20
>> These patches looks good for the 4.19-stable back port.
>>=20
>> Please post it to stable with Reported-by and Tested-by tag.
>=20
> I had posted those patches to stable@vger.kernel.org and cc to you but
> I have no idea why the mail server denied my address.
> Please help me forward the email to stable list, thanks.
>=20
>>=20
>> Thanks.
>>=20
>>>>=20
>>>> --
>>>> Himanshu Madhani         Oracle Linux Engineering
>>=20
>> --
>> Himanshu Madhani         Oracle Linux Engineering

--
Himanshu Madhani	 Oracle Linux Engineering

