From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Fri, 09 Jul 2010 12:22:51 -0400
Message-ID: <yq1iq4o1v6s.fsf@sermon.lab.mkp.net>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
	<20100706213136.GA21246@redhat.com> <4C33BEDF.7050602@interlog.com>
	<20100707004748.GA3068@redhat.com>
	<yq1ocek6pf4.fsf@sermon.lab.mkp.net> <4C33F619.4010302@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26253 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0GIQXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2010 12:23:41 -0400
In-Reply-To: <4C33F619.4010302@interlog.com> (Douglas Gilbert's message of
	"Tue, 06 Jul 2010 23:35:53 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

>> Maximum Unmap LBA Count> 0 (in combination with the descriptor count)
>> are what indicate that the device server supports UNMAP.

Doug> That has been superseded by the TPU and TPWS bits in the Thin
Doug> provisioning VPD page (B2h) in sbc3r22.  TPU and TPWS indicate
Doug> support for the UNMAP and WRITE SAME (16) with UNMAP bit **
Doug> commands respectively.

*sigh* this is getting more and more convoluted.  I really wish T10 had
been able to agree on a single approach instead of 2.


Doug> I think sbc3r22 is just flaky in that area and will be cleaned up
Doug> soon. As the words stand now, in the Block limits VPD page
Doug> "maximum unmap lba count" only applies to the UNMAP command while
Doug> "optimal unmap granularity" applies to both the UNMAP command and
Doug> the WRITE SAME(16) command. Inconsistent.  And "maximum unmap lba
Doug> count"==0 implying no UNMAP command is pointless given the TPU
Doug> bit.

I'll ask around and see what the plans are in T10 when I get back from
vacation next week.  And I'll try to adjust our heuristics accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering
