From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch/rfc/rft] sd: allocate request_queue on device's local
 numa node
Date: Tue, 23 Oct 2012 19:58:22 +0200
Message-ID: <5086DABE.7070807@kernel.dk>
References: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com> <50863D0A.6040800@acm.org> <x49fw556sgu.fsf@segfault.boston.devel.redhat.com> <5086D6EB.7020701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5086D6EB.7020701@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2012-10-23 19:42, Bart Van Assche wrote:
> On 10/23/12 18:52, Jeff Moyer wrote:
>> Bart Van Assche <bvanassche@acm.org> writes:
>>> Please keep in mind that a
>>> single PCIe bus may have a minimal distance to more than one NUMA
>>> node. See e.g. the diagram at the top of page 8 in
>>> http://bizsupport1.austin.hp.com/bc/docs/support/SupportManual/c03261871/c03261871.pdf
>>> for a system diagram of a NUMA system where each PCIe bus has a
>>> minimal distance to two different NUMA nodes.
>>
>> That's an interesting configuration.  I wonder what the numa_node sysfs
>> file contains for such systems--do you know?  I'm not sure how we could
>> allow this to be user-controlled at probe time.  Did you have a specific
>> mechanism in mind?  Module parameters?  Something else?
> 
> As far as I can see in drivers/pci/pci-sysfs.c the numa_node sysfs 
> attribute contains a single number, even for a topology like the one 
> described above.

This is an artifact of how ACPI works, it's not possible to have it be a
mask of nodes. But obviously that is how most intel based systems from
the last few years works, so the kernel parts should be updated to at
least allow it to be a mask. How to get this information is a separate
problem.

-- 
Jens Axboe
