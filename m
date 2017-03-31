From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 0/3] Improve block device testing coverage
Date: Fri, 31 Mar 2017 10:43:19 +0300
Message-ID: <8760ip28o8.fsf@dmlp.sw.ru>
References: <1490879944-26240-1-git-send-email-dmonakhov@openvz.org> <20170331065702.GA17435@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34524 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbdCaHnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 03:43:23 -0400
In-Reply-To: <20170331065702.GA17435@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-scsi@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Mar 30, 2017 at 05:19:01PM +0400, Dmitry Monakhov wrote:
>> During LSFMM we have discussed how to test lower-backend of linux IO-stack.
>> Common opinion was that xfstests is the most obvious solution which cover
>> most of use cases filesystem care about.
>> 
>> I'm working on integration T10-DIF/DIF data integrity features to ext4,
>> for that reason we need to be shure that linux integrity framework is
>> in working state, which is currently broken in several places.
>> 
>> In fact, it is relatively simple to add basic coverage tests for basic
>> IO operations over virtual device with integrity support. All we need
>> is to add lio target support.
>
> First:  Thanks for adding block layer testing!
>
> Second: even more so than Darrick's blockdev fallocate test this is
> the wrong place.  If I run xfstests I want to test my file system,
> not random block device features.  Please start a proper block device
> testsuite instead, possibly by copy and pasting code from xfstests.
Fair enough. I also not happy to place blkdev feature  to tests/generic
namespace. But altearnative to fork xfstests infrastructure to dedicated
test-framework only for blkdevice seems not very good. Because fork is
always pain. I already maintain one internal fork of xfstests which
tests our Vituozzo's speciffic features.

May be it would be reasonable idea to add didicated namespace
'tests/blockdev' in xfstests, and move all blkdev related tests here?
IMHO this is good idea. Because filesystem relay on some basic
features from blkdev which should be tested explicitly, because
implicit testing is too hard to debug/investigation.

>
> That's how I started the test suite for qemu's block layer for example.
Do you mean qemu/tests/qemu-iotests ?
