Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49480C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 04:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244853AbiDAEcp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 00:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiDAEcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 00:32:43 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37CF1FF431
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 21:30:50 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220401043044epoutp02a995f042bef74302091dfd58385fb417~hq3HeOBub1184011840epoutp02K
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 04:30:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220401043044epoutp02a995f042bef74302091dfd58385fb417~hq3HeOBub1184011840epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648787444;
        bh=SXTi4A4CoFkQz7hG9lvVwdZNoaj7sgzPOl+KK2jMb6I=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=f6QQmoEu9qzDeSl6iZPjENmGxf6nBVfkRSR2uWGg5veO0WgZ5+Xid/zizCc8wI2sF
         T+SB4kSfMrzVbSFtrK2tsUKbK997XyD25q/mmSr46cF8SB83ojg78dkpURKOa2yYdK
         TXSmUEtuBmXQ7CkdgnFXULqVEYjUIpORqEiOweNo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20220401043043epcas2p4aba6762bee1a1079c9860c87283827c7~hq3G0uAeF0293902939epcas2p4f;
        Fri,  1 Apr 2022 04:30:43 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KV6fn5Q55z4x9QM; Fri,  1 Apr
        2022 04:30:41 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.68.25540.1FF76426; Fri,  1 Apr 2022 13:30:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20220401043040epcas2p3e3c164687877ea290bd8c8ef31b03955~hq3Easjuy0791007910epcas2p3u;
        Fri,  1 Apr 2022 04:30:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220401043040epsmtrp1891af65be80b2c513827feb9a58b22f2~hq3EZnBDg0997609976epsmtrp1J;
        Fri,  1 Apr 2022 04:30:40 +0000 (GMT)
X-AuditID: b6c32a47-81bff700000063c4-c3-62467ff11c72
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.E6.24342.0FF76426; Fri,  1 Apr 2022 13:30:40 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220401043040epsmtip1a04165bed62851fa49e2c7f30055055f~hq3EMgubb0382403824epsmtip1W;
        Fri,  1 Apr 2022 04:30:40 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Daejun Park'" <daejun7.park@samsung.com>,
        "'Guenter Roeck'" <linux@roeck-us.net>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Keoseong Park'" <keosung.park@samsung.com>,
        "'Mike Snitzer'" <snitzer@redhat.com>,
        "'Eric Biggers'" <ebiggers@google.com>,
        "'Jens Axboe'" <axboe@kernel.dk>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>
