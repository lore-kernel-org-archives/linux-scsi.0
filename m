From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH 4/4] fusion: fibre channel: don't sync cache if remote
 port deleted
Date: Tue, 01 Aug 2006 10:37:26 -0500
Message-ID: <44CF7536.5030006@sgi.com>
References: <44CE3BC0.8020901@sgi.com> <1154444303.3446.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:62109 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030285AbWHAPhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 11:37:32 -0400
In-Reply-To: <1154444303.3446.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

The mid-layer appears to be inconsistent with regard to sync cache.
I agree the sync should not be in the lldd.  It's been in fusion for
a long time and I'm just fixing the implementation for fibre channel.
This isn't a new feature, just a fix to an existing one.

I refer you to two threads which discussed the issue.

http://marc.theaimsgroup.com/?l=linux-scsi&m=115386616817044&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=115266599732078&w=2

Mike


James Bottomley wrote:
> On Mon, 2006-07-31 at 12:20 -0500, Michael Reed wrote:
>> mptscsih_slave_destroy issues an unconditional synchronize cache.
> 
> A) mptscsih_slave_destroy shouldn't be doing this ... it should be
> relying on the functionality in the mid-layer.
> 
>> It is not necessary for fibre channel devices for which the rport
>> has been deleted.  This patch creates a new function,
>> mptfc_slave_destroy(), which implements the appropriate test.
> 
> So, this is really code that shouldn't be in a driver, it should be
> higher up.
> 
> The other three patches look fine.
> 
> James
> 
