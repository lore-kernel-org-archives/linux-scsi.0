Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85688C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 20:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5966661168
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 20:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhDBUPj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 16:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231443AbhDBUPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 16:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617394533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AVEmdsO2TJYV9geMBZ8cCyAkgIpfjx8kxLHfSM1/18Y=;
        b=TEJQXiuSvLPe4SMifh1fuMPX+9ALDccp5KhzZ/JTQHKkvrS2j8f1gLyMxVdsQan/tKnBBg
        CpaKUOCktO5AZRMbaR2mJ6R7Lsj1JDV1HIlB9xoL5cz4jYhJm38rARuQRneZa7yxybNZcg
        0uXIcr9dFJ5Fq3YFV3hCN4jAwnGoq9U=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-wMRMd45lP7CWezlVXraM_A-1; Fri, 02 Apr 2021 16:15:30 -0400
X-MC-Unique: wMRMd45lP7CWezlVXraM_A-1
Received: by mail-qv1-f69.google.com with SMTP id j3so5810777qvo.1
        for <linux-scsi@vger.kernel.org>; Fri, 02 Apr 2021 13:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AVEmdsO2TJYV9geMBZ8cCyAkgIpfjx8kxLHfSM1/18Y=;
        b=U2ifkB6tqhhEGuGP1xw3kZp6aeyXd45/XYGn8NnpRsVRK3+8pr43Z7w5ZKKY4umVfW
         rvxwk8lAhjsi+DYSXAj2csMzx/aaVwcQqS2UxQ1VVfsvzvutgtTfi7DuQQrcQ35/Sxxs
         q2FYyb0pxxZGsOcoDwv/BzpK01KpEbqjyt53l1bK6Jg/TUx56x6twgqhCb04o5mpHWfk
         rVj8jkjabMo1+Hj0DQBejXIYcuW2IzXNhVkzTIRELq156B1MYmRLUtFPAdLOWjcYXXbZ
         Kc8mG2G+DFi1hxBAMGYfnA5mI+PG/og9v2ms/bkeggksyvS4+hW170ZZhqBgVcFdn7NG
         3Ung==
X-Gm-Message-State: AOAM533txFQCl31S8xvZLL7DtxzdW/CtV4YnGCHMjH8KfrBWpruf2eTe
        BfObybeAtkVlHw6mHTiWs+7vSSRQt1dHnVzT9zSjoM4bP3AXfmcA1jfKzYdEqx+KSg0mK3VCQQC
        xFER9292bkxbTgn41Wo7I4Q==
X-Received: by 2002:ac8:4d02:: with SMTP id w2mr12590032qtv.126.1617394529592;
        Fri, 02 Apr 2021 13:15:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/39cdUZC9t4K6LFU9F3KRKlbMf3w8lMTSlfqeOar37TsFy/Db3y2VPTeWHq2MCNMKFFV9GQ==
X-Received: by 2002:ac8:4d02:: with SMTP id w2mr12590011qtv.126.1617394529361;
        Fri, 02 Apr 2021 13:15:29 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id h11sm7398284qtp.24.2021.04.02.13.15.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Apr 2021 13:15:28 -0700 (PDT)
Message-ID: <881ff1e6ac12fc73d10d0119dfa36b1ed3d71a21.camel@redhat.com>
Subject: Re: [PATCH] scsi: scsi_transport_srp: don't block target in
 SRP_PORT_LOST state
From:   Laurence Oberman <loberman@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>
Date:   Fri, 02 Apr 2021 16:15:27 -0400
In-Reply-To: <af2a5e04-8ed8-f33c-68f9-84483c18e2d5@acm.org>
References: <20210401091105.8046-1-mwilck@suse.com>
         <af2a5e04-8ed8-f33c-68f9-84483c18e2d5@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-04-02 at 12:38 -0700, Bart Van Assche wrote:
> On 4/1/21 2:11 AM, mwilck@suse.com wrote:
> > rport_dev_loss_timedout() sets the rport state to SRP_PORT_LOST and
> > the SCSI target state to SDEV_TRANSPORT_OFFLINE. If this races with
> > srp_reconnect_work(), a warning is printed:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 

Indeed I have seen this while running rapid resets in my lab. Was not
sure if it was something I was doing or a real bug.

For example this script will bring it out if I lower the delay
#!/bin/bash
#on ibclient server in /sys/class/srp_remote_ports, using echo 1 >
delete for the particular port will simulate a port reset.

#/sys/class/srp_remote_ports
#[root@ibclient srp_remote_ports]# ls
#port-1:1  port-2:1
for d in /sys/class/srp_remote_ports/*
do
	echo 1 > $d/delete
sleep 60
done

Looks correct, and anyway Bart agrees so:

Reviewed-by:
Laurence Oberman <loberman@redhat.com>


