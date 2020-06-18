Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7B6C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 12:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 680C92080D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 12:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="i409kKuw";
	dkim=pass (2048-bit key) header.d=octiron.net header.i=@octiron.net header.b="u//XLbv1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgFRM2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 08:28:02 -0400
Received: from fourecks.uuid.uk ([147.135.211.183]:43798 "EHLO
        fourecks.uuid.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgFRM0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 08:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GwpwYN7fcjVD5JOBtRDLYYGkzTdld4atRJZPVH9CT8o=; b=i409kKuweWdj5i+yO300qD9UM9
        ogf5WGJ0wNz9RF8USD87C2lkiPmylOiocyPhc0flTIFGFEZOt9zAwTNhaAGT5j6f0BioTj49Sdxte
        1uvOmKX9u0/IA/DrpmBbVDO/Wu0pwYutwbDgy5uKEmze5ZIotk5iVSbjpSJ902LYGtjvOuFH6AAA/
        0vglcFdFcci4V9m5505JULMPYtu0IcAXg5abJzqT/ddeInMHXSNenvTcmoz1iH7D+gDA2t8JTiQC6
        TLkkp1RMHTWNqfih6N+/3sVQUlX+vjRUdb5dqxq9L8EL1axrc682ZcgFNI8+aS3lPE8p3Zqq9sHEU
        mPt2JIpg==;
Received: by fourecks.uuid.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <simon@octiron.net>)
        id 1jltcD-0003Fq-Vh; Thu, 18 Jun 2020 13:26:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=octiron.net
        ; s=20180214; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject;
        bh=GwpwYN7fcjVD5JOBtRDLYYGkzTdld4atRJZPVH9CT8o=; b=u//XLbv1oTe1N+cIA92I5Isk9E
        HxRwpuhsmswk3V023bPznux8shzpvpkbjrksH4GPK/l1hpYAi27aj7MtpWqL7wldlaVtUKaWxMPO0
        pwniabl17tIVkkMyzPQG+P3qkZTaQciuEwG39U6iQlZPFoniMukTU1HLwOOoshogmVBYKqPYZKH1K
        jIj5awZyrW/2pBBnijyOKvnaOet8I4l1GM3nmhRtnq/m5e9bPt5Q8EWERFfuSBMbrZE9doXyuMo5x
        b8nX+oCi0dulpMDnDLXqI0udfj+pQFfiMZiVjbBvQ7x2jUxjfQpb7YbST1Zq0G+SrkZmGMGOok+aJ
        aIjoGEFA==;
Received: by tsort.uuid.uk with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <simon@octiron.net>)
        id 1jltcC-0005s7-9F; Thu, 18 Jun 2020 13:25:56 +0100
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
From:   Simon Arlott <simon@octiron.net>
Message-ID: <18da4d78-f3df-967f-e7ea-8f2faaa95d6b@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Date:   Thu, 18 Jun 2020 13:25:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/06/2020 09:36, Damien Le Moal wrote:
> On 2020/06/18 3:50, Simon Arlott wrote:
>> I need to use "reboot=p" on my desktop because one of the PCIe devices
>> does not appear after a warm boot. This results in a very cold boot
>> because the BIOS turns the PSU off and on.
>> 
>> The scsi sd shutdown process does not send a stop command to disks
>> before the reboot happens (stop commands are only sent for a shutdown).
>> 
>> The result is that all of my SSDs experience a sudden power loss on
>> every reboot, which is undesirable behaviour. These events are recorded
>> in the SMART attributes.
> 
> Why is it undesirable for an SSD ? The sequence you are describing is not
> different from doing "shutdown -h now" and then pressing down the power button
> again immediately after power is cut...

On a shutdown the kernel will send a stop command to the SSD. It does
not currently do this for a reboot so I observe the unexpected power
loss counters increasing.

> Are you experiencing data loss or corruption ? If yes, since a clean reboot or
> shutdown issues a synchronize cache to all devices, a corruption would mean that
> your SSD is probably not correctly processing flush cache commands.

No, I'm not experiencing any data loss or corruption that I'm aware of.

We can argue whether or not any given SSD correctly processes commands
to flush the cache, but they are expecting to be stopped before power
is removed.

>> Avoiding a stop of the disk on a reboot is appropriate for HDDs because
>> they're likely to continue to be powered (and should not be told to spin
>> down only to spin up again) but the default behaviour for SSDs should
>> be changed to stop them before the reboot.
> 
> If your BIOS turns the PSU down and up, then the HDDs too will lose power... The
> difference will be that the disks will still be spinning from inertia on the
> power up, and so the HDD spin up processing will be faster than for a pure cold
> boot sequence.

I haven't verified it, but the BIOS leaves the power off for several
seconds which should be long enough for the HDDs to spin down.

I'm less concerned about those suddenly losing power but it would be
nice to have a stop command sent to them too.

-- 
Simon Arlott
