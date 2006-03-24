From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device driver.
Date: Fri, 24 Mar 2006 12:17:53 +0000
Message-ID: <1143202673.18986.5.camel@localhost.localdomain>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>
	 <4421D943.1090804@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32423 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932503AbWCXML1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Mar 2006 07:11:27 -0500
In-Reply-To: <4421D943.1090804@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ian Pratt <m+Ian.Pratt@cl.cam.ac.uk>, Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, Ian Pratt <ian.pratt@xensource.com>, ian.pratt@cl.cam.ac.uk, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mer, 2006-03-22 at 18:09 -0500, Jeff Garzik wrote:
> An IBM hypervisor on ppc64 communicates uses SCSI RPC messages.  I think 
> this would be quite nice for Xen, because SCSI (a) is a message-based 
> model, and (b) implementing block using SCSI has a very high Just 
> Works(tm) value which cannot be ignored.  And perhaps (c) SCSI target 
> code already exists, so implementing the server side doesn't require 
> starting from scratch, but rather simply connecting the Legos.

A pure SCSI abstraction doesn't allow for shared head scheduling which
you will need to scale Xen sanely on typical PC boxes. SCSI emulations
are also always full of bits people got wrong, often critical bits like
tagged queues and error sequences - things that break your journalled
file system.


