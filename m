Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A421C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 02:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F686103C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 02:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhJHCFG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 22:05:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64030 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbhJHCFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 22:05:05 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211008020309epoutp02a17faa7f72a676b03b11508667278443~r69Tjkb0V3118031180epoutp02k
        for <linux-scsi@vger.kernel.org>; Fri,  8 Oct 2021 02:03:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211008020309epoutp02a17faa7f72a676b03b11508667278443~r69Tjkb0V3118031180epoutp02k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633658589;
        bh=jt36w1XFUQcMRSiBLHwuYbtIkpJrsEWBkEMlkqLcZkQ=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=EPvtq7feoOqHstx4INvrZaxHh6U10zlWHLgUC0Z65Zp/CyWQZHY4PX3tWqDNTujU4
         7ZozuqjLmcPorytynMKyB6XoPLh4Ic2dsdJ4rD1UJ8d4ts8K6+pS3WRb/ThiQyKor+
         SV0LPMiGhvoecracRtVTn1hUzSoVy4sCQKGcqTMg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211008020248epcas2p18c704d63a377d90b9156b57573396527~r69ASTfCw0562705627epcas2p11;
        Fri,  8 Oct 2021 02:02:48 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.90]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HQWfs65m5z4x9R0; Fri,  8 Oct
        2021 02:02:45 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.AD.09717.5C6AF516; Fri,  8 Oct 2021 11:02:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211008020234epcas2p35496e5217a51db2535a75682cae12c29~r68zD9CLO1463214632epcas2p3A;
        Fri,  8 Oct 2021 02:02:34 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211008020234epsmtrp2be182a1b933e62ccfa7a403df059656c~r68zD0VZV1251712517epsmtrp2t;
        Fri,  8 Oct 2021 02:02:34 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-d9-615fa6c5c10d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.EA.09091.AB6AF516; Fri,  8 Oct 2021 11:02:34 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211008020234epsmtip1a361df8cf2b24c7f1f60dcb1b4a75395~r68yyN0aQ1777117771epsmtip1K;
        Fri,  8 Oct 2021 02:02:34 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>, <vkumar.1997@samsung.com>
In-Reply-To: <b548158d-a155-bde9-caff-0f3fefbda403@acm.org>
Subject: RE: [PATCH v1] scsi: ufs: clear doorbell for hibern8 errors when
 using ah8
