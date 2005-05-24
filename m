From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Tue, 24 May 2005 18:17:58 -0500
Message-ID: <1116976678.7710.34.camel@mulgrave>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
	 <42939610.3070104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42717 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262157AbVEXXSH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 19:18:07 -0400
In-Reply-To: <42939610.3070104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

On Tue, 2005-05-24 at 14:01 -0700, Mike Christie wrote:
> > It's a leading transport connection of the session1 (above). Quoting the
> > spec (http://www.faqs.org/rfcs/rfc3720.html):
> > 
> >    - According to [SAM2], the I_T nexus is a relationship
> >      between a SCSI Initiator Port and a SCSI Target Port.  For iSCSI,
> >      this relationship is a session, defined as a relationship between
> >      an iSCSI Initiator's end of the session (SCSI Initiator Port) and
> >      the iSCSI Target's Portal Group.  
> > 
> > The session itself is not a "physical connection"; it aggregates one or more
> > transport connections between a given SCSI Initiator Port and a SCSI Target
> > Port. There is always at least one (leading) connection.
> > 
> 
> So just to be clear, open-iscsi can support multiple connections per 
> session. Do you want us to completely remove this feature for mainline? 
> I know you and christoph have given me this answer many times before, 
> but not seeing a reply to Nicholas's question about just disabling may 
> have created some doubt as to the extent people have to go? Since 
> open-iscsi pushed the connection management code to userspace, removing 
> MCS from the driver will not be too terrible a job for us though.
> 
> The connection dir for single connection sessions though is just a nice 
> way to export the kernel structure's info and have it also reflect the 
> iSCSI RFC's definitions at the same time. For sfnet we used to throw 
> everything in one dir becuase it did not have a connection structure so 
> it simplified refcounting.

My current position on MC/S is that it runs counter to the no multi-
pathing in the drivers policy, so should not be done.

As far as I can see it's an optional add on to the iSCSI standard which
doesn't improve the feature set or provide any value add over the
mandatory explicit multi-path support in rfc3720, which is easy to do
via dm-multipath.

James


