Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BFDC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 11:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A3B82082E
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 11:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qF0FYYcB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgFZLmu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 07:42:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11213 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFZLmu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 07:42:50 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200626114246epoutp01ec632457f9fafc34c6b98a70e86e3693~cFUflcwnm0036800368epoutp01X
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2020 11:42:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200626114246epoutp01ec632457f9fafc34c6b98a70e86e3693~cFUflcwnm0036800368epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593171766;
        bh=QmUco7l6tOoe7oerFB9PNtpjKhWVfd+ECh6I1DRRuLk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=qF0FYYcBO+fBdvcj6gmY3jd2bIttlPX8bN5UeJIRl+0Mpp8zXKtOuhP3tB0diHKWp
         w0RhtwPcDNmGUXJ3EZMCf/e4bkMyiCqumpd4+u0Y9KVdaHc7FeRPpWpw5ItRVcse+m
         BwnpVIcFGBsFMtHYUgJy07T5qbQ5paGQdnT9czsE=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200626114246epcas2p2531544a1d9a94fe5b5c116a737727230~cFUfMScyl2316823168epcas2p2H;
        Fri, 26 Jun 2020 11:42:46 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.184]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49tZkX0xv6zMqYkb; Fri, 26 Jun
        2020 11:42:44 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.78.27013.13FD5FE5; Fri, 26 Jun 2020 20:42:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200626114240epcas2p21c9d47ad70dbe0a7073231af3eb74337~cFUaEqAKX2799627996epcas2p20;
        Fri, 26 Jun 2020 11:42:40 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200626114240epsmtrp1488a27c2b4a08339c0988470fbec4bc8~cFUaBa6Rz3029530295epsmtrp1G;
        Fri, 26 Jun 2020 11:42:40 +0000 (GMT)