Date:   Fri, 8 Oct 2021 11:02:33 +0900
Message-ID: <000001d7bbe8$8f5e07b0$ae1a1710$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHah6ZofR0Lvc5+Bbmc5G3bkedCfAIuqRJVAsxncCSrmuacMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmme7RZfGJBvu/KlmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxerFD1gsFt3YxmRxedccNovu6zvYLJYf/8dk
        0XX3BqPF0n9vWSzu3P/I4sDvcfmKt8flvl4mj8V7XjJ5TFh0gNHj+/oONo+PT2+xePRtWcXo
        8XmTnEf7gW6mAM6obJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
        nwBdt8wcoA+UFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQXmBXrFibnFpXnpenmp
        JVaGBgZGpkCFCdkZR1r7mQu+SFXMmGLZwLhMtIuRg0NCwESi/ahOFyMnh5DADkaJM0sFIOxP
        jBLLDhl0MXIB2d+A4vcWsIMkQOrfTdjIBpHYyyjRt2AnE4TzglHi0tFXLCBVbALaEtMe7mYF
        SYgIzGeW+HJ+EStIglPAWqLl4nIwW1ggVGL+1B1gY1kEVCR+rD3BBmLzClhKHLh4ghHCFpQ4
        OfMJ2FBmoKHLFr5mhjhDQeLn02Vgc0QEnIDO28AGUSMiMbuzjRlksYTAAw6J7ifXmCD+dJHY
        djQdoldY4tXxLVDvSEl8freXDcKul9g3tYEVoreHUeLpvn+MEAljiVnP2hlB5jALaEqs36UP
        MVJZ4sgtqNP4JDoO/2WHCPNKdLQJQTQqS/yaNBlqiKTEzJt3oLZ6SFx6fpV1AqPiLCRPzkLy
        5Cwkz8xC2LuAkWUVo1hqQXFuemqxUYEhPKaT83M3MYJTtpbrDsbJbz/oHWJk4mA8xCjBwawk
        wptvH5soxJuSWFmVWpQfX1Sak1p8iNEUGOwTmaVEk/OBWSOvJN7QxNLAxMzM0NzI1MBcSZx3
        7j+nRCGB9MSS1OzU1ILUIpg+Jg5OqQYmH8lp751knneccblsEn/1Qe+KDU8Ovdz2+8vmJAdh
        zl+qea8EP3f+qppQMeMu/4PWDDW9vKfH+9OLq7af4n21yuPWycWsW4/knPqieEHd4VJZ0gX/
        V0WhBbcdvtRu3r3z4hKj6fPyjU90p5SL7zpwcydv+xKeM6v9GBZ/CppY4WB+4++Eh+3+dwPK
        o6JkJ9QUlmkd2S42t89f+S2zrdZMrYtvGLSflHFqP5r94uQ0vTtGk53CJHXkVe0nfMpX5qh+
        vOx4b2z2tN+1tyW01z6xWetzu5claRXnI9vIpdPzjpyvCFnW/E/t2Ipjtra8jtqPLm/zCTRe
        JJGiqyqQfLVc52Dp/uDtndmLPqlu6f2srMRSnJFoqMVcVJwIAKURsJBiBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWy7bCSnO6uZfGJBkd+cFucfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Xi69JnrBbTPvxktvi0fhmrxerFD1gsFt3YxmRxedccNovu6zvYLJYf/8dk
        0XX3BqPF0n9vWSzu3P/I4sDvcfmKt8flvl4mj8V7XjJ5TFh0gNHj+/oONo+PT2+xePRtWcXo
        8XmTnEf7gW6mAM4oLpuU1JzMstQifbsEroy3C+4zFpyRqni26C1LA+M3kS5GTg4JAROJdxM2
        snUxcnEICexmlFjeepcJIiEpcWLnc0YIW1jifssRVoiiZ4wSN/52gxWxCWhLTHu4GywhIrCR
        WWJt2wNGiKrjjBKTL98Ea+cUsJZoubgcqIqDQ1ggWOLtOnaQMIuAisSPtSfYQGxeAUuJAxdP
        MELYghInZz5hAbGZgRY8vfkUzl628DUzxEUKEj+fLmMFsUUEnCTO3NvABlEjIjG7s415AqPQ
        LCSjZiEZNQvJqFlIWhYwsqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOVy3NHYzb
        V33QO8TIxMF4iFGCg1lJhDffPjZRiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp
        2ampBalFMFkmDk6pBqYlxzMtXyg021frVYd0vBMpX/Ase1HIkmebJXcfFFC1uqI3S9rp3NqJ
        U69oSeuET3uo4vTGj+u9VHKgxGX//+9VxHgf+bdo5f0zE7g0K+6xI4ecRuOL7etTDts8flMY
        OVXD97hHZ2y4osK+J8s/fxa0kXuqcXO2inhZmmzWtycT6zIC8tflHc3InnlWSEJVnfX7Ka/w
        mNMzdr9IMBc233Nl/dObZ/sb1m/8rOskXvu0PcbqTYbfrv88Gep2m5YG780vvyGeaVaVLmP1
        6seV07osm1i/GxYL5KccuMf1skCuYu+E9FdhmTsrLZfvn80/dZ7dM4G5m3aVc2yYc2Tp8mj+
        4pJvW7T3SfusujNN2U2JpTgj0VCLuag4EQB7ZuUdRgMAAA==
