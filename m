Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C69C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 02:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED00E61437
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 02:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhDWCge (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 22:36:34 -0400
Received: from mailout.easymail.ca ([64.68.200.34]:48506 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbhDWCgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 22:36:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 70B919FF35;
        Fri, 23 Apr 2021 02:35:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eqAUQ7-zxInA; Fri, 23 Apr 2021 02:35:57 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 15D1A9FEE0;
        Fri, 23 Apr 2021 02:35:52 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id D8D983EE3E;
        Thu, 22 Apr 2021 20:35:51 -0600 (MDT)
Subject: Re: [PATCH] Fix 64-bit system enumeration error for Buslogic
To:     =?UTF-8?B?546L5paH5rab?= <witallwang@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Elaine Zhao <yzhao@vmware.com>
References: <AC748808-586E-469C-BBC1-1CB86D5B4686@gmail.com>
From:   Khalid Aziz <khalid@gonehiking.org>
Message-ID: <218eeece-e471-748b-6083-aa666997118e@gonehiking.org>
Date:   Thu, 22 Apr 2021 20:35:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <AC748808-586E-469C-BBC1-1CB86D5B4686@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 12:09 AM, 王文涛 wrote:
> From: matt <wwentao@vmware.com>
> Date: Tue, 20 Apr 2021 15:27:48 +0800
> Subject: [PATCH] Fix 64-bit system enumeration error for Buslogic

I would update this to "scsi: BusLogic: Fix 64-bit system enumeration
error for Buslogic". Martin, if you can do that when applying it to
scsi-staging,

Acked-by: Khalid Aziz <khalid@gonehiking.org>

> 
>  Commit 391e2f25601e("BusLogic: Port driver to 64-bit") in Buslogic
>  driver introduced a serious issue for 64-bit systems. With this
>  commit, 64-bit kernel will enumerate 8*15 non-existing disks.  This
>  is caused by the broken CCB structure. The change from u32 data to
>  void *data increased CCB length on 64-bit system, which introduced
>  an extra 4 byte offset of the CDB. This leads to incorrect response
>  to Inquiry commands during enumeration.
> 
>  This patch fixes the error.
> 
> Signed-off-by: matt <wwentao@vmware.com>
> ---
>  drivers/scsi/BusLogic.c | 6 +++---
>  drivers/scsi/BusLogic.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index ccb061ab0a0a..7231de2767a9 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -3078,11 +3078,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
>  		ccb->opcode = BLOGIC_INITIATOR_CCB_SG;
>  		ccb->datalen = count * sizeof(struct blogic_sg_seg);
>  		if (blogic_multimaster_type(adapter))
> -			ccb->data = (void *)((unsigned int) ccb->dma_handle +
> +			ccb->data = (unsigned int) ccb->dma_handle +
>  					((unsigned long) &ccb->sglist -
> -					(unsigned long) ccb));
> +					(unsigned long) ccb);
>  		else
> -			ccb->data = ccb->sglist;
> +			ccb->data = virt_to_32bit_virt(ccb->sglist);
>  
>  		scsi_for_each_sg(command, sg, count, i) {
>  			ccb->sglist[i].segbytes = sg_dma_len(sg);
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index 6182cc8a0344..e081ad47d1cf 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -814,7 +814,7 @@ struct blogic_ccb {
>  	unsigned char cdblen;				/* Byte 2 */
>  	unsigned char sense_datalen;			/* Byte 3 */
>  	u32 datalen;					/* Bytes 4-7 */
> -	void *data;					/* Bytes 8-11 */
> +	u32 data;					/* Bytes 8-11 */
>  	unsigned char:8;				/* Byte 12 */
>  	unsigned char:8;				/* Byte 13 */
>  	enum blogic_adapter_status adapter_status;	/* Byte 14 */
> 

