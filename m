Return-Path: <SRS0=749Z=X4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03307C32792
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 21:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC4FD2133F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 21:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nCGIXYs/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbfJCVTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 17:19:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfJCVTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 17:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s1b1QGPWo7eGlMVA47KnxB99j3OasMbsofXzn7s2rTQ=; b=nCGIXYs/zPbQi81jAlWV8Cyrh
        oGXU1BMSQ/V1yShigPjKIADfQv8WKVH74v1w2STKF49cDsdrdU7eovb2BFMS92xFEgMIR7P2IZu7h
        Ep7e3MZIdA2BoPtENP9Aveo+cXefE/JKr5u0UdbjLY0+4xnmLdfEZEWtmmfIxKjkZqrNzCWXx5QWD
        oOz7nllUqE0+TiZVf0SBfj6UsXcQ36tIvVeLcJIVG5vQssSv6fowXcjm7o/NefoqI5VuM4BxkjkW4
        YjY/wiVpxvs/PMye/oVplA1w33nI0mOBF576aCA+wKCfD5ro+W2qwJ45UZsVmQLxeegWRcFJy9RMi
        zh2qdqsqQ==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iG8Vd-0001Ce-TT; Thu, 03 Oct 2019 21:19:37 +0000
Subject: Re: SCSI device probing non-deterministic in 5.3
To:     Bradley LaBoon <blaboon@linode.com>, linux-kernel@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <d2ff27ce-67b0-735e-8652-0e925d5f756c@linode.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f6d6622d-a9a0-d7de-b5af-b7a885ee1b61@infradead.org>
Date:   Thu, 3 Oct 2019 14:19:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d2ff27ce-67b0-735e-8652-0e925d5f756c@linode.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[add linux-scsi mailing list]

On 10/3/19 1:32 PM, Bradley LaBoon wrote:
> Hello, LKML!
> 
> Beginning with kernel 5.3 the order in which SCSI devices are probed and
> named has become non-deterministic. This is a result of a patch that was
> submitted to add asynchronous device probing (specifically, commit
> f049cf1a7b6737c75884247c3f6383ef104d255a). Previously, devices would
> always be probed in the order in which they exist on the bus, resulting
> in the first device being named 'sda', the second device 'sdb', and so on.
> 
> This is important in the case of mass VM deployments where many VMs are
> created from a single base image. Partition UUIDs cannot be used in the
> fstab of such an image because the UUIDs will be different for each VM
> and are not known in advance. Normally you can't rely on device names
> being consistent between boots, but with QEMU you can set the bus order
> of each block device and thus we currently use that to control the
> device order in the guest. With the introduction of the aforementioned
> patch this is no longer possible and the device ordering is different on
> every boot, resulting in the guest booting into an emergency shell
> unless the devices randomly happen to be loaded in the expected order.
> 
> I have created a patch which reverts back to the previous behavior, but
> I wanted to open this topic to discussion before posting it. I'm not
> totally familiar with the low-level details of SCSI device probing, so I
> don't know if the non-deterministic device order was the intended
> behavior of the patch or just a side-effect. If that is the intended
> behavior then is there perhaps some other way to ensure a consistent
> device ordering for a guest VM?
> 
> I am not subscribed to the list, so please CC me on any replies.
> 
> Thank you!
> Bradley LaBoon
> 


-- 
~Randy
