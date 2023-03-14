Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39861C6FD1F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 17:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjCNRqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCNRq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 13:46:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605F9B371C;
        Tue, 14 Mar 2023 10:46:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BC9BA1F37E;
        Tue, 14 Mar 2023 17:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678815982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWPTcrU+Vc7dUfMqSqw4m6q+HYA7vaR8BcVAMYrFIss=;
        b=L71BzkenwM0AI1iWO54iFR1SFRDWutGjkWudnznzEKJSG+R7k/5AcjwH47BALWE2QXEw+N
        5qdbHSQBK2ptDvpNjMYS9hye6CruqQ6IA0XkiW26p3P9zt96t9RrPkMQDq7YU0o2fKe11i
        rXjH/WyjoI0vziFA3WJUAy8JLOLjqL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678815982;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWPTcrU+Vc7dUfMqSqw4m6q+HYA7vaR8BcVAMYrFIss=;
        b=md8k87f0dwgGCAs3RLYUxft3uao2WoTmkTFaGFN/ebExGGzSRfOiZD7MfmZugz0I+0JlLD
        jKcRnbM3VW/PJZAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97BBB13A1B;
        Tue, 14 Mar 2023 17:46:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id w35yJO6yEGQBEQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 17:46:22 +0000
Message-ID: <0c54c25f-2aab-27b6-864e-2942ead86d36@suse.de>
Date:   Tue, 14 Mar 2023 18:46:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 8/9] iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <8c1dfc1de1e0e6ba2669976b21f6f813699000c0.1675876735.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <8c1dfc1de1e0e6ba2669976b21f6f813699000c0.1675876735.git.lduncan@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/23 18:40, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> These are cleanups after the bus to class conversion
> for flashnode devices.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c       |  52 +++++++-------
>   drivers/scsi/scsi_transport_iscsi.c | 102 ++++++++++++++--------------
>   include/scsi/scsi_transport_iscsi.h |  48 ++++++-------
>   3 files changed, 102 insertions(+), 100 deletions(-)
> 
Can be merged with the previous patch, but otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes

