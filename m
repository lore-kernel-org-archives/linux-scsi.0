From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 1st  REVIEW : UNH iSCSI for 2.6-test5
Date: Thu, 25 Sep 2003 09:19:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030925091949.A6827@infradead.org>
References: <20030924151228.8206.qmail@web60208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:35851 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261600AbTIYITu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2003 04:19:50 -0400
Content-Disposition: inline
In-Reply-To: <20030924151228.8206.qmail@web60208.mail.yahoo.com>; from jpd_hp_linux_scsi@yahoo.com on Wed, Sep 24, 2003 at 08:12:28AM -0700
List-Id: linux-scsi@vger.kernel.org
To: jd <jpd_hp_linux_scsi@yahoo.com>
Cc: linux-scsi@vger.kernel.org

More comments:

 - unh_iscsi/security should really go away.  We have a nice crypto API
   in 2.6 and late 2.4, but authentification really shouldn't be done
   in kernelspace anyway.
 - kill iscsi_device.c.  A scsi LLDD has no business messing with device
   nodes..
 - you're comment style is strange.  In kernel code we tend to use

/*
 * Foo, blah
 * baz..
 */

not

/*

*/

but that's just a minor nitpick.

Having the module description over the copyright boilerplate also is
very strange.

 - your split into common/ and initiator/ is strange.  You can build
   multiple modules in one directory and that would cleanup your
   includes mess nicely
 - having a single host for all of iscsi looks strange.  Why do you
   do that?
 - the #ifdef K26 is totally unreadble.  Especially when it's around
   code that works for both 2.4 and 2.6..
 - kill my_kmallocd / my_free
 - you seems to not handle lots of error returns, e.g. from down_interruptible
   or kernel_thread
 - the UNH_LOCK/UNH_UNLOCK obsfucation hinders reading
 - kill ISCSI_INITIATOR, there's no need for this #define - just initialize
   the host template directly


