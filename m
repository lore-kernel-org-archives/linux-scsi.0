From: malahal@us.ibm.com
Subject: Re: [PATCH 05 of 16] Block layer data integrity
Date: Tue, 6 May 2008 13:29:09 -0700
Message-ID: <20080506202909.GA25904@us.ibm.com>
References: <patchbomb.1209165122@sermon.lab.mkp.net> <26ccaf2ccdc5548c4c9f.1209165127@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:58856 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbYEFU3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 16:29:12 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m46KTB55022089
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 16:29:11 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m46KTBPN215688
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 14:29:11 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m46KTBn3026203
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 14:29:11 -0600
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.130])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m46KTAWc026178
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2008 14:29:10 -0600
Content-Disposition: inline
In-Reply-To: <26ccaf2ccdc5548c4c9f.1209165127@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Martin K. Petersen [martin.petersen@oracle.com] wrote:
>  		 */
>  		blk_partition_remap(bio);
>  
> +		if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
> +			goto end_io;
> +
>  		if (old_sector != -1)
>  			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector,
>  					    old_sector);

It is expected that the bio's data should NOT be changed until this I/O
is sent out to the HBA for WRITES. How do you ensure that applications
or file systems don't modify the data of a bio that is in progress?

--Malahal.
