Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	CHARSET_FARAWAY_HEADER,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B28ECC47083
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8467860FF2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFCDXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:23:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42660 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhFCDXf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 23:23:35 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210603032149epoutp03ae0e08421f033ca36e8494d50ec3f615~E9GvUBIKS1358313583epoutp033
        for <linux-scsi@vger.kernel.org>; Thu,  3 Jun 2021 03:21:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210603032149epoutp03ae0e08421f033ca36e8494d50ec3f615~E9GvUBIKS1358313583epoutp033
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622690509;
        bh=xfQdp7ENFf82HbCO6D4eu9F+lquLlW/Lgs0PAWtVh/o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=gs+Tk9AZOhn1rUW/AhHpcr9AmHrNCytqWSuyP1OyoTRlMUN5XdaZ1lJUFLg2zmnlI
         kCaKQWjUS/5YmIVq2HSm2U4UITfhfdAsP9y1YThVBVGKR0wpl8o/LQkRfoT6Mwhbv3
         2qaGHwAERoZHC2QQ4xxbL3mghDynEYooDAup86vQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210603032148epcas2p2071da659da39875669d95a428266c405~E9GupOrRA3169231692epcas2p2J;
        Thu,  3 Jun 2021 03:21:48 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.190]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4FwWQf4KsXz4x9Pw; Thu,  3 Jun
        2021 03:21:46 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.47.09433.ACA48B06; Thu,  3 Jun 2021 12:21:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210603032146epcas2p1e41a262effe24ac53064896e1fa60926~E9Gr2lnKS1506015060epcas2p1_;
        Thu,  3 Jun 2021 03:21:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210603032145epsmtrp12886b533f405f7256da7afd7dbd59978~E9Gr15aRj2254622546epsmtrp1I;
        Thu,  3 Jun 2021 03:21:45 +0000 (GMT)
