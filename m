Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA75DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92ABA64DE7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 08:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhBCIBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 03:01:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40244 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhBCIBi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 03:01:38 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210203080054epoutp016b8745604d3c507054888820cb0c910d~gLgJQwfS60887308873epoutp01r
        for <linux-scsi@vger.kernel.org>; Wed,  3 Feb 2021 08:00:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210203080054epoutp016b8745604d3c507054888820cb0c910d~gLgJQwfS60887308873epoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1612339254;
        bh=iPxmIJa34Eg1hXens4XJ6YI2UvOh6sT2917kFdU+wtc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=oBjfCiBKzR11CBrFSS2BZW0KRTqoqS+Hh+miXTvFewAr6jBmaWtbelWmJ02EQhynx
         LLKwrLxq3MvLzXkXiju4Hl3TEaipm7/Ti6VobPVwQBA0ADx9+t2mQTFdx5YgVeD7op
         sidKJgDJTkRLvaQ6BjVvUVDoBQKxzuUisZJ/MrHc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210203080052epcas1p230e60a0760d405a781057772b46a6dbf~gLgIDTsgP1317213172epcas1p2q;
        Wed,  3 Feb 2021 08:00:52 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.160]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DVvJ172pbz4x9Qc; Wed,  3 Feb
        2021 08:00:49 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.89.09577.1385A106; Wed,  3 Feb 2021 17:00:49 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210203080048epcas1p2436eb909cd11859292796f8e769631ab~gLgD0YjZA1054710547epcas1p2L;
        Wed,  3 Feb 2021 08:00:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210203080048epsmtrp2baca3d7aaa5a2ad388e2ef002edc10fa~gLgDx714i2418924189epsmtrp2_;
        Wed,  3 Feb 2021 08:00:48 +0000 (GMT)
