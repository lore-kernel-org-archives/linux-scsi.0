Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329C2C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 012E161435
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243704AbhDUUsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:48:43 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:40536 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbhDUUsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:48:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 3F99FC65CA;
        Wed, 21 Apr 2021 20:48:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo04-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo04-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iFFWFYRQURty; Wed, 21 Apr 2021 20:48:09 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 51E21C65C4;
        Wed, 21 Apr 2021 20:48:05 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 6B8533EE45;
        Wed, 21 Apr 2021 14:48:05 -0600 (MDT)
Subject: Re: Fix 64-bit Buslogic driver enumeration error
To:     Matt Wang <wwentao@vmware.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Elaine Zhao <yzhao@vmware.com>
References: <CE1E0FEA-1041-47C1-85D3-DE9F97AD0C89@vmware.com>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <9856830c-6c2f-018c-ee6f-609e7a3e82c3@gonehiking.org>
Date:   Wed, 21 Apr 2021 14:48:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CE1E0FEA-1041-47C1-85D3-DE9F97AD0C89@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 1:52 AM, Matt Wang wrote:
> Hi Khalid,
> 
>  
> 
> Commit 391e2f25601e34a7d7e5dc155e487bc58dffd8c6 in Buslogic driver
> introduced a serious issue for 64-bit systems. With this commit, 64-bit
> kernel will enumerate 8*15 non-existing disks.
> 
> This is caused by the broken CCB structure. The change from u32
> data to void *data increased CCB length in 64-bit system, which
> introduced an extra 4 byte offset to the CDB. This leads to incorrect
> response to Inquiry commands during enumeration.
> 
>  
> 
> This patch fixes the error.
> 
>  

Hi Matt,

Thanks for looking at this. These changes look good. The conversion
"ccb->data = virt_to_32bit_virt(ccb->sglist);" from 64-bit address to
32-bit should be ok since ccb is allocated using dma_alloc_coherent and
should be 32-bit DMA addressable.

A few issues to address with this patch:

- Can you add a proper commit log? The email body itself can serve as
commit log:

"   Fix 64-bit system enumeration error for Buslogic

    Commit 391e2f25601e("BusLogic: Port driver to 64-bit") in Buslogic
    driver introduced a serious issue for 64-bit systems. With this
    commit, 64-bit kernel will enumerate 8*15 non-existing disks.  This
    is caused by the broken CCB structure. The change from u32 data to
    void *data increased CCB length on 64-bit system, which introduced
    an extra 4 byte offset of the CDB. This leads to incorrect response
    to Inquiry commands during enumeration.

    This patch fixes the error."

- Add your Signed-off-by

- Send the patch inline (plain text format, not html) instead of as
attachment.

Thanks,
Khalid

