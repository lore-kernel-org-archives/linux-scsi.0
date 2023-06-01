Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5934C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 00:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjFAAnR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 20:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjFAAnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 20:43:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9F7123;
        Wed, 31 May 2023 17:43:15 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJpt0B027834;
        Thu, 1 Jun 2023 00:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=Ips1jBAXiHfKVpI/1xTGaQn2pdf449cCEABytqFx1Tk=;
 b=VdJ0//G6rO5K/bp3m3I+pY8tZ/pYYZZu9+IYiilnu37gtENfQZDOldQuldRtYrKTHbCP
 rEQAQORRR0yQGiYRUqsRu7DVPHXV/FvtlsrlggKO+Vq55XL3EY98EaAkgXdgYW8UkAvd
 tQ5ep8EtVcHL8EYz3vn1bznvckJIhnNtbAHdgtkdx1DXblJ/Ut86gAGFUWYEZjHXl0p8
 jG9JlQZ4iHqLeE+jChV/gsFEmxCCjv8dJDqAxviNxWWcMLsFm1N6o6WCAZ6zdewv3FZW
 XfBOL69z8LTX5o8Tw2Mw6N2yaq6RFrTQDgfpMTniehiQiF69gJ+prnnBWszoGTCkUO6O Vg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwfagc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:43:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VMItKT026123;
        Thu, 1 Jun 2023 00:43:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8ad024x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:43:06 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3510cuYe000727;
        Thu, 1 Jun 2023 00:43:05 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qu8ad024q-1;
        Thu, 01 Jun 2023 00:43:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: stex: Fix gcc 13 warnings
Date:   Wed, 31 May 2023 20:43:01 -0400
Message-Id: <168557998048.2461145.1627682048369491421.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529195034.3077-1-bvanassche@acm.org>
References: <20230529195034.3077-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_18,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=812 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010002
X-Proofpoint-ORIG-GUID: Osla6yPD2r9ojDsAbnGi9H6AxUATctMM
X-Proofpoint-GUID: Osla6yPD2r9ojDsAbnGi9H6AxUATctMM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 29 May 2023 12:50:34 -0700, Bart Van Assche wrote:

> gcc 13 may assign another type to enumeration constants than gcc 12. Split
> the large enum at the top of source file stex.c such that the type of the
> constants used in time expressions is changed back to the same type chosen
> by gcc 12. This patch suppresses compiler warnings like this one:
> 
> In file included from ./include/linux/bitops.h:7,
>                  from ./include/linux/kernel.h:22,
>                  from drivers/scsi/stex.c:13:
> drivers/scsi/stex.c: In function ‘stex_common_handshake’:
> ./include/linux/typecheck.h:12:25: error: comparison of distinct pointer types lacks a cast [-Werror]
>    12 |         (void)(&__dummy == &__dummy2); \
>       |                         ^~
> ./include/linux/jiffies.h:106:10: note: in expansion of macro ‘typecheck’
>   106 |          typecheck(unsigned long, b) && \
>       |          ^~~~~~~~~
> drivers/scsi/stex.c:1035:29: note: in expansion of macro ‘time_after’
>  1035 |                         if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
>       |                             ^~~~~~~~~~
> 
> [...]

Applied to 6.4/scsi-fixes, thanks!

[1/1] scsi: stex: Fix gcc 13 warnings
      https://git.kernel.org/mkp/scsi/c/6d074ce23177

-- 
Martin K. Petersen	Oracle Linux Engineering
