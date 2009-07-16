From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 14:33:34 +0300
Message-ID: <4A5F100E.9000107@panasas.com>
References: <alpine.DEB.1.10.0907151801040.9159@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:6216
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752644AbZGPLdh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 07:33:37 -0400
In-Reply-To: <alpine.DEB.1.10.0907151801040.9159@asgard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On 07/16/2009 04:09 AM, david@lang.hm wrote:
> is there any way to get deterministic device ordering with scsi async 
> scanning?
> 
> currently (2.6.30) it seems that the various scsi busses are loaded in the 
> order that they are detected, which can vary from boot to boot depending 
> on how long it takes for the card to initialize.
> 
> would it be possible to detect the cards/drives, but not register them 
> until all the detection is complete so that they can be registered in a 
> deterministic order?
> 
> having two drives on two different controllers swap positions from boot to 
> boot makes it very painful. yes I can make an initrd that fixes this up in 
> user space by examining each drive and creating links to re-order them, 
> but this is a lot of work to fix randomization that can be prevented in 
> the first place.
> 
> David Lang

It is highly discouraged to setup any kind of system that depends
on device-names for block-devices. mounts have the mount by-label
or mount by-uuid. Any other subsystem should go by /dev/disk/by-id/*
slinks to find a persistent raw block-device. the id is generated
from characteristics inside the disk itself so it will be the same
no matter what host connection or bus it is connected too (almost).

This is because even if the boot order is consistent, the device-name
is so volatile in the life-span of a system. Did I boot with a removable
USB inserted. that camera or printer was on or off, disk was connected
to the other port. Any such change will break things and give you a very
poor user experience.

I would say that "scsi async" is a grate blessing

Boaz
