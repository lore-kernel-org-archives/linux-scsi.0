From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Bio Traversal Changes
Date: Fri, 02 Aug 2002 08:48:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <13845.9527669058$1028296355@news.gmane.org>
References: <suparna@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA03837
	for <linux-scsi@vger.kernel.org>; Fri, 2 Aug 2002 06:48:14 -0700
In-Reply-To: Message from Suparna Bhattacharya <suparna@in.ibm.com>
   of "Fri, 02 Aug 2002 18:05:13 +0530." <20020802180513.A1802@in.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: suparna@in.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.org, B.Zolnierkiewicz@elka.pw.edu.pl, akpm@zip.com.au

The SCSI changes (small that they are) look reasonable.

This does look like it exposes an existing problem in the tag/barrier 
approach, though.

The bio can be split by making multiple requests over segements of the bio, 
correct?  If this is a BIO_RW_BARRIER, then each of these requests will be a 
REQ_BARRIER.  However, in the SCSI paradigm where we translate REQ_BARRIER to 
ordered tag, each of the requests will get a new ordered tag as it comes back 
around through end_that_request_first, potentially allowing other tags to be 
inserted in between these, which would be incorrect, since other bios would be 
inserted in between the segments of this one, thus violating the barrier.

Is the above correct?  If it is, I may have finally found a use for linked 
scsi tasks (gives you the ability to have one tag cover multiple commands).

James


