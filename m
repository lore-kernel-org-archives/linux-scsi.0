From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [REPOST #3][PATCH 1/6] lpfc 8.1.7 : Adding statistics reset	callback
 for FC transport
Date: Thu, 3 Aug 2006 10:06:47 +0200
Message-ID: <OF72A08B9B.60EB1A87-ON422571BF.002BABC0-422571BF.002BE417@de.ibm.com>
References: <1154546674.3663.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:929 "EHLO
	mtagate6.de.ibm.com") by vger.kernel.org with ESMTP id S932389AbWHCIDb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Aug 2006 04:03:31 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.7/8.13.7) with ESMTP id k7383Ssq112544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 3 Aug 2006 08:03:29 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k7386rcE100036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 3 Aug 2006 10:06:55 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7383Jtw026865
	for <linux-scsi@vger.kernel.org>; Thu, 3 Aug 2006 10:03:20 +0200
In-Reply-To: <1154546674.3663.0.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On 02.08.2006 21:24 James Smart <James.Smart@Emulex.Com> wrote:
> Sorry folks - a last code review identified one last reference
> to seconds_since_last_reset that didn't get caught.

Sorry -- for speaking up so lately.

> Adding statistics reset callback for FC transport

Now lpfc is the second FC driver that stores old stats data in
order to reset FC host stats. (zfcp is the other one.)

Shouldn't this stuff be moved into scsi_transport_fc?
So the default for scsi_transport_fc would be to store
a stats-offset (as you call it) together with seconds since
last reset. So every FC lldd gets the reset-stats functionality
for free.
Of course an lldd is able to register its own reset-callback
(maybe because the reset is implemented in hardware)
to replace the default handler.

This just came into my mind when reviewing your patch.


Regards,

Andreas

--
Linux for eServer Development
Tel :  +49-7031-16-4640
Notes mail :  Andreas Herrmann/GERMANY/IBM@IBMDE
email :  aherrman@de.ibm.com

