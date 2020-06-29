Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D1FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD94214F1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GU3hC8Xc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgF2SvX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 14:51:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56188 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729576AbgF2SvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:51:19 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200629070132epoutp02f67d994f9244c85620c20b21a56e99b2~c8azGPtJ22281922819epoutp02C
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 07:01:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200629070132epoutp02f67d994f9244c85620c20b21a56e99b2~c8azGPtJ22281922819epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593414092;
        bh=QZlCyyvvl3LjjferaScWUK823pot8T+gyxLSn+ED2a4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=GU3hC8XcJISXT5QLFKhyNP3A4kTF0GSzCsJITGRLN/rCSpBwuuvVI5JrRDVbs2bSh
         sPR4QpxJ+7dpvW4FiJPtAjbf4bIPULKjuH40SaGHnWAmyCNyZO1j12g4qNFo4isL7G
         MatO5EZk3u1LG1GmjHcTtPEO+R3jcMEe8zr2XFFI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200629070132epcas2p4e2301bf1a16a5b213a9c37e3337a0446~c8ayp8HFj1584615846epcas2p4b;
        Mon, 29 Jun 2020 07:01:32 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49wJLf0hjfzMqYlt; Mon, 29 Jun
        2020 07:01:30 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.C0.18874.9C199FE5; Mon, 29 Jun 2020 16:01:30 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200629070129epcas2p4f5a9d0a46a630efc91d8545325730cb5~c8awIbgwF1346613466epcas2p4H;
        Mon, 29 Jun 2020 07:01:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629070129epsmtrp2bd133049f6b141c3e3be11afc3c55308~c8awHhYud2249022490epsmtrp2e;
        Mon, 29 Jun 2020 07:01:29 +0000 (GMT)
X-AuditID: b6c32a46-519ff700000049ba-02-5ef991c94cdd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.6C.08382.9C199FE5; Mon, 29 Jun 2020 16:01:29 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200629070129epsmtip112abaa8ddf4b38ec8f594cfd3f066b67~c8av2fBDz2279422794epsmtip1Q;
        Mon, 29 Jun 2020 07:01:29 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Stanley Chu'" <chu.stanley@gapp.nthu.edu.tw>
Cc:     <linux-scsi@vger.kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Bean Huo \(beanhuo\)'" <beanhuo@micron.com>,
        "'Asutosh Das'" <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>
