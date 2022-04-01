Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456AEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 17:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349408AbiDARFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 13:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349141AbiDARFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 13:05:43 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92975A5BC
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 10:03:52 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220401170347epoutp01cc9477c89609c4f2d158110ba111fd82~h1IoLsbhy1066010660epoutp01P
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 17:03:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220401170347epoutp01cc9477c89609c4f2d158110ba111fd82~h1IoLsbhy1066010660epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648832628;
        bh=+1cc/kWoFyGeFxbK+NdADtVqkbHz28MlLkQfbk/Z/xQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=gx1vWVkdCZ6HMqU4pBYKYAtlXozoE7QC8HvzuLZ8RhMNXc4z5sQK/ah6G3s8fWsGQ
         pV0fF1NJz3pKwaAXa4xevRNQMxzeAv/6RRM5bPeXfjoqCBhSurZzDUcWrnkT1yIJuk
         xxeCvCysaUxANWrjBLuDnXeLvrOrNIiHu736LItI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220401170346epcas5p2d303c20e50354f964366b57eac757fb2~h1InKRZCi0236402364epcas5p2H;
        Fri,  1 Apr 2022 17:03:46 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KVRMg3cwYz4x9Px; Fri,  1 Apr
        2022 17:03:43 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.D4.09952.F6037426; Sat,  2 Apr 2022 02:03:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220401170342epcas5p137be705b6948a3b1c6fd8d59bd32bf07~h1Ii6-rPE1220712207epcas5p1U;
        Fri,  1 Apr 2022 17:03:42 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220401170342epsmtrp2fea3c659fde876acadf0de7e7be17d5d~h1Ii4yFcX2139321393epsmtrp2n;
        Fri,  1 Apr 2022 17:03:42 +0000 (GMT)
X-AuditID: b6c32a4b-4b5ff700000226e0-e0-6247306f664d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        FE.F3.03370.E6037426; Sat,  2 Apr 2022 02:03:42 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220401170330epsmtip16c67f881c39f6f49dfa7fe4caad435ea~h1IYTy1Hz0535805358epsmtip1a;
        Fri,  1 Apr 2022 17:03:30 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Andy Gross'" <agross@kernel.org>,
        "'Bjorn Andersson'" <bjorn.andersson@linaro.org>,
        "'Matthias Brugger'" <matthias.bgg@gmail.com>,
        "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Asutosh Das'" <asutoshd@codeaurora.org>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Daejun Park'" <daejun7.park@samsung.com>,
        "'Keoseong Park'" <keosung.park@samsung.com>,
        "'Eric Biggers'" <ebiggers@google.com>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "'Mike Snitzer'" <snitzer@redhat.com>,
        "'Jens Axboe'" <axboe@kernel.dk>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Anders Roxell'" <anders.roxell@linaro.org>,
        "'Peter Wang'" <peter.wang@mediatek.com>,
        "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Phillip Potter'" <phil@philpotter.co.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Ye Bin'" <yebin10@huawei.com>,
        "'ChanWoo Lee'" <cw9316.lee@samsung.com>,
        "'Sergey Shtylyov'" <s.shtylyov@omprussia.ru>,
        "'Srinivas Kandagatla'" <srinivas.kandagatla@linaro.org>,
        "'Xiaoke Wang'" <xkernel.wang@foxmail.com>,
        "'Jinyoung Choi'" <j-young.choi@samsung.com>,
        "'Gustavo A. R. Silva'" <gustavoars@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <47e847a9-d4b6-6fc9-d89f-9911c6510226@acm.org>
