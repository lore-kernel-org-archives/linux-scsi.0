From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]ibft: Fix the display of a few fields in the NIC
 attribute  structure in sysfs
Date: Wed, 15 Apr 2009 14:37:44 -0700
Message-ID: <20090415143744.84d6c598.akpm@linux-foundation.org>
References: <81083a450904110629j93c5c2j2c1250e9822c3888@mail.gmail.com>
	<1239472568.3416.11.camel@mulgrave.int.hansenpartnership.com>
	<200904120907.08828.ketuzsezr@darnok.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbZDOVnc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Apr 2009 17:43:32 -0400
In-Reply-To: <200904120907.08828.ketuzsezr@darnok.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ketuzsezr@darnok.org
Cc: James.Bottomley@hansenpartnership.com, ashutosh.naik@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pjones@redhat.com, konradr@linux.vnet.ibm.com, vishnu@chelsio.com

On Sun, 12 Apr 2009 09:06:59 -0400
Konrad Rzeszutek <ketuzsezr@darnok.org> wrote:

> > The second question is who picks this up?  The drivers/firmware
> > directory doesn't seem to have a dedicated tree, so I can take this
> > through the SCSI tree if required or Andrew can take it through -mm.
> 
> Which way works best for everybody? I was thinking SCSI, since the end result 
> of this module is to configure the storage used to bootstrap the box.

I can merge merge it later this week.

However...


: From: Ashutosh Naik <ashutosh.naik@gmail.com>
: 
: Fix the display of a few fields in the iBFT NIC attribute structure in
: sysfs.
: 
: Signed-off-by: Ashutosh Naik <ashutosh.naik@gmail.com>
: Cc: Vishnu V <vishnu@chelsio.com>
: Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
: ---
: 
:  drivers/firmware/iscsi_ibft.c |    4 ++--
:  1 file changed, 2 insertions(+), 2 deletions(-)
: 
: diff -puN drivers/firmware/iscsi_ibft.c~ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs drivers/firmware/iscsi_ibft.c
: --- a/drivers/firmware/iscsi_ibft.c~ibft-fix-the-display-of-a-few-fields-in-the-nic-attribute-structure-in-sysfs
: +++ a/drivers/firmware/iscsi_ibft.c
: @@ -754,11 +754,11 @@ static int __init ibft_check_nic_for(str
:  		rc = 1;
:  		break;
:  	case ibft_eth_ip_addr:
: -		if (!memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
: +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
:  			rc = 1;
:  		break;
:  	case ibft_eth_subnet_mask:
: -		if (!memcmp(nic->dhcp, nulls, sizeof(nic->dhcp)))
: +		if (nic->subnet_mask_prefix)
:  			rc = 1;
:  		break;
:  	case ibft_eth_origin:

The changelog is bad.

What does "fix" mean?  What does the old output look like and how does
this patch change it?

This matters, because this is a userspace interface and who knows, there
might be applications out there which somehow depend on the old and
broken behaviour.

Of course, that might be totally silly and unrealistic but because we
weren't told what the patch actually does, how can I tell?

Please send a new and complete description of this change, thanks.