In-Reply-To: <CAOBeenZ41xLfDDjfTUxaRmu4WJfzV+dXNSt3nCi_Oiu-Fi-oBA@mail.gmail.com>
Subject: RE: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
Date:   Mon, 29 Jun 2020 16:01:28 +0900
Message-ID: <003b01d64de3$1cdd7a00$56986e00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL8/V917mWvtxF9jWsyhmCCDxjM/gJ/aiFPAXuCqJoBAcj1HAIH5g0EpmmmEBA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmme6piT/jDP7fZ7J4MG8bm8XethPs
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtZjbcoTdYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HlOXrWX2mLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MAZxROTYZqYkpqUUKqXnJ+SmZ
        eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O1sivJL
        S1IVMvKLS2yVUgtScgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMh5+ucNU8ECj4uDHScwN
        jOfUuxg5OSQETCTuLf3ABGILCexglJg/J6WLkQvI/sQocWR2ByOE841R4vSaRkaYjsb+NVCJ
        vYwSk06/ZoRof8Eo8fN1EojNJqAtMe3hblYQW0TASGL7jTlsIDazwFMmif+vxUBsToFAiRur
        34GtFhYIlXjw6wgziM0ioCrx9OFOsHpeAUuJ431rmCFsQYmTM5+wQMzRlli28DUzxEEKEj+f
        LgPaxQG0y0/ixE8hiBIRidmdbcwgd0oIHOGQeHZsBVS9i8T611vYIWxhiVfHYWwpic/v9rJB
        2PUS+6Y2sEI09zBKPN33D+p7Y4lZz9oZQZYxC2hKrN+lD2JKCChLHLkFdRqfRMfhv+wQYV6J
        jjYhiEZliV+TJkMNkZSYefMO+wRGpVlIHpuF5LFZSD6YhbBrASPLKkax1ILi3PTUYqMCI+So
        3sQITsJabjsYp7z9oHeIkYmD8RCjBAezkgjvZ+tvcUK8KYmVValF+fFFpTmpxYcYTYFBPZFZ
        SjQ5H5gH8kriDU2NzMwMLE0tTM2MLJTEeesVL8QJCaQnlqRmp6YWpBbB9DFxcEo1MOVGX7dK
        jVQ5/e7kgYO5FpM4jp1+/btbYcqauRtEEq///n/jebLJrbJfNrfDhXZNeKNxpNL8hXD8Tyfr
        h+z1um+fP22dLMi78NOih8c0p5161M6cP2f7zeebCp5YfNP+Prug4u2fSMGG3LMr/rDzVKZ6
        btFcujDVsXX3ba8Tap8vfyyQcdvyyKO/g8uV42IHQ+9e5/muRx4tbiw1WaW8z9OajbGiK2HO
        kVsb4p7UcE366KqdYLFHSZu7oe70vsyCH91HSi5f/cF2p6dqzryeRKXrJyeobzO8KqLQJfl6
        4vv4o5/1JlzS5paSFHQXF7pdPf8do839QL7vb+pDzhvUJHIY2Z7tSvBzk3X6wfJZkkWJpTgj
        0VCLuag4EQBiMfmTSwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnO7JiT/jDOZsF7J4MG8bm8XethPs
        Fi9/XmWzOPiwk8Vi2oefzBaf1i9jtZjbcoTdYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HlOXrWX2mLDoAKPH9/UdbB4fn95i8ejbsorR4/MmOY/2A91MAZxRXDYpqTmZZalF+nYJXBlv
        j7xnKZguVTH9xnvWBsYdwl2MnBwSAiYSjf1rGLsYuTiEBHYzSky7tYkdIiEpcWLnc0YIW1ji
        fssRVoiiZ4wSd54cZgNJsAloS0x7uJsVxBYRMJLYfmMOWJxZ4C2TxPfpUA3nmSR+Xt/LBJLg
        FAiUuLH6HZgtLBAs8eDHObBtLAKqEk8f7gRr5hWwlDjet4YZwhaUODnzCQvEUG2J3oetjDD2
        soWvmSGuU5D4+XQZ0DIOoCP8JE78FIIoEZGY3dnGPIFReBaSSbOQTJqFZNIsJC0LGFlWMUqm
        FhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIEx6SW5g7G7as+6B1iZOJgPMQowcGsJML72fpb
        nBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeG4UL44QE0hNLUrNTUwtSi2CyTBycUg1ME1RXr7W0
        XXYg2EPC5+7KbSkPrgkk8OfNaoj6tuViAL+ZRb0Vt2axoFlEtt5uZa2+Or39ZvLr1yayMbYf
        6tDaF7H33uxkf9NY74UXKmSV3ivcPhC0b1/C86dKexeo7np/6vdvh7WC57qd/vjc8vz7THPp
        t/xe6T2zv6mv5LgltlvO6dx7kU1aXp5tWUGrHoi/XhvXqbrjHXtJ7pbNZ86EfXwhX2N3+dAq
        uzOnQieocNtMXX5d4LwYi+Wsqd+d3WafrL5Xsefd/3dz3wfE7niZ/KylePI7+fa3XHXJYgmX
        +k9bvF86b9uRM+fT3kX/C1zN8FRecEKU6IOfk7ksBROnz+R/YXP0r9jGP3KVzwL5eZRYijMS
        DbWYi4oTAV6LV284AwAA