Subject: RE: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Date:   Fri, 1 Apr 2022 22:33:29 +0530
Message-ID: <009301d845ea$707e5160$517af420$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEkvIO8WDCMeleYLL46gzQacByZhQJQD67yAlAXIwMA15aYegEl4dvirg1rusA=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUZRTvu/fu3YVCrwvIB9oMbmgBgbsC60dIMGJ1FUucHow0hRe4AQG7
        O7usRJg6QIgggRooCMlbBWx5gzxi470or1BEkgkJSDAQUcYBGqZddy3/+53v/H7nd8755vBw
        /jjXihcqiWTlEiZcQBoTtW22dg5S4QcBwjKNGdJMlpGo789VAo3+uIqh5oRuLppZvk2i0rFU
        Ev16/xSBbrTMEyhjYRlHi6piDhpqsUcXehI4qGTcFw2WxnPQ9GgzhuIKVCRaGczgoLN/pBEo
        JbWGRJOqLBzlj9RiqEszD1B/fzkX3a3uIFDynXptNu8mhi53rWEoNt4J1SyuclB6sSOqeLyC
        o4SKJYASOjs5qKjmLkBd13zRRPUAjgY6nnI8t9JDt7zpoR9SMDr3dD9OX88a49K5lUo6vn2O
        Qxc0zWD0UK+Sriw5RdL3hptIurUtEdBp+WpAt+SUcel4TQtBP1MlkrTq6ijwsfAL2xXCMkGs
        3JqVBEqDQiXB7gLvj/29/F3EQpGDyBXtFFhLmAjWXbBnv4/D+6Hh2mUKrI8w4Urtkw+jUAi2
        v7tLLlVGstYhUkWku4CVBYXLnGWOCiZCoZQEO0rYyHdEQuEOFy3xcFhIz3AjIRsw/+bvhy3Y
        CTDDTwJGPEg5w9M3G7EkYMzjU40A5qT1GYJFAGOryoA+eAJgY98d4oXk5/xCQ6IBwIXBNINk
        Rhs8GiJ1LJJygPUFCaQuYUad08rn2oEugVO3XoWLGdt02Ihyg5qxDkyHTal98GTfxHMLgrKB
        A9f1hUwoVzhaWYjp8QaoyZwk9HXsYXHeQ1zfkjVcnirmJAGe1uwjeO+8rZ5iAWc62rm6HiBV
        YwxrT5YCPX8P/K1x3qA1hbNd1Vw9toJP5ptJXR1I0TD/Hyv9cwicu6wySD2g+lY2oaPglC1U
        NWzXW62DKauTmF5pAhMTDOvdCuPmbxv2tgmeSU7m6DENLyQtYWlgS9ZLc2W9NFfWSwNk/W+W
        C4gSYMnKFBHBrMJF5iRho/7770BpRCV4fmp23vVgYnzBsRVgPNAKIA8XmJnc/uK9AL5JEBP9
        LSuX+suV4ayiFbhol30GtzIPlGpvVRLpL3J2FTqLxWJnVyexSGBh0hNczvCpYCaSDWNZGSt/
        ocN4RlYnsIYD6b9njn/5/VvZ2eW/WIzkVvnWiYc37jYa/erisbYySt3v990VD7/GxDmfc0Zv
        z63v9oruvvI49vg+/tGC1NVrh1uE05f4rmUBeW98MsLdXG+5c8Us+cGyZ32TtX2+18yRyear
        btMVB1+Z/TDodWJq3M1bJHZI2VQ/5Z1Tt+Ov6E56nU9QjGPoxUNea1GPPI5++mypVxlWlIO6
        Pz+42zx5rKhQfXy9OKounnQ5eek1W5uqTPVnIpGX1+nZ9GP3D/aanlfbgFSl2dOYiOEetc/e
        Ink5U3529evN2/Y7x/QduOzZ7mvZHV0exox0d6XuxW8gs641BbYxTvWm5oGTIETWe2jDT6MC
        QhHCiOxwuYL5FxvwzUfzBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf1CTdRzH+z6/9jDd3ePGta9QVDu5EhsyJO/LaZxhHU/CZYlFdZUMeQIU
        5tpAMct2tZtAoUSptDNigHAOaLIBtx1wxJAfg+LHhhoEUsAkQjg11MYMY646/nt97v3j8/nj
        Q+PCPjKIzlBkcyqFPFNC8YmmDkmIVBERlxIxn0cix3QthfqnvAQa/dqLoVZdDw/Nei5TqGb8
        FIXaf8snUF/bAoHO3PTg6LapikSutk2opFdHIuOvSWioRkui66OtGPqswkShpaEzJCqeKCJQ
        4alGCk2b9Dgq/7kJQ92OBYAGBi7y0EhDJ4E+v2pdUQ0/Yqi6exlDn2q3oMbbXhKdrgpH9beW
        cKSrvwOQrquLROcbRwDqrktCkw2DOBrsXCR3hLKu4XjWdbIQY8u+GMBZm36cx5aZc1jtpXmS
        rWiZxVjXTzms2ZhPsWNXWijW3pEH2KLyHwDb9m0tj9U62gj2nimPYk0XRsGr4rf521O5zIzD
        nGpzTDI/vbTMSSi9gbkN567hGlAsLAABNGSi4PfllaAA8GkhYwVQM9nL8wvB8Gp90b8sgheW
        Z3h+0wyAzlYD8AkUI4XWCh3lEwKZrwCstn9H+Aac+WMNHNY4SX9Ej8E/m/2RAGYbdIx3Yj4W
        Mbvgif5JwscEswEO2lyUjwVMNBw1V2J+Xgcd30w/9ODMJugecf/PVYY53H/fk9DjrlpZRq+c
        8QocO7vRbxHD2c5LvCIg0q9q0q9q0q9q0q+KlAHCCNZzSnVWWpZapoxUcEfC1fIsdY4iLXz/
        oSwzePhvYWFW0GK8GW4HGA3sANK4JFBw+d2XUoSCVPnRDznVoX2qnExObQfBNCERCwYLHPuE
        TJo8mzvIcUpO9Z+K0QFBGizjQOqe4vUdETucSSGy5MdetLsT7z+S8ubZDPUdYVRpz9ZSS6Cm
        z9acFlJ94649dJe4sfSDyRcS4ufeV3mPXTenay2vjT1bUvL69g2y3Vckrr7Et6L+Snnvy7V3
        9z6uswzXPH3f4qkrOfx7wnJM+0zd2uB3DLGShLjjx/u9B6Ti86dF3vRH11UufvzgnFa6MTe+
        xzuypTlRFRsZc0tgnAo4sfcZ1TX58JptvFyzKP/vyJMLTU5Z4b2nmPFZg+XgL2zc0RufNMQ+
        p+yfmOJZuZc/6jpmfKJiYkK+f/fOPTtDPdH8i0FD2S5b5huETbsUvTU2G0W1M27xkecf1Eq7
        jJvnk+d6FyMlhDpdLgvDVWr5P4VrWbPeAwAA
