Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D92CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 17:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAFDD20650
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 17:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RMhe8mQH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OH8f4sto"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410208AbfJXRF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 13:05:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410205AbfJXRF6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 13:05:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2275E616CD; Thu, 24 Oct 2019 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571936758;
        bh=LzE///rHExRVgk+RnJGks/bQmYQI1qFeZEg28IUoTfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RMhe8mQHCuslB7SFBa1+dEpu/52Qio1InZv11y7cBchOAgiXT2DobhiD2Voj2pL2Z
         qOj3UoTyXtuNtZEC9OLx+NI/cuVT0fkN55/tuZAYd7WIrMp6Y3TDIbN4M/Ae9Y/j/K
         5BuwJqqTM4N6Q0LK/bNlHFYiR66SY4IZzZjlw9uI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 87486616C0;
        Thu, 24 Oct 2019 17:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571936757;
        bh=LzE///rHExRVgk+RnJGks/bQmYQI1qFeZEg28IUoTfM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OH8f4stoZ3R3MXq2Xre+aJJvCYo1YKGYZo5DuZX4SwTojuWo8MLnYkoF/6A2Bq4pU
         aYG6Lz4nbAMMx0cvDuABhagd/YzEpssltC+t46FGl7dW9yUr6rk4XTveGEm7Vv11Ec
         uHGhkpnRmxnj9TJWPbkN0lqkfXqmOFbSk3/mvJrY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Oct 2019 10:05:57 -0700
From:   asutoshd@codeaurora.org
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org
Subject: Re: Query: SCSI Device node creation when UFS is loaded as a module
In-Reply-To: <d2804026-7908-4601-3216-e60d51131984@linux.ibm.com>
References: <468eb805fa69da76c88a0a37aa209c7f@codeaurora.org>
 <d2804026-7908-4601-3216-e60d51131984@linux.ibm.com>
Message-ID: <e1d00a73efd3b73adae441ff5e00c4b4@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-24 02:50, Steffen Maier wrote:
> On 10/24/19 1:51 AM, asutoshd@codeaurora.org wrote:
>> Hi
>> I'm loading the ufs-qcom driver as a module but am not seeing the 
>> /dev/sda* device nodes.
>> Looks like it's not being created.
>> 
>> I find the sda nodes in other paths being enumerated though:
>> 
>> / # find /sys -name sda
>> /sys/kernel/debug/block/sda
>> /sys/class/block/sda
>> /sys/devices/platform/<...>/<xxx>.ufshc/host0/target0:0:0/0:0:0:0/block/sda
>> /sys/block/sda
>> 
>> All Luns are detected and I see sda is detected and prints for all the 
>> Luns as below -:
>> sd 0:0:0:0: [sda] .... ....-byte logical blocks:
>> 
>> ... so on ...
>> 
>> But if I link it statically instead of a module, it works fine. All 
>> device nodes are created.
>> 
>> I'm trying to figure out where/how in SCSI does it create these device 
>> nodes - /dev/sd<a/b/c/d> ?
> 
> That's from (systemd-)udevd user space based on uevents from the 
> kernel.
> 
>> I've looked into sd.c but I couldn't figure out the exact place yet.
> 
> Yeah, based on the SCSI device probe and add lun, the high level
> driver sd would emit udev events for block devices.

Thanks Steffen and Avri.

I understood that sd.c creates the devices based on scsi_device and 
establishes a relation between scsi_device (sdp) and scsi_disk (sdkp).
But I couldn't figure out why it creates the device fine when the 
ufs-qcom is linked statically, but is unable to create the devices when 
inserted as a module.

Does it follow a different method to create the device nodes when 
statically linked and needs (systemd-)udevd to handle the events during 
dynamic insertion?

Thanks
asd
