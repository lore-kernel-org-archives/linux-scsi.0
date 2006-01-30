From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Large Sequential Reads Being Broken Up. Why?
Date: Mon, 30 Jan 2006 10:58:29 -0600
Message-ID: <1138640309.3283.9.camel@mulgrave>
References: <43DE2EB0.2040700@datadirectnet.com>
	 <43DE3BFD.3090902@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:39846 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964780AbWA3Q6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 11:58:40 -0500
In-Reply-To: <43DE3BFD.3090902@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: "Martin W. Schlining III" <mschlining@datadirectnet.com>, linux-scsi@vger.kernel.org

On Mon, 2006-01-30 at 11:17 -0500, James Smart wrote:
> As of 2.6.10, the kernel started paying attention to this field, which the
> emulex driver, as of that time, didn't set. The result was the kernel
> dropped back to a default max_sectors of 1024 - which results in a 512k max.
> The lpfc driver was updated in rev 8.0.29 with this change.
> 
> Caveat is : Even with this change, you must be using O_DIRECT to get high
> bandwidth. Otherwise, the upper layers will segment the requests (if I
> remember right, we had a hard time making a "normal" config exceed 256k).

Actually, please also remember that the maximum SG element list size is
128 in a normal kernel (depending on the driver ... some drivers set
lower limits as well), so on a very fragmented 4k page machine, you're
unlikely to get above 512k just because you run out of SG table entries
(obviously on 16k page machines, this goes up to 2MB, and if you're
lucky enough to have a fully functional IOMMU, this limitation won't
affect you at all).

James


