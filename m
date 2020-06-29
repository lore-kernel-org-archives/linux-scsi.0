Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA8CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B15B20663
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:01:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="M60yGgLI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgF2TBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:01:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58413 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbgF2TBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:01:17 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200629071158epoutp02f9755241b3c6403f754939299e48e94c~c8j52kZHE3240932409epoutp02U
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 07:11:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200629071158epoutp02f9755241b3c6403f754939299e48e94c~c8j52kZHE3240932409epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593414718;
        bh=F4/LreYMNdNHvdrHcGzcQewgw9dj9fmV9XNgpzsrRZk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=M60yGgLItUF7y2mpr6aP01OzlYcEeMmPXEJLZmQn91HKVFMQVrKQax5PUiiLMqF7k
         8sbZSGxTaMpvFzHkjG6VdFJPKVdiTnUy7WKQS3zSj6a/jyPHdNYGMoc5o6znRrOuHF
         8aNKZpK9NGQQCqhVJDLapjhFkJnAC+iIalmXicWk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200629071157epcas2p1f04cac80669cd862d2e2edb3affe06b3~c8j5HIcYE2186421864epcas2p1V;
        Mon, 29 Jun 2020 07:11:57 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49wJZg09tMzMqYls; Mon, 29 Jun
        2020 07:11:55 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.E6.18874.A3499FE5; Mon, 29 Jun 2020 16:11:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200629071153epcas2p193dd536a5037b8e0b7bc8d672c1cd2af~c8j1st8eM1964419644epcas2p1m;
        Mon, 29 Jun 2020 07:11:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200629071153epsmtrp115e797c436e9cce356e79237e6e10c4b~c8j1r98Wr2117621176epsmtrp1k;
        Mon, 29 Jun 2020 07:11:53 +0000 (GMT)
X-AuditID: b6c32a46-503ff700000049ba-20-5ef9943a60f1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BE.8D.08382.93499FE5; Mon, 29 Jun 2020 16:11:53 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200629071153epsmtip11a74065c83ec7d5720b23a90d325d8c1~c8j1gaFNQ0037900379epsmtip1P;
        Mon, 29 Jun 2020 07:11:53 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>,
        "'Stanley Chu'" <chu.stanley@gapp.nthu.edu.tw>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Bean Huo \(beanhuo\)'" <beanhuo@micron.com>,
        "'Asutosh Das'" <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>
