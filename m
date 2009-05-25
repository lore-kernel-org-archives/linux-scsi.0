From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/] OSD changes for 2.6.31
Date: Mon, 25 May 2009 14:54:30 +0000
Message-ID: <1243263270.3428.3.camel@localhost.localdomain>
References: <4A197CB5.60709@panasas.com>  <4A1AADA2.7050302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60024 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbZEYOyb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2009 10:54:31 -0400
In-Reply-To: <4A1AADA2.7050302@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, 2009-05-25 at 10:39 -0400, Jeff Garzik wrote:
> Boaz Harrosh wrote:
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
> > log stat
> >  drivers/scsi/osd/Kbuild          |   25 -----------
> >  drivers/scsi/osd/Makefile        |   37 -----------------
> >  drivers/scsi/osd/osd_initiator.c |   83 +++++++++++++++++++++++++++-----------
> >  drivers/scsi/osd/osd_uld.c       |   66 ++++++++++++++----------------
> >  fs/exofs/common.h                |    6 ---
> >  fs/exofs/inode.c                 |    8 ++--
> >  fs/exofs/osd.c                   |   26 ------------
> >  include/scsi/osd_attributes.h    |   74 +++++++++++++++++++++++++++++++++-
> >  include/scsi/osd_initiator.h     |   14 +++++-
> >  include/scsi/osd_protocol.h      |    8 ++++
> >  10 files changed, 185 insertions(+), 162 deletions(-)
> >  delete mode 100755 drivers/scsi/osd/Makefile
> > 
> > These patches are available in the git repository at:
> > 
> >   git://git.open-osd.org/linux-open-osd.git osd-devel
> 
> Any chance osdblk could get added to this patchset sometime soon?

You mean for upstream submission?  You need to publish it in final form
and sign off on it first ...  Even the modified patch set is still
showing:

From: Jeff Garzik <jeff@garzik.org>

TODO: Commit log

NOT-Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
WILL-Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

James


