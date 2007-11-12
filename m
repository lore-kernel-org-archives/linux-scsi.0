From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Fix problem with size of allocation in libsas
Date: Sun, 11 Nov 2007 18:45:45 -0600
Message-ID: <1194828345.3445.35.camel@localhost.localdomain>
References: <200711120024.54773.jesper.juhl@gmail.com>
	 <1194825603.3445.21.camel@localhost.localdomain>
	 <47379F67.2030504@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:56484 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620AbXKLAps (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Nov 2007 19:45:48 -0500
In-Reply-To: <47379F67.2030504@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, 2007-11-11 at 19:33 -0500, Douglas Gilbert wrote:
> James Bottomley wrote:
> > On Mon, 2007-11-12 at 00:24 +0100, Jesper Juhl wrote:
> >> From: Jesper Juhl <jesper.juhl@gmail.com>
> >>
> >> in sas_get_phy_change_count(), the line
> >> 	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
> >> will allocate 56 bytes due to this define:
> >> 	#define DISCOVER_RESP_SIZE 56
> >> But, the struct is actually 60 bytes in size.
> >>
> >> So change the define to be 
> >> 	#define DISCOVER_RESP_SIZE sizeof(struct smp_resp)
> >> so we always get the correct size even when people 
> >> fiddle with the structure.
> >>
> >> This change also fixes the same problem in 
> >> sas_get_phy_attached_sas_addr()
> >>
> >> (Found by the Coverity checker. Compile tested only)
> > 
> > Well, your fix is definitely wrong.
> > 
> > Could you explain the problem a little more?  The discover response SMP
> > frame is 56 bytes as mandated by the standard.  I don't see anywhere in
> > the code where we're actually using a value beyond the 56th byte ...
> > where is the problem use?
> 
> The response size of SMP DISCOVER keeps growing with
> each rev. Currently in SAS-2 revision 12 it is 112 bytes long!
> The original SAS standard and SAS 1.1 have implicit response
> sizes and for DISCOVER that is 56 bytes.
> 
> To be compliant with SAS-2 the code should read byte 3 of
> a DISCOVER response. If it is zero then the response length
> is 56 bytes, otherwise the response length is that many
> dwords (i.e. 4 byte units) plus 4 bytes for the CRC.
> [Similar logic applies to many other SMP responses.]
> 
> I have tables for all SMP requests and response (up until
> SAS-2 rev 12) in my smp_utils package, see the smp_lib.c
> file.

Right at the moment, we're requiring the 1.1 56 byte response because
the request has byte three zeroed (sas 2 requires responders to return
the 1.1 response frame in this case).  I suppose if we ever need to do
zoning, there might be a case to move to larger sizes, but at the moment
it would just tell us about features we're not using anyway (plus we're
bound to confuse some older expanders).

James


