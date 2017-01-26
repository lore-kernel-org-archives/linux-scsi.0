From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/16] block: split scsi_request out of
	struct request
Date: Thu, 26 Jan 2017 20:37:34 +0100
Message-ID: <20170126193734.GA26037@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
	<1485185361-29786-16-git-send-email-hch@lst.de>
	<455a58ef-905c-abf9-ae59-ca98f003f31e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <455a58ef-905c-abf9-ae59-ca98f003f31e@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2017 at 11:12:51AM -0800, Bart Van Assche wrote:
> Where does the '* 3' come from? I think that deserves a comment.
> Additionally, this patch introduces a new warning when building with W=1:

It's a magic factor copied from the old code :(

That beeing said I really wonder if we should keep the tracing for
the scsi_requests fields at all.  We have tracing in SCSI, and poking
into these SCSI fields from block code is painful and just screams
layering violations.

Jens, any opinion on just removing the printout of the SCSI CDB
for blktrace?
