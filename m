Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF26C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 06:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78433611BD
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 06:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbhI1Gtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:49:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24095 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238992AbhI1Gtl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 02:49:41 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210928064800epoutp039760046e46de2355b59dc16e7fb11b05~o6ZKY75u72124121241epoutp03E
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 06:48:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210928064800epoutp039760046e46de2355b59dc16e7fb11b05~o6ZKY75u72124121241epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632811680;
        bh=uIYwablSrD0Lk8AeLcYhXVEfaoaazcqOMjDMbRB+wKU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=J0/uQZ/jQ8ZAoiPbv8uF3WcxeGpkk4UTa/MvG8jmKNUKoAH/59LjfrRtZKq0b9KgC
         dBVm7neuAEP9ttXvrF1OgDbwrsH+Urn+C8lMo8lBCbsx9xjkuZwLAPgZy3up1Z4vYb
         hghKtgTqIrFXDQFne1Z6sm9ZaYoIhnJ48s23eqAs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210928064759epcas2p2e6bac9ce41f92340b3560971efe4a375~o6ZJIL3bA1434414344epcas2p2_;
        Tue, 28 Sep 2021 06:47:59 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HJVSY1T89z4x9QP; Tue, 28 Sep
        2021 06:47:57 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.93.09749.D9AB2516; Tue, 28 Sep 2021 15:47:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210928064756epcas2p3975b89e0cecd0ca1807b354bafadccd3~o6ZGdtuZR2288822888epcas2p3q;
        Tue, 28 Sep 2021 06:47:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210928064756epsmtrp26021691941d7a2f8af4d5a7612408123~o6ZGb3OFF2668426684epsmtrp2w;
        Tue, 28 Sep 2021 06:47:56 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-22-6152ba9dea16
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.F9.08750.C9AB2516; Tue, 28 Sep 2021 15:47:56 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210928064756epsmtip1921215f18f347434a3efecddd770da0f~o6ZGL0OzO1767417674epsmtip1V;
        Tue, 28 Sep 2021 06:47:56 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <adrian.hunter@intel.com>
Cc:     <alim.akhtar@samsung.com>, <asutoshd@codeaurora.org>,
        <avri.altman@wdc.com>, <bvanassche@acm.org>, <cang@codeaurora.org>,
        <huobean@gmail.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <liwei213@huawei.com>,
        <manivannan.sadhasivam@linaro.org>, <martin.petersen@oracle.com>
