From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 12:41:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025194122.GE1514@beaverton.ibm.com>
References: <James.Bottomley@steeleye.com> <200210251834.g9PIY2l03794@localhost.localdomain> <20021025120802.A12776@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021025120802.A12776@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

Patrick Mansfield [patmans@us.ibm.com] wrote:
> Incorrect number of segments after building list
> counted 3, received 2
> req nr_sec 256, cur_nr_sec 8
> end_request: I/O error, dev 08:a0, sector 1334497
> qla2x00_status_entry: cmd is NULL: already returned to OS (sp=f39810e0)
> cmd_timeout: LOST command state = 0x6 
> qla2x00 (2): Did not free all srbs, Free count = 4095, Alloc Count = 4096

I this a signature of sg_tablesize not matching max_sectors.

I heard of an old issue on this.

qla2x00 values are:

max_sectors is 512

SG_SEGMENTS 32

Someone could try setting 

SG_SEGMENTS to  64.

-andmike
--
Michael Anderson
andmike@us.ibm.com

