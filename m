From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Tue, 8 Dec 2015 13:18:31 -0800
Message-ID: <CAPcyv4gJrdP23sh2cQU94fpq6+Z9GBjxWf0RpBp_4+kydpQAsA@mail.gmail.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	<1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
	<1449271801.27077.25.camel@HansenPartnership.com>
	<1449273524.16905.103.camel@intel.com>
	<87egewslfa.fsf@notabene.neil.brown.name>
	<1449608892.16905.121.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449608892.16905.121.camel@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>, "neilb@suse.com" <neilb@suse.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 8, 2015 at 1:08 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Wed, 2015-12-09 at 08:03 +1100, NeilBrown wrote:
>> On Sat, Dec 05 2015, Verma, Vishal L wrote:
>> > >
>> > > > +int badblocks_clear(struct badblocks *bb, sector_t s, int
>> > > > sectors)
>> > > > +{
>> > > [...]
>> > > > +#define DO_DEBUG 1
>> > >
>> > > Why have this at all if it's unconditionally defined and always
>> > > set.
>> >
>> > Neil - any reason or anything you had in mind for this? Or is it
>> > just an
>> > artifact and can be removed.
>>
>> Like the comment says:
>>
>>       /* Allow clearing via sysfs *only* for testing/debugging.
>>        * Normally only a successful write may clear a badblock
>>        */
>>
>> The DO_DEBUG define and ifdefs are documentation identifying bits of
>> code that should be removed when it all seems to be working.
>> Maybe now is a good time to remove that code.
>>
> Hm, I think it would be nice to continue to have the ability to clear
> badblocks using sysfs at least for a while more, as we test the various
> error handling paths for NVDIMMS (Dan, thoughts?).
>
> We could either remove it later or (I'm leaning towards) make it a
> config option similar to FAIL_MAKE_REQUEST and friends..

"later" as in before v4.5-rc1?  We can always carry this debug feature
locally for testing.  We don't want userspace growing ABI attachments
to this capability now that it's more than just md tooling that will
see this.
