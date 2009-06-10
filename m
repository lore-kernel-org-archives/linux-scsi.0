From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/] OSD changes for 2.6.31
Date: Wed, 10 Jun 2009 14:03:38 +0000
Message-ID: <1244642618.4109.3.camel@mulgrave.site>
References: <4A197CB5.60709@panasas.com>  <4A2F7896.2070905@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48907 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742AbZFJODl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 10:03:41 -0400
In-Reply-To: <4A2F7896.2070905@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Jeff Garzik <jeff@garzik.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Wed, 2009-06-10 at 12:10 +0300, Boaz Harrosh wrote:
> On 05/24/2009 07:58 PM, Boaz Harrosh wrote:
> > These are the accumulated osd patches for the next merge window,
> > Linux 2.6.31. 
> > 
> > Most of these patches are a repost rebased on latest scsi-misc
> > 
> > List of patches:
> > [PATCH 01/10 resend] libosd: OSD2r05: Additional command enums                                                        
> > [PATCH 02/10 resend] libosd: OSD2r05: Attribute definitions
> > [PATCH 03/10 resend] libosd: Better printout of OSD target system information
> > [PATCH 04/10 resend] libosd: osd_req_{read,write}_kern new API
> > [PATCH 05/10 resend] libosd: Let _osd_req_finalize_data_integrity receive number of out_bytes
> > [PATCH 06/10 resend] libosd: osd_req_{read,write} takes a length parameter
> > 
> >    These are a resend. The last 2 patches are important for supporting Jeff's
> >    osdblk driver. (The first 4 are old patches that thier time has come)
> > 
> > [PATCH 07/10] libosd: Define an osd_dev wrapper to retrieve the request_queue
> >    Simple wrapper
> > 
> > [PATCH 08/10] osduld: use filp_open() when looking up an osd-device
> > 
> >     This patch was inspired by Al Viro. It uses the in-kernel open-file
> >     mechanism to look up the osd char-device for Kernel users like exofs
> >     and later pNFS-Objlayout.
> >     It was heavily tested and works well.
> >     It fixes the problem we had before, of need to open+close a file handle
> >     on the osd-char-device before mounting an exofs.
> >     Please review
> > 
> > [PATCH 09/10] libosd: Use REQ_QUIET requests.
> >     Recent scsi_lib changes, caused a dmesg span in exofs+osd regular use,
> >     because of the way we routinely receive a recovered scsi sense. Recently, for
> >     reason I could not find, this condition started to print messages at:
> >        scsi_io_comlition:778 (look for "== RECOVERED_ERROR")
> >     Use of a REQ_QUIET flag is needed to silence these prints.
> >     OSD has it's own prints for scsi-sense returns, when needed.
> > 
> > [PATCH 10/10] osd: Remove out-of-tree left overs
> > 
> 
> The merge window has risen upon us and these patches are still not
> in scsi-misc. (Luckily they where in linux-next through the osd tree)
> If these will not go into 2.6.31 I'm very screwed, with the pNFS stuff,
> Please reconsider?

I didn't reject them ... they just contain non scsi bits in fs/exofs.
However, since they're tightly entangled, I suppose the scsi-misc tree
will do ... just testing them out now.

James


