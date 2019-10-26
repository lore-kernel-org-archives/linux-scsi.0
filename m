Return-Path: <SRS0=2Pi9=YT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE065CA9EA0
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Oct 2019 00:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC1D205ED
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Oct 2019 00:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TUhKTWEz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfJZAjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 20:39:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJZAjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 20:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PY2ifMzsUHES99tnuXwNKBR7kXj8m7j/uX2jyvu+b+k=; b=TUhKTWEzIVS/qjMS53rpwksuq
        GtnO5CqrhoDYNUmJqaUyG47KimgW1SAoq0BekCXB3aAT8VHBJ1RDN40VpZk3jrs1Y76GXMEgY600k
        MaO2CNJBHjCcRgpdLJM8r7/yKtARrLqHj1Gh7HiHjxktumqI46nkKL5bvba9q9iKj6rz5OgAVBgmC
        ZIlF/hlPcdyFkFe/T3dhHURs0MwZnmjTG9jqBzOhu5Bo08rWpg5Xt7kIMTDpJRt1BZ5RVoojTnEYX
        BcWMwtq8BpLVEJmyCmJJKcWNP/Scyi7K7UoeO0OMxivfFkP4/j1ywWwjgH+U52yWvqa8EA0dsuc1u
        S4WwHQSrg==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOA7G-0004GQ-JM; Sat, 26 Oct 2019 00:39:38 +0000
Subject: Re: [PATCH 32/32] elx: efct: Tie into kernel Kconfig and build
 process
To:     kbuild test robot <lkp@intel.com>,
        James Smart <jsmart2021@gmail.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191023215557.12581-33-jsmart2021@gmail.com>
 <201910260807.ud4c6FJP%lkp@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <71048ade-35fb-2eed-e69c-eb65daa09c74@infradead.org>
Date:   Fri, 25 Oct 2019 17:39:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <201910260807.ud4c6FJP%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,


On 10/25/19 5:34 PM, kbuild test robot wrote:
> vim +/offset +818 drivers/scsi/elx/libefc_sli/sli4.c
> 
> 8994bfd36daa33 James Smart 2019-10-23  795  
> 8994bfd36daa33 James Smart 2019-10-23  796  /**
> 8994bfd36daa33 James Smart 2019-10-23  797   * @ingroup sli_fc
> 8994bfd36daa33 James Smart 2019-10-23  798   * @brief Write an RQ_CREATE_V2 command.
> 8994bfd36daa33 James Smart 2019-10-23  799   *
> 8994bfd36daa33 James Smart 2019-10-23  800   * @param sli4 SLI context.
> 8994bfd36daa33 James Smart 2019-10-23  801   * @param buf Destination buffer for the command.
> 8994bfd36daa33 James Smart 2019-10-23  802   * @param size Buffer size, in bytes.
> 8994bfd36daa33 James Smart 2019-10-23  803   * @param qmem DMA memory for the queue.
> 8994bfd36daa33 James Smart 2019-10-23  804   * @param cq_id Associated CQ_ID.
> 8994bfd36daa33 James Smart 2019-10-23  805   * @param buffer_size Buffer size pointed to by each RQE.
> 8994bfd36daa33 James Smart 2019-10-23  806   *
> 8994bfd36daa33 James Smart 2019-10-23  807   * @note This creates a Version 0 message
> 8994bfd36daa33 James Smart 2019-10-23  808   *
> 8994bfd36daa33 James Smart 2019-10-23  809   * @return Returns zero for success and non-zero for failure.
> 8994bfd36daa33 James Smart 2019-10-23  810   */

BTW, what is that notation?  It's not kernel-doc. Please use kernel-doc notation
for documentation in the kernel.

> 8994bfd36daa33 James Smart 2019-10-23  811  static int
> 8994bfd36daa33 James Smart 2019-10-23  812  sli_cmd_rq_create_v2(struct sli4_s *sli4, u32 num_rqs,
> 8994bfd36daa33 James Smart 2019-10-23  813  		     struct sli4_queue_s *qs[], u32 base_cq_id,
> 8994bfd36daa33 James Smart 2019-10-23  814  		     u32 header_buffer_size,
> 8994bfd36daa33 James Smart 2019-10-23  815  		     u32 payload_buffer_size, struct efc_dma_s *dma)
> 8994bfd36daa33 James Smart 2019-10-23  816  {


thanks.
-- 
~Randy