In-Reply-To: <91fb8b36-b3dd-c68b-5d08-49928c1e6d27@acm.org>
Subject: RE: [PATCH 26/29] scsi: ufs: Split the ufshcd.h header file
Date:   Fri, 1 Apr 2022 13:30:40 +0900
Message-ID: <00ef01d84581$3e65db30$bb319190$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEkvIO8WDCMeleYLL46gzQacByZhQJUTo2RAiEKkqMCQmOkQQGrW4twrf5wCmA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJsWRmVeSWpSXmKPExsWy7bCmqe7Herckg6UdPBYnn6xhs3j58yqb
        xeq7/WwWBx92slhM+/CT2WLVg3CLi6tbWC2erJ/FbLHoxjYmi+Mn3zFadF/fwWbxZOEZJovl
        x/8xWbRt/MpocXxtuAO/x+Ur3h4LNpV6LN7zksnj8tlSj02rOtk87lzbw+YxYdEBRo/v6zvY
        PD4+vcXi8X7fVTaPnd8b2D36tqxi9Pi8Sc6j/UA3UwBfVLZNRmpiSmqRQmpecn5KZl66rZJ3
        cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBbSgpliTmlQKGAxOJiJX07m6L80pJUhYz8
        4hJbpdSClJwC8wK94sTc4tK8dL281BIrQwMDI1OgwoTsjGk3DrMUTBKt6NmyhKWB8bBAFyMn
        h4SAicSdcwsZuxi5OIQEdjBKLL52B8r5xCjRc+w9M4TzjVHi65lGdpiWXx+PM4PYQgJ7GSUa
        jvpBFL1glDhw+hkLSIJNQF/iZcc21i5GDg4RgRSJ/Q8kQWqYBaazSJzt+wU2iFPAWuL6p2aw
        GmEBF4nTTytAwiwCKhIXZj0Dm88rYCnx/8trFghbUOLkzCdgNrOAvMT2t3OYIe5RkPj5dBkr
        iC0i4CfxcfcLqBoRidmdbWAPSAj0c0o0Nl9lgWhwkWjrPsYEYQtLvDq+BeoxKYmX/W1QdrHE
        0lmfmCCaGxglLm/7xQaRMJaY9aydEeRoZgFNifW79EFMCQFliSO3oPbySXQc/ssOEeaV6GgT
        gmhUlziwfTrUBbIS3XM+s05gVJqF5LNZSD6bheSDWQi7FjCyrGIUSy0ozk1PLTYqMIbHdXJ+
        7iZGcILXct/BOOPtB71DjEwcjIcYJTiYlUR4r8a6JgnxpiRWVqUW5ccXleakFh9iNAWG9URm
        KdHkfGCOySuJNzSxNDAxMzM0NzI1MFcS5/VK2ZAoJJCeWJKanZpakFoE08fEwSnVwKRXGe0R
        xiryi8dLPEb16nad27HfdhgG7BTuOvwyXLB0Pa98+9atzNyddZMC8oVmf/nUECeiyrCkbVmI
        e/3czeWh+66pnWoMuXtCcdHn1WktN4/sFZGR/JmgG/vOMOHk1ysnOLN2/15g9Crs5Ynan7o8
        Lkks82zU/zMltzw/tHDjwlfPJObml36Utln2SGRy+LYH0xfEFDJx5agd5cz3OSvYEWbwWvxx
        9JlJ/gcz9T13hjIHcs3jvDmXS3fx6gsc1vdEsv/l1AQIlQVnuU08U/lRW5lv0aogl0A2qaKj
        O83PLGZ9ydEmGGRvZRAzL6jkxtEpm2d3MTMtbFYQOr5nMuebjrm31Y/90VRUbDukqcRSnJFo
        qMVcVJwIAPgaJSN5BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWy7bCSnO6Herckgw2f9C1OPlnDZvHy51U2
        i9V3+9ksDj7sZLGY9uEns8WqB+EWF1e3sFo8WT+L2WLRjW1MFsdPvmO06L6+g83iycIzTBbL
        j/9jsmjb+JXR4vjacAd+j8tXvD0WbCr1WLznJZPH5bOlHptWdbJ53Lm2h81jwqIDjB7f13ew
        eXx8eovF4/2+q2weO783sHv0bVnF6PF5k5xH+4FupgC+KC6blNSczLLUIn27BK6MaTcOsxRM
        Eq3o2bKEpYHxsEAXIyeHhICJxK+Px5m7GLk4hAR2M0o879jGCJGQlXj2bgc7hC0scb/lCCtE
        0TNGiU9nvzGDJNgE9CVedmxjBbFFBFIkZiz4yA5SxCywkEVi8sRmFoiO6UwS/dcOgI3lFLCW
        uP6pGaiDg0NYwEXi9NMKkDCLgIrEhVnPwIbyClhK/P/ymgXCFpQ4OfMJmM0soC3x9OZTKFte
        YvvbOcwQ1ylI/Hy6DOoIP4mPu19A1YhIzO5sY57AKDwLyahZSEbNQjJqFpKWBYwsqxglUwuK
        c9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgiNeS3MH4/ZVH/QOMTJxMB5ilOBgVhLhvRrrmiTE
        m5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD017Ne3f1Vpl9
        l3VkTzu72eeS+rzrEwunHdO9xDxHP2udzYroXnkVMbmfwb8EN4Su2SXukl6R6fXKNTh+9/89
        omfkRZ31Dt+9/iIu4kFWXK3TjfD7UVF7AhL+3vowi5ktcsaBcpWsrZuym9aZr9vSMn3iMQFf
        038WOtqWJT0XX6/W2/ksbN2Pwx0qEgGxpg/DtlY8WjH3/JTXuXtsuDbbC00pf19juGVpxLbW
        XXeOhHyLlsraefyo3cVNn1eeajxQ92zS/sqVDVw6ZYejjl+vjzYO6W/i1kv9tFjBdEXLND21
        StkNB8X4r6+9NvXaXvZwW6+5R87FPsyZ5raUfwnz1YNb5v+YmbnnpJq7nJCLS6ISS3FGoqEW
        c1FxIgB71WrYZwMAAA==
