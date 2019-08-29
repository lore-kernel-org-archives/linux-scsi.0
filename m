Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B5BC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB5BC233FF
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH2VbR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:31:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbfH2VbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 17:31:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7TLRmZE141627;
        Thu, 29 Aug 2019 17:30:48 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2upnwp1gxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 17:30:48 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x7TLUEuc017314;
        Thu, 29 Aug 2019 21:30:47 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 2ujvv6xssu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Aug 2019 21:30:47 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7TLUj2p46661926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:30:45 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4022F6E056;
        Thu, 29 Aug 2019 21:30:45 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D8ED6E04C;
        Thu, 29 Aug 2019 21:30:44 +0000 (GMT)
Received: from [9.24.4.105] (unknown [9.24.4.105])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu, 29 Aug 2019 21:30:44 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 1/3] scsi: cxlflash: Fix fallthrough warnings.
From:   Uma Krishnan <ukrishn@linux.ibm.com>
In-Reply-To: <279d33f05007e9f3e3fb4e6ea19634b2608ffbd3.1567081143.git.msuchanek@suse.de>
Date:   Thu, 29 Aug 2019 16:30:43 -0500
Cc:     linuxppc-dev@lists.ozlabs.org,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <814EA905-2AD8-4451-AC1E-4439B64227E7@linux.ibm.com>
References: <cover.1567081143.git.msuchanek@suse.de>
 <279d33f05007e9f3e3fb4e6ea19634b2608ffbd3.1567081143.git.msuchanek@suse.de>
To:     Michal Suchanek <msuchanek@suse.de>
X-Mailer: Apple Mail (2.3445.104.11)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290215
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Below commit queued up for 5.4 includes these changes.

commit 657bd277c162580674ddb86a90c4aeb62639bff5
Author: Gustavo A. R. Silva <gustavo@embeddedor.com>
Date:   Sun Jul 28 19:21:19 2019 -0500

Thanks,
Uma Krishnan

> On Aug 29, 2019, at 7:32 AM, Michal Suchanek <msuchanek@suse.de> wrote:
> 
> Add fallthrough comments where missing.
> 
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
> drivers/scsi/cxlflash/main.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index b1f4724efde2..f402fa9a7bec 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -753,10 +753,13 @@ static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level,
> 		/* SISL_MSI_ASYNC_ERROR is setup only for the primary HWQ */
> 		if (index == PRIMARY_HWQ)
> 			cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 3, hwq);
> +		/* fall through */
> 	case UNMAP_TWO:
> 		cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 2, hwq);
> +		/* fall through */
> 	case UNMAP_ONE:
> 		cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 1, hwq);
> +		/* fall through */
> 	case FREE_IRQ:
> 		cfg->ops->free_afu_irqs(hwq->ctx_cookie);
> 		/* fall through */
> @@ -973,14 +976,18 @@ static void cxlflash_remove(struct pci_dev *pdev)
> 	switch (cfg->init_state) {
> 	case INIT_STATE_CDEV:
> 		cxlflash_release_chrdev(cfg);
> +		/* fall through */
> 	case INIT_STATE_SCSI:
> 		cxlflash_term_local_luns(cfg);
> 		scsi_remove_host(cfg->host);
> +		/* fall through */
> 	case INIT_STATE_AFU:
> 		term_afu(cfg);
> +		/* fall through */
> 	case INIT_STATE_PCI:
> 		cfg->ops->destroy_afu(cfg->afu_cookie);
> 		pci_disable_device(pdev);
> +		/* fall through */
> 	case INIT_STATE_NONE:
> 		free_mem(cfg);
> 		scsi_host_put(cfg->host);
> @@ -3017,6 +3024,7 @@ static ssize_t num_hwqs_store(struct device *dev,
> 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
> 		if (cfg->state == STATE_NORMAL)
> 			goto retry;
> +		/* fall through */
> 	default:
> 		/* Ideally should not happen */
> 		dev_err(dev, "%s: Device is not ready, state=%d\n",
> -- 
> 2.12.3
> 