Subject: Re: [PATCH V5 1/3] scsi: ufs: Fix error handler clear ua deadlock
Date:   Tue, 28 Sep 2021 15:47:56 +0900
Message-ID: <002201d7b434$c4bdef80$4e39ce80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: Ade0NEk7VgayU3rRTZCsfbAEdvNyrg==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJsWRmVeSWpSXmKPExsWy7bCmhe7cXUGJBpvXsVicfLKGzeLBvG1s
        FnvbTrBbvPx5lc1i2oefzBaf1i9jtZhztoHJYtGNbUwW3dd3sFn8nXOE0eJuSyerxfLj/5gc
        eDwuX/H2uNzXy+Sxc9Zddo+WI29ZPRbvecnkcefaHjaPCYsOMHp8fHqLxaNvyypGj8+b5Dza
        D3QzBXBH5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyVj/Rb7gPmvFpGWdbA2M21i7GDk5JARMJO60bGPsYuTiEBLYwShxff8ydgjnE6PE
        5DV3oZzPjBI3T9xlg2nZdfoBE0RiF6PE/feXmEASQgIvGCV2P1YFsdkEtCWmPdwNtkNEQFbi
        05odYA3MAsuYJJqXHQNyODiEBbwkDu/mBKlhEVCVmPhjAzOIzStgKXH86hkoW1Di5MwnLCA2
        M9DMZQtfM0McoSDx8+kyqPl6EgeaQC4FqRGRmN3ZBlVzgkOi40syhO0icXHJNqi4sMSr41vY
        IWwpic/v9kI9Vi+xb2oDK8idEgI9jBJP9/1jhEgYS8x61s4IcjOzgKbE+l36IKaEgLLEkVtQ
        p/FJdBz+yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfWQeP5vIcsERsVZSJ6cheTJWUiemYWw
        dwEjyypGsdSC4tz01GKjAmPkqN7ECE7WWu47GGe8/aB3iJGJg/EQowQHs5IIbzCLf6IQb0pi
        ZVVqUX58UWlOavEhRlNgsE9klhJNzgfmi7ySeENTIzMzA0tTC1MzIwslcd65/5wShQTSE0tS
        s1NTC1KLYPqYODilGpj8Ks6tsHrJdcsz9IwE+xyWwjy7tOb0E2dEnp5ac/lseC6Lu1uhczWn
        VwFTOWuSmunJyWlnvF4kPEnaHryoXylB/Ed+/udks5fTjqknfneV1O5U/Ga+bGuPym8t+Z+l
        x1Ou39ypXpv4Rzuxx2fdZdHzjy7NDlsntlZjZsHTe9Mn5V32+COxwtVJoyvAcqNM+qRdzh9F
        PcuXLti77e/2NQ8Xl9dJHatTbHkUu9X+3Y3X/m2GfwQaLc8Edp63O3d116oJn/i/2mXvkoiU
        dohv+8ws+N/sahzTl6Qf2zlXH/zU0xhQVd9q6c367NdXGb7vCpYpIvkTjpzfaXv1fpaVe3cK
        05x5P3aelKq6UtCWtkqJpTgj0VCLuag4EQCPE1c+XwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWy7bCSnO6cXUGJBkeWS1mcfLKGzeLBvG1s
        FnvbTrBbvPx5lc1i2oefzBaf1i9jtZhztoHJYtGNbUwW3dd3sFn8nXOE0eJuSyerxfLj/5gc
        eDwuX/H2uNzXy+Sxc9Zddo+WI29ZPRbvecnkcefaHjaPCYsOMHp8fHqLxaNvyypGj8+b5Dza
        D3QzBXBHcdmkpOZklqUW6dslcGU0zpnOXrCKpaLjpnsD4zbmLkZODgkBE4ldpx8wgdhCAjsY
        JS48qYKIS0qc2PmcEcIWlrjfcoS1i5ELqOYZo8TP60vZQBJsAtoS0x7uZgWxRQRkJT6t2cEE
        UsQssIlJYv7piexdjBwcwgJeEod3c4LUsAioSkz8sQFsMa+ApcTxq2egbEGJkzOfsIDYzEAz
        ex+2MsLYyxa+hjpUQeLn02VQu/QkDjTdZYeoEZGY3dnGPIFRcBaSUbOQjJqFZNQsJC0LGFlW
        MUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEx6GW1g7GPas+6B1iZOJgPMQowcGsJMIb
        zOKfKMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAMT34M1
        cWY3l/rUBj51+dvOaeW9TkjWYovD0aM/P/meWFEq7rpj8WbhVy/nGjZ9uTLHv8xW6bvUg4Ou
        N7LS9l7fXvKq9dn1k0IP+TbaBYTukzF6sHeS6waFlvfa+2T5Zxvsn3Ckhz92/8UPvB9F9uuX
        yvZP6/MTTAw+vPnkLqet8d/2HHM5fVPeXSbx7i+T96L3C5dJvfq/t2DWhWWtZz21nnRPs5iu
        6dD2RsVVbUPalpgGnhefj+rv4eC7dqq1b86c4oTzvkxTbkeJmckuyP+7tMzpveatOQcU/N3u
        WknFm9061zoxMmULv+Qpq9vWcmLnTS/utO/frnf5xzrDPuHC66d2/FOrmLfmgfXHY2xqK5RY
        ijMSDbWYi4oTASqcYW4yAwAA
X-CMS-MailID: 20210928064756epcas2p3975b89e0cecd0ca1807b354bafadccd3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210928064756epcas2p3975b89e0cecd0ca1807b354bafadccd3
References: <CGME20210928064756epcas2p3975b89e0cecd0ca1807b354bafadccd3@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+	prd_table=5B0=5D.size       =3D cpu_to_le32(UFS_SENSE_SIZE - 1);

UFSHCI specifies Data Byte Count (DBC) like this:
A =E2=80=980=E2=80=99=20based=20value=20that=20indicates=20the=20length,=20=
in=20bytes,=20of=20the=20data=20=0D=0Ablock.=20A=20maximum=20of=20length=20=
of=20256KB=20may=20exist=20for=20any=20entry.=20Bits=201:0=20of=20this=20fi=
eld=20shall=20be=20=0D=0A11b=20to=20indicate=20Dword=20granularity.=20A=20v=
alue=20of=20=E2=80=983=E2=80=99=20indicates=204=20bytes,=20=E2=80=987=E2=80=
=99=20indicates=208=20bytes,=20etc.=0D=0A=0D=0AThat=20means=20the=20size=20=
value=20should=20be=20aligned=20with=204.=20And=20as=20I=20know=20it's=2018=
.=20=0D=0A=0D=0AThanks.=0D=0AKiwoong=20Kim=0D=0A=0D=0A=0D=0A=0D=0A
