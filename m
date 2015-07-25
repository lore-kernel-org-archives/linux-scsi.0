From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: fix crash in cmd tracing when cmd didn't match
	a LUN
Date: Sat, 25 Jul 2015 08:48:49 +0200
Message-ID: <20150725064849.GA8052@lst.de>
References: <1437689973-22991-1-git-send-email-sbaugh@catern.com> <20150724105206.GA25162@lst.de> <1437769934.26220.8.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437769934.26220.8.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Spencer Baugh <sbaugh@catern.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Alexei Potashnik <alexei@purestorage.com>, Andy Grover <agrover@redhat.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, Roland Dreier <roland@purestorage.com>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 24, 2015 at 01:32:14PM -0700, Nicholas A. Bellinger wrote:
> We've already been through this discussion a couple of years back when
> target_submit_cmd() first came into existence.
> 
> The reason iscsi/iser-target continues to be a special case is due to
> immediate data vs. non immediate data and their respective command
> sequence number ordering requirements.

I don't see how immediate data plays into this, the write_pending
callbacks can simply skip the data transfer path, similar to what
Bart's port of the latest SRP target to lio does as well.