X-CMS-MailID: 20220401043040epcas2p3e3c164687877ea290bd8c8ef31b03955
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220331224010epcas2p33104ab9dbf6df0d885f1cc2b31d07d12
References: <20220331223424.1054715-1-bvanassche@acm.org>
        <CGME20220331224010epcas2p33104ab9dbf6df0d885f1cc2b31d07d12@epcas2p3.samsung.com>
        <20220331223424.1054715-27-bvanassche@acm.org>
        <002201d8455e$67b46e70$371d4b50$@samsung.com>
        <91fb8b36-b3dd-c68b-5d08-49928c1e6d27@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > I'm seeing below build error when I applied this patch. Any baseline
> > do I need?
> >
> > In file included from drivers/scsi/ufs/ufs-sysfs.c:9:
> > drivers/scsi/ufs/ufshcd-priv.h:32:20: error: redefinition of
> > 'ufs_hwmon_probe'
> >     32 | static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
> {}
> >        |                    ^~~~~~~~~~~~~~~
> > In file included from drivers/scsi/ufs/ufshcd-priv.h:5,
> >                   from drivers/scsi/ufs/ufs-sysfs.c:9:
> > drivers/scsi/ufs/ufshcd.h:1079:20: note: previous definition of
> > 'ufs_hwmon_probe' with type 'void(struct ufs_hba *, u8)' {aka
> > 'void(struct ufs_hba *, unsigned char)'}
> >   1079 | static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
> {}
> >        |                    ^~~~~~~~~~~~~~~
> > In file included from drivers/scsi/ufs/ufs-sysfs.c:9:
> > drivers/scsi/ufs/ufshcd-priv.h:33:20: error: redefinition of
> > 'ufs_hwmon_remove'
> >     33 | static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
> >        |                    ^~~~~~~~~~~~~~~~
> > In file included from drivers/scsi/ufs/ufshcd-priv.h:5,
> >                   from drivers/scsi/ufs/ufs-sysfs.c:9:
> > drivers/scsi/ufs/ufshcd.h:1080:20: note: previous definition of
> > 'ufs_hwmon_remove' with type 'void(struct ufs_hba *)'
> >   1080 | static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
> >        |                    ^~~~~~~~~~~~~~~~
> 
> Hi Chanho,
> 
> Patch 26/29 duplicates the ufs_hwmon_remove() etc. definitions instead of
> moving these. The patch below needs to be applied on top of this patch to
> make it build. I will fix this when I repost this patch series.

Below can fix the build errors. Thanks for the update.

Best Regards,
Chanho Park

> 
> Thanks,
> 
> Bart.
> 
> diff --git a/include/scsi/ufshcd.h b/include/scsi/ufshcd.h index
> 946d915f5a42..3caec295d87a 100644
> --- a/include/scsi/ufshcd.h
> +++ b/include/scsi/ufshcd.h
> @@ -1071,16 +1071,6 @@ static inline void *ufshcd_get_variant(struct
> ufs_hba *hba)
>   	return hba->priv;
>   }
> 
> -#ifdef CONFIG_SCSI_UFS_HWMON
> -void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask); -void
> ufs_hwmon_remove(struct ufs_hba *hba); -void ufs_hwmon_notify_event(struct
> ufs_hba *hba, u8 ee_mask); -#else -static inline void
> ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {} -static inline void
> ufs_hwmon_remove(struct ufs_hba *hba) {} -static inline void
> ufs_hwmon_notify_event(struct ufs_hba *hba, u8
> ee_mask) {}
> -#endif
> -
>   #ifdef CONFIG_PM
>   extern int ufshcd_runtime_suspend(struct device *dev);
>   extern int ufshcd_runtime_resume(struct device *dev);