X-CMS-MailID: 20211008020234epcas2p35496e5217a51db2535a75682cae12c29
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4
References: <CGME20211007075635epcas2p16af95ce29750417f34f8490b0d8000d4@epcas2p1.samsung.com>
        <1633592411-129911-1-git-send-email-kwmad.kim@samsung.com>
        <b548158d-a155-bde9-caff-0f3fefbda403@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 10/7/21 12:40 AM, Kiwoong Kim wrote:
> > When an scsi command is dispatched right after host complete all the
> > pending requests goes to idle and ufs driver tries to ring a doorbell,
> > host might be still during entering into hibern8. If an error occurrs
> > during that period, the doorbell might not be zero. In this case,
> > clearing it should be needed to requeue its command.
> > Currently, ufshcd_err_handler goes directly to reset when the driver's
> > link state is broken. This patch is to make it clear doorbells in the
> > case. In the situation, communication would be disabled, so TM isn't
> > necessary or we can say it's not available.
>=20
> The above text is too hard to comprehend. Please make it more clear. As a=
n
> example, in the first sentence, what does =22goes to idle=22 apply to?
> Does it apply to =22SCSI command=22, =22pending requests=22 or something =
else?

My 'goes to idle' means a state of no pended UTP requests.
I write 'scsi command' because the symptom that I saw is related with scsi =
command.

>=20
> What mechanism does =22If an error occurs=22 refer to? A SCSI command
> processing error, a link error or another type of error?

Hibern8 errors written in the title.

>=20
> > Here's an actual symptom that I've faced. At the time, tag =2317 is
> > still pended even after host reset. And then the block timer is
> > expired.
>=20
> pended -> pending.

Got it.
>=20
> > exynos-ufs 11100000.ufs: ufshcd_check_errors: Auto Hibern8 Enter
> > failed - status: 0x00000040, upmcrs: 0x00000001 ..
> > host_regs: 00000050: b8671000 00000008 00020000 00000000 ..
> > exynos-ufs 11100000.ufs: ufshcd_abort: Device abort task at tag 17
>=20
> The relationship between the example and the description above the exampl=
e
> is not clear. If a command is pending before the error handler starts,
> aborting that command fails and the host is not reset then the command
> will still be pending after the error handler has finished.
>=20
> > =40=40 -6138,7 +6139,12 =40=40 static void ufshcd_err_handler(struct Sc=
si_Host
> *host)
> >   	     (hba->saved_uic_err & (UFSHCD_UIC_DL_NAC_RECEIVED_ERROR =7C
> >   				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))) =7B
> >   		needs_reset =3D true;
> > -		goto do_reset;
> > +		spin_lock_irqsave(hba->host->host_lock, flags);
> > +		if (=21hba->ahit && ufshcd_is_link_broken(hba))
> > +			link_broken_in_ah8 =3D true;
> > +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +		if (=21link_broken_in_ah8)
> > +			goto do_reset;
> >   	=7D
> >
>=20
> My understanding is that hba->ahit =3D=3D 0 means that auto-hibernation i=
s
> disabled. Hence, the above code sets 'link_broken_in_ah8' only if auto-
> hibernation is disabled. So what does the name of the variable
> 'link_broken_in_ah8' mean?

Mistake. And while I'm commenting, I get a better idea and will revise this=
 patch.

>=20
> > =40=40 -6168,6 +6174,9 =40=40 static void ufshcd_err_handler(struct Scs=
i_Host
> *host)
> >   		=7D
> >   	=7D
> >
> > +	if (link_broken_in_ah8)
> > +		goto lock_skip_pending_xfer_clear;
> > +
> >   	/* Clear pending task management requests */
> >   	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) =7B
> >   		if (ufshcd_clear_tm_cmd(hba, tag)) =7B
>=20
> Why is skipping the ufshcd_clear_tm_cmd() calls useful in this case?
>=20
> Thanks,
>=20
> Bart.
>=20


