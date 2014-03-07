From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 5/6] target: Allocate se_luns only when used
Date: Fri, 07 Mar 2014 10:31:57 -0800
Message-ID: <531A109D.4030007@redhat.com>
References: <1394144131-31499-1-git-send-email-agrover@redhat.com> <1394144131-31499-6-git-send-email-agrover@redhat.com> <20140307104114.GC14195@infradead.org> <531A0BF9.9040504@redhat.com> <20140307182232.GA5474@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140307182232.GA5474@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/07/2014 10:22 AM, Christoph Hellwig wrote:
> On Fri, Mar 07, 2014 at 10:12:09AM -0800, Andy Grover wrote:
>>> I can't see how the synchronization can work without refcounting the lun
>>> structure.  The lock just protectes the assignment, but you free it
>>> right after.  What happens to how jsut dereferenced it under the lock
>>> but then uses it outside (e.g. core_dev_add_initiator_node_lun_acl).
>>
>> Well you're right, but this is one instance of a larger lio
>> locking/refcounting hairball. This will be addressed in a separate
>> patch series.
>
> I don't think that's true. Before your series we might be accessing a
> lun structure that was marked as not active just before, but now the
> race becomes a genuine use after free.

OK. I'll work on a follow-on patch that ensures the locks are held long 
enough.

Thanks -- Andy