X-CMS-MailID: 20200629070129epcas2p4f5a9d0a46a630efc91d8545325730cb5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
        <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
        <CAOBeenbWTEbi=gF0WtHCYRK8Y3_nGD7sGcdRqP=oebBJUkanag@mail.gmail.com>
        <02e801d64bae$e5d36f00$b17a4d00$@samsung.com>
        <CAOBeenZ41xLfDDjfTUxaRmu4WJfzV+dXNSt3nCi_Oiu-Fi-oBA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
>=20
> Kiwoong Kim <kwmad.kim=40samsung.com> =E6=96=BC=202020=E5=B9=B46=E6=9C=88=
26=E6=97=A5=20=E9=80=B1=E4=BA=94=20=E4=B8=8B=E5=8D=887:42=E5=AF=AB=E9=81=93=
=EF=BC=9A=0D=0A>=20>=0D=0A>=20>=20>=20Hi=20Kiwoong,=0D=0A>=20>=20>=0D=0A>=
=20>=20>=20Kiwoong=20Kim=20<kwmad.kim=40samsung.com>=20=E6=96=BC=202020=E5=
=B9=B46=E6=9C=8820=E6=97=A5=20=E9=80=B1=E5=85=AD=20=E4=B8=8B=E5=8D=883:00=
=E5=AF=AB=E9=81=93=EF=BC=9A=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20Some=20=
SoC=20specific=20might=20need=20command=20history=20for=20various=20reasons=
,=0D=0A>=20such=0D=0A>=20>=20>=20>=20as=20stacking=20command=20contexts=20i=
n=20system=20memory=20to=20check=20for=20debugging=0D=0A>=20>=20>=20>=20in=
=20the=20future=20or=20scaling=20some=20DVFS=20knobs=20to=20boost=20IO=20th=
roughput.=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20What=20you=20would=20do=
=20with=20the=20information=20could=20be=20variant=20per=20SoC=0D=0A>=20>=
=20>=20>=20vendor.=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20Signed-off-by:=
=20Kiwoong=20Kim=20<kwmad.kim=40samsung.com>=0D=0A>=20>=20>=20>=20---=0D=0A=
>=20>=20>=20>=20=20drivers/scsi/ufs/ufshcd.c=20=7C=204=20++++=0D=0A>=20>=20=
>=20>=20=20drivers/scsi/ufs/ufshcd.h=20=7C=208=20++++++++=0D=0A>=20>=20>=20=
>=20=202=20files=20changed,=2012=20insertions(+)=0D=0A>=20>=20>=20>=0D=0A>=
=20>=20>=20>=20diff=20--git=20a/drivers/scsi/ufs/ufshcd.c=20b/drivers/scsi/=
ufs/ufshcd.c=0D=0A>=20>=20>=20>=20index=2052abe82..0eae3ce=20100644=0D=0A>=
=20>=20>=20>=20---=20a/drivers/scsi/ufs/ufshcd.c=0D=0A>=20>=20>=20>=20+++=
=20b/drivers/scsi/ufs/ufshcd.c=0D=0A>=20>=20>=20>=20=40=40=20-2545,6=20+254=
5,8=20=40=40=20static=20int=20ufshcd_queuecommand(struct=0D=0A>=20Scsi_Host=
=0D=0A>=20>=20>=20*host,=20struct=20scsi_cmnd=20*cmd)=0D=0A>=20>=20>=20>=20=
=20=20=20=20=20=20=20=20/*=20issue=20command=20to=20the=20controller=20*/=
=0D=0A>=20>=20>=20>=20=20=20=20=20=20=20=20=20spin_lock_irqsave(hba->host->=
host_lock,=20flags);=0D=0A>=20>=20>=20>=20=20=20=20=20=20=20=20=20ufshcd_vo=
ps_setup_xfer_req(hba,=20tag,=20true);=0D=0A>=20>=20>=20>=20+=20=20=20=20=
=20=20=20if=20(cmd)=0D=0A>=20>=20>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20ufshcd_vops_cmd_log(hba,=20cmd,=201);=0D=0A>=20>=20>=20>=20=20=
=20=20=20=20=20=20=20ufshcd_send_command(hba,=20tag);=0D=0A>=20>=20>=20>=20=
=20out_unlock:=0D=0A>=20>=20>=20>=20=20=20=20=20=20=20=20=20spin_unlock_irq=
restore(hba->host->host_lock,=20flags);=20=40=40=0D=0A>=20>=20>=20>=20-4890=
,6=20+4892,8=20=40=40=20static=20void=20__ufshcd_transfer_req_compl(struct=
=0D=0A>=20>=20>=20ufs_hba=20*hba,=0D=0A>=20>=20>=20>=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20/*=20Mark=20completed=
=20command=20as=20NULL=20in=20LRB=20*/=0D=0A>=20>=20>=20>=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20lrbp->cmd=20=3D=20=
NULL;=0D=0A>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20lrbp->compl_time_stamp=20=3D=20ktime_get();=0D=0A>=
=20>=20>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20ufshcd_vops_cmd_log(hba,=20cmd,=202);=0D=0A>=20>=20>=20>=20+=0D=
=0A>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20/*=20Do=20not=20touch=20lrbp=20after=20scsi=20done=20*/=
=0D=0A>=20>=20>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20cmd->scsi_done(cmd);=0D=0A>=20>=20>=20>=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20__ufshcd_releas=
e(hba);=0D=0A>=20>=20>=0D=0A>=20>=20>=20If=20your=20cmd_log=20vop=20callbac=
ks=20are=20only=20existed=20in=0D=0A>=20=22ufshcd_queuecommand=22=0D=0A>=20=
>=20>=20and=20=22ufshcd_transfer_req_compl=22,=20perhaps=20you=20could=20re=
-use=0D=0A>=20>=20>=20=22ufshcd_vops_setup_xfer_req()=22=20and=20an=20added=
=20=22ufshcd_vops_compl_req()=22=0D=0A>=20>=20>=20instead=20of=20a=20brand=
=20new=20=22ufshcd_vops_cmd_log()=22=20?=0D=0A>=20>=20>=0D=0A>=20>=20>=20Th=
anks,=0D=0A>=20>=20>=20Stanley=20Chu=0D=0A>=20>=0D=0A>=20>=20Currently,=20u=
fshcd_vops_setup_xfer_req=20doesn't=20get=20scsi_cmnd=20variable.=0D=0A>=20=
=0D=0A>=20You=20could=20get=20scsi_cmnd=20by=20hba->lrb=5Btag=5D.cmd=20if=
=20is_scsi_cmd=20is=20true=20in=0D=0A>=20your=20ufshcd_vops_setup_xfer_req=
=20vendor=20implementation.=0D=0A>=20=0D=0A>=20>=20Actually,=20when=20intro=
duced=20this=20callback=20first,=20I=20was=20willing=20to=20make=20it=0D=0A=
>=20do=20that=0D=0A>=20>=20but=20someone=20gave=20me=20another=20idea.=20Th=
en=20do=20you=20agree=20to=20change=20argument=0D=0A>=20set=20of=20the=20fu=
nction?=0D=0A>=20>=0D=0A>=20>=20And=20I=20can't=20find=20ufshcd_vops_compl_=
req=20in=205.9/scsi-queue.=20Could=20you=20let=0D=0A>=20me=20know=20where=
=20to=20find?=0D=0A>=20>=0D=0A>=20=0D=0A>=20Sorry=20to=20not=20describing=
=20clearly.=20What=20I=20mean=20is=20that=20you=20could=20=22add=22=0D=0A>=
=20ufshcd_vops_compl_xfer_req=20vop=20callback=20in=20your=20patch.=0D=0A>=
=20=0D=0A>=20Thanks,=0D=0A>=20Stanley=20Chu=0D=0A=0D=0AGot=20it=20and=20I'l=
l=20refer=20to=20what=20you=20said.=0D=0AThanks.=0D=0AKiwoong=20Kim=0D=0A=
=0D=0A=0D=0A
