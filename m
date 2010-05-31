From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Mon, 31 May 2010 13:34:47 +0200
Message-ID: <20100531113447.GB16260@schmichrtp.mainz.de.ibm.com>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 31, 2010 at 01:28:17PM +0200, Christof Schmitt wrote:
> When running tests with an ext2 filesystem on a device using DIF/DIX
> integrity data, i sometimes see invalid guard tags on write requests.
> To track down the problem, i patched the function sd_prep_fn in sd.c
> to verify the IP checksums in the guard tags against the actual data.
> Sometimes there is a mismatch and the write request fails when the HBA
> checks the guard tag.
> 
> Since the guard tags are created in Linux, it seems that the data
> attached to the write request changes between the generation in
> bio_integrity_generate and the call to sd_prep_fn.
> 
> Using ext3 or ext4 instead of ext2 does not show the problem.
> 
> There is a bugzilla open at Redhat with the same symptom, but there is
> no data or activity:
> https://bugzilla.redhat.com/show_bug.cgi?id=574266
> 
> What would be the best way to track down this problem?

One more thing: The test is running with a 2.6.34 kernel, the problem
in the bugzilla is reported for 2.6.33.

Christof Schmitt
