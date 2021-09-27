Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11F1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 11:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65E860F91
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 11:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhI0LKQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 07:10:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40608 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbhI0LKO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 07:10:14 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210927110834epoutp01e1e9ac4e4235d5811810ae123d55d4b4~oqTYOZh4q2189321893epoutp01e
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 11:08:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210927110834epoutp01e1e9ac4e4235d5811810ae123d55d4b4~oqTYOZh4q2189321893epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632740914;
        bh=XmdlFFuFvpa9s+Mge1Gbifkq07nJ6/8AP1mNRFsmF7M=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ZNCbxMWcKnMlEiIDf0Q4at04eFYEVoMbw3k+MlLj4rQCMS1TkNKerrk5GajcJehjz
         Fc1MZ09byPmRNgqZHcMdYpKvBRAkMIQJ2aZNcVoF917djuKJKclNg7VTcedGPurQoz
         DJg/9Ov7XeWEx2lrTNmW2fwJESKoVUce6r802mZY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210927110833epcas2p4e0910d0d041148c9eaa0e41473275aa9~oqTXrBAZr2976029760epcas2p4Q;
        Mon, 27 Sep 2021 11:08:33 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HJ0Hh0LFDz4x9QG; Mon, 27 Sep
        2021 11:08:32 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.94.09816.F26A1516; Mon, 27 Sep 2021 20:08:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210927110831epcas2p1089e07008f8a7b4e9645ba46e46928af~oqTVSv4bD2180921809epcas2p1m;
        Mon, 27 Sep 2021 11:08:31 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210927110831epsmtrp212638f5a49e899d3757683e047beb77e~oqTVRxNGz0652306523epsmtrp2P;
        Mon, 27 Sep 2021 11:08:31 +0000 (GMT)
X-AuditID: b6c32a46-63bff70000002658-26-6151a62ff940
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        75.E3.08750.F26A1516; Mon, 27 Sep 2021 20:08:31 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210927110831epsmtip149eae1aae7fe4a3e3ec97fd0be13afc5~oqTVDN5wy1970819708epsmtip1a;
        Mon, 27 Sep 2021 11:08:31 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Inki Dae'" <inki.dae@samsung.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <cpgs@samsung.com>
In-Reply-To: <1891546521.01632738482290.JavaMail.epsvc@epcpadp4>
Subject: RE: [PATCH v3 03/17] scsi: ufs: ufs-exynos: change pclk available
 max value
