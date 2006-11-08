From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Wed, 08 Nov 2006 09:47:05 +0900
Message-ID: <20061108094705M.fujita.tomonori@lab.ntt.co.jp>
References: <454FAD72.6040103@torque.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:53457 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1752129AbWKHArP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Nov 2006 19:47:15 -0500
In-Reply-To: <454FAD72.6040103@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

From: Douglas Gilbert <dougg@torque.net>
Subject: RFC: SCSI Generic version 4 interface
Date: Mon, 06 Nov 2006 16:47:30 -0500

>                 SCSI Generic version 4 interface structure
>                 ==========================================
>                                              Version 1.1
> 
> Goals:

(snip)

>   - same structure can be used for a synchronous (e.g. interruptible
>     ioctl) or asynchronous (e.g. ioctl()/read() ) pass through.

Can you provide details on "asynchronous" part?

The scsi target code needs sg for:

- SAN gateway (like iSCSI to FC)

- SCSI device support in Xen (corresponds to raw device mapping in
VMware); enables domU to use SCSI devices. domU sends SCSI commands
via the virtual HBA driver to dom0 and then dom0 uses sg to perform
them.

The scsi target code uses the single user-space daemon so needs an
asynchronous interface, i.e. sends requests and receives the
completions asynchronously.
