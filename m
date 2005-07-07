From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Thu, 7 Jul 2005 20:06:44 +0300 (EEST)
Message-ID: <Pine.LNX.4.61.0507071903260.2964@kai.makisara.local>
References: <92952AEF1F064042B6EF2522E0EEF437348354@EXNA.corp.stratus.com>
 <Pine.LNX.4.61.0507071332570.2964@kai.makisara.local> <42CD2CFA.20902@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:14714 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261359AbVGGRDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2005 13:03:08 -0400
In-Reply-To: <42CD2CFA.20902@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: "Dailey, Nate" <Nate.Dailey@stratus.com>, linux-scsi@vger.kernel.org

On Thu, 7 Jul 2005, Brian King wrote:

> Kai Makisara wrote:
> >>The primary change is adding a kref to the Scsi_Tape structure, to avoid
> >>an oops when the tape drive is removed while open. This includes
> >>scsi_tape_get/put routines and scsi_tape_release, and changes to st_open
> >>and st_release. This is all based on the SCSI disk & CD reference
> >>counting code.
> >>
> > 
> > You have added a new kref for this. Have you considered using the 
> > existing cdev refcounting instead of a separate kref?
> > 
> > (When the new character device code was introduced, I got the impression 
> > that the proper way for the st would be to embed the struct into struct 
> > scsi_tape and make the destructor. The scsi_tapes[] array would not be 
> > necessary any more because the struct scsi_tape would be accessible through 
> > containerof(inode->i_cdev, struct scsi_tape, cdev).
> > (An array would be still necessary for tape number allocation.)
> > I did not implement this at that time because there was no real need for 
> > the change and it seemed too complex to test just for fun.)
> 
> I'm not sure how you would do this since there is currently no way to
> embed data in a cdev.

True. This is why it has to be done the other way: embed cdev(s) into 
struct scsi_tape. The file linux/drivers/char/snsc.c is an example how 
this works except for the release (deallocation) part. I just searched
linux/fs/char_dev.c for a solution for this part but did not find one. The 
URL http://lkml.org/lkml/2003/9/22/220 quite well describes what the 
code looks like. Seems best to forget using cdevs for deallocation.

The tape devices now appear in the sysfs class scsi_tape. One possibility 
might be to use refcounting in these objects as suggested by the URL. This 
does not remove the search loop through scsi_tapes[] in st_open() and the 
added code and data would be only for deallocation.

> Also, since there are multiple cdevs per scsi_tape,
> it seems cleaner to use a new kref.
> 
The new kref may well be the best way overall. I just want to explore the 
existing possibilities that don't need updating when the world around st 
changes.

-- 
Kai