Date:   Mon, 27 Sep 2021 20:08:31 +0900
Message-ID: <00f401d7b390$017ed1f0$047c75d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQFpqUVjAcLaBWECfhBmbAGusc59AbIkwGipxx4jQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJsWRmVeSWpSXmKPExsWy7bCmua7+ssBEg+nrrS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWrw8pGnRs9PZ4vSERUwWk+5PYLF4sn4Ws8WiG9uYLDa+
        /cFkMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBOVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JKSQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEn416baMFNrop106waGK9zdDFyckgImEhs
        f3+YtYuRi0NIYAejxM6/T5ghnE+MEv/PTWKBcD4zSryevoUZpuVD6zJGiMQuRonn0zZBVb1g
        lDj5YxNYFZuAvsTLjm1gg0UEljFJrOz9BuYwCzQwS7xbspYFpIpTwEHiTNNOMFtYIExizfSF
        TCA2i4CqxJbd3YwgNq+ApcTMlu2sELagxMmZT8DqmQW0JZYtfA11k4LEz6fLwGpEgOZs3Taf
        DaJGRGJ2ZxvYRxICzZwS7ff2MUI0uEg0Tl3BBmELS7w6voUdwpaS+PxuLxtEQzejROuj/1CJ
        1YwSnY0+ELa9xK/pW4C2cQBt0JRYv0sfxJQQUJY4cosFooJXomHjb3aIG/gkOg7/ZYco4ZXo
        aBOCKFGXOLB9OssERuVZSD6bheSzWUg+mIWwawEjyypGsdSC4tz01GKjAiPk2N7ECE7vWm47
        GKe8/aB3iJGJg/EQowQHs5IIbzCLf6IQb0piZVVqUX58UWlOavEhRlNgWE9klhJNzgdmmLyS
        eENTIzMzA0tTC1MzIwslcd65/5wShQTSE0tSs1NTC1KLYPqYODilGpiMSrn/+Z7x29n6fGWx
        iqyjfoy09JMl63pb3DT4tMukSv+6GbOzMz+7u7RcYMHOi3aplQoG6U7eS5cFPF/NWNw9faqB
        7m9VvROeomt+rn8nG75B6M3tBf9zZeQLVkStUYxlM+7Zfv78woh1j/nuzan3vpzOOue5wvbG
        73c4F92uW+U49aF61Wc9WX67B3cn3VncX8ytvY5nX4F921nXZ1dNvnM6PkjO+jovaIvnDoeX
        aeI2k5Y/8HbZf96lb4ZqYafMHt0pNlEXZe5suKvXs7BNZ/ee2Sc/qDv6bl7V0fFdRq18f9uB
        Hqt9F9/tEzd0l95yzVrzSGa51HfXs8Jzz1eKT+g82OPYkTC79ujb8/ZKLMUZiYZazEXFiQBP
        73D6eAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7bCSnK7+ssBEg0uXBS1OPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWrw8pGnRs9PZ4vSERUwWk+5PYLF4sn4Ws8WiG9uYLDa+
        /cFkMeP8PiaL7us72CyWH//H5CDgcfmKt8eshl42j8t9vUwem1doeSze85LJY9OqTjaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBPFZZOSmpNZllqkb5fAlfHxcTN7wU2uis+L
        FrE3MJ7n6GLk5JAQMJH40LqMsYuRi0NIYAejRN/6xYwQCVmJZ+92sEPYwhL3W46wQhQ9Y5Q4
        s38+C0iCTUBf4mXHNrCEiMAKJolTkzezgDjMAh3MEqc/nGGDaLnFJPH06HKwuZwCDhJnmnaC
        tQsLhEicWX4GbAeLgKrElt3dYDW8ApYSM1u2s0LYghInZz4Bq2cW0JZ4evMpnL1s4WtmiPsU
        JH4+XQZWLyIQJrF123w2iBoRidmdbcwTGIVnIRk1C8moWUhGzULSsoCRZRWjZGpBcW56brFh
        gVFearlecWJucWleul5yfu4mRnC0a2ntYNyz6oPeIUYmDsZDjBIczEoivMEs/olCvCmJlVWp
        RfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MNVreTetFbj51a3vWKQ7
        QzFHTZgRc1WizJSlLImq5i0OkXppssqrwpOv7kw/xBrf+v/zyQUyQazyvO6/uRdua7qw5+yp
        8jNJijVWO2/tK17KXKc0QbvJRLrsmO7mZd++OlTeqn3h2FxqxHaF/Zwyp3Tj58AaNt8FNsc9
        p7/MWfjx65U1Xyeyv525lEOL9/fHXU3VbtFNDV4qoj5XFR/NdVtU4C4kv8LZseRZVdmUvfqX
        v3+tUE5zyXQ93bZKlpUrTCvILTvkwNFHtbM1OeSCuJYm9BourY4QEBI4c01RdMFi0y7RSb9u
        L5I0bZq3w/Hcb0/pPSdalE+fat7j+Ixl1wm7Q9WC01t2hNg0yPUpsRRnJBpqMRcVJwIAyMYh
        VWUDAAA=
X-CMS-MailID: 20210927110831epcas2p1089e07008f8a7b4e9645ba46e46928af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065522epcas2p26f56b37c3f7505b9d0e34bc2162fdbbd@epcas2p2.samsung.com>
        <20210917065436.145629-4-chanho61.park@samsung.com>
        <878274034.81632720182984.JavaMail.epsvc@epcpadp4>
        <000001d7b36b$5a8817e0$0f9847a0$@samsung.com>
        <1891546521.01632738482290.JavaMail.epsvc@epcpadp4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >>>  =23define PCLK_AVAIL_MIN	70000000
> >>> -=23define PCLK_AVAIL_MAX	133000000
> >>> +=23define PCLK_AVAIL_MAX	167000000
> >>>
> >>
> >> I'm not sure but doesn't the maximum clock frequency depend on a
> >> given machine? Is it true for all machines using different SoC?
> >
> > Regarding pclk(sclk_unipro)of the ufs, it can be defined by
> mux(MUX_CLK_FSYS2_UFS_EMBD).
> > It can be either 167MHz or 160MHz. And it can be defined by OSCCLK(26MH=
z)
> as well. The value was up to 133Mhz in case of exynos7 but can be extende=
d
> up to 167MHz for later SoCs, AFAIK.
>=20
> Oscillator clock frequency could be different according to machine. And
> what if UFS driver is enabled for other machine using Exynos7? Is it true
> to use a fixed 167MHz frequency for these machines?
> I think you could get a proper pclk frequency from device tree specific t=
o
> machine.

The actual pclk value will be get by CCF's clk_get_rate. PCLK_AVAIL_MAX rep=
resents the available maximum value of UFS's pclk to find an optimal value =
of unipro clock. I just extend the maximum pclk rate from 133MHz to 167MHz.=
 The divider will be calculated according to the actual pclk value :)

=5B1=5D: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/tree/drivers/scsi/ufs/ufs-exynos.c?h=3Dv5.15-rc3=23n287

Best Regards,
Chanho Park

