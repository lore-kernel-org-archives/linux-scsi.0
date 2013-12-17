From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Mon, 16 Dec 2013 17:59:02 -0800
Message-ID: <1387245542.20247.284.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1387231426.20247.260.camel@haakon3.risingtidesystems.com>
	 <52AFADB3.3060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52AFADB3.3060101@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-12-16 at 17:49 -0800, Andy Grover wrote:
> On 12/16/2013 02:03 PM, Nicholas A. Bellinger wrote:
> > On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> >> Hi Nicholas,
> >>
> >> This patchset uses krefs to refcount structures shared across threads.
> >> LIO is full of these because configfs-based configuration actions can
> >> be removing an object, even while that object is being used by a SCSI
> >> command.
> >>
> >> Using kref to free the struct on whichever thread drops the last
> >> reference allows us to avoid busy-waiting in configfs removal functions.
> >> Next, this set removes the statically-sized tpg lun and deve arrays in
> >> favor of dynamically adding entries into rbtrees. This reduces memory
> >> consumption and allows more than 255 luns per tpg and initiator mapping.
> >>
> >> Except for some rbtree lookups, these changes are entirely in the
> >> configuration paths of Lio. I have tested these as extensively as I can,
> >> and it's ready for wider testing.
> >>
> >> Note: patch 22 converts a percpu refcount to a normal kref. I'd argue
> >> the benefit is really in the "refcount" part rather than the "percpu",
> >> so a simpler kref does the job, but we might want to discuss this some
> >> more.
> >>
> >
> > It would be helpful to breakup future patches into different series
> > based on:
> >
> >    * Bugfixes
> >    * New features
> >    * Minor improvements
> 
> Thanks for all the reviews. For the remaining changes, it'll be after 
> the new year before a v2. I'm still hopeful we can work out the issues 
> preventing the use of krefs.
> 

So I'd like to see krefs implemented for these cases, but the rub is
that configfs_group_operations->drop_items() cannot return before the
last reference has dropped.

> I'm somewhat surprised over the resistance to rbtrees. I guess I'll need 
> to hold off on resubmitting that until I have some performance data on 
> their effect.
> 

I do appreciate the effort, but the extra pointer chasing here makes
rbtrees prohibitively expensive for fast past operations.

--nab
