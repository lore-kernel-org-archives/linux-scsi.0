Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150ADC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jan 2022 02:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244391AbiATCvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:51:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49689 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiATCvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 21:51:31 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220120025129epoutp023847694cab001538e9bd69feef5bf249~L2tMx2SNT1244412444epoutp02g
        for <linux-scsi@vger.kernel.org>; Thu, 20 Jan 2022 02:51:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220120025129epoutp023847694cab001538e9bd69feef5bf249~L2tMx2SNT1244412444epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1642647089;
        bh=6v1DbUHoAni8eiXbPHbpCUbTZkXT8iKtg6QKxiegaYY=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=sMiMHsPI84Gvn/0Q9+iazUqq6XfZm2c23t1i0mfCKOm9vKf5/3OYaFg6pi1rXjr+X
         HvMFK+yFE1fsaEdoE9DvIurWhNpFpG5VO5ZWDfZQtDXf/ZO/4/pmY4uGYlLDuUvbiz
         xmzV6t03n52hqvZHrSAZJHaTHxPqQY+PfXFuGfvc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20220120025129epcas2p20b47936e4f4bf210dc9df094eb10189a~L2tMWWXT02904029040epcas2p2e;
        Thu, 20 Jan 2022 02:51:29 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.98]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4JfRq36Vjtz4x9Q5; Thu, 20 Jan
        2022 02:51:27 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.9B.10018.59DC8E16; Thu, 20 Jan 2022 11:48:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20220120025127epcas2p34ef71e7051606df008267df74a31815d~L2tKwffPF0992309923epcas2p3N;
        Thu, 20 Jan 2022 02:51:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220120025127epsmtrp2ba4c575a7cd31220fe5f8c60c0b13abd~L2tKv0fyz2814228142epsmtrp2c;
        Thu, 20 Jan 2022 02:51:27 +0000 (GMT)
X-AuditID: b6c32a46-a25ff70000002722-c9-61e8cd95cda3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.F8.08738.F2EC8E16; Thu, 20 Jan 2022 11:51:27 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220120025127epsmtip232828f03422f6cbb774b33a97a690aea~L2tKkJ4WY2456824568epsmtip2c;
        Thu, 20 Jan 2022 02:51:27 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>, <vkumar.1997@samsung.com>
In-Reply-To: <3bb0f5ad-2cea-2509-a9e1-d8ed159bd875@acm.org>
Subject: RE: [PATCH v1] scsi: ufs: use an generic error code in
 ufshcd_set_dev_pwr_mode
