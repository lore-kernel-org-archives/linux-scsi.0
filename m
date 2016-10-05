From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and
 blk_resume_queue()
Date: Wed, 5 Oct 2016 16:00:38 -0700
Message-ID: <686e3937-0068-0f52-1208-1a832ff591c2@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com>
 <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
 <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com>
 <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
 <a11bb09a-6207-f4a8-cfd4-4fe5627c1700@sandisk.com>
 <09238e87-7d60-89c9-98b0-e51caa0c0839@grimberg.me>
 <6d612be9-7ba7-888e-f9c6-f8aa4ef1606a@sandisk.com>
 <732bf5d6-d7a8-6ff0-6501-8a3d46f12fab@grimberg.me>
 <07628c2f-3a4e-b12e-663a-b0711ce20cc9@sandisk.com>
 <CACVXFVMwQnOuUukEMO8CyG3sPOg6DxuKAZx+5FT+LS+hGAcWVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMwQnOuUukEMO8CyG3sPOg6DxuKAZx+5FT+LS+hGAcWVQ@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 10/05/2016 03:49 PM, Ming Lei wrote:
> We can use srcu read lock for BLOCKING and rcu read lock for non-BLOCKING,
> by putting *_read_lock() and *_read_unlock() into two wrappers, which
> should minimize the cost of srcu read lock & unlock and the code is still easy
> to read & verify.

Hello Ming,

The lock checking algorithms in the sparse and smatch static checkers 
are unable to deal with code of the type "if (condition) (un)lock()". So 
unless someone has a better proposal my preference is to use the 
approach from the patch at the start of this e-mail thread.

Thanks,

Bart.

