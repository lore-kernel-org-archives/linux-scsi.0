Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABE6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 16:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32430611C4
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 16:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhKDQGp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 12:06:45 -0400
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:50054 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231484AbhKDQGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 12:06:44 -0400
Received: from omf08.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 0EC68838436D;
        Thu,  4 Nov 2021 16:04:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf08.hostedemail.com (Postfix) with ESMTPA id 1E5841A29FC;
        Thu,  4 Nov 2021 16:04:04 +0000 (UTC)
Message-ID: <834e83a227f40c4654b97f2f0b045b4cbd326f16.camel@perches.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix return checks for kcalloc
From:   Joe Perches <joe@perches.com>
To:     George Kennedy <george.kennedy@oracle.com>,
        gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Date:   Thu, 04 Nov 2021 09:04:01 -0700
In-Reply-To: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
References: <1635966102-29320-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 16zn43i8n69z9pymassbmob55zucsoi7
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 1E5841A29FC
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+sBPcUO2wOTsQDKinIY1mJf6efqbRRJZ0=
X-HE-Tag: 1636041843-960213
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-11-03 at 14:01 -0500, George Kennedy wrote:
> Change return checks from kcalloc() to now check for NULL and
> ZERO_SIZE_PTR using the ZERO_OR_NULL_PTR macro or the following
> crash can occur if ZERO_SIZE_PTR indicator is returned.
> 
> BUG: KASAN: null-ptr-deref in memcpy include/linux/fortify-string.h:191 [inline]
> BUG: KASAN: null-ptr-deref in sg_copy_buffer+0x138/0x240 lib/scatterlist.c:974
> Write of size 4 at addr 0000000000000010 by task syz-executor.1/22789
[]
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
[]
> @@ -3909,7 +3909,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
>  		return ret;
>  	dnum = 2 * num;
>  	arr = kcalloc(lb_size, dnum, GFP_ATOMIC);
> -	if (NULL == arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
>  		return check_condition_result;

This one isn't necessary as num is already tested for non-0 above
this block.

> @@ -4265,7 +4265,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  		return ret;
>  
>  	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
> -	if (!arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
>  		return check_condition_result;

Here it's probably clearer code to test vnum == 0 before the kcalloc
and return check_condition_result;

> @@ -4334,7 +4334,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>  			    max_zones);
>  
>  	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
> -	if (!arr) {
> +	if (ZERO_OR_NULL_PTR(arr)) {
>  		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
>  				INSUFF_RES_ASCQ);
>  		return check_condition_result;

And here test alloc_len == 0 before the kcalloc.


