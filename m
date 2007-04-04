From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [patch 1/1] scsi: Disable short inquiry log by default
Date: Wed, 04 Apr 2007 13:18:13 -0500
Message-ID: <4613EBE5.40504@linux.vnet.ibm.com>
References: <200704022120.l32LKOZU018499@d03av02.boulder.ibm.com> <1175550136.3680.84.camel@mulgrave.il.steeleye.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50873 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667AbXDDSSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2007 14:18:16 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l34IIFvu032460
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2007 14:18:15 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l34IIEx9226436
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2007 14:18:14 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l34IIE2a024117
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2007 14:18:14 -0400
In-Reply-To: <1175550136.3680.84.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2007-04-02 at 16:20 -0500, brking@linux.vnet.ibm.com wrote:
>> If a scsi device reports less than 36 bytes of standard inquiry
>> data, scsi core logs a KERN_INFO printk indicating this. It was
>> observed that this results in lots of clutter in the log on
>> systems with devices that respond to a SCSI Inquiry with PQ=3 or
>> PQ=1 with less than 36 bytes of inquiry data, such as ibmvscsi.
>> Disable this log by default.
> 
> It shouldn't be doing this ... the standards are pretty clear, say SPC-3
> section 6.4.2
> 
> "The standard INQUIRY data shall contain at least 36 bytes"
> 
> Horrible things happen when this rule is violated (as it is by some
> badly constructed devices), so I'd really like to leave the print in so
> we know what we're debugging.
> 
> Can't you fix ibmvscsi to be standards compliant?

James,

You can drop this patch. I've verified that the current ibmvscsi server
does not do this. I wasn't using the latest ibmvscsi server implementation.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
