From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
Date: Fri, 19 Sep 2014 14:43:14 -0700
Message-ID: <lvi81j$ud8$2@ger.gmane.org>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com> <1410822750-10717-5-git-send-email-agrover@redhat.com> <1411161279.23258.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33033 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757837AbaISVn2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2014 17:43:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XV5xf-0002OV-8f
	for linux-scsi@vger.kernel.org; Fri, 19 Sep 2014 23:43:27 +0200
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2014 23:43:27 +0200
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2014 23:43:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Nicholas A. Bellinger wrote:

<snip>
> So the idea of allowing the in-kernel CDB emulation to run after
> user-space has returned unsupported opcode is problematic for a couple
> of different reasons.
> 
> First, if the correct feature bits in standard INQUIRY + EVPD INQUIRY,
> etc are not populated by user-space to match what in-kernel CDB
> emulation actually supports, this can result in potentially undefined
> results initiator side.
> 
> Also for example, if user-space decided to emulate only a subset of PR
> operations, and leaves the rest of it up to the in-kernel emulation,
> there's not really a way to sync current state between the two, which
> also can end up with undefined results.
> 
> So that said, I think a saner approach would be two define two modes of
> operation for TCMU:
> 
>    *) Passthrough Mode: All CDBs are passed to user-space, and no
>       in-kernel emulation is done in the event of an unsupported
>       opcode response.
> 
>    *) I/O Mode: I/O related CDBs are passed into user-space, but
>       all control CDBs continue to be processed by in-kernel emulation.
>       This effectively limits operation to TYPE_DISK, but with this mode
>       it's probably OK to assume this.
> 
> This seems like the best trade-off between flexibility when everything
> should be handled by user-space, vs. functionality when only block
> remapping of I/O is occurring in user-space code.

The problem there is that the first case has all the issues of pscsi and 
simply becomes a performance optimization over tgt+iscsi client+pscsi and 
the latter case excludes the main use cases I'm interested in - OSDs, media 
changers, optical discs (the biggest thing for me), and so forth.

One of the main things I want to do with this is hook up a plugin that uses 
libmirage to handle various optical disc image formats.

