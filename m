Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E82C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 08:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJRIDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 04:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJRIDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 04:03:12 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294F283068
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 01:03:09 -0700 (PDT)
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221018080302epoutp022ce9963d5e7cc8c53f1352790f744731~fGxlWy8PG0608606086epoutp02q
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 08:03:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221018080302epoutp022ce9963d5e7cc8c53f1352790f744731~fGxlWy8PG0608606086epoutp02q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666080182;
        bh=eYUIUhyJOvuj8ktmtbmTGNnrY3OwArlXqWtwc254S2k=;
        h=Subject:Reply-To:From:To:Date:References:From;
        b=DT+UUrPpGe1kRPGhnllFo+K+TcMRMnM80Pq5eVoOCKe+2KZDWEvLJh8+nnuAFzJdi
         yg7Gy+NmuUwRp5vB4nAAMfuLH5+n4vrKkHTmXms9VoX2+bU5wP71+8a3EXT426pmhk
         mtZsgo9cgtqRb9KTKW07VFZZpVPHtPOh0giX+zHQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20221018080302epcas3p2c09f5af779f3d1e66bc215648a616794~fGxkxT37c3059830598epcas3p2D;
        Tue, 18 Oct 2022 08:03:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4Ms5vV0sBpz4x9Pw; Tue, 18 Oct 2022 08:03:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Fix the error log in
 ufshcd_query_flag_retry()
Reply-To: d_hyun.kwon@samsung.com
Sender: Dukhyun Kwon <d_hyun.kwon@samsung.com>
From:   Dukhyun Kwon <d_hyun.kwon@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        cpgsproxy3 <cpgsproxy3@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01666080182092.JavaMail.epsvc@epcpadp4>
Date:   Tue, 18 Oct 2022 16:30:03 +0900
X-CMS-MailID: 20221018073003epcms2p6c9e735f7d1c6061263e025417169b469
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20221017022939epcms2p669fa5e5685ef5be1d6c4d1d3e74b6c51
References: <CGME20221017022939epcms2p669fa5e5685ef5be1d6c4d1d3e74b6c51@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In=C2=A0ufshcd_query_flag_retry()=C2=A0failed=C2=A0log
is=C2=A0incorrectly=C2=A0output=C2=A0as=C2=A0"ufs=C2=A0attibute"

Signed-off-by:=C2=A0d_hyun.kwon=C2=A0<d_hyun.kwon@samsung.com>
---
=C2=A0drivers/ufs/core/ufshcd.c=C2=A0|=C2=A02=C2=A0+-
=C2=A01=C2=A0file=C2=A0changed,=C2=A01=C2=A0insertion(+),=C2=A01=C2=A0delet=
ion(-)

diff=C2=A0--git=C2=A0a/drivers/ufs/core/ufshcd.c=C2=A0b/drivers/ufs/core/uf=
shcd.c
index=C2=A07c15cbc737b4..d8d214001217=C2=A0100644
---=C2=A0a/drivers/ufs/core/ufshcd.c
+++=C2=A0b/drivers/ufs/core/ufshcd.c
@@=C2=A0-3101,7=C2=A0+3101,7=C2=A0@@=C2=A0static=C2=A0int=C2=A0ufshcd_query=
_flag_retry(struct=C2=A0ufs_hba=C2=A0*hba,
=C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if=C2=A0(ret)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0dev_err(hba->dev,
-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"%s=
:=C2=A0query=C2=A0attribute,=C2=A0opcode=C2=A0%d,=C2=A0idn=C2=A0%d,=C2=A0fa=
iled=C2=A0with=C2=A0error=C2=A0%d=C2=A0after=C2=A0%d=C2=A0retries\n",
+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"%s=
:=C2=A0query=C2=A0flag,=C2=A0opcode=C2=A0%d,=C2=A0idn=C2=A0%d,=C2=A0failed=
=C2=A0with=C2=A0error=C2=A0%d=C2=A0after=C2=A0%d=C2=A0retries\n",
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
__func__,=C2=A0opcode,=C2=A0idn,=C2=A0ret,=C2=A0retries);
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return=C2=A0ret;
=C2=A0}
--=C2=A0
2.17.1


