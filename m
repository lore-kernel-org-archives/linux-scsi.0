From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Date: Thu, 25 Sep 2008 23:30:27 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F280A3@HQ-EXCH-5.corp.brocade.com>
References: <200809260106.m8Q160kj028501@swe37.brocade.com> <20080926025514.GD9480@kroah.com> <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com> <1222408937.3265.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:23406 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbYIZGab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Sep 2008 02:30:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1222408937.3265.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, "Srikanth Rayas (CW)" <srayas@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

Hi James,

It is encouraging to know that we can discuss and add new feature into
existing fc transport. I guess this is opensource all about. I didn't
have linux opensource experience before, so I was not quite sure how
easy to request new features in fc transport such as mechanism to create
multiple subdirectories for different level of statistics info in
addition to the snia fc statitistics we already have, and other features
such as CT/SCSI passthru and asynchronous event notification etc.

Thanks

Jing 


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Thursday, September 25, 2008 11:02 PM
To: Jing Huang
Cc: Greg KH; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
Ramkumar Vadivelu; Srikanth Rayas (CW); Vinodh Ravindran
Subject: RE: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission
(2ndtry)

On Thu, 2008-09-25 at 21:49 -0700, Jing Huang wrote:
> The reason we creating our own sysfs directory under /sys/devices path
> was we felt the fc transport and scsi host attributes are not enough
for
> all the HBA management features we want to have.

This isn't really a valid reason.  We use the fc transport class to
share infrastructure and provide a common interface for users.  If you
need more, we can discuss adding features to the fc transport class if
they would be useful to fibre drivers in general.  If they're not useful
to other drivers, then you can add pieces specific to your driver for
them, but the functionality that's already in the fc transport shouldn't
be duplicated by that.

>  We have ioctl in our
> non opensource driver, and we want to have something to emulate
all/most
> of the IOCTL functionality we have in the opensource driver. We
provide
> multi-level of driver/fw statistics info to the user, and we want to
put
> those info under a separate directory instead of throw them all under
> scsi_host.

That's how the fc transport class currently operates.  It's statistics
all appear in a "statistics" directory under the host.  If you use it
(and add the ones you need that are missing) everyone will be happy and
you won't need to worry about creating the directories.

>  I just didn't know how to create a subdirectory under scsi/fc
> host. Currently, we only implement a small portion of all the IOCTL
> functionalities. We want to know if this is acceptable in the upstream
> kernel. 
> 
> I agree that there are a lot of redundancy with the attributes we
> created under scsi_host. We will clean them up.

James


