From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 23:11:33 -0700
Message-ID: <45219028-09FB-476E-8519-1D4528C4D288@dilger.ca>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com> <20120117200609.GA7933@redhat.com> <20120117213648.GA9457@quack.suse.cz> <20120118225808.GA3074@tux1.beaverton.ibm.com> <20120118232200.GA22019@quack.suse.cz> <4F1758D4.9010401@panasas.com> <20120125112352.0dfadc0b@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120125112352.0dfadc0b@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@us.ibm.com>, Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2012-01-24, at 5:23 PM, NeilBrown wrote:
> On Thu, 19 Jan 2012 01:42:12 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>> Or possibly modify md-raid5 not to snapshot dirty pages prior to xor/write?
>>>> (I never really bothered to find out if it really does this.)
>> 
>> md-raid5/1 currently copies all pages if that what you meant.
>> 
> 
> Small correction:  RAID5 and RAID6 copy all pages.
>                   RAID1 and RAID10 do not.
> 
> If the incoming bios had nicely aligned pages which were somehow flagged to
> say that they would not change until the request completed, then it should be
> trivial to avoid that copy.

Lustre has a patch to that effect that we've been carrying for several years.
It avoids copying of the pages submitted to the RAID5/6 layer, and provides
a significant improvement in performance and efficiency.

A version of the patches for RHEL6 is available at:

http://review.whamcloud.com/1142

though I don't know how close it is to working with the latest kernel.

Cheers, Andreas





