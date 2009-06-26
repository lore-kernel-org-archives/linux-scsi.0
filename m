From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] mechanism for multipath to pass information to
 hardware handler
Date: Fri, 26 Jun 2009 14:10:47 -0500
Message-ID: <1246043447.3925.64.camel@mulgrave.site>
References: <1245863681.8709.135.camel@eddie-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49702 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbZFZTKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jun 2009 15:10:49 -0400
In-Reply-To: <1245863681.8709.135.camel@eddie-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Chandra Seetharaman <sekharan@us.ibm.com>

On Wed, 2009-06-24 at 13:14 -0400, Eddie Williams wrote:
> I notice in scsi_dh_emc.c that there is a comment:
> 
> TODO: need some interface so we can set trespass values
> 
> I don't see where any such interface has been developed or even any
> discussion on the different mailing lists to create such an interface.
> Did I miss something?
> 
> As it stands now there is no way that I can see to have the emc hardware
> handler support the "honor trespass" feature short of recompiling the
> module forcing the flag to be set.  This leaves a feature that worked in
> earlier versions of multipath not working now.

OK so as I understand it that means that the line

hardware handler "1 emc 0 1"

now fails to function correctly because dm-emc no longer exists.  That
makes this a functionality regression from 2.6.26 because of this
commit:


commit cb520223d7f22c5386aff27a5856a66e2c32aaac
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu May 1 14:50:34 2008 -0700

    [SCSI] scsi_dh: Remove hardware handlers from dm
    
    This patch removes the 3 hardware handlers that currently exist
    under dm as the functionality is moved to SCSI layer in the earlier
    patches.

Because we haven't actually moved all the functionality.

James



