From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 19 Jun 2007 19:46:26 -0700
Message-ID: <1182307586.10507.7.camel@mulgrave.il.steeleye.com>
References: <200706191025.30986.swen@vnet.ibm.com>
	 <20070619171217.GA30099@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36842 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754610AbXFTEy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2007 00:54:26 -0400
In-Reply-To: <20070619171217.GA30099@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Swen Schillig <swen@vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, christof.schmitt@de.ibm.com

On Tue, 2007-06-19 at 18:12 +0100, Christoph Hellwig wrote:
> fcp_lun is an unsigned long long (and should be a __be64), so casting
> this to a struct type is not very nice.  Care to add a version that
> takes
> a __be64 intead?  In fact using that variant in scsi_scan.c might be
> benefical aswell, so you could aswell just convert over the existing
> scsilun_to_int. 

Actually, I don't think this is necessary for zfcp: all of these lun
values are input by a user and translated using a strtoull() so it's
going to get highly confusing trying to keep the be64 label [whether
it's desirable for s390 people to be entering BE LUN values is another
matter].  I'd really rather not encourage the use of __be64 u64 for SCSI
luns because it's asking for alignment issues ... instead, the internal
struct scsi_lun contains all the necessary information, and is a stream
of u8 in bus order.

James


