From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Thu, 26 Jan 2012 10:00:04 -0700
Message-ID: <10715842-8E51-40A5-8C28-AD8B1090645D@dilger.ca>
References: <20120124203936.GC20650@quack.suse.cz> <20120125032932.GA7150@localhost> <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca> <1327502034.2720.23.camel@menhir> <D3F292ADF945FB49B35E96C94C2061B915A638A6@nsmail.netscout.com> <1327509623.2720.52.camel@menhir> <1327512727.2776.52.camel@dabdike.int.hansenpartnership.com> <D3F292ADF945FB49B35E96C94C2061B915A63A30@nsmail.netscout.com> <1327516668.7168.7.camel@dabdike.int.hansenpartnership.com> <20120125200613.GH15866@shiny> <20120125224614.GM30782@redhat.com> <D3F292ADF945FB49B35E96C94C2061B915A64111@nsmail.netscout.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915A64111@nsmail.netscout.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Steven Whitehouse <swhiteho@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, "<neilb@suse.de>" <neilb@suse.de>, "<dm-devel@redhat.com>" <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, "<linux-mm@kvack.org>" <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Wu Fengguang <fengguang.wu@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, "<lsf-pc@lists.linux-foundation.org>" <lsf-pc@lists.linux-foundation.org>, "Darrick J.Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 2012-01-26, at 9:40, "Loke, Chetan" <Chetan.Loke@netscout.com> wrote:
> And 'maybe' for adaptive RA just increase the RA-blocks by '1'(or some
> N) over period of time. No more smartness. A simple 10 line function is
> easy to debug/maintain. That is, a scaled-down version of
> ramp-up/ramp-down. Don't go crazy by ramping-up/down after every RA(like
> SCSI LLDD madness). Wait for some event to happen.

Doing 1-block readahead increments is a performance disaster on RAID-5/6. That means you seek all the disks, but use only a fraction of the data that the controller read internally and had to parity check.

It makes more sense to keep the read units the same size as write units (1 MB or as dictated by RAID geometry) that the filesystem is also hopefully using for allocation.  When doing a readahead it should fetch the whole chunk at one time, then not do another until it needs another full chunk.

Cheers, Andreas