X-AuditID: b6c32a48-d35ff70000006985-5f-5ef5df31e6b4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.19.08303.03FD5FE5; Fri, 26 Jun 2020 20:42:40 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200626114240epsmtip14fe6b35d9b711874f562058d607a8b4a~cFUZ1Ns2n1448214482epsmtip1r;
        Fri, 26 Jun 2020 11:42:40 +0000 (GMT)
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
In-Reply-To: <CAOBeenbWTEbi=gF0WtHCYRK8Y3_nGD7sGcdRqP=oebBJUkanag@mail.gmail.com>
Subject: RE: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
Date:   Fri, 26 Jun 2020 20:42:40 +0900
Message-ID: <02e801d64bae$e5d36f00$b17a4d00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL8/V917mWvtxF9jWsyhmCCDxjM/gJ/aiFPAXuCqJqmfYo+8A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmua7h/a9xBheXi1s8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWsxtOcJusejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        j6nL1jJ7TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAM6oHJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoEOVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GRPPTmEumCJfceTTUeYG
        xkVyXYycHBICJhLHz29g7GLk4hAS2MEocbptLwuE84lRYsXmB6wQzmdGib6/d9hgWiZuvssK
        YgsJ7GKUuL7ZFaLoBaPEvc0fmEESbALaEtMe7gYrEhEwkth+Yw5YM7PAUyaJ/6/FQGxOgUCJ
        Zef3MILYwgKhEg9+HQHrZRFQlWjZ/AcszitgKfF6+XxWCFtQ4uTMJywQc7Qlli18zQxxkILE
        z6fLoHY5Sfz9s5kVokZEYnZnGzPIcRICBzgkHj+CWCYh4CKxZU4bC4QtLPHq+BZ2CFtK4mV/
        G5RdL7FvagMrRHMPo8TTff+gmo0lZj1rB7I5gDZoSqzfpQ9iSggoSxy5BXUbn0TH4b/sEGFe
        iY42IYhGZYlfkyZDDZGUmHnzDvsERqVZSD6bheSzWUg+mIWwawEjyypGsdSC4tz01GKjAhPk
        yN7ECE7EWh47GGe//aB3iJGJg/EQowQHs5IIb4jbpzgh3pTEyqrUovz4otKc1OJDjKbAsJ7I
        LCWanA/MBXkl8YamRmZmBpamFqZmRhZK4rzvrC7ECQmkJ5akZqemFqQWwfQxcXBKNTAxzTX6
        X79zxnvLw9+nha5ed028d3ttep7TNAP5B+eSu/bdr3MJN/K0Ox7BIsO0LeMgc+t9rW1SQbdT
        rx+0jTK9ILyzIDEjbIreRQ/TsIrZLx9lflsqXOoYzxznvzrJoPFR7TnufL7aoKWs5RZqr1Y9
        +qk28cap3Lrk8E9bohmLBTf2qV72K2hT5pFpz3+647J1zF/+52c6nPIr9dSe/zq6+sX5oNhE
        u2epvvfX8sddjvCrepLDsTatcFf+z1jbBRbGsksiTji6228v4f+6hGm2xLLPjI+3XObyWvxQ
        LH6V1AWvLYVndudFXXw58Yzx66/5/UwLt/1wdAu46eag5dXtdujrpk2ppdPfM7ydnajEUpyR
        aKjFXFScCADv0QFxTQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSnK7B/a9xBqv2alo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWsxtOcJusejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        j6nL1jJ7TFh0gNHj+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAM4oLpuU1JzMstQifbsErowP
        P9+xFUwUqTjVNpO1gbGXv4uRk0NCwERi4ua7rF2MXBxCAjsYJZ7teckCkZCUOLHzOSOELSxx
        v+UIK4gtJPCMUWLGF3EQm01AW2Law91gcREBI4ntN+awgdjMAm+ZJL5Phxp6h1FiycI3YIM4
        BQIllp3fA2YLCwRLPPhxjh3EZhFQlWjZ/AcszitgKfF6+XxWCFtQ4uTMJywQQ7Uleh+2MsLY
        yxa+ZoY4TkHi59NlUEc4Sfz9s5kVokZEYnZnG/MERuFZSEbNQjJqFpJRs5C0LGBkWcUomVpQ
        nJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyTWlo7GPes+qB3iJGJg/EQowQHs5IIb4jbpzgh
        3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MLl+WmB17lTg
        h3Qd1oiou/PNWpKuhZVVd2geD/t3TWSSx93J1TVRW4u811y+Wv9tfvLUPtWXfJniZsFPI//r
        T5px0VIg5o6gzutTSzQ1FqpN0KvYdGv/2Za676GJK6qMgzrqWvSW2r2z5v9/uI5rS0bxd1fG
        YyG7M/QmaoQVnOQ+oNCstjcs3655icLCrf1x6T2qzF1bO3o/HPg3LXOLiLHxqqe6q6J1BDY/
        Nnjz0sTGU7nlvf7cxO7dS3SMgqf9fXlrX6yj2K4N719M91XM3lJlb7l822WZq/ve8Rq/7LV1
        f8TivlDihfwXXe/iVw46T3cs2vQg5o64uUn/xYq1edUq/PdzjNj02Ka61OgfVGIpzkg01GIu
        Kk4EAM7D/9o4AwAA