In-Reply-To: <CAOBeenZ41xLfDDjfTUxaRmu4WJfzV+dXNSt3nCi_Oiu-Fi-oBA@mail.gmail.com>
Subject: RE: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
Date:   Mon, 29 Jun 2020 16:11:53 +0900
Message-ID: <003c01d64de4$91208c80$b361a580$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL8/V917mWvtxF9jWsyhmCCDxjM/gJ/aiFPAXuCqJoBAcj1HAIH5g0EpmmpZtA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJJsWRmVeSWpSXmKPExsWy7bCmma7VlJ9xBkeuc1k8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWsxtOcJusejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        j6nL1jJ7TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAM6oHJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoEOVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5Gft3Whc81qi4N722gfGi
        ehcjJ4eEgInE3P9NTF2MXBxCAjsYJTqvbmCDcD4xSpxZ+pUdwvnGKHGqbw0zTMujfbtYIBJ7
        GSWO7rjJDOG8YJT4eOwPK0gVm4C2xLSHu8FsEYEgiZ2vHoAtYRY4ziQxZ9tkNpAEp0CgxI3V
        75hAbGGBUIkHv46ArWARUJXY9nAuWA2vgKXE1a7jULagxMmZT1hAbGagBcsWvoY6SUHi59Nl
        QMs4gJb5Sew45wdRIiIxu7MN7DgJgSMcEut+TWaEqHeRWLH4IjuELSzx6vgWKFtK4mV/G5Rd
        L7FvagMrRHMPo8TTff+gmo0lZj1rZwRZxiygKbF+lz6IKSGgLHHkFtRpfBIdh/+yQ4R5JTra
        hCAalSV+TYK5QFJi5s077BMYlWYheWwWksdmIflgFsKuBYwsqxjFUguKc9NTi40KjJDjehMj
        OA1rue1gnPL2g94hRiYOxkOMEhzMSiK8n62/xQnxpiRWVqUW5ccXleakFh9iNAUG9URmKdHk
        fGAmyCuJNzQ1MjMzsDS1MDUzslAS561XvBAnJJCeWJKanZpakFoE08fEwSnVwGTwU+vHgS9P
        Q+2bxMVdvKdwS1984jYlJaL8xQGVDPNZfn96fdLmdZ58FTr/8Fmtu9PleVV6Fl7J6BN/Ib54
        uv5ZM40thtKB0fF64qELprUtObio8sStMxz+5taMukeXer5Ji6y0U/m+mz9CeUmaze0fa9+f
        PTv92/vvLhfcnDT6RZguTzLsEU/ed47p1KeXqXWFpq829pg53N56wej5o/mNZ8+UVU8QWZwn
        LjZLXOGpavqrer1ri/bzrUjcW3iifjIrh5yT0dVMEx1Z+RyPqnNFXI2+QvdnmjiyHbqh09u4
        QtFH/K6Whduq9JWRr45Wb9p2gEGrYdprtSt3MhZKHLS44vqi0PP+VfmEzeH5O5RYijMSDbWY
        i4oTAX5G/2FMBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSnK7llJ9xBhcu6lg8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWsxtOcJusejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        j6nL1jJ7TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAM4oLpuU1JzMstQifbsErozH
        V1sYC2ZJVezfvJ2pgXG3cBcjJ4eEgInEo327WEBsIYHdjBK/j4VDxCUlTux8zghhC0vcbznC
        ClHzjFGic2EYiM0moC0x7eFusLiIQJBEQ9cB5i5GLg5mgbNMEm29i5lAHCGB80wSP6/vZQKp
        4hQIlLix+h2YLSwQLPHgxzl2EJtFQFVi28O5bCA2r4ClxNWu41C2oMTJmU/ArmMG2tb7sJUR
        xl628DUzxHUKEj+fLgO6ggPoCj+JHef8IEpEJGZ3tjFPYBSehWTSLCSTZiGZNAtJywJGllWM
        kqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMERqaW5g3H7qg96hxiZOBgPMUpwMCuJ8H62
        /hYnxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQimCwTB6dUA9NUyzT7
        /6WNk6NuNnuYT5R4ISDxW36T5Z74Zd7RFT2xe8rZPZfmMZ9+lfpM/NadeXkrz333Xn+na1fg
        moqb4jNVs61idIPYn2+r2yWZLJ6Wlc/3rfv8QbYnH4NuL9PcJWXwO+V6UXBjq/rlGe3eelrz
        LLdbHQw7ZREmxX7LTbZ0ueWt9e8Ybj27f/5DXGINjwuDrM/kmIsN12VzJr3e+/HMaU7Z9vvr
        H2dO7Xa/83fpdMbeNJ9ZS2oued+LtWaQ0bj+d9LK5ASTZ/sFPQ4Vl7VHM3ndXaE8uUbulNdL
        y6lKjPm3yuXnX7K8NjM1vHpNTbZW6Aqjpw2HVt06WCmaH86yiWNevav7FT3O9/Juf5RYijMS
        DbWYi4oTAfOPohg3AwAA
X-CMS-MailID: 20200629071153epcas2p193dd536a5037b8e0b7bc8d672c1cd2af
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
=20=0D=0A>=20Thanks,=0D=0A>=20Stanley=20Chu=20=0D=0A=0D=0AGot=20it=20and=20=
I'll=20refer=20to=20what=20you=20said.=0D=0A=0D=0AThanks.=0D=0AKiwoong=20Ki=
m=0D=0A=0D=0A
