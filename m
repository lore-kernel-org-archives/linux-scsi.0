From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Fix scsi/scsi_transport.h compile error
Date: Mon, 31 Jul 2006 15:37:46 +0200
Message-ID: <44CE07AA.9030202@s5r6.in-berlin.de>
References: <200607310943.25384.eike-kernel@sf-tec.de> <20060731131446.GB6087@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:14772 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S932243AbWGaNlN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 09:41:13 -0400
In-Reply-To: <20060731131446.GB6087@athena.road.mcmartin.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 7/31/2006 3:14 PM, Kyle McMartin wrote:
> On Mon, Jul 31, 2006 at 09:43:25AM +0200, Rolf Eike Beer wrote:
>> scsi_transport.h defines the inline function scsi_transport_device_data()
>> that dereferences a pointer of "struct scsi_device *". Since the struct is
>> not known by the header this might break compilation.
> 
> This should be solved with a "struct scsi_device;" decl, instead of
> Yet More Header Dependancies...

That function accesses members of the struct, i.e. the compiler needs to
know offsets into struct scsi_device at this point. Therefore it needs
the definition, not a declaration.
-- 
Stefan Richter
-=====-=-==- -=== ==---
http://arcgraph.de/sr/