X-AuditID: b6c32a47-f4bff700000024d9-56-60b84aca7e79
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AC.29.08163.9CA48B06; Thu,  3 Jun 2021 12:21:45 +0900 (KST)
Received: from KORDO039821 (unknown [10.229.8.133]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210603032145epsmtip2ea3929570f42d1c5df521f57856f1ad6~E9GrknrtG1856818568epsmtip2Q;
        Thu,  3 Jun 2021 03:21:45 +0000 (GMT)
From:   =?ks_c_5601-1987?B?waTBvrnO?= <jjmin.jeong@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <a31867eaf47a298baeec714f29e9cafe@codeaurora.org>
Subject: RE: [PATCH 3/3] scsi: ufs: add quirk to support host reset only
Date:   Thu, 3 Jun 2021 12:21:45 +0900
Message-ID: <000101d75827$94eb33d0$bec19b70$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIoW8PMwO5SDtoUto4XDMUWk4sZmgJIuCXRATb+sNsButkn1Ko1wOaw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmqe4prx0JBldWyFucfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Xi0/plrBaLbmxjsri8aw6bRff1HWwWy4//Y3Lg9Ljc18vksXjPSyaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBGVY5ORmpiSWqSQmpecn5KZl26r5B0c7xxv
        amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdJ+SQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYp
        tSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEnY/m3VqaCueIVjY/msDQwbhXqYuTkkBAw
        kVj84QhjFyMXh5DADkaJts1n2SGcT4wSvbtnQTmfGSW+rFzOCNMyf9ZyJojELkaJ5aemQjkv
        GCXWL/rMDFLFJmArseXwIyYQW0RAVeJd63k2EJtZ4C6jxOE7LCA2p4CdxPSnh4BqODiEBTwk
        zu72BAmzCKhIvD38C6yEV8BSounAPzYIW1Di5MwnLBBjjCSWrJ7PBGHLS2x/O4cZ4jgFiZ9P
        l7FCrHWTWPn6ANRaEYnZnW3MIHdKCBzgkDgx6zoTRIOLxKXWu1CfCUu8Or6FHcKWknjZ3wZl
        10vsbtgD1TyBUaK78yoLRMJe4tf0LawgD0gIKEscuQV1HJ9Ex+G/7BBhXomONmhYq0psWbwR
        apW0xNK1x1kmMCrNQvLaLCSvzULy2iwkLyxgZFnFKJZaUJybnlpsVGCMHN2bGMGpV8t9B+OM
        tx/0DjEycTAeYpTgYFYS4d2jtiNBiDclsbIqtSg/vqg0J7X4EKMpMLQnMkuJJucDk39eSbyh
        qZGZmYGlqYWpmZGFkjjvz9S6BCGB9MSS1OzU1ILUIpg+Jg5OqQamxh9fVTWXF5/hcju81O1q
        7PKK5JnMWm/Cv6a/5JJwSuovCV4YxGG6Yj5jgEHkw7ciijtuXan9d/zD3eAvW/8zv3scss62
        wEf9wFk36bKEuEUf9Bctm7E6s6nP6Vsfe6fQvg1v5t69dlCh4EDLSnfJGWecGIRjQtnOZG0t
        8g7NOvdil+DHLRffVM55+GjHfWZxa66pR/PPx63ZMOu2W8np31ZBilkVd38a/9n7Zs7cCc5T
        xf833f6eznK4NHDrzU97fOruWrOH1fLP1Pm8/5P7xjc8Yfc3HNgtto5vC+/5fcIvuS+fz61p
        tGuaEz1ruffExVJpUkoc2bOXTk+b8/W6+pf+/ldfrmz+eCk11HEZa6ISS3FGoqEWc1FxIgDJ
        MkJvRgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWy7bCSvO5Jrx0JBntnGFmcfLKGzeLBvG1s
        Fi9/XmWzOPiwk8Xi0/plrBaLbmxjsri8aw6bRff1HWwWy4//Y3Lg9Ljc18vksXjPSyaPCYsO
        MHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOSmpNZllqkb5fAlbH8WytTwVzxisZH
        c1gaGLcKdTFyckgImEjMn7WcqYuRi0NIYAejxKIJ19m6GDmAEtISa/ZIQ9QIS9xvOcIKUfOM
        UeLs7SOMIAk2AVuJLYcfMYHYIgKqEu9az7OBFDELPGWUWPy4jwWi4yOQ09/FClLFKWAnMf3p
        ISaQDcICHhJnd3uChFkEVCTeHv7FAmLzClhKNB34xwZhC0qcnPkELM4MdGnj4W4oW15i+9s5
        zBDXKUj8fLqMFeIIN4mVrw+wQdSISMzubGOewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPT
        c4sNC4zyUsv1ihNzi0vz0vWS83M3MYIjUEtrB+OeVR/0DjEycTAeYpTgYFYS4d2jtiNBiDcl
        sbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBib5ezVC5ffNONbv
        49g1//S+tyLv+9QfRDWsP/bu5G2jN3wX0+aHTCm/V8Y/b6Hxzsj6i9eFokP3vj4uVvHleUzU
        hIxdCgedFHz/KzJN54p3Wq5SNLNz3uGzTZXfM//NCZ3adCav7x376nOTjW1ObspevSj1qfIb
        tbe261cry875sknlnsz1fe6Pd5ywvdTTdvX0HJGSwj0CpZs4OxMutttNC6o8+pbh/+vM91vy
        ur/ZF/uo6Chk//gfkDahYtfcPcrTHgloGsXk+Sa910rbrLCz0SfXaqJDie+MOS/OTp0w+W+H
        +Ndvr35vnZQWoRqoqyS3XaKKIXXJ4riyW5E1WjkWNVbCtx79+bjxoNbdaIs3SizFGYmGWsxF
        xYkAcymPoC8DAAA=
X-CMS-MailID: 20210603032146epcas2p1e41a262effe24ac53064896e1fa60926
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
        <CGME20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0@epcas2p4.samsung.com>
        <20210527030901.88403-4-jjmin.jeong@samsung.com>
        <a31867eaf47a298baeec714f29e9cafe@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> > samsung ExynosAuto SoC has two types of host controller interface to
> > support the virtualization of UFS Device.
> > One is the physical host(PH) that the same as conventaional UFSHCI,
> > and the other is the virtual host(VH) that support data transfer
> > function only.
> >
> > In this structure, the virtual host does support host reset handler
> > only.
> > This patch calls the host reset handler when abort or device reset
> > handler has occured in the virtual host.
> 
> One more question, as per the plot in the cover letter, the VH does
> support TMRs.
> Why are you trying to make ufshcd_abort() and
> ufshcd_eh_device_reset_handler()
> no-ops?
> 
> Thanks,
> 
> Can Guo.


Can, 
Thanks for your review.
Yes, you are right about ufshcd_abort.
it would be better to call if it fails abort handling has failed.
I will apply this modification to the next patch.

device reset handler case is a little different. We do not want the virtual
host to do device reset(LUN reset).

According to our virtualization architecture, virtual OSs can share LUNs.
Therefore, we are trying to prevent the reset for LUN in guest OS.

> >
> > Change-Id: I3f07e772415a35fe1e7374e02b3c37ef0bf5660d
> > Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 7 +++++++  drivers/scsi/ufs/ufshcd.h | 6
> > ++++++
> >  2 files changed, 13 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 4787e40c6a2d..9d1912290f87 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6826,6 +6826,9 @@ static int ufshcd_eh_device_reset_handler(struct
> > scsi_cmnd *cmd)
> >  	u8 resp = 0xF, lun;
> >  	unsigned long flags;
> >
> > +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_RESET_HANDLER)
> > +		return ufshcd_eh_host_reset_handler(cmd);
> > +
> >  	host = cmd->device->host;
> >  	hba = shost_priv(host);
> >
> > @@ -6972,6 +6975,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
> >  	host = cmd->device->host;
> >  	hba = shost_priv(host);
> >  	tag = cmd->request->tag;
> > +
> > +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_RESET_HANDLER)
> > +		return ufshcd_eh_host_reset_handler(cmd);
> > +
> >  	lrbp = &hba->lrb[tag];
> >  	if (!ufshcd_valid_tag(hba, tag)) {
> >  		dev_err(hba->dev,
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 0ab4c296be32..82a9c6889978 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -581,6 +581,12 @@ enum ufshcd_quirks {
> >  	 * support interface configuration.
> >  	 */
> >  	UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION	= 1 << 16,
> > +
> > +	/*
> > +	 * This quirk needs to be enabled if the host controller support
> > +	 * host reset handler only.
> > +	 */
> > +	UFSHCD_QUIRK_BROKEN_RESET_HANDLER		= 1 << 17,
> >  };
> >
> >  enum ufshcd_caps {


Best Regards,
Jongmin jeong

