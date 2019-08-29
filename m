Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A41C3A5A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E40922CEA
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfH2Vcn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:32:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:44178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbfH2Vcn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 17:32:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 13294B048;
        Thu, 29 Aug 2019 21:32:42 +0000 (UTC)
Date:   Thu, 29 Aug 2019 23:32:40 +0200
From:   Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
To:     Uma Krishnan <ukrishn@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: cxlflash: Fix fallthrough warnings.
Message-ID: <20190829233240.243e6206@naga>
In-Reply-To: <21A3BB0F-98DB-4D64-AE93-9B8A8B6193B3@linux.ibm.com>
References: <cover.1567081143.git.msuchanek@suse.de>
        <279d33f05007e9f3e3fb4e6ea19634b2608ffbd3.1567081143.git.msuchanek@suse.de>
        <21A3BB0F-98DB-4D64-AE93-9B8A8B6193B3@linux.ibm.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 29 Aug 2019 15:34:08 -0500
Uma Krishnan <ukrishn@linux.ibm.com> wrote:

> Below commit queued up for 5.4 includes these changes.
> 
> commit 657bd277c162580674ddb86a90c4aeb62639bff5
> Author: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Date:   Sun Jul 28 19:21:19 2019 -0500
> 
> Thanks,
> Uma Krishnan

Works for me as well.

Thanks

Michal

> 
> On Aug 29, 2019, at 7:32 AM, Michal Suchanek <msuchanek@suse.de> wrote:
> > 
> > Add fallthrough comments where missing.
> > 
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > ---
> > drivers/scsi/cxlflash/main.c | 8 ++++++++
> > 1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> > index b1f4724efde2..f402fa9a7bec 100644
> > --- a/drivers/scsi/cxlflash/main.c
> > +++ b/drivers/scsi/cxlflash/main.c
> > @@ -753,10 +753,13 @@ static void term_intr(struct cxlflash_cfg *cfg, enum undo_level level,
> > /* SISL_MSI_ASYNC_ERROR is setup only for the primary HWQ */
> > if (index == PRIMARY_HWQ)
> > cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 3, hwq);
> > + /* fall through */
> > case UNMAP_TWO:
> > cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 2, hwq);
> > + /* fall through */
> > case UNMAP_ONE:
> > cfg->ops->unmap_afu_irq(hwq->ctx_cookie, 1, hwq);
> > + /* fall through */
> > case FREE_IRQ:
> > cfg->ops->free_afu_irqs(hwq->ctx_cookie);
> > /* fall through */
> > @@ -973,14 +976,18 @@ static void cxlflash_remove(struct pci_dev *pdev)
> > switch (cfg->init_state) {
> > case INIT_STATE_CDEV:
> > cxlflash_release_chrdev(cfg);
> > + /* fall through */
> > case INIT_STATE_SCSI:
> > cxlflash_term_local_luns(cfg);
> > scsi_remove_host(cfg->host);
> > + /* fall through */
> > case INIT_STATE_AFU:
> > term_afu(cfg);
> > + /* fall through */
> > case INIT_STATE_PCI:
> > cfg->ops->destroy_afu(cfg->afu_cookie);
> > pci_disable_device(pdev);
> > + /* fall through */
> > case INIT_STATE_NONE:
> > free_mem(cfg);
> > scsi_host_put(cfg->host);
> > @@ -3017,6 +3024,7 @@ static ssize_t num_hwqs_store(struct device *dev,
> > wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
> > if (cfg->state == STATE_NORMAL)
> > goto retry;
> > + /* fall through */
> > default:
> > /* Ideally should not happen */
> > dev_err(dev, "%s: Device is not ready, state=%d\n",
> > --
> > 2.12.3
> > 
> > 
> 

