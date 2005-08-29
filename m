From: Mark Lord <liml@rtr.ca>
Subject: Re: libata: clustering on or off?
Date: Mon, 29 Aug 2005 11:56:53 -0400
Message-ID: <43133045.7050107@rtr.ca>
References: <20050828094218.GA29145@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050828094218.GA29145@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

Clustering has always been a (small) win for the ATA/SATA hardware
I have worked on.  Many controllers read the scatter-gather list
"on demand", so if clustering is not used, there are a lot of
times where the controller must stop streaming data, and fetch
the next s/g entry, then resume streaming data.

Clustering reduces the number of such events, giving better bus
utilization and (slightly) faster transfers.

The more modern hardware I'm working with now will generally
read the s/g table in larger blocks, so that it only rarely
needs to interrupt data transfers to fetch s/g info.
Clustering is not as big a win with this, but still reduces
total bus cycles required.

Cheers
