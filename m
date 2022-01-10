Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1F6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 22:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbiAJWEt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 17:04:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9524 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbiAJWEs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 17:04:48 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlXiW026175;
        Mon, 10 Jan 2022 22:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=5/Xlk6IYk+oHf/bV37gJghV5gNwHBOgklZq7o0jMl6M=;
 b=HhoKSEd5xsY1fWE0Jt5yk0Oi24+A4aNVILAaaLFFtQK5BtKrv/Gnlma7MLmNIAzTPH68
 hu+ZFkbzxDOb21NdV+KgThG06LePnOTfU6IGhVhgyoggZvu3gUvbB/mjaRYuScoJ3Fjj
 sxlsU8LXvE9ha1tAhd9kodJ9rH5LBPUC577YW0c9LLfrpLbkg5JOFmI3vjCGIVmLd51a
 STdTmbfR/eGHBt+/7JxDnjgtGHxswCd5/v9e0mZ8XsZpBKdhahiVxkav9f9ujdRLuhZp
 8GGcAWg+eOXdy1B2QUmOMReEQFuIHkGIRrsEjf2qQHJ04JFreP3Cp1vk5iy1q3Vt6Zdh Yw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtg9sva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALtvTD138972;
        Mon, 10 Jan 2022 22:04:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:44 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20AM4iBw174082;
        Mon, 10 Jan 2022 22:04:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqp8-1;
        Mon, 10 Jan 2022 22:04:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ajish Koshy <Ajish.Koshy@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: pm80xx: port reset timeout error handling correction.
Date:   Mon, 10 Jan 2022 17:04:33 -0500
Message-Id: <164182835585.13635.17385390679327751458.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
References: <20211228111753.10802-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: AaXrTA6ZL0y7IBZHx_Y2zhUbyosCPORR
X-Proofpoint-ORIG-GUID: AaXrTA6ZL0y7IBZHx_Y2zhUbyosCPORR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Dec 2021 16:47:53 +0530, Ajish Koshy wrote:

> Error handling steps were not in sequence as per the programmers
> manual. Expected sequence:
>  -PHY_DOWN (PORT_IN_RESET)
>  -PORT_RESET_TIMER_TMO
>  -Host aborts pending I/Os
>  -Host deregister the device
>  -Host sends HW_EVENT_PHY_DOWN ack
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: pm80xx: port reset timeout error handling correction.
      https://git.kernel.org/mkp/scsi/c/ee05cb71f9f7

-- 
Martin K. Petersen	Oracle Linux Engineering