X-CMS-MailID: 20200626114240epcas2p21c9d47ad70dbe0a7073231af3eb74337
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
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
>=20
> Kiwoong Kim <kwmad.kim=40samsung.com> =E6=96=BC=202020=E5=B9=B46=E6=9C=88=
20=E6=97=A5=20=E9=80=B1=E5=85=AD=20=E4=B8=8B=E5=8D=883:00=E5=AF=AB=E9=81=93=
=EF=BC=9A=0D=0A>=20>=0D=0A>=20>=20Some=20SoC=20specific=20might=20need=20co=
mmand=20history=20for=20various=20reasons,=20such=0D=0A>=20>=20as=20stackin=
g=20command=20contexts=20in=20system=20memory=20to=20check=20for=20debuggin=
g=0D=0A>=20>=20in=20the=20future=20or=20scaling=20some=20DVFS=20knobs=20to=
=20boost=20IO=20throughput.=0D=0A>=20>=0D=0A>=20>=20What=20you=20would=20do=
=20with=20the=20information=20could=20be=20variant=20per=20SoC=0D=0A>=20>=
=20vendor.=0D=0A>=20>=0D=0A>=20>=20Signed-off-by:=20Kiwoong=20Kim=20<kwmad.=
kim=40samsung.com>=0D=0A>=20>=20---=0D=0A>=20>=20=20drivers/scsi/ufs/ufshcd=
.c=20=7C=204=20++++=0D=0A>=20>=20=20drivers/scsi/ufs/ufshcd.h=20=7C=208=20+=
+++++++=0D=0A>=20>=20=202=20files=20changed,=2012=20insertions(+)=0D=0A>=20=
>=0D=0A>=20>=20diff=20--git=20a/drivers/scsi/ufs/ufshcd.c=20b/drivers/scsi/=
ufs/ufshcd.c=0D=0A>=20>=20index=2052abe82..0eae3ce=20100644=0D=0A>=20>=20--=
-=20a/drivers/scsi/ufs/ufshcd.c=0D=0A>=20>=20+++=20b/drivers/scsi/ufs/ufshc=
d.c=0D=0A>=20>=20=40=40=20-2545,6=20+2545,8=20=40=40=20static=20int=20ufshc=
d_queuecommand(struct=20Scsi_Host=0D=0A>=20*host,=20struct=20scsi_cmnd=20*c=
md)=0D=0A>=20>=20=20=20=20=20=20=20=20=20/*=20issue=20command=20to=20the=20=
controller=20*/=0D=0A>=20>=20=20=20=20=20=20=20=20=20spin_lock_irqsave(hba-=
>host->host_lock,=20flags);=0D=0A>=20>=20=20=20=20=20=20=20=20=20ufshcd_vop=
s_setup_xfer_req(hba,=20tag,=20true);=0D=0A>=20>=20+=20=20=20=20=20=20=20if=
=20(cmd)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20ufshcd_=
vops_cmd_log(hba,=20cmd,=201);=0D=0A>=20>=20=20=20=20=20=20=20=20=20ufshcd_=
send_command(hba,=20tag);=0D=0A>=20>=20=20out_unlock:=0D=0A>=20>=20=20=20=
=20=20=20=20=20=20spin_unlock_irqrestore(hba->host->host_lock,=20flags);=20=
=40=40=0D=0A>=20>=20-4890,6=20+4892,8=20=40=40=20static=20void=20__ufshcd_t=
ransfer_req_compl(struct=0D=0A>=20ufs_hba=20*hba,=0D=0A>=20>=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20/*=20Mark=20com=
pleted=20command=20as=20NULL=20in=20LRB=20*/=0D=0A>=20>=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20lrbp->cmd=20=3D=20=
NULL;=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20lrbp->compl_time_stamp=20=3D=20ktime_get();=0D=0A>=20>=20=
+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20ufshc=
d_vops_cmd_log(hba,=20cmd,=202);=0D=0A>=20>=20+=0D=0A>=20>=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20/*=20Do=20not=
=20touch=20lrbp=20after=20scsi=20done=20*/=0D=0A>=20>=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20cmd->scsi_done(cmd);=
=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20__ufshcd_release(hba);=0D=0A>=20=0D=0A>=20If=20your=20cmd_log=
=20vop=20callbacks=20are=20only=20existed=20in=20=22ufshcd_queuecommand=22=
=0D=0A>=20and=20=22ufshcd_transfer_req_compl=22,=20perhaps=20you=20could=20=
re-use=0D=0A>=20=22ufshcd_vops_setup_xfer_req()=22=20and=20an=20added=20=22=
ufshcd_vops_compl_req()=22=0D=0A>=20instead=20of=20a=20brand=20new=20=22ufs=
hcd_vops_cmd_log()=22=20?=0D=0A>=20=0D=0A>=20Thanks,=0D=0A>=20Stanley=20Chu=
=0D=0A=0D=0ACurrently,=20ufshcd_vops_setup_xfer_req=20doesn't=20get=20scsi_=
cmnd=20variable.=0D=0AActually,=20when=20introduced=20this=20callback=20fir=
st,=20I=20was=20willing=20to=20make=20it=20do=20that=0D=0Abut=20someone=20g=
ave=20me=20another=20idea.=20Then=20do=20you=20agree=20to=20change=20argume=
nt=20set=20of=20the=20function?=0D=0A=0D=0AAnd=20I=20can't=20find=20ufshcd_=
vops_compl_req=20in=205.9/scsi-queue.=20Could=20you=20let=20me=20know=20whe=
re=20to=20find?=0D=0A=0D=0AThank=20you=20for=20your=20opinions.=0D=0A=0D=0A=
=0D=0A
