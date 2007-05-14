From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] FC Transport support for vports based on NPIV
Date: Mon, 14 May 2007 14:12:40 +0200
Message-ID: <20070514121239.GA23620@schmichrtp>
References: <1176408091.19824.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:51129 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbXENMNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 08:13:33 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.8/8.13.8) with ESMTP id l4ECDSEx265202
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 12:13:28 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4ECDHE24046862
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 14:13:23 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4ECD3Uf016678
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2007 14:13:07 +0200
Content-Disposition: inline
In-Reply-To: <1176408091.19824.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, duane.grigsby@qlogic.com

James,

i try to understand what the introduction of the vports means for zfcp, since
this driver also supports NPIV. The documentation for the fc transport class
describes a driver that would fully control the adapter and the creation of
virtual address. Since you mentioned Xen, i assume that this could be a dom0.

With zfcp, the hardware FCP adapter does NPIV and only hands out the virtual
address to individual Linux instances. zfcp gets the assigned virtual address
for the Linux instance. This address is used for allocating the scsi_host
structure. Basically, the whole system uses NPIV, but each Linux only uses one
assigned virtual WWPN.

My current understanding is that the vports introduced in the fc transport
class do not affect the Linux systems that only use one virtual address.  To
map this to Xen, the dom0 would use the vports to show all virtual address, and
each domU would use the assigned virtual address without showing the vport in
sysfs. Is this correct?

Christof
