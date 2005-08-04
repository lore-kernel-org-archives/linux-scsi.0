From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/2] cpqfc: fix for "Using too much stach" in 2.6 kernel
Date: Thu, 4 Aug 2005 00:49:11 -0400
Message-ID: <20050804044911.GB26949@redhat.com>
References: <4221C1B21C20854291E185D1243EA8F302623BCC@bgeexc04.asiapacific.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37565 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261817AbVHDEtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2005 00:49:19 -0400
Content-Disposition: inline
In-Reply-To: <4221C1B21C20854291E185D1243EA8F302623BCC@bgeexc04.asiapacific.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Saripalli, Venkata Ramanamurthy (STSD)" <saripalli@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Thu, Aug 04, 2005 at 10:09:51AM +0530, Saripalli, Venkata Ramanamurthy (STSD) wrote:
 > -          ULONG ulFibreFrame[2048/4];  // max DWORDS in incoming FC

This is 512 ulongs, which is 2KB.

 > +	  ulFibreFrame = kmalloc((2048/4), GFP_KERNEL);

You're replacing it with a 512 byte buffer.

		Dave