X-AuditID: b6c32a39-c13ff70000002569-27-601a5831af5d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.DF.13470.F285A106; Wed,  3 Feb 2021 17:00:47 +0900 (KST)
Received: from dh0421hwang01 (unknown [10.253.101.58]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210203080047epsmtip2fe614d5ee0b032a6cbaa3dd7649bb29f~gLgDbV6QW2877528775epsmtip2L;
        Wed,  3 Feb 2021 08:00:47 +0000 (GMT)
From:   "DooHyun Hwang" <dh0421.hwang@samsung.com>
To:     "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <asutoshd@codeaurora.org>, <beanhuo@micron.com>,
        <jaegeuk@kernel.org>, <satyat@google.com>
Cc:     <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
        <junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
        <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
        <sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <fb6603bb-f5ae-826f-a303-c5168a06d290@intel.com>
Subject: RE: [PATCH] scsi: ufs: Add total count for each error history
Date:   Wed, 3 Feb 2021 17:00:47 +0900
Message-ID: <000701d6fa02$ae837e20$0b8a7a60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKvIKjW/jinXCYywgW1sWkbkyl50wHTTRXlAYd95o6oeumREA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xbVRzOuW1vC6R6KQWPFYVdFxcaKS1d4UCAOZzj+lqIbMuCMaXQa0H6
        si1mPmKmPOSxMdwGSgcKDAHpkjoGpeAQ7JLxkEQFGcMoAwZbeDpA6BiC9sEi/32/73y/8/2+
        c/LjMHibuICTpTXRBq1CTeK+TNv1MFG45IQgTXyhIgr1T1/G0cRXNhx1FfSx0ezGCI5+nCxi
        ohVrAwt9OVDAQg+3rGw0bTUzUGHbeQzV3bJhyH5vkI06t3IxNNxZhaOSUTuOGnu3MXTW8ieO
        Pv3nBya6OdjHQt+0jQF0dWid+UIgNVx6BqNqWnKoS9dmMaqluQinyup6AJXX382knNZCnFqe
        +Z1JlbY2A2q15Rnqs54SLNkvVR2XSSuUtCGU1mbolFlaVTz5aor8RbksSiwJl8SgaDJUq9DQ
        8eSh15LDD2epXUnJ0PcU6hwXlawwGsmIhDiDLsdEh2bqjKZ4ktYr1XqJWC8yKjTGHK1KlKHT
        xErE4kiZS5mmztywfKxvDTx5rbIanAJX/IuBDwcS+2FtUzuzGPhyeIQdwK7b27i3WAHwzmo/
        063iEesAlvclPeoYdjQAr6gLwCu2/J1iHsC5u+3ArcIJMTx/Y8FzFZ9YwGBH7iLbXTCIUQA3
        xv/G3CofIh5uLK2w3DiAOAxrOko9fkxiL6xYf+jBXCIGLg8Xs7zYH/ZXTnt4BhEC2xerGN6Z
        QuHGTAPLy/PhxaICD88nEmHbnVrMbQwJiw+0DVTi3oZDsKxpfAcHwLneVrYXC+DqUtcOXwLg
        WUeCt7kMwOHe0zsHUriyuurKyXG5hUFrZ4SX3gM7NquBd4jH4NLaaZZbAgkuLCzgeSXPwUvb
        TpeE7cLB8BO/MkCadwUz7wpm3hXG/L9VDWA2gyBab9SoaKNEL9v92S3AswXCGDv4YvG+yAEw
        DnAAyGGQfO7AuaA0HlepeP8D2qCTG3LUtNEBZK6n/pwhCMzQudZIa5JLZJFSqRTtj4qOkknJ
        J7jp4gk5j1ApTHQ2Tetpw6M+jOMjOIVJX5k6piqKSdAk1I/V/6IUHeirlj346Bg/feiqYCpJ
        9XjXGf/Um29F2oV6vDbEqboct5jf2k74kc6ZzIPHmxtt35970/Ls8+R43Wz6QvKRi3smOyPN
        5Tf0SRX7Rkbvs5rGntLrY1uihIR82yc74JbFmbJvTvhb/ktHTaUptuCRkDeWUsGvWX8Jv8uL
        +Lk0Nj3Vr29qyNJt53c7vv2w+PV/EwjFliC/cZL1oIlzpLEcCO4qLdLp5cRKLWwTPb3dYwpe
        nKPWzG9PjLYO/nS7qm4027757vwfIe+cWFsvcdY/+bJv8QV8bfzrxHvcgyVB18tzww5YZSc1
        GfNHo9W6vfV5x9NJpjFTIREyDEbFfzqQVgCOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsWy7bCSvK5BhFSCwTYDi5NP1rBZPJi3jc1i
        b9sJdouXP6+yWRx82Mli8Wn9MlaLGafaWC1+/V3PbvFk/Sxmi46tk5ksFt3YxmSx4/kZdotd
        f5uZLC7vmsNm0X19B5vF8uP/mCz6V99ls2j6s4/F4tqZE6wWS7feZLTYfOkbi4Oox+W+XiaP
        BZtKPRbvecnksWlVJ5vHhEUHGD1aTu5n8fi+voPN4+PTWywefVtWMXp83iTn0X6gmymAO4rL
        JiU1J7MstUjfLoEr4+fquoItohV7Zs5lbGDcKNjFyMkhIWAicfnQMsYuRi4OIYHdjBI7t35m
        h0jISHTf3wtkcwDZwhKHDxeDhIUEXgLVbBEHsdkEDCQmH3vDBtIrIvCLSWL70dlgDrPAfUaJ
        RdumskNMPcAocf/UCmaQFk4BW4mf7z6xgtjCAm4SC3b2sYDYLAIqEtO+/QKzeQUsJT5e7mKF
        sAUlTs58AhZnFtCWeHrzKZQtL7H97RxmiEsVJH4+XcYKEReRmN3ZBhYXEXCS2Pp4IdMERuFZ
        SEbNQjJqFpJRs5C0L2BkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJEZwStDR3MG5f
        9UHvECMTB+MhRgkOZiUR3lOTxBKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKa
        nZpakFoEk2Xi4JRqYAor6sxUfHPqWq6W+q/MuX33Hij+zb+7odvUNOFvaufrF+nlSz2dDPS6
        Zgt9eGQmVqS08rHDmaPVfrM0mo7aH1uSemWLg9Sl86KK372v9U8pqd/ytXRNubXkoz17zfu/
        nls3eWq8zvHdPTMu9XFM7PmpaPMt4d5051071m3W3/3qzFsFAZPDGVOVv696MvnN97spbevu
        952+eXFad+fRqflTLyxh/KkRWaPJrKd357DlZ3ND9U8uf1m/bn95XrHuXCz3nWeFG2ZOX5Li
        yP/J5Tn/j6linbsDZzTsd/qs7TPz/WbhwAc1otduHwnpXewvLGbR/r3jaA+zueGKo+25P4Im
        uLcl3U2QfHTPf83V+Re2K7EUZyQaajEXFScCAA9bP6h4AwAA
X-CMS-MailID: 20210203080048epcas1p2436eb909cd11859292796f8e769631ab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de
References: <CGME20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de@epcas1p2.samsung.com>
        <20210203065346.26606-1-dh0421.hwang@samsung.com>
        <fb6603bb-f5ae-826f-a303-c5168a06d290@intel.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

Thank you for your review and I found the below commit in linux-next.
So, I'll reject this patch.

>On 3/02/21 8:53 am, DooHyun Hwang wrote:
>> Since the total error history count is unknown because the error
>> history records only the number of UFS_EVENT_HIST_LENGTH, add a member
>> to count each error history.
>>
>> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
>
>Hi
>
>Please note that the following patch is already queued - see linux-next
>
>
>commit b6cacaf2044fd9b82e5ceac88d8d17e04a01982f
>Author: Adrian Hunter <adrian.hunter@intel.com>
>Date:   Thu Jan 7 09:25:38 2021 +0200
>
>    scsi: ufs: ufs-debugfs: Add error counters
>
>    People testing have a need to know how many errors might be occurring
>over
>    time. Add error counters and expose them via debugfs.
>
>    A module initcall is used to create a debugfs root directory for
>    ufshcd-related items. In the case that modules are built-in, then
>    initialization is done in link order, so move ufshcd-core to the top of
>the
>    Makefile.
>
>    Link: https://lore.kernel.org/r/20210107072538.21782-1-
>adrian.hunter@intel.com
>    Reviewed-by: Avri Altman <avri.altman@wdc.com>
>    Reviewed-by: Bean Huo <beanhuo@micron.com>
>    Reviewed-by: Can Guo <cang@codeaurora.org>
>    Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 3 +++
>>  drivers/scsi/ufs/ufshcd.h | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index fb32d122f2e3..7ebc892553fc 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -437,6 +437,8 @@ static void ufshcd_print_evt(struct ufs_hba *hba,
>> u32 id,
>>
>>  	if (!found)
>>  		dev_err(hba->dev, "No record of %s\n", err_name);
>> +	else
>> +		dev_err(hba->dev, "%s: total count=%u\n", err_name, e->count);
>>  }
>>
>>  static void ufshcd_print_evt_hist(struct ufs_hba *hba) @@ -4544,6
>> +4546,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32
>val)
>>  	e->val[e->pos] = val;
>>  	e->tstamp[e->pos] = ktime_get();
>>  	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
>> +	e->count++;
>>
>>  	ufshcd_vops_event_notify(hba, id, &val);  } diff --git
>> a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
>> aa9ea3552323..df28d3fc89a5 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -450,6 +450,7 @@ struct ufs_event_hist {
>>  	int pos;
>>  	u32 val[UFS_EVENT_HIST_LENGTH];
>>  	ktime_t tstamp[UFS_EVENT_HIST_LENGTH];
>> +	u32 count;
>>  };
>>
>>  /**
>>


