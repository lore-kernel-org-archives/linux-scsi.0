From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 03 Dec 2003 15:14:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070486082.1771.48.camel@mulgrave>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<03120319364802.02505@naveenb-lnx.cisco.com>
	<1070464184.1771.33.camel@mulgrave>
	<yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
	<20031203175417.GA893@beaverton.ibm.com>
	<yqujiskx3apj.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:22021 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261411AbTLCVQK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 16:16:10 -0500
In-Reply-To: <yqujiskx3apj.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Wed, 2003-12-03 at 14:31, Clay Haapala wrote:
> In discussions around here it was pointed out that the driver should
> *not* retry on COMMAND ABORT situations, rather let the upper layers
> handle it.  A retry at the driver level might be outright incorrect in
> the case of tape devices, for instance.

I agree.  I didn't mean handle the command retry internally, but
translate the sense internally to a DID_ code (rather than relying on us
to modify the sense parser).  We could actually give you one which would
do an immediate retry without decrementing the retries count (for crc
conditions you new shouldn't contribute to the retry processing), say
DID_IMMEDIATE_RETRY.

James


