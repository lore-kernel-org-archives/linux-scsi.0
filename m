From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Wed, 7 Jan 2015 15:31:50 +0100
Message-ID: <20150107143150.GC659@lst.de>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de> <1420583956.6927.61.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59758 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbbAGOby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2015 09:31:54 -0500
Content-Disposition: inline
In-Reply-To: <1420583956.6927.61.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, Jan 06, 2015 at 02:39:16PM -0800, Nicholas A. Bellinger wrote:
> The fabric_max_sectors=8192 value is already being exposed by target in
> block limits EVPD as MAXIMUM TRANSFER LENGTH.
> 
> I'm guessing that since the host side support was not added until June
> 2014 in commit bcdb247c by MKP, Stefan is likely using an earlier
> initiator that is not honoring this value.

If I understand Stefan correct he was using a recent 3.19-rc kernel,
which contains my commit in the subject that stops capping the
max_sectors used by the kernel below that which the hardware supports.

Given that LIO actually implements the block limits EVPD that suggests
we're not properly using that information.

Stefant, what does:

sg_vpd -p bl /dev/sdX

for the LIO device tell?
