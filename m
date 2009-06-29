From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Mon, 29 Jun 2009 14:52:17 +0200
Message-ID: <20090629125217.GI23611@kernel.dk>
References: <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown> <20090626125037.GO23611@kernel.dk> <f0d53a7338e1be4e7bdcbe09223c6f73.squirrel@neil.brown.name> <20090626132940.GR23611@kernel.dk> <19014.4447.248248.63960@notabene.brown> <20090629101841.GF23611@kernel.dk> <b0aa07ac85efd6040501e4ea875176a3.squirrel@neil.brown.name> <20090629114121.GH23611@kernel.dk> <4A48B75C.5080209@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A48B75C.5080209@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: NeilBrown <neilb@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 29 2009, Boaz Harrosh wrote:
> On 06/29/2009 02:41 PM, Jens Axboe wrote:
> > On Mon, Jun 29 2009, NeilBrown wrote:
> >> On Mon, June 29, 2009 8:18 pm, Jens Axboe wrote:
> >>> On Sat, Jun 27 2009, Neil Brown wrote:
> >>>>> There's no such thing as first or second class block devices. The fact
> >>>>> that drivers using ->make_request_fn directly do not utilize the full
> >>>>> scope of the queue isn't a very interesting fact, imho.
> >>>>  Your phrase "drivers using ->make_request_fn directly" seems to
> >>>>  suggest you are looking at things very differently to me.
> >>>>
> >>>>  From my perspective, all drivers use ->make_request_fn equally.
> >>>>  Some set it to "__make_request", some to "md_make_request", others to
> >>>>  "dm_request" or "loop_make_request" etc.
> >>> Neil, will you please stop these silly games. Stop trying to invent
> >>> differences based on interpretations of what you read into my replies.
> >>
> >> We do seem to be having trouble communicating don't we :-(
> >> Be assured that it is not my intention to play games, silly or otherwise.
> >>
> >> Maybe I should just try sending you patches.  Maybe that will
> >> make my meaning clearer.
> >>
> >> For the moment, I'm much more interested in the other question,
> >> that of whether I can avoid having a 'queue' directory introduced into
> >> md/dm/etc device directories in sysfs.
> > 
> > We already talked about this, several times. My answer is that it seems
> > pointless to begin with internally, and externally it just makes the API
> > worse since tools then have to know which device type they are talking
> > to.
> > 
> 
> I do however see a problem with sysfs-files that mostly work for most
> devices but for some "device type" they do nothing silently. At least
> make these directory/files read-only for the un-used cases (eg.
> dm/md). And return proper values to indicate their un-usefulness like
> "-1" or "NA"

I agree, but most of the files do have a meaning for the device types.
It's all about making the interface sane, moving things around is not a
sane interface. Making sure that the files propagate their proper
meaning is, so if some file does not make sense for device type X, then
by all means we should make sure that is apparent.

-- 
Jens Axboe