Date:   Thu, 20 Jan 2022 11:51:27 +0900
Message-ID: <000001d80da8$9e987cd0$dbc97670$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFcFW0MD/41ZuhWiwfo7q9IaGBfeAIxMRR3AZIYxmqtRQh70A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdljTVHfq2ReJBvs28Vl8XfqM1WLah5/M
        FqsXP2Cx6L6+g82i6+4NRoul/96yWNy5/5HFgd3j8hVvj74tqxg9Pm+SC2COyrbJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwL9ArTswtLs1L18tLLbEyNDAwMgUqTMjO2LjtKlPBQY6K
        xctaWRoY97N1MXJySAiYSGy6vZu5i5GLQ0hgB6PE5Eu3mSCcT4wSK3ZPY4RwPjNKnFu6nxWm
        5deZtWwQiV2MEmtffYZyXjBKfDm7kQmkik1AW2Law92sIAkRgdOMEr0Lr7F3MXJwcApYS6xd
        GQ9SIywQKfHsyWtGEJtFQFVi3+z1YEfxClhKXFm3lwnCFpQ4OfMJC4jNDDRz2cLXzBBXKEj8
        fLoM7CIRASeJg4samCFqRCRmd7aBPSQh8JVd4uCjg1ANLhKrLlxmgbCFJV4d38IOYUtJfH63
        lw2ioZlRYufuRqjuKYwSS/Z/gKoylpj1rJ0R5ANmAU2J9bv0QUwJAWWJI7egjuOT6Dj8lx0i
        zCvR0SYE0ags8WvSZEYIW1Ji5s07UAM9JE4tu8c+gVFxFpI3ZyF5cxaSd2Yh7F3AyLKKUSy1
        oDg3PbXYqMAIHt3J+bmbGMEJU8ttB+OUtx/0DjEycTAeYpTgYFYS4ZWqf5YoxJuSWFmVWpQf
        X1Sak1p8iNEUGPATmaVEk/OBKTuvJN7QxNLAxMzM0NzI1MBcSZzXK2VDopBAemJJanZqakFq
        EUwfEwenVAOTuT4XS9MTfgbXnhc1ckYx8mLHVnS7rOacufDnY5VpRasuxK8818W0+3bQ/Jq1
        V6eqf7zMXGN4a3L32dRLW+9MW9tuptDjKlHeXyt4e6Fz7ZnFM05eM1Z5nc9cNtV5qkVGZ1qg
        ybLw1m1frKYsYrun8uVP/9oJa8tu2qYFi6+4cMEohMvtR37Di5uHDKaH/Wq9fdSdI85YaCoP
        +6Mm7hMe21anHa7X2/u66sbBtU4f5WovOTglu/7YVSJ1Kst096IPb/7MY6lmVnqpdbEicp+a
        4y/tpxL9grqdCRNsmcSMlm5LNFTVOmhtKXA3JaJhjWLDmS+6GXc67Hunn1i3a8NclwP8sZdn
        L5ExvKv/7JaoEktxRqKhFnNRcSIAf+lgDyEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSvK7+uReJBn82yFp8XfqM1WLah5/M
        FqsXP2Cx6L6+g82i6+4NRoul/96yWNy5/5HFgd3j8hVvj74tqxg9Pm+SC2CO4rJJSc3JLEst
        0rdL4MpofXWcsWA9R8WOzq2MDYwr2boYOTkkBEwkfp1ZC2RzcQgJ7GCUePTwOBNEQlLixM7n
        jBC2sMT9liOsEEXPGCW+/b3LApJgE9CWmPZwN1hCROAyo8Tp/gtQVccZJc72zWLuYuTg4BSw
        lli7Mh6kQVggXGLn91Ngq1kEVCX2zV4PZvMKWEpcWbeXCcIWlDg58wnYAmagBU9vPoWzly18
        zQxxkYLEz6fLWEFsEQEniYOLGpghakQkZne2MU9gFJqFZNQsJKNmIRk1C0nLAkaWVYySqQXF
        uem5xYYFRnmp5XrFibnFpXnpesn5uZsYwTGipbWDcc+qD3qHGJk4GA8xSnAwK4nwStU/SxTi
        TUmsrEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qB6cDJuhXqe6Xu
        cPvlCf/5wKf64V7Wi71nv0rdFfWoKXspaLoz6kVzNFOxloN/wYw06T9adyeEO96S5nuf7yU2
        vfwYn/wGqf12p7U6tkQH/rJrSL2TtY5hl21qrhnL0aijop5/vyy52VkRev/Tykly+0tS9j6Y
        qig913SDBs+cnILXRS4StlVXF8hYLj3Syflgx3WDqTP3ztj6Q+vNyw3vvyxx83fn8sxau311
        4+4m7gemJfUCbYqnF2fNurbqINsPdsuHcdd8uYM3b76Vo/fhVM+tibu/tC1PCPv4ZWu5oNvy
        ft846QlX62fsFm3m8kny2Dwx3Ug0/lPJBRu2SbUThb3eLv2T1qa69n1Wm+3/RUosxRmJhlrM
        RcWJAChq5iEAAwAA
X-CMS-MailID: 20220120025127epcas2p34ef71e7051606df008267df74a31815d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220117103107epcas2p3d7223ff63f6cb575316695cc8fb155a4
References: <CGME20220117103107epcas2p3d7223ff63f6cb575316695cc8fb155a4@epcas2p3.samsung.com>
        <1642415361-140388-1-git-send-email-kwmad.kim@samsung.com>
        <3bb0f5ad-2cea-2509-a9e1-d8ed159bd875@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > =40=40 -8669,6 +8669,7 =40=40 static int ufshcd_set_dev_pwr_mode(struct=
 ufs_hba
> *hba,
> >   			    pwr_mode, ret);
> >   		if (ret > 0 && scsi_sense_valid(&sshdr))
> >   			scsi_print_sense_hdr(sdp, NULL, &sshdr);
> > +		ret =3D -EIO;
> >   	=7D
> >
> >   	if (=21ret)
>=20
> Shouldn't =22ret =3D -EIO=22 only be executed if ret > 0? Additionally, p=
lease
> update the documentation of ufshcd_set_dev_pwr_mode(). I'm referring to
> the following comment: =22Returns non-zero if failed to set the requested
> power mode=22.
>=20
> Thanks,
>=20
> Bart.

scsi_execute returns cmd->result(int type) but I think there is no case tha=
t the valaue is negative
because all values defined for its most significant byte, i.e. driver byte,=
 are smaller than 0x80.
And I understand the 'ret > 0' presents that something wrong happens during=
 the process.

So I'm not sure if 'ret =3D -EIO;' should be executed under 'ret > 0'.

--
=23define DRIVER_BUSY         0x01
=23define DRIVER_SOFT         0x02

And for the comment, I got it.

Thanks
Kiwoong

