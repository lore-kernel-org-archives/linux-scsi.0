Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1793CB;
	Mon, 27 Nov 2023 01:29:37 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB26567373; Mon, 27 Nov 2023 10:29:33 +0100 (CET)
Date: Mon, 27 Nov 2023 10:29:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Daejun Park <daejun7.park@samsung.com>, Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 01/15] fs: Rename the kernel-internal data lifetime
 constants
Message-ID: <20231127092933.GA3572@lst.de>
References: <20231114214132.1486867-1-bvanassche@acm.org> <20231114214132.1486867-2-bvanassche@acm.org> <CGME20231127070931epcas5p4a75cd61de4c00a00b9c75518d1831bbf@epcas5p4.samsung.com> <20231127070830.GA27870@lst.de> <1e2481ac-6075-c940-327b-350f1d4b9ee5@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e2481ac-6075-c940-327b-350f1d4b9ee5@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 02:15:51PM +0530, Kanchan Joshi wrote:
> How about this argument (assuming you may not have seen) from previous 
> iteration [1]-
> 
> "Does it make sense to do away with these, and have temperature-neutral
> names instead e.g., WRITE_LIFE_1, WRITE_LIFE_2?
> 
> With the current choice:
> - If the count goes up (beyond 5 hints), infra can scale fine but these
> names do not. Imagine ULTRA_EXTREME after EXTREME.
> - Applications or in-kernel users can specify LONG hint with data that
> actually has a SHORT lifetime. Nothing really ensures that LONG is
> really LONG.
> 
> Temperature-neutral names seem more generic/scalable and do not present
> the unnecessary need to be accurate with relative temperatures."

I don't really buy it, as that's not the use case we currently have,
which hasn't changed.  And even if we did, life would probably be
simpler if you decoupled it from this series..

But IFF we decided to do away with the meanings, having constants
that just are numbered simply doesn't make any sense.
