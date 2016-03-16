From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] qla2xxx: avoid maybe_uninitialized warning
Date: Wed, 16 Mar 2016 13:59:49 +0100
Message-ID: <2808565.5VeioJTJAb@wuerfel>
References: <1458078051-529344-1-git-send-email-arnd@arndb.de> <1458078554.2375.97.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:62473 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbcCPNFk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2016 09:05:40 -0400
In-Reply-To: <1458078554.2375.97.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: qla2xxx-upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Alexei Potashnik <alexei@purestorage.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Swapnil Nagle <swapnil.nagle@purestorage.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tuesday 15 March 2016 14:49:14 James Bottomley wrote:
> On Tue, 2016-03-15 at 22:40 +0100, Arnd Bergmann wrote:
> > 
> > This slightly rearranges the code to move the second if() block
> > into the first one, to avoid the warning while retaining the
> > behavior of the code.
> 
> I thought our usual policy was to ask someone to fix the compiler when
> it emitted a spurious warning.

No, the rule is that we shouldn't blindly add initializations to
the variables when the compiler should have figured it out.

In this case, I wouldn't expect the compiler to ever see through
the unlikely() macro, and I'm not adding a potentially counterproductive
initialization, so I see no reason not to apply the patch.

Making it easier for the compiler to figure out what is going
on should also lead to slightly better object code. If you think
my patch makes it less readable, an alternative would be to remove
the 'unlikely', which also gets rid of the warning.

	Arnd
