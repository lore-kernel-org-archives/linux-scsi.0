From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC PATCH] libfcoe: Replace module state checking with global
 flag checking
Date: Sat, 19 Mar 2011 10:58:31 -0400
Message-ID: <1300546711.12679.11.camel@mulgrave.site>
References: <20110312020737.21655.31389.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:59603 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1CSO6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Mar 2011 10:58:36 -0400
In-Reply-To: <20110312020737.21655.31389.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2011-03-11 at 18:07 -0800, Robert Love wrote:
> libfcoe uses module parameters for its create, destroy,
> etc... interfaces. The user land application will write
> the name of the netdevice to these interface files to
> trigger the kernel to take some action.
> 
> Module parameter sysfs files are both present and writable
> before the module has completed its initialization routine.
> This means that the user could call 'create' before
> libfcoe's global data structures have been initialized.
> 
> The current solution is to check the module's state in
> the sysfs store functions and if the module is not
> MODULE_STATE_LIVE the sysfs store routine will immediately
> exit, thus not doing anything if the module has not
> completed initialization. This solution is not sufficient
> because it expects THIS_MODULE to have been initialized,
> which is not guaranteed.
> 
> This patch adds a global (to libfcoe) atomic variable
> which is used to track the modules initialization state.
> In other words, this patch uses a flag to indicate
> whether the module has completed initialization or not.

OK, so this isn't really the way to do it, because you've just replaced
one race condition with another: The race is that the module can go dead
immediately after you make your liveness checks.  The fix is that you
want the correct lifetime rules on the objects.

For the sysfs files, that means using them properly, so they don't
appear until the module is ready to begin processing calls and they
disappear *before* you begin teardown.

James


