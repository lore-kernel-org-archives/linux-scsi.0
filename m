From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUGFIX 2/2] gdth: bugfix for the Timer at exit crash
Date: Wed, 13 Feb 2008 09:44:28 -0600
Message-ID: <1202917468.3109.5.camel@localhost.localdomain>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38067 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762834AbYBMPod (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 10:44:33 -0500
In-Reply-To: <47B1DA2A.1060904@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Sven =?ISO-8859-1?Q?K=F6hler?= <skoehler@upb.de>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Joerg Dorchain <joerg@dorchain.net>, Jon Chelton <jchelton@ffpglobal.com>, Stefan Priebe - allied internet ag <s.priebe@allied-internet.ag>

On Tue, 2008-02-12 at 19:40 +0200, Boaz Harrosh wrote:
> -	gdth_flush(ha);
> -

This piece doesn't look right.  gdth_flush() forces the internal cache
to disk backing.  If you remove it, you're taking the chance that the
machine will be powered off without a writeback which can cause data
corruption.

James


