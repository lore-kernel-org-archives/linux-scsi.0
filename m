From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] scsi: Add EH Start Unit retry
Date: Tue, 03 Apr 2007 08:20:37 -0500
Message-ID: <461254A5.6000409@linux.vnet.ibm.com>
References: <11751999513070-patch-mail.ibm.com>  <460C375F.1000000@torque.net> <46115234.20308@us.ibm.com> <1175569791.3680.94.camel@mulgrave.il.steeleye.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35545 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966166AbXDCNVn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Apr 2007 09:21:43 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l33DLgT1001384
	for <linux-scsi@vger.kernel.org>; Tue, 3 Apr 2007 09:21:42 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l33DKdS6273406
	for <linux-scsi@vger.kernel.org>; Tue, 3 Apr 2007 09:20:39 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l33DKc1q009081
	for <linux-scsi@vger.kernel.org>; Tue, 3 Apr 2007 09:20:39 -0400
In-Reply-To: <1175569791.3680.94.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com

James Bottomley wrote:
> On Mon, 2007-04-02 at 13:57 -0500, Brian King wrote:
>> I agree. The reason the ipr adapter firmware added this UA
>> in this configuration was to support SCSI 1 reservations and
>> communicate to the host that any reservation previously
>> held to the disk array is now lost since the adapter was reset.
> 
> For that particular case, scsi_report_bus_reset() was the original
> design concept ... it's asynchronous when the problem occurs ... if you
> have to wait until UA, you don't necessarily find there's a problem
> until much later.

Right. One of the ipr patches in my queue is to call scsi_report_bus_reset
for the logical disk array bus after the adapter is reset, so that scsi core
knows about this reset and it can handle the UA, although this patch is
obviously still needed even with that change... 

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
