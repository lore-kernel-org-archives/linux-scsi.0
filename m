Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00296C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 11 May 2022 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbiEKCrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 22:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242807AbiEKCiN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 22:38:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760241BB117
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 19:38:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AKsKqv017478;
        Wed, 11 May 2022 02:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=GPOURhMLbEDSAxCOlpgs26zTXUfURoOrBtQsbDbnAC0=;
 b=pLDRS9DnX7yjAAImFzGg8IQJVJQ8KNUfhnSSobRoJ1Qi8al5tCIpPL1Hdo61F273Ntlb
 B2q++wh2o0WDqi8r3hm1AyozMWbDzXF3HtOa+T7O1TMPDOnZc8wePJMkG8kj/ey0oihe
 J8wkpj/lTGjY7nM67EuDW9NQYBqkSeqQ7+m5z6ODKTtocWZge7SmiUbMT+2jX+MDCblY
 UzHfMo3pl4ccYv5VNEBernFpJsfCVvV2Ec0lwz4Fs5vSrAKxsZC7NNlF9sma2Zdq4Scd
 Lh1SoziqwzTXuBBgdbhTgxxDaE51ZKsYJ2v8Y1cfUU3YAjuPsXTidEpk567ieTX/poef IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgn9r3e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:38:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24B2LeHV015415;
        Wed, 11 May 2022 02:38:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73scta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 May 2022 02:38:09 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24B2c95X027764;
        Wed, 11 May 2022 02:38:09 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73scsr-1;
        Wed, 11 May 2022 02:38:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH] lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
Date:   Tue, 10 May 2022 22:38:06 -0400
Message-Id: <165223667362.31045.3159914778746373173.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220506205548.61644-1-jsmart2021@gmail.com>
References: <20220506205548.61644-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: e8FAV_mcIBURc16431Mo-7e9NOUEdiIy
X-Proofpoint-ORIG-GUID: e8FAV_mcIBURc16431Mo-7e9NOUEdiIy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 May 2022 13:55:48 -0700, James Smart wrote:

> Garbage FCoE CT frames are transmitted on the wire because of bad DMA ptr
> addresses filled in the GEN_REQ_WQE.
> 
> The __lpfc_sli_prep_gen_req_s4() routine is using the wrong buffer for
> the payload address. Change the dma buffer assignment from the bmp buffer
> to the bpl buffer.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] lpfc: Correct BDE DMA address assignment for GEN_REQ_WQE
      https://git.kernel.org/mkp/scsi/c/775266207105

-- 
Martin K. Petersen	Oracle Linux Engineering
