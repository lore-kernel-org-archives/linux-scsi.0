From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: add SMP READ/WRTIE GPIO support
Date: Wed, 03 Aug 2011 15:02:43 -0500
Message-ID: <1312401763.2855.72.camel@mulgrave>
References: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com>
	 <4DE64D78.6090309@interlog.com>  <4DE6708F.8080604@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51012 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028Ab1HCUCq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2011 16:02:46 -0400
In-Reply-To: <4DE6708F.8080604@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2011-06-01 at 19:02 +0200, Artur Wojcik wrote:
> On 06/01/2011 04:32 PM, Douglas Gilbert wrote:
> > On 11-06-01 10:02 AM, Artur Wojcik wrote:
> >> This patch enables the SMP READ/WRITE GPIO function interface in 
> >> libsas SMP
> >> host module. The interface is used to control the SGPIO initiator in 
> >> the SAS
> >> initiator. The implementation is SFF-8485 and SAS-2 compliant.
> >>
> >> There are two functions in transport class only responsible for 
> >> reading and
> >> writting GPIO registers. I decided to leave the decission about what 
> >> type of
> >> registers are supported to lldd.
> >>
> >> Now the user space application may issue SMP READ/WRITE GPIO frame to 
> >> HBA in
> >> order to read/write GPIO registers.
> >
> > Your code also accepts the somewhat mysterious READ GPIO
> > REGISTER ENHANCED SMP function and its WRITE equivalent.
> > Reference is made in sas2r16.pdf to SFF-8485 for those
> > functions. However the most recent version of SFF-8485
> > on the Seagate site is 0.7 dated February 2006, and it does
> > not define those ENHANCED functions.
> >
> > Could you tell us what those ENHANCED versions do?
> >
> > Doug Gilbert
> I have not found the description of ENHANCED frames in any publicly 
> available specification related to SGPIO. I took SAS-2 as the major 
> reference and it says SMP functions 02h (READ) and 82h (WRITE) are 
> obsolete. My understanding is that for the moment the new functions are 
> replacing the deprecated functions, but the frame format and registers 
> set stay the same.

Then why change the function numbers?  I mean if you're keeping the call
and return compatible, you can just reuse the now obsoleted functions.
Usually you only change functions if you have to break compatibility
somehow (like order or length of parameters).   Since the current
implementation critically depends on this (because you break out the
fields from the frame) I'd be very wary of putting this in only to have
it broken again by a later revision of SFF-8485

James


