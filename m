From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Questions about  [SCSI] modify scsi to handle new fail fast flags.
Date: Fri, 13 Mar 2009 11:37:57 -0400
Message-ID: <20090313153757.GA11370@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-216-57-134-2.customer.veroxity.net ([216.57.134.2]:58944
	"EHLO mars.virtualiron.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753773AbZCMPim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Mar 2009 11:38:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Hey Mike,

I was having a problem with one of the SATA controllers at work and traced it
down to enclosure. But during that time I found out that the error handler
of bio's issued from SCSI block vs the multipath block driver act differently.

The "scsi_eh_flush_done_q" is the one that controls whether the I/Os should
be repeated or returned back. Earlier in the days it would check the
bio->flags to see if the REQ_FAILFAST* attributes were set, but nowadays
it is more discriminating and depending on the host_byte(scmd->result) figures
out if needs to check for the REQ_FAILFAST* attribute.

The end result is that the bio's mapped through multipath have the same
logic as through the SCSI block. Compared to Linux releases in RHEL53, SLES10
the behaviour is different.

So my question is that OK? From the perspective of dm-mpath it looks as
if the device driver now does the retry/re-issue and ignores the FAILFAST
attribute. Instead of allowing dm-mpath to be the ...umm "brain" behind this.

Oh, the git that causes this behavior is this one:

commit 4a27446f3e39b06c28d1c8e31d33a5340826ed5c
Author: Mike Christie <michaelc@cs.wisc.edu>
Date:   Tue Aug 19 18:45:31 2008 -0500

    [SCSI] modify scsi to handle new fail fast flags.

    This checks the errors the scsi-ml determined were retryable
    and returns if we should fast fail it based on the request
    fail fast flags.

    Without the patch, drivers like lpfc, qla2xxx and fcoe would return
    DID_ERROR for what it determines is a temporary communication problem.
    There is no loss of connectivity at that time and the driver thinks
    that it would be fast to retry at the driver level. SCSI-ml will however
    sees fast fail on the request and DID_ERROR and will fast fail the io.
    This will then cause dm-multipath to fail the path and possibley switch
    target controllers when we should be retrying at the scsi layer.

    We also were fast failing device errors to dm multiapth when
    unless the scsi_dh modules think otherwis we want to retry at
    the scsi layer because multipath can only retry the IO like scsi
    should have done. multipath is a little dumber though because it
    does not what the error was for and assumes that it should fail
    the paths.
