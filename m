From: scameron@beardog.cce.hp.com
Subject: Are these comments in scsi_host.h still true?
Date: Mon, 5 Mar 2012 17:18:58 -0600
Message-ID: <20120305231858.GB22578@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41615 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab2CEXS7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2012 18:18:59 -0500
Received: from g4t0009.houston.hp.com (g4t0009.houston.hp.com [16.234.32.26])
	by g4t0014.houston.hp.com (Postfix) with ESMTP id 291792435F
	for <linux-scsi@vger.kernel.org>; Mon,  5 Mar 2012 23:18:59 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g4t0009.houston.hp.com (Postfix) with ESMTP id 1A6E2C092
	for <linux-scsi@vger.kernel.org>; Mon,  5 Mar 2012 23:18:59 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [127.0.0.1])
	by beardog.cce.hp.com (8.13.8/8.13.8) with ESMTP id q25NIw6P023451
	for <linux-scsi@vger.kernel.org>; Mon, 5 Mar 2012 17:18:58 -0600
Received: (from scameron@localhost)
	by beardog.cce.hp.com (8.13.8/8.13.8/Submit) id q25NIw9K023450
	for linux-scsi@vger.kernel.org; Mon, 5 Mar 2012 17:18:58 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Is this comment from include/scsi/scsi_host.h still true?

        /*
         * This is an error handling strategy routine.  You don't need to
         * define one of these if you don't want to - there is a default
         * routine that is present that should work in most cases.  For those
         * driver authors that have the inclination and ability to write their
         * own strategy routine, this is where it is specified.  Note - the
---->    * strategy routine is *ALWAYS* run in the context of the kernel eh
---->    * thread.  Thus you are guaranteed to *NOT* be in an interrupt
---->    * handler when you execute this, and you are also guaranteed to
---->    * *NOT* have any other commands being queued while you are in the
         * strategy routine. When you return from this function, operations
         * return to normal.
         *
         * See scsi_error.c scsi_unjam_host for additional comments about
         * what this function should and should not be attempting to do.
         *
         * Status: REQUIRED     (at least one of them)
         */

Also what about this, about scsi_unjam_host() from scsi_error.c?

 * Notes:
 *    When we come in here, we *know* that all commands on the bus have
 *    either completed, failed or timed out.  we also know that no further
 *    commands are being sent to the host, so things are relatively quiet
 *    and we have freedom to fiddle with things as we wish.

I'm not seeing what code makes sure those are true.

Thanks,

-- steve

