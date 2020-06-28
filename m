Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B9EC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12072204EA
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="dN0e/O1J";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="yVEUycbW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgF1ScS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 14:32:18 -0400
Received: from fourecks.uuid.uk ([147.135.211.183]:53084 "EHLO
        fourecks.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgF1ScS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 14:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EmGRDwzXYyrRKHmxgqMp+SlhJvcVmdcX/2jLPUH2gdY=; b=dN0e/O1JdmXcxE4WpKcOasWOJ2
        bDhlDt85+BnvqFTDmM4XXu95ME3M/vX+NV7KgVW4xzyuB07zjruAwfCkoPeVAfE/tqLiGCbW84JU2
        3lrYqdAPq8uJwkGdoCZXZuN4qqZrXVZSTNBWh9M6mWmFCuE4PKgHAM7QSG/OzqnotWKrLl0VKZnmR
        1Q4QgbRF9TFsJaAF8+OWHPLz7NcckYuduT1wECdqX4GgMKB1YbCsjvIQV9Sv3yeqjsNmKc+v6s7va
        xbp1C6SMZIS1rBjT347tNggTAPJwsm0VEzvm5Ispwjh8Oq9XHRpMR+uytM4+86xt2Vs+giuRfbhXi
        b1G8mZSw==;
Received: by fourecks.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jpc5y-000652-9A; Sun, 28 Jun 2020 19:32:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject;
        bh=EmGRDwzXYyrRKHmxgqMp+SlhJvcVmdcX/2jLPUH2gdY=; b=yVEUycbW2baGmmDxnxjl/9efBf
        UPCzJ4AL7NuLlANH6UuUqf2X1120C6if2ejKqe3JhHg94TQWllRebyywcJoegNs/+ZDiXPxsXhkWU
        aC3Lkhmu6xxfCIPj6JIH+vJpooQjIimbhwdSwF+7UyXUzxrtp4sGafXi4zoGBUj8hPRBuJo3UDPhJ
        iE+waX/kU4PjDUnJQ80LazUOUewxLFiZErcFHlblFRAhWxqVwDXnaW1/Y6SYMQfe1+MJdzzLvDzhv
        jZku+jd/GUIEDOIZNCTcAjK6QCzHnUibxwmI7WD7NsNIPVjQvNqy60b5DD4dx8VdSJl25IzlM/c6i
        bkVaRNcA==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jpc5t-0007O6-Ot; Sun, 28 Jun 2020 19:31:58 +0100
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200623204234.GA16156@khazad-dum.debian.net>
From:   Simon Arlott <simon@octiron.net>
Message-ID: <4e9c7e62-b1e4-80b0-8e22-9d57d3431f37@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sun, 28 Jun 2020 19:31:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623204234.GA16156@khazad-dum.debian.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/06/2020 21:42, Henrique de Moraes Holschuh wrote:
> [1] I have long lost the will and energy to pursue this, so *this* is a
> throw-away anecdote for anyone that cares: I reported here a few years
> ago that many models of *SATA* based SSDs from Crucial/Micron, Samsung
> and Intel were complaining (through their SMART attributes) that Linux
> was causing unsafe shutdowns.
> 
> https://lkml.org/lkml/2017/4/10/1181
> 
> TL;DR: wait one *extra* second after the SSD acknowleged the STOP
> command as complete before you trust the SSD device is safe to be
> powered down (i.e. before reboot, suspend, poweroff/shutdown, and device
> removal/detach).  This worked around the issue for every vendor and
> model of SSD we tested.

Looking through that thread, it looks like a simple 1 second delay on
shutdown/reboot patch hasn't been proposed yet?

In my case none of the SSDs are recording unexpected power loss if they
are stopped before the reboot, but the reboot won't necessarily be
instantaneous after the last stop command returns.

-- 
Simon Arlott
