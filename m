Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A49C3A5A0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7887120644
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WS0iU9Yz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfHTCKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 22:10:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbfHTCKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 22:10:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K297r9168630;
        Tue, 20 Aug 2019 02:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Ggp8E3ralYb72627g66ZTKCcGX2pev5T3HC6H2LNuvw=;
 b=WS0iU9YzweOUccR2GTR4ExHkI8pXP6z70u04qdTDCkgEKdv7iPqsbC5iX7gk41S10g3u
 qy67iKv4SfeUExwAeicTw5/XRHh1usMoo5Iz2IU5v5XWjVRwlKfWvLzFetLqiYyiiW1F
 m+pwi4Alb9ekmtts/rUL1ISxj1WX6BlWE7P3NmNuvHKTDiXktlh1QE2sWyDN7l1TIGnb
 p6VNZCnOhWvIm3gWSNSyu9RF2oF69hZB+SHEcRQmJB2KqTAJxlYvr5yfV+8pdFU4stY0
 Xw0q+d7TLyYmQyzE7FGkmQ5B1UANrf82x6SLg1Wa4e0d9Uh8XPzCJ/P61ndWaML3lT9e ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ue9hpb0d1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 02:10:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K28Rn6071068;
        Tue, 20 Aug 2019 02:10:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2ufwgcjtpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 02:10:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7K2AjGW004669;
        Tue, 20 Aug 2019 02:10:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 19:10:45 -0700
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: use spin_lock_irqsave instead of spin_lock_irq in IRQ context
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190812083134.7033-1-huangfq.daxian@gmail.com>
Date:   Mon, 19 Aug 2019 22:10:43 -0400
In-Reply-To: <20190812083134.7033-1-huangfq.daxian@gmail.com> (Fuqian Huang's
        message of "Mon, 12 Aug 2019 16:31:34 +0800")
Message-ID: <yq18srozivw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=588
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=655 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Fuqian,

> As spin_unlock_irq will enable interrupts.
> Function lpfc_findnode_rpi is called from
>     lpfc_sli_abts_err_handler (./drivers/scsi/lpfc/lpfc_sli.c)
>  <- lpfc_sli_async_event_handler
>  <- lpfc_sli_process_unsol_iocb
>  <- lpfc_sli_handle_fast_ring_event
>  <- lpfc_sli_fp_intr_handler
>  <- lpfc_sli_intr_handler
>  and lpfc_sli_intr_handler is an interrupt handler.
> Interrupts are enabled in interrupt handler.
> Use spin_lock_irqsave/spin_unlock_irqrestore instead of spin_(un)lock_irq
> in IRQ context to avoid this.

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
