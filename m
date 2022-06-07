Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2781C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 16:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344909AbiFGQNK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344936AbiFGQNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 12:13:08 -0400
Received: from bee.birch.relay.mailchannels.net (bee.birch.relay.mailchannels.net [23.83.209.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410EC2FE5F
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 09:13:04 -0700 (PDT)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id C7AAE81B35;
        Tue,  7 Jun 2022 16:13:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a312.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 6C1D181FC1;
        Tue,  7 Jun 2022 16:13:03 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1654618383; a=rsa-sha256;
        cv=none;
        b=EDx/qlD7CW+nO7b8zDXgnFV5FNa3eZAqEy0rBigd0e9G0J89qmaddQF1a6JWV2htrYFXgc
        geePOGCOZwUz6YwgCvq0V46zpCKBLvfLngMyOxC1ZUz2w3sm4PyDbOBH7mgTB05MuUzKSY
        ZSEcEUNLoCLYRP/xAlEJY+PJDVHOOOfaD6079sD5qZdc+aizYtXPVvqzOJeVDXW0NeQfXH
        E00H9X98Z5B3YJxnhT/XQILsrxk6zSS1IUPlu8Zeba/CCNogY9CrWoL0CoQPLLcoNIU7zX
        gm9P30fe+C9b3hNaZXesylBfPSDBhfhPoDW4jlpRJU1W4bZSWHtTwZP41bXg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1654618383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=VP4dZVsWW3+pOxEsWUamkQfEFZJbgA3IpLzPwMcQP2A=;
        b=qdCAfJPV5c1TvCw1GUK6sBQClf1HGVe81Emp50/LpTl4qAStTkk5O29pRB8Pk5pivhE2xj
        K2rRKlkFePI2mfGPcAnGxUmU9FMZI17zu5k7Ni75p2/8XisrTFOL+AOze1wHRdKWWezaS/
        YcEEE9SO5SazNI1ghWe52fY6XYhQX3hOBRGslCO7yBJ30WOE8w634RCZ4aw5tSL1/toiIF
        l51wRoTX6ltSmGVuR8KpelNMHDGfzYczgzt11qgcfU208Nr0eHEss/mIF7K9Ac+uLfAm1t
        j0DdlzhSkBs1pkxSTcwD7RxtUadU5LQQRBxVZc4NayGpcsd4pawRzvShxJi2Og==
ARC-Authentication-Results: i=1;
        rspamd-848669fb87-jdfmx;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Wipe-Dime: 0b7f0db15cf7b57a_1654618383569_3684172013
X-MC-Loop-Signature: 1654618383569:1855903361
X-MC-Ingress-Time: 1654618383568
Received: from pdx1-sub0-mail-a312.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.116.106.98 (trex/6.7.1);
        Tue, 07 Jun 2022 16:13:03 +0000
Received: from offworld (unknown [104.36.31.105])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a312.dreamhost.com (Postfix) with ESMTPSA id 4LHb4G5bZpz6m;
        Tue,  7 Jun 2022 09:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1654618383;
        bh=VP4dZVsWW3+pOxEsWUamkQfEFZJbgA3IpLzPwMcQP2A=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=IxMBQjYTq7AZXzcc8pXQrCORE4AYcNYOE59PzECzSTj6jgt6S1T6SvzrF5Q4iSfaT
         GuR9PNXvyjTDQ1HSV06Kea6qzFqc/c+1IyH8oIKjDsof1GSv1kU0Q/8wHHpp/e6Wfm
         wurSwCRRPQ0fx5HHg06MtKJfuCsspcmBXSd8VH3UIXs2mqyjAyq/riN/DhYMJWgSg+
         NCSvp7RKQgk8oQAdDIqIfJTSrTiOPCGNVMeUeiU/Q+Ou5gjLATyClMcdyXH2i8LdgN
         IA/oDn4wMOWjN4ULmCVOpqislMHAxOUBmTMU0nhxpeEakws1ejM3yDCce7/NFS6wBV
         SLHSAotI5psvg==
Date:   Tue, 7 Jun 2022 08:59:18 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 00/10] scsi: Replace tasklets as BH
Message-ID: <20220607155918.i5f7pkqadeiuaqpn@offworld>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <YphtdGbu2rhx4RaQ@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YphtdGbu2rhx4RaQ@linutronix.de>
User-Agent: NeoMutt/20220429
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thanks for the careful reviewing and feedback. I'll address
them in a v2 as soon as I get a chance.

Thanks,
Davidlohr
