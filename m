From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/7] sd: Implement support for WRITE SAME
Date: Tue, 06 Mar 2012 12:58:58 -0500
Message-ID: <yq1hay1lifx.fsf@sermon.lab.mkp.net>
References: <1330658571-12958-1-git-send-email-martin.petersen@oracle.com>
	<1330658571-12958-7-git-send-email-martin.petersen@oracle.com>
	<20120305150728.GA18546@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:21741 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2CFR7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 12:59:14 -0500
In-Reply-To: <20120305150728.GA18546@redhat.com> (Vivek Goyal's message of
	"Mon, 5 Mar 2012 10:07:28 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

>> + blk_add_request_payload(rq, bio_page(bio), sdp->sector_size);

Vivek> I was just curious about what above function is doing. This is
Vivek> strange is that we already have the bio->io_vec initialized and
Vivek> we are reusing that to overwrite same bio with same information
Vivek> and trying to update rq again with same information.

Yeah, you're right. I don't think this is needed now that we distinguish
between bio_has_data() and bio_is_rw() when mapping the request.

Mike, would you mind stubbing out the blk_add_request_payload call in
sd_set_write_same_cmnd() and rerun your iSCSI thinp test?

It works for me with SAS/FC...

-- 
Martin K. Petersen	Oracle Linux Engineering
