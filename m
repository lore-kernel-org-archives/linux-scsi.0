From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 03 Dec 2003 15:19:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070486359.1984.51.camel@mulgrave>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<03120319364802.02505@naveenb-lnx.cisco.com>
	<1070464184.1771.33.camel@mulgrave>
	<yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
	<20031203175417.GA893@beaverton.ibm.com>
	<yquj4qwh3a29.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:32261 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261837AbTLCVUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 16:20:48 -0500
In-Reply-To: <yquj4qwh3a29.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Wed, 2003-12-03 at 14:45, Clay Haapala wrote:
> A couple of related SCSI (not necessarily iSCSI) questions:
> 
> "If the allowed count has not been exceeded" - The first two commands
> after a connection has been estabilished will fail with
> Unit_Attention. What if that first command then also gets a crc error
> (Aborted_command)?  Will the retry count be large enough?

Yes and it may not be, that's why I think we give you a DID_ code that
doesn't affect the retry count.

> Does the retry also apply to tape?  Without proper tape error
> recovery, retrying the command could result in duplicate records
> written to tape.

Yes.  That's another good reason for not adding too much to the generic
sense processor.  At the moment, the only retry that tape might not be
happy about is MEDIUM_ERROR.

James


