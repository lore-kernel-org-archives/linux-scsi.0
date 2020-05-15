Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12466C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 23:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B66205CB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 23:50:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LOE/kShL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEOXuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 19:50:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40331 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726231AbgEOXuH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 19:50:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589586606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hw3RkCsgcQacr6zjV1u999K3NhEH21GsqpqwnnfF7j0=;
        b=LOE/kShLy3W8yXhbc2TAIxVMuH/Ebl05F/9u/jGl0+afA7bgUjLNPKxYE1Usr8hm9G3Acu
        v02Cv+QF60/bQrLGCx2EhaWZ0wcztAiMXP/T5js/s7/QmxsWTvcJOt95AxVjN7j+XT6hvj
        SJpUsn4zt7VhuHaMp+LwnCBM3fmMthE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-ICg31iNCP2q4ZAaE7I9IYw-1; Fri, 15 May 2020 19:50:03 -0400
X-MC-Unique: ICg31iNCP2q4ZAaE7I9IYw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B9CA1841958;
        Fri, 15 May 2020 23:50:02 +0000 (UTC)
Received: from [10.10.118.190] (ovpn-118-190.rdu2.redhat.com [10.10.118.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 828C51943D;
        Fri, 15 May 2020 23:50:01 +0000 (UTC)
Subject: Re: [PATCH target] target: Add initiatorname to NON_EXISTENT_LUN
 error
To:     Lance Digby <lance.digby@gmail.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cd119ce943d9ec62ef1bff237ebb49e35a337c3b.1589407872.git.lance.digby@gmail.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <93c437ce-f881-9f54-5e39-afa8afd96141@redhat.com>
Date:   Fri, 15 May 2020 18:50:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <cd119ce943d9ec62ef1bff237ebb49e35a337c3b.1589407872.git.lance.digby@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/20 11:01 PM, Lance Digby wrote:
> The NON_EXISTENT_LUN error can be written without an error condition
>  on the initiator responsible. Adding the initiatorname to this message
>  will reduce the effort required to fix this when many initiators are
> supported by a target.
> 
> Signed-off-by: Lance Digby <lance.digby@gmail.com>
> ---
>  drivers/target/target_core_device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 4cee113..604dea0 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -100,9 +100,10 @@
>  		 */
>  		if (unpacked_lun != 0) {
>  			pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
> -				" Access for 0x%08llx\n",
> +				" Access for 0x%08llx from %s\n",
>  				se_cmd->se_tfo->fabric_name,
> -				unpacked_lun);
> +				unpacked_lun,
> +				se_sess->se_node_acl->initiatorname);

You can do nacl->initiatorname.

Do you also want add the name to the tmr case? It's probably not common,
but the error message would be consistent.

>  			return TCM_NON_EXISTENT_LUN;
>  		}
>  

