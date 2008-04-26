From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 11 of 16] Move scsi_disk() accessor function to sd.h
Date: Sat, 26 Apr 2008 09:01:12 -0400
Message-ID: <yq1od7wlqhz.fsf@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
	<b512cd02f8b0de20d093.1209165133@sermon.lab.mkp.net>
	<20080426062347.GA1081@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:33589 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYDZNsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Apr 2008 09:48:07 -0400
In-Reply-To: <20080426062347.GA1081@infradead.org> (Christoph Hellwig's message of "Sat\, 26 Apr 2008 02\:23\:47 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> Nack.  Creating of sd.h was a big mistake already and
Christoph> should be reverse.  No one but sd.c has any business
Christoph> playing with these.

DIF is part of SBC hence scsi_dif.c is a logical subset of sd.c.

I could roll scsi_dif.c into sd.c but I don't necessarily think that's
prettier.

Maybe I should rename scsi_dif.c to sd_dif.c?


An alternative to exporting scsi_disk() is to introduce a field in
scsi_cmnd to let the HBA driver know how to handle the request.
That's how I originally did it but didn't want to grow scsi_cmnd when
I could avoid it.  And it seemed DIF-specific.

However, given the impending "I-can't-believe-it's-not-DIF" extensions
for SCSI tape maybe there's merit in having a generic routing field?

-- 
Martin K. Petersen	Oracle Linux Engineering
