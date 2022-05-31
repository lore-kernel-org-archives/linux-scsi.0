Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F70C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 15:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345433AbiEaPGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 11:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbiEaPGK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 11:06:10 -0400
Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA74986CF
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 08:06:08 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id B7DC2218A2;
        Tue, 31 May 2022 15:05:54 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E21F6218F4;
        Tue, 31 May 2022 15:05:53 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1654009554; a=rsa-sha256;
        cv=none;
        b=ibVfLRTj3aAGta+J6md9ysrOsw/C/KsUeRNXcObjPOdzH8t6W4d9pCB26ZCwQrfSN6ob4z
        aNX+fd6JZKT+xb/f2uYUiVuIiY+rWrNlXypnbv/DREz4NPOCAIdBZA9rgOWkRSvHYh8x3u
        yh8habmHlSukKu6u3ybZzsdqd0EP3qnNyNm3mFwk5R3HxH7anWrRofpNJ2yf5V58QFwRi7
        HyZTl/3S2X9oDcLE9M1jJL+5gZeb0x02oL5UKnhMVb18Dz2Z4xkzgDMh4nrSYxBX6STka1
        OQqekoSshWh7hjoAbX3cLjGI4CSqqzMNTSxbFYJwlllRZiTHpx4ZE7Qhl3BI0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1654009554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=epsgfZasHD+olmkvsbvkGIF/H7chCsQ/mpyAuTxmCvc=;
        b=P6WQA95s7see8FzdEOEJxQsbNxVCNihyUgarf+WXgLe5A+5QzAkZdeFi4aVtluBOoai8F5
        A5P8LakazVn7xpY4Hi/+FMO6ALXoU7gTrd2O0pbx2/WdPmNJY8RLeHzqtGOA54lTU9g+/i
        7Y1crkFyds++UG9tEL601Oy4i09gXD0JyBUieC2xjTAM4XeZDH5493Gg0pSY4xZjmhabAx
        CDzi5Z4fiQomNf7licNWmOndTwb66qhVCehUqTZT0r55N8CvvTFESte6hkG5GIwfAhE/qM
        ZDHNkY4GkKLMUhmNi8j9uAh22CxI/4443ecMxIFTJlzYmpWM4iq0KKGSyyL1rA==
ARC-Authentication-Results: i=1;
        rspamd-77f9f854d9-kc4pd;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Quick-Abaft: 665f0ae469671a1c_1654009554341_2433529739
X-MC-Loop-Signature: 1654009554341:2031530661
X-MC-Ingress-Time: 1654009554341
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.96.96.15 (trex/6.7.1);
        Tue, 31 May 2022 15:05:54 +0000
Received: from offworld (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LCFw05XNyz3T;
        Tue, 31 May 2022 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1654009553;
        bh=epsgfZasHD+olmkvsbvkGIF/H7chCsQ/mpyAuTxmCvc=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=lebbaM8oBt9lVx66htUo9zKinbncIRM/Z4JtFHc3ATd3QDDdl+XcNV7Cd0aoW4t+l
         rfWt708CS3btGcwQqbcrBd0W4u3fy2egtjELLY9BOZKUIMCznLm9i2voKnpe9sXNVP
         NXgv+kikqc7qDBZbve5MnXJXaUdpxCYYx47G9t7nZUixovVJ3AuHHKxO8SaWRbvCXm
         KM3LUBiR6xyy3GQr46xr6MqNs5RgNcHFff7kWSxVaeab0IaH82zx7dgV+29yg34Wkg
         BPjnjHwaJbaQ6c7gEbCCB0les2QY8nbPE1iTjwDPkPlCFVxJHaao4CMX39p04oDTkQ
         pKFwMOup1juXQ==
Date:   Tue, 31 May 2022 07:52:31 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     John Garry <john.garry@huawei.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, bigeasy@linutronix.de, tglx@linutronix.de
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
Message-ID: <20220531145231.opypdzrlrg23ihil@offworld>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
 <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
User-Agent: NeoMutt/20220408
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 31 May 2022, John Garry wrote:
>Question: Can there be any good reason to do this?

Removing tasklets altogether, albeit perhaps a pipe dream.

Thanks,
Davidlohr