X-CMS-MailID: 20220401170342epcas5p137be705b6948a3b1c6fd8d59bd32bf07
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220401135856epcas5p38d9e7721c1c0981928b38edcbb2c530f
References: <20220331223424.1054715-1-bvanassche@acm.org>
        <20220331223424.1054715-30-bvanassche@acm.org>
        <c4b47162-1f98-c03b-d041-dc7ac8bd9ae2@intel.com>
        <CGME20220401135856epcas5p38d9e7721c1c0981928b38edcbb2c530f@epcas5p3.samsung.com>
        <47e847a9-d4b6-6fc9-d89f-9911c6510226@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Bart Van Assche =5Bmailto:bvanassche=40acm.org=5D
>Sent: Friday, April 1, 2022 7:29 PM
>To: Adrian Hunter <adrian.hunter=40intel.com>; Martin K . Petersen
><martin.petersen=40oracle.com>
>Cc: Jaegeuk Kim <jaegeuk=40kernel.org>; linux-scsi=40vger.kernel.org; Jame=
s
>E.J. Bottomley <jejb=40linux.ibm.com>; Krzysztof Kozlowski
><krzk=40kernel.org>; Stanley Chu <stanley.chu=40mediatek.com>; Andy Gross
><agross=40kernel.org>; Bjorn Andersson <bjorn.andersson=40linaro.org>;
>Matthias Brugger <matthias.bgg=40gmail.com>; Avri Altman
><Avri.Altman=40wdc.com>; Can Guo <cang=40codeaurora.org>; Asutosh Das
><asutoshd=40codeaurora.org>; Bean Huo <beanhuo=40micron.com>; Guenter
>Roeck <linux=40roeck-us.net>; Daejun Park <daejun7.park=40samsung.com>;
>Keoseong Park <keosung.park=40samsung.com>; Eric Biggers
><ebiggers=40google.com>; Ulf Hansson <ulf.hansson=40linaro.org>; Mike Snit=
zer
><snitzer=40redhat.com>; Jens Axboe <axboe=40kernel.dk>; Geert
>Uytterhoeven <geert=40linux-m68k.org>; Anders Roxell
><anders.roxell=40linaro.org>; Peter Wang <peter.wang=40mediatek.com>;
>Chanho Park <chanho61.park=40samsung.com>; Alim Akhtar
><alim.akhtar=40samsung.com>; Inki Dae <inki.dae=40samsung.com>; Phillip
>Potter <phil=40philpotter.co.uk>; Greg Kroah-Hartman
><gregkh=40linuxfoundation.org>; Ye Bin <yebin10=40huawei.com>; ChanWoo
>Lee <cw9316.lee=40samsung.com>; Sergey Shtylyov
><s.shtylyov=40omprussia.ru>; Srinivas Kandagatla
><srinivas.kandagatla=40linaro.org>; Xiaoke Wang
><xkernel.wang=40foxmail.com>; Jinyoung Choi <j-young.choi=40samsung.com>;
>Gustavo A. R. Silva <gustavoars=40kernel.org>; Kiwoong Kim
><kwmad.kim=40samsung.com>
>Subject: Re: =5BPATCH 29/29=5D scsi: ufs: Split the drivers/scsi/ufs direc=
tory
>
>On 3/31/22 23:38, Adrian Hunter wrote:
>> In particular drivers/ufs/core and drivers/ufs/host would seem a more
>> typical arrangement.
>
>Hi Adrian,
>
>Thanks for having taken a look at this patch series. I'm open to changing =
the
>directory names. Moving the ufs directory one level up sounds like a good
>idea to me. However, I'm not sure that drivers/ufs/host would be a better
>name than drivers/ufs/drivers since all files in drivers/ufs/core also imp=
lement
>UFS host controller support.
>
Hi Bart,

Interesting, it is true that ufshcd.c does have implementation of UFS HCI s=
pecification.
And since core uses a lot of vendor specific callbacks implementation, so m=
ay be=20
drivers/ufs/core and=20
drivers/ufs/hci-vendor or drivers/ufs/pltfm=7B-vendor=7D might be good logi=
cal one.

Having said that, looking at mmc sub-system directory structure, it is simp=
ly=20
drivers/mmc/core and drivers/mmc/host


=20
>Thanks,
>
>Bart.

