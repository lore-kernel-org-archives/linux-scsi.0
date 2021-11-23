Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7481AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhKWDw3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:52:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32096 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232724AbhKWDw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:52:26 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN1mGmM015381;
        Tue, 23 Nov 2021 03:49:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=71yF8cF8+NytRLvxni4D99sEMQZ/LyKM30Fk+C7roy4=;
 b=wZ8I1XFl4NyfRtQb/fZruI3rKQuDkRg+pQCnui4jEIPUsujE4Neaks4LTnx63fn4U20z
 33iGbDpr2XMKZUWnS4BCbrXy0ew13GZ4+dI4605ZNUO3FfIO3EDlo/ErDhd6CcUToX8T
 fJEJmj9AEFb5+BmtbEpxzhv9ew3yhDb6XBH/UvU22zxl2STsaYxAFKx34pbnZlVdJO6c
 tKRNYiynoVG3vuvpKLqh8mTKUatmjUchOUSc3kGRhuJ9akUFg6DeFZ1OMoCyn8iSOMC8
 i7veWFCcSFDRNJ5dBTRSGY1wGbPKJBT4Y3Q0MZg4p/gfCnIyBHfDujhthQUFN8Jz7LH6 vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg46f6sj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3l03s162085;
        Tue, 23 Nov 2021 03:49:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:09 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3l19q162141;
        Tue, 23 Nov 2021 03:49:09 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hc-5;
        Tue, 23 Nov 2021 03:49:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Wrap Universal Flash Storage drivers in SCSI_UFSHCD
Date:   Mon, 22 Nov 2021 22:49:03 -0500
Message-Id: <163763931254.19362.13195258684777232140.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211106164650.1571068-1-geert@linux-m68k.org>
References: <20211106164650.1571068-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: M0uRRB7CRSdXRebIyLl8_jLJw_DMi5b5
X-Proofpoint-ORIG-GUID: M0uRRB7CRSdXRebIyLl8_jLJw_DMi5b5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 6 Nov 2021 17:46:50 +0100, Geert Uytterhoeven wrote:

> The build only descends into drivers/scsi/ufs/ if SCSI_UFSHCD is
> enabled.  Hence all later config symbols should depend on SCSI_UFSHCD,
> to prevent asking the user about config symbols for driver code that
> won't be build anyway.  Unfortunately not all symbols have that
> dependency.
> 
> Fix this by wrapping them all into a big if/endif block.  Remove the now
> superfluous explicit dependencies on SCSI_UFSHCD from all symbols that
> already had it.
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: ufs: Wrap Universal Flash Storage drivers in SCSI_UFSHCD
      https://git.kernel.org/mkp/scsi/c/d28a78537d1d

-- 
Martin K. Petersen	Oracle Linux Engineering
