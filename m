From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Fri, 13 Aug 2010 13:48:58 +0200
Message-ID: <20100813114858.GA31937@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281616891-5691-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

The patchset looks functionally correct to me, and with a small patch
to make use of WRITE_FUA_FLUSH survives xfstests, and instrumenting the
underlying qemu shows that we actually get the flush requests where we should.

No performance or power fail testing done yet.

But I do not like the transition very much.  The new WRITE_FUA_FLUSH
request is exactly what filesystems expect from a current barrier
request, so I'd rather move to that functionality without breaking stuff
inbetween.

So if it was to me I'd keep patches 1, 2, 4 and 5 from your series, than
a main one to relax barrier semantics, then have the renaming patches 7
and 8, and possible keep patch 11 separate from the main implementation
change, and if absolutely also a separate one to introduce REQ_FUA and
REQ_FLUSH in the bio interface, but keep things working while doing
this.

Then we can patches do disable the reiserfs barrier "optimization" as
the very first one, and DM/MD support which I'm currently working on
as the last one and we can start doing the heavy testing.

