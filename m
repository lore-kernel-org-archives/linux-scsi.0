From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/] OSD changes for 2.6.31
Date: Mon, 25 May 2009 10:39:30 -0400
Message-ID: <4A1AADA2.7050302@garzik.org>
References: <4A197CB5.60709@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59819 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZEYOjs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2009 10:39:48 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Al Viro <viro@ZenIV.linux.org.uk>

Boaz Harrosh wrote:
> These are the accumulated osd patches for the next merge window,
> Linux 2.6.31. 
> 
> Most of these patches are a repost rebased on latest scsi-misc
> 
> List of patches:
> [PATCH 01/10 resend] libosd: OSD2r05: Additional command enums                                                        
> [PATCH 02/10 resend] libosd: OSD2r05: Attribute definitions
> [PATCH 03/10 resend] libosd: Better printout of OSD target system information
> [PATCH 04/10 resend] libosd: osd_req_{read,write}_kern new API
> [PATCH 05/10 resend] libosd: Let _osd_req_finalize_data_integrity receive number of out_bytes
> [PATCH 06/10 resend] libosd: osd_req_{read,write} takes a length parameter
> 
>    These are a resend. The last 2 patches are important for supporting Jeff's
>    osdblk driver. (The first 4 are old patches that thier time has come)
> 
> [PATCH 07/10] libosd: Define an osd_dev wrapper to retrieve the request_queue
>    Simple wrapper
> 
> [PATCH 08/10] osduld: use filp_open() when looking up an osd-device
> 
>     This patch was inspired by Al Viro. It uses the in-kernel open-file
>     mechanism to look up the osd char-device for Kernel users like exofs
>     and later pNFS-Objlayout.
>     It was heavily tested and works well.
>     It fixes the problem we had before, of need to open+close a file handle
>     on the osd-char-device before mounting an exofs.
>     Please review
> 
> [PATCH 09/10] libosd: Use REQ_QUIET requests.
>     Recent scsi_lib changes, caused a dmesg span in exofs+osd regular use,
>     because of the way we routinely receive a recovered scsi sense. Recently, for
>     reason I could not find, this condition started to print messages at:
>        scsi_io_comlition:778 (look for "== RECOVERED_ERROR")
>     Use of a REQ_QUIET flag is needed to silence these prints.
>     OSD has it's own prints for scsi-sense returns, when needed.
> 
> [PATCH 10/10] osd: Remove out-of-tree left overs
> 
> log stat
>  drivers/scsi/osd/Kbuild          |   25 -----------
>  drivers/scsi/osd/Makefile        |   37 -----------------
>  drivers/scsi/osd/osd_initiator.c |   83 +++++++++++++++++++++++++++-----------
>  drivers/scsi/osd/osd_uld.c       |   66 ++++++++++++++----------------
>  fs/exofs/common.h                |    6 ---
>  fs/exofs/inode.c                 |    8 ++--
>  fs/exofs/osd.c                   |   26 ------------
>  include/scsi/osd_attributes.h    |   74 +++++++++++++++++++++++++++++++++-
>  include/scsi/osd_initiator.h     |   14 +++++-
>  include/scsi/osd_protocol.h      |    8 ++++
>  10 files changed, 185 insertions(+), 162 deletions(-)
>  delete mode 100755 drivers/scsi/osd/Makefile
> 
> These patches are available in the git repository at:
> 
>   git://git.open-osd.org/linux-open-osd.git osd-devel

Any chance osdblk could get added to this patchset sometime soon?

	Jeff




