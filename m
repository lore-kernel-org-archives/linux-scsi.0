Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FB7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 897536128E
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhJSDqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:46:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25844 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhJSDqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:46:05 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19J32Rhc004569;
        Tue, 19 Oct 2021 03:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9C+Cre8liTdptm7yIUvhie+B5csAwt91gqsC/5ram8E=;
 b=jAGlALXLMMIzFawdu1tjwW+T1lyzY9wm06LVUB6nJzy7oeyt2lGfLsBeToxrTPZGBa6s
 PUNHpPXrTB+90HTKVGHwuvl5NGztUZ1XrhnkzjBeWzsKBzZnJucmT+mbkQdPQDXovnmw
 gn+7kdMDYi1tDd/8BKTtpKBNtNCyUYbb9+9pObw+2+1DCq91rXqwz3hhmYIAGy/yAxvM
 ADVwIQqnZi3synaB2GYZ1iLSq1N7bcFcKoZqcMC97ikLtMNjd0qIHvxe57g4/W3iPagf
 /Yp8rRZq0q+K8ej+TD+cSXXnMGef/KrNu8BZ42AVdXdZU6JyJA9cnLHPiGaIHUuW6WBZ uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brnnnftte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J3ZTrr077032;
        Tue, 19 Oct 2021 03:43:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3br8grmmu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:43:48 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19J3hhHj101685;
        Tue, 19 Oct 2021 03:43:48 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3br8grmmrp-6;
        Tue, 19 Oct 2021 03:43:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Zheyu Ma <zheyuma97@gmail.com>, jejb@linux.ibm.com,
        njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
Date:   Mon, 18 Oct 2021 23:43:42 -0400
Message-Id: <163461411521.13664.874914944959947071.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1634522181-31166-1-git-send-email-zheyuma97@gmail.com>
References: <1634522181-31166-1-git-send-email-zheyuma97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: clds8nxCnZTRmncAJHIQjcdBUtl2_J73
X-Proofpoint-GUID: clds8nxCnZTRmncAJHIQjcdBUtl2_J73
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 01:56:21 +0000, Zheyu Ma wrote:

> During the process of driver probing, probe function should return < 0
> for failure, otherwise kernel will treat value > 0 as success.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Return -ENOMEM if kzalloc() fails
      https://git.kernel.org/mkp/scsi/c/06634d5b6e92

-- 
Martin K. Petersen	Oracle Linux Engineering
