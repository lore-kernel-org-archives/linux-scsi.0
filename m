From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 3 Dec 2003 15:24:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031203232438.GA1775@beaverton.ibm.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com> <03120217260300.01630@naveenb-lnx.cisco.com> <1070383028.2345.8.camel@mulgrave> <03120319364802.02505@naveenb-lnx.cisco.com> <1070464184.1771.33.camel@mulgrave> <yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com> <20031203175417.GA893@beaverton.ibm.com> <yquj4qwh3a29.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:22420 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262188AbTLCXUX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 18:20:23 -0500
Content-Disposition: inline
In-Reply-To: <yquj4qwh3a29.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Clay Haapala [chaapala@cisco.com] wrote:
> On Wed, 3 Dec 2003, Mike Anderson outgrape:
> 
> > Clay Haapala [chaapala@cisco.com] wrote:
> >> 
> >> Naveen, is it intended that the iSCSI driver retry when the 0B/4705
> >> is detected, or will that sense code and COMMAND ABORT be passed up
> >> to the SCSI layers for retry?
> >> 
> >> James, et al, do the SCSI layers retry on COMMAND ABORT?
> >> 
> >> I don't believe the SCSI layers retry on HARDWARE ERROR -- this is
> >> a difference between how Solaris and Linux operate, for example,
> >> unless I am misunderstanding or have obsolete information.  --
> > 
> > scsi_check_sense will return NEEDS_RETRY for:
> > 	- ABORTED_COMMAND
> > 
> > 	- NOT_READY and UNIT_ATTENTION under the expecting_cc_ua and
> > 	becoming ready case.
> > 
> > 	- MEDIUM_ERROR
> > 
> > If the allowed count has not been exceeded the command will be
> > retried.
> > 
> > -andmike
> 
> A couple of related SCSI (not necessarily iSCSI) questions:
> 
> "If the allowed count has not been exceeded" - The first two commands
> after a connection has been estabilished will fail with
> Unit_Attention. What if that first command then also gets a crc error
> (Aborted_command)?  Will the retry count be large enough?
> 

The sd upper level driver sets the allowed value to SD_MAX_RETRIES
(5). In your above example it would be retried. In theory a scsi command
could have been through the retry path SD_MAX_RETRIES-1 times prior and 
would not be retried.

> Does the retry also apply to tape?  Without proper tape error
> recovery, retrying the command could result in duplicate records
> written to tape.
> 

The tape upper level drivers set there retries to 0 for read and write
operations.

andmike
--
Michael Anderson
andmike@us.ibm.com

