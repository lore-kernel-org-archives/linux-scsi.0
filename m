Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCEBC001DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 17:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjGYR1n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjGYR1l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 13:27:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738221FCF
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690306014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xbds6RC4+zmMm8S6mNyiiv6mc/Jhy2JAc61bU2x/U1k=;
        b=KB3KAE6uVkrhQkzTyxlKo8CIGQab6z4AqPWPEiFEgHzVQJkr0QwwPuJeBepO3hq6OrvOVC
        K6nBJo3S8oOVlrVYdF8pdgBlOs9t97u4LKFotHtzzIwXy4CZ7QynSMoNSZervUTqsx/7/B
        USr9fR370H1Nq48LTw8azyEhqsHEgoU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-Eke6rSJ1N4W5UsDSgFaWyQ-1; Tue, 25 Jul 2023 13:26:51 -0400
X-MC-Unique: Eke6rSJ1N4W5UsDSgFaWyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43AD9858F1E;
        Tue, 25 Jul 2023 17:26:50 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BFB9C2C856;
        Tue, 25 Jul 2023 17:26:49 +0000 (UTC)
Date:   Tue, 25 Jul 2023 10:26:47 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     lduncan@suse.com, michael.christie@oracle.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, vikas.chaudhary@qlogic.com,
        JBottomley@parallels.com, mchan@broadcom.com, benli@broadcom.com,
        ogerlitz@voltaire.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] scsi: iscsi: Add strlen check in
 iscsi_if_set_{host}_param
Message-ID: <ZMAF1+P3blgBZ+/m@rhel-developer-toolbox-latest>
References: <20230725024545.428519-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725024545.428519-1-linma@zju.edu.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 25, 2023 at 10:45:45AM +0800, Lin Ma wrote:
> The function iscsi_if_set_param and iscsi_if_set_host_param converts
> nlattr payload to type char* and then call C string handling functions
> like sscanf and kstrdup.
> 
>   char *data = (char*)ev + sizeof(*ev);
>   ...
>   sscanf(data, "%d", &value);
> 
> However, since the nlattr is provided by the user-space program and
> the nlmsg skb is allocated with GFP_KERNEL instead of GFP_ZERO flag
> (see netlink_alloc_large_skb in netlink_sendmsg), the dirty data
> remained in the heap can cause OOB read for those string handling
> functions.

Reviewed-by: Chris Leech <cleech@redhat.com>

