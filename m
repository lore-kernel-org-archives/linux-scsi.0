From: "weasel@meer.net" <weasel@meer.net>
Subject: question about DID_RESET handling
Date: Thu, 28 Oct 2010 16:22:39 -0400
Message-ID: <20101028162239.10346b0ye9g07iww@webmail.meer.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.ctinetworks.com ([205.166.61.227]:51561 "EHLO
	smtp2.ctinetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0J1U27 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 16:28:59 -0400
Received: from horde2.ctinetworks.com (horde2.ctinetworks.com [205.166.61.242])
	by smtp2.ctinetworks.com (Postfix) with ESMTP id C35721A73E8
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 16:22:39 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

during a test that creates a CRC error (target to initiator) by dropping
a data word from a frame w/o recomputing the CRC, i can induce a 'loop'
case. the controller sees the the CRC error, issues a device reset, and
the scsi request comes back w/ DID_RESET set (rather than DID_PARITY or
something else since it has already done the reset). i have an issue out
to the controller vendor about this, but sallying forth to
linux-scsi-land regardless...

scsi_decide_disposition() looking at a command w/ DID_RESET returns
SUCCESS and then scsi_io_completion() unconditionally retries the
command. w/ our injector setup to corrupt alternating data frames i can
induce an 'infinite loop' in the case where the controller's reset works
and then the scsi READ(10) fails.

anyway, i'd like to avoid this loop regardless of 'odd' controller
behavior so am asking about the two possible fixes i see and to see if
there's some other way.

- make scsi_decide_disposition()'s handling of DID_RESET just use the
   maybe_retry logic.

   however, (being new to this area) scsi_io_completion() calls
   scsi_end_request() in case some data actually got read. i don't see that
   a request w/ DID_RESET set can have data, but if it really can, then...

- copy retry logic to scsi_io_completion() in the DID_RESET case. using
   cmd->retries seems safe here since it won't ahve gotten updated in
   scsi_decide_disposition(), but maybe a comment there might be nice.

am i offbase/missing something/lacking sufficient details?

\p
