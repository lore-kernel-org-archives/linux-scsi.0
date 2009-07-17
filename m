From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: Recommended HBA management interfaces
Date: Fri, 17 Jul 2009 10:35:49 -0500
Message-ID: <4A609A55.9040404@linux.vnet.ibm.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:34902 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789AbZGQPjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2009 11:39:35 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n6HFZB19027136
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 09:35:11 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6HFZsuA112850
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 09:35:55 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6HFZp6m027149
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2009 09:35:51 -0600
In-Reply-To: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Mukker, Atul wrote:
> Hi All,
> 
> We would like expert comments on the following questions regarding
> management of HBA from applications.
> 
> Traditionally, our drivers create a character device node, whose
> file_operations are then used by the management applications to
> transfer HBA specific commands. In addition to being quirky, this
> interface has a few limitations which we would like to remove, most
> important being able to seamlessly handle asynchronous events with
> data transfer.
> 
> 1. What is (are) the other standard/recommended interfaces which
> applications can use to transfer HBA specific commands and data.

Depends on what the commands look like. With ipr, the commands that
the management application need to send to the HBA look sufficiently
like SCSI that I was able to report an sg device node for the adapter
and use SG_IO to send these commands.

sysfs, debugfs, and configfs are options as well.


> 2. How should an LLD implement interfaces to transmit asynchronous
> information to the management applications? The requirement is to be
> able to transmit data buffer as well as notifications for events.

I've had good success with netlink. In my use I only send a notification
to userspace and let the application send some commands to figure out
what happened, but netlink does allow to send data as well. It makes it very
easy to have multiple concurrent readers of the data, which I've found very
useful.

> 3. The interface should be able to work even if no SCSI devices are
> exported to the kernel.

netlink allows this.

> 4. Should work seamlessly across vmware and xen kernels.

netlink should work here too.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


