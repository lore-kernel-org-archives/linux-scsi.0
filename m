Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F04CC11F69
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 16:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE6C8613D9
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 16:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhGAQnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 12:43:32 -0400
Received: from smtprelay0194.hostedemail.com ([216.40.44.194]:57082 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229764AbhGAQnb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 12:43:31 -0400
Received: from omf05.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 6A3B5100E472A;
        Thu,  1 Jul 2021 16:40:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf05.hostedemail.com (Postfix) with ESMTPA id 37C34B2793;
        Thu,  1 Jul 2021 16:40:58 +0000 (UTC)
Message-ID: <6ddc71efad6cd45e45991028a7656eab203df12d.camel@perches.com>
Subject: Re: [PATCH] scsi: aic94xx: Fix fall-through warning for Clang
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Date:   Thu, 01 Jul 2021 09:40:56 -0700
In-Reply-To: <20210701010433.GA57746@embeddedor>
References: <20210701010433.GA57746@embeddedor>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 37C34B2793
X-Stat-Signature: gznc799dteu3m8s9wumnqrhepq5map57
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19DwiLC1MjWGtvuepLMBtmJQwGEjJXxw9w=
X-HE-Tag: 1625157658-948689
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-06-30 at 20:04 -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a
> warning by explicitly adding a fallthrough; statement.
> 
> Notice that this seems to be a Duff device for performance[1]. So,
> although the code looks a bit _funny_, I didn't want to refactor
> or modify it beyond merely adding a fallthrough marking, which
> might be the least disruptive way to fix this issue.

If you read the surrounding calling code, it appears it's
not performant.

 * @start has to be the _base_ element start, since the
 * linked list entries's offset is from this pointer.
 * Some linked list entries use only the first id, in which case
 * you can pass 0xFF for the second.

> diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
[]
> @@ -718,10 +718,12 @@ static void *asd_find_ll_by_id(void * const start, const u8 id0, const u8 id1)
>  	do {
>  		switch (id1) {
>  		default:
> -			if (el->id1 == id1)
> +			if (el->id1 == id1) {
> +			fallthrough;
>  		case 0xFF:
>  				if (el->id0 == id0)
>  					return el;
> +			}
>  		}
>  		el = start + le16_to_cpu(el->next);
>  	} while (el != start);

And this is still horrible code to read.

I think the below is rather more sensible and it doesn't change
the defconfig with aic94xx object size.

$ size drivers/scsi/aic94xx/aic94xx_sds.o*
   text	   data	    bss	    dec	    hex	filename
  10010	    192	      0	  10202	   27da	drivers/scsi/aic94xx/aic94xx_sds.o.new
  10010	    192	      0	  10202	   27da	drivers/scsi/aic94xx/aic94xx_sds.o.old
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index 297a66770260c..069278f6d6cea 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -717,11 +717,14 @@ static void *asd_find_ll_by_id(void * const start, const u8 id0, const u8 id1)
 
 	do {
 		switch (id1) {
-		default:
-			if (el->id1 == id1)
 		case 0xFF:
-				if (el->id0 == id0)
-					return el;
+			if (el->id0 == id0)
+				return el;
+			break;
+		default:
+			if (el->id0 == id0 && el->id1 == id1)
+				return el;
+			break;
 		}
 		el = start + le16_to_cpu(el->next);
 	} while (el != start);

