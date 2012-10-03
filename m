From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] target/file: Re-enable optional fd_buffered_io=1
 operation
Date: Wed, 3 Oct 2012 07:47:21 -0400
Message-ID: <20121003114721.GA16209@infradead.org>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
 <1348984696-30992-2-git-send-email-nab@linux-iscsi.org>
 <20121001084605.GA23497@infradead.org>
 <1349209004.28145.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349209004.28145.61.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 02, 2012 at 01:16:44PM -0700, Nicholas A. Bellinger wrote:
>          * Optionally allow fd_buffered_io=1 to be enabled for people
>          * who want use the fs buffer cache as an WriteCache mechanism.
>          *
>          * This means that in event of a hard failure, there is a risk
>          * of silent data-loss if the SCSI client has *not* performed a
>          * forced unit access (FUA) write, or issued SYNCHRONIZE_CACHE
>          * to write-out the entire device cache.
>          */

Oh, I get Vlads flame.  This doesn't simply disable O_DSYNC now but also
sets WCE=1.  In this case I don't really get the point of the patch, why
can't we simply set it from configfs?
