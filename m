From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Tue, 31 Aug 2010 12:55:23 +0300
Message-ID: <4C7CD18B.2060608@panasas.com>
References: <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de> <4C753D75.2010305@kernel.org> <20100825200223.GE2738@quack.suse.cz> <4C76250B.6060800@kernel.org> <20100827173147.GA12374@quack.suse.cz> <x4939tv98n8.fsf@segfault.boston.devel.redhat.com> <20100830202034.GB12226@quack.quadriga.com> <4C7C170D.9090409@vlnb.net> <20100830210205.GD12226@quack.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:53449 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183Ab0HaJzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 05:55:32 -0400
In-Reply-To: <20100830210205.GD12226@quack.quadriga.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>

On 08/31/2010 12:02 AM, Jan Kara wrote:
> On Tue 31-08-10 00:39:41, Vladislav Bolkhovitin wrote:
>> Jan Kara, on 08/31/2010 12:20 AM wrote:
>>> On Mon 30-08-10 15:56:43, Jeff Moyer wrote:
>>>> Jan Kara<jack@suse.cz>  writes:
>>>>
>>>>>   An update: I've set up an ext4 barrier testing in KVM - run fsstress,
>>>>> kill KVM at some random moment and check that the filesystem is consistent
>>>>> (kvm is run in cache=writeback mode to simulate disk cache). About 70 runs
>>>>
>>>> But doesn't your "disk cache" survive the "power cycle" of your guest?
>>>   Yes, you're right. Thinking about it now the test setup was wrong because
>>> it didn't refuse writes to the VM's data partition after the moment I
>>> killed KVM. Thanks for catching this. I will probably have to use the fault
>>> injection on the host to disallow writing the device at a certain moment.
>>> Or does somebody have a better option?
>>
>> Have you considered to setup a second box as an iSCSI target (e.g.
>> with iSCSI-SCST)? With it killing the connectivity is just a matter
>> of a single iptables command + a lot more options.

Still same problem no? the data is still cached on the backing store device
how do you trash the cached data?

>   Hmm, this might be an interesting option. Will try that. Thanks for
> suggestion. 
> 
> 								Honza

with stgt it's very simple as well. It's a user mode application.
All on the same machine:
- run stgt application
- login + mount a filesystem
- run test
- kill -9 stgt mid flight

But how to throw away the data on the backing store cache?

Boaz
