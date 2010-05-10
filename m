From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [LSF/VM TOPIC] Handling of invalid requests in virtual HBAs
Date: Mon, 10 May 2010 12:16:19 +0900
Message-ID: <20100510121550W.fujita.tomonori@lab.ntt.co.jp>
References: <4BB45632.5020700@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44593 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab0EJDQb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 May 2010 23:16:31 -0400
In-Reply-To: <4BB45632.5020700@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org

On Thu, 01 Apr 2010 10:15:46 +0200
Hannes Reinecke <hare@suse.de> wrote:

> [Abstract]
> This discussion will focus on the problem of correct request handling with virtual HBAs.
> For KVM I have implemented a 'megasas' HBA emulation which serves as a backend for the
> megaraid_sas linux driver.
> It is now possible to connect several disks from different (physical) HBAs to that
> HBA emulation, each having different logical capabilities wrt transfersize,
> sgl size, sgl length etc.

The 'megaraid_sas' emulation HBA tells the guests about such
capabilities via the register, right?

If so, the problem is that how to do it with hotplug on the host?


> The goal of this discussion is how to determine the 'best' capability setting for the
> virtual HBA and how to handle hotplug scenarios, where a disk might be plugged in
> which has incompatible settings from the one the virtual HBA is using currently.
