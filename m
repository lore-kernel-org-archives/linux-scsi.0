From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: replace BKL with global mutex
Date: Tue, 1 Jun 2010 17:37:55 -0400
Message-ID: <20100601213755.GA1004@infradead.org>
References: <1275428028-10901-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275428028-10901-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Douglas Gilbert <dgilbert@interlog.com>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NAK.  You're really only creation a mini-BKL here without
sorting out the locking.  Please go through the individual
callers and sort them out.  Start by pushing the remaining
ioctls to the unlocked version and moving the BKL into the
->open and ->release methods.
