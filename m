Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7226AC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Feb 2023 16:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBPQkw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Feb 2023 11:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBPQkw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2023 11:40:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8874C4CC98;
        Thu, 16 Feb 2023 08:40:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3904DB828EE;
        Thu, 16 Feb 2023 16:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887BFC433D2;
        Thu, 16 Feb 2023 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676565648;
        bh=dz/6alTdHn2I5NxkOALw1FekhE9x9x60dVTsdIVdiPw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q1nyyh/s7tIzVQFmn/zl0zA46VYXIWOypnfsu+zwr3BvRZp/0/g/gRqT/gZ9bqyEI
         QVJilOJYrkWCLQe6tio/d+NK7zAj/TSPjzgaSlkpASbESMsBM/R8XpkxKpY68+wctX
         xS6oqbb4ZfzdYb+tI1baW7z6M2w8Vspfnhn6fF8Gf+taQWisNOFHUvmLhruFlJocYi
         0msbM17Qx/GmJD8g7PcxWs20AAqyNphMFZu3ityMMsiTdgzBcUOYFwzdQyzcmPMcn5
         MyJnHKZa+snTJVQIa3JUQl2cK6oH9HQPQgVzNCsuEL1kEbIKuXTUGPneD6XHeebv96
         FcDMqQUUdj2Ug==
Date:   Thu, 16 Feb 2023 09:40:44 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        lsf-pc@lists.linuxfoundation.org
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Message-ID: <Y+5cjPBE6h/IW9VH@kbusch-mbp>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 16, 2023 at 12:50:03PM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> it has come up in other threads, so it might be worthwhile to have its own
> topic:
> 
> Userspace command aborts
> 
> As it stands we cannot abort I/O commands from userspace.
> This is hitting us when running in a virtual machine:
> The VM sets a timeout when submitting a command, but that
> information can't be transmitted to the VM host. The VM host
> then issues a different command (with another timeout), and
> again that timeout can't be transmitted to the attached devices.
> So when the VM detects a timeout, it will try to issue an abort,
> but that goes nowhere as the VM host has no way to abort commands
> from userspace.
> So in the end the VM has to wait for the command to complete, causing
> stalls in the VM if the host had to undergo error recovery or something.

Aborts are racy. A lot of hardware implements these as a no-op, too.
 
> With io_uring or CDL we now have some mechanism which look as if they
> would allow us to implement command aborts.

CDL on the other hand sounds more promising.

> So this BoF will be around discussions on how aborts from userspace could be
> implemented, whether any of the above methods are suitable, or whether there
> are other ideas on how that could be done.
