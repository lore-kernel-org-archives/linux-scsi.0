Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2BAC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D939E20760
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 18:23:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="ge3L2Z21";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="gjTDjK1M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgF1SXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 14:23:33 -0400
Received: from chalk.uuid.uk ([51.68.227.198]:40094 "EHLO chalk.uuid.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbgF1SXc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Jun 2020 14:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9t7pciCG1E0zNu4oQ07IGz0z9R7oHtfDQoBBiX267b8=; b=ge3L2Z21o6v6QhE6V8vf8PHHaI
        GPPBiT+BimpjU729m/lFlzwzazoG7yokcNllMERWmvbnI/2HothT9fTMAsOYbnvZGN0x2yWjSvVta
        gIjkEiQDIj/sOBDAfJaB47CvAujrh6v29/KPwi9lYV7DyvXQKHCD/FUHluLO6z8In1ltfzMY1b7WX
        OGe2PKLabGZ8R9nlW6lnbe99oabxggtPSYt8neQwXuJ2V0qC/qhZSwnO/Dwoe+jMOrQqS/OjDKttn
        asa12+EQBhMoou/zuU81+RP0iY0vf0grNimJk80iRa5m93b75wL43LaF1UZTmcokodn4aRrbSXWqJ
        5B3GVThg==;
Received: by chalk.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jpbxc-0008Dd-UA; Sun, 28 Jun 2020 19:23:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject;
        bh=9t7pciCG1E0zNu4oQ07IGz0z9R7oHtfDQoBBiX267b8=; b=gjTDjK1McY2HKRPXenMoIPdr2g
        V/8jNsz8CBGUYq0rAfsvxORqHMlWELQroUcuXgPKZfuo06GgtBH5G0SJ97dJRhtSXhvaU08FNaqWX
        FT2rf9cxcx6+jAL3fL28oVqSrsu0rvvajmm/ADMtrKsqnGHRL+CD1T3tF+ZWmEtd3PlnjimCUbDbK
        dsLELz3UDBc4qIBHNL6yIAAdt7iKFgqkStR27eKnrxTBQ+01wjgc0/nITcvivfMQqG1+qOyjOeCgF
        guSS0ecG5wcP/cKJuzn6rEVlVtd575iW38FYl4dgACf2ANm102SygKCJGe4YQa8Lj/9zkmg0etarC
        ZPVsWa3g==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jpbxa-0007F9-DC; Sun, 28 Jun 2020 19:23:23 +0100
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <18da4d78-f3df-967f-e7ea-8f2faaa95d6b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB375112FC181C9A625137DB94E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
From:   Simon Arlott <simon@octiron.net>
Message-ID: <fff9e48d-e9a5-632d-5d84-a0aaa68f92a9@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Sun, 28 Jun 2020 19:23:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB375112FC181C9A625137DB94E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/06/2020 00:31, Damien Le Moal wrote:
> On 2020/06/18 21:26, Simon Arlott wrote:
>> I haven't verified it, but the BIOS leaves the power off for several
>> seconds which should be long enough for the HDDs to spin down.
>> 
>> I'm less concerned about those suddenly losing power but it would be
>> nice to have a stop command sent to them too.
> 
> OK. So maybe the patch should be as simple as changing SYSTEM_RESTART state to
> SYSTEM_POWER_OFF if reboot=p is set, no ? Since that is consistent with the fact
> that reboot=p will cause power to go off, exactly the same as a regular
> shutdown, it seems cleaner and safer to use SYSTEM_POWER_OFF for the entire
> system, not just scsi disks.

That could be a bit misleading because the power isn't going to stay
off. Some of the network drivers have specific WOL behaviour changes
for a power off.

Power cycling the PSU is not something that every BIOS will do, so it's
not that simple. It could be a module parameter but I'd be concerned
that some other code will assuming the system should be powered off and
all of my reboots will become power off events.

-- 
Simon Arlott
