Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53318C6FD19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 02:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCNClu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 22:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCNCls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 22:41:48 -0400
X-Greylist: delayed 420 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Mar 2023 19:41:45 PDT
Received: from mp-relay-01.fibernetics.ca (mp-relay-01.fibernetics.ca [208.85.217.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C94E8736D;
        Mon, 13 Mar 2023 19:41:44 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-01.fibernetics.ca (Postfix) with ESMTPS id 14C11E1648;
        Tue, 14 Mar 2023 02:34:43 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id F091260A93;
        Tue, 14 Mar 2023 02:34:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id rWs2PeUIJriv; Tue, 14 Mar 2023 02:34:40 +0000 (UTC)
Received: from [192.168.48.17] (host-184-164-23-94.dyn.295.ca [184.164.23.94])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 1A74C60A4A;
        Tue, 14 Mar 2023 02:34:31 +0000 (UTC)
Message-ID: <5f8c7ee6-fade-2060-d44a-8794d2d6e505@interlog.com>
Date:   Mon, 13 Mar 2023 22:34:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH RESEND v2 01/11] scsi: scsi_debug: Don't hold driver host
 struct pointer in host->hostdata[]
Content-Language: en-CA
To:     John Garry <john.g.garry@oracle.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
References: <20230313093114.1498305-1-john.g.garry@oracle.com>
 <20230313093114.1498305-2-john.g.garry@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230313093114.1498305-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-03-13 05:31, John Garry wrote:
> This driver stores just a pointer to the driver host structure in
> host->hostdata[]. Most other drivers actually have the driver host
> structure allocated in host->hostdata[], but this driver is different as
> we allocate that memory separately before allocating the shost memory.
> 
> However there is no need to allocate this memory only in host->hostdata[]
> when we can already look up the driver host structure from shost->dma_dev,
> so add a macro for this - shost_to_sdebug_host(). Rename to_sdebug_host()
> -> dev_to_sdebug_host() to avoid ambiguity.
> 
> Also remove a check for !sdbg_host in find_build_dev_info(), as this cannot
> be true. Other similar checks will be later removed.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Please apply my "ack" to the rest of this series (2 through 11).

Good the have other eyes looking at this driver and making
improvements.

Thanks
Doug Gilbert

