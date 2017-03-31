From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/3] Improve block device testing coverage
Date: Fri, 31 Mar 2017 13:02:06 +0300
Message-ID: <8737dt228x.fsf@dmlp.sw.ru>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org> <20170331065702.GA17435@infradead.org> <8760ip28o8.fsf@dmlp.sw.ru> <20170331093801.GK22845@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170331093801.GK22845@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Eryu Guan <eguan@redhat.com> writes:

> On Fri, Mar 31, 2017 at 10:43:19AM +0300, Dmitry Monakhov wrote:
>> Christoph Hellwig <hch@infradead.org> writes:
>> 
>> > On Thu, Mar 30, 2017 at 05:19:01PM +0400, Dmitry Monakhov wrote:
>> >> During LSFMM we have discussed how to test lower-backend of linux IO-stack.
>> >> Common opinion was that xfstests is the most obvious solution which cover
>> >> most of use cases filesystem care about.
>> >> 
>> >> I'm working on integration T10-DIF/DIF data integrity features to ext4,
>> >> for that reason we need to be shure that linux integrity framework is
>> >> in working state, which is currently broken in several places.
>> >> 
>> >> In fact, it is relatively simple to add basic coverage tests for basic
>> >> IO operations over virtual device with integrity support. All we need
>> >> is to add lio target support.
>> >
>> > First:  Thanks for adding block layer testing!
>> >
>> > Second: even more so than Darrick's blockdev fallocate test this is
>> > the wrong place.  If I run xfstests I want to test my file system,
>> > not random block device features.  Please start a proper block device
>> > testsuite instead, possibly by copy and pasting code from xfstests.
>> Fair enough. I also not happy to place blkdev feature  to tests/generic
>> namespace. But altearnative to fork xfstests infrastructure to dedicated
>> test-framework only for blkdevice seems not very good. Because fork is
>> always pain. I already maintain one internal fork of xfstests which
>> tests our Vituozzo's speciffic features.
>> 
>> May be it would be reasonable idea to add didicated namespace
>> 'tests/blockdev' in xfstests, and move all blkdev related tests here?
>> IMHO this is good idea. Because filesystem relay on some basic
>> features from blkdev which should be tested explicitly, because
>> implicit testing is too hard to debug/investigation.
>
> I'm not sure if xfstests is the right place for blockdev tests,
> especially for the pure blockdev level features (at least Darrick's
> blockdev tests are testing fallocate(2) interface).
Another good example may be a bug with dirty page cache after blkdiscard
https://lkml.org/lkml/2017/3/22/789 . This simple bug  result in crappy
fsimage if mkfs relay on discard_zeroes_data behaviour.
So IMHO basic blkdev test coverage is important filesystem testing. i.e.
important for xfstests.
>
> But yeah, a new tests/blockdev dir would be good if we eventually decide
> adding blockdev tests to xfstests, so they're not run by default when
> people want to test filesystems.
>
> Thanks,
> Eryu
