From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Mon, 6 Jun 2016 18:03:46 +0200
Message-ID: <2e9d3296-3da3-aef0-521c-d096daa37c21@redhat.com>
References: <1464702149-26573-1-git-send-email-emilne@redhat.com>
 <5755278E.8040002@suse.de> <1465222299.20724.114.camel@localhost.localdomain>
 <5755873E.5080303@suse.de> <4c7c1ec8-06bf-e2f5-c971-de82eb69fdb4@redhat.com>
 <69fd3238-fde2-90f3-2eb6-3f71a7317016@redhat.com>
 <92aeeb5e-9b36-339e-8e44-afb78adeac6e@redhat.com>
 <d84ec540-bfcb-8ce3-8615-bcfeb0271270@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbcFFQDx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2016 12:03:53 -0400
In-Reply-To: <d84ec540-bfcb-8ce3-8615-bcfeb0271270@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Snow <jsnow@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com
Cc: linux-scsi@vger.kernel.org



On 06/06/2016 17:47, John Snow wrote:
> > > Various downstreams may have backported the VPD fix to older versions,
> > > we need to be careful not to block those, too ... so targeting the core
> > > behavior seems like the more strictly correct, easily maintainable solution.
> > 
> > I think this is not practical.  I'm okay with the big hammer if an
> > algorithmic fix is not feasible; but otherwise it does seem a better
> > idea than blacklisting based on inquiry data...
> 
> You think the more practical solution is a SCSI driver that can hang
> because of an incorrect/missing response and to maintain a carefully
> curated blacklist to work around this behavior?

The best solution would be an algorithmic fix, perhaps predicated by
some kind of quirk bit.

A carefully curated blacklist is impossible because you cannot account
for a zillion downstreams, most of which probably don't change the
inquire vendor/product data; version numbers are awful.

Paolo
