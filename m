From: Suman Anna <s-anna@ti.com>
Subject: Re: DEFINE_IDA causing memory leaks? (was Re: [PATCH 1/2] virtio: fix
	memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 17:32:17 -0500
Message-ID: <55FB3F71.7070103@ti.com>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
	<1442449758-14594-2-git-send-email-s-anna@ti.com>
	<20150917082425-mutt-send-email-mst@redhat.com>
	<55FA630A.4020707@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <55FA630A.4020707@suse.de>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: open-iscsi@googlegroups.com, JBottomley@Odin.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 09/17/2015 01:51 AM, Hannes Reinecke wrote:
> On 09/17/2015 07:33 AM, Michael S. Tsirkin wrote:
>> On Wed, Sep 16, 2015 at 07:29:17PM -0500, Suman Anna wrote:
>>> The virtio core uses a static ida named virtio_index_ida for
>>> assigning index numbers to virtio devices during registration.
>>> The ida core may allocate some internal idr cache layers and
>>> an ida bitmap upon any ida allocation, and all these layers are
>>> truely freed only upon the ida destruction. The virtio_index_ida
>>> is not destroyed at present, leading to a memory leak when using
>>> the virtio core as a module and atleast one virtio device is
>>> registered and unregistered.
>>>
>>> Fix this by invoking ida_destroy() in the virtio core module
>>> exit.
>>>
>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>> Signed-off-by: Suman Anna <s-anna@ti.com>
>>
>> Interesting.
>> Will the same apply to e.g. sd_index_ida in drivers/scsi/sd.c
>> or iscsi_sess_ida in drivers/scsi/scsi_transport_iscsi.c?

Yes, I would think so as long as they are used as modules and the
modules are loaded & unloaded with a registration in between. For
built-in, it is not an issue.

A search on lkml yielded a similar fixup patches recently from Johannes
Thumshirn (actually those are using a idr, but both ida and idr use
common logic), see
https://patchwork.kernel.org/patch/6748601/ for one such patch.

>>
>> If no, why not?
>>
>> One doesn't generally expect to have to free global variables.
>> Maybe we should forbid DEFINE_IDA in modules?
>>
>> James, could you comment on this please?
>>
> Well, looking at the code 'ida_destroy' only need to be called
> if you want/need to do a general cleanup.
> It shouldn't be required if you do correct reference counting
> on your objects, and call idr_remove() on each of them.
> 
> Unless I'm misreading something.

Yeah, I should have written a better last sentence in the first para,
its not clear in the commit description without looking at my cover
letter. The memory leak is seen only when used as module and the module
is removed with atleast one ida allocation.

regards
Suman

> 
> Seems like a topic for KS; Johannes had a larger patchset recently to
> clean up idr, which run into very much the same issues.
> 
> Cheers,
> 
> Hannes
> 
