From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 10/10] libsas: feed the scsi_block_when_processing_errors()
 meter
Date: Thu, 2 Feb 2012 00:04:43 -0800
Message-ID: <CAA9_cmf4_AtQ7WFO-hUxced=hxZxVgZuhJEesB5k6EBTWCqZFA@mail.gmail.com>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
	<20120117051153.22344.92696.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120117051153.22344.92696.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Abraham Carranza <abrahamx.c.carranza@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 16, 2012 at 9:11 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> This is called per-sdev but in the sas-transport case this waits for =
the
> entire domain to recover which is never guaranteed to be less than 12=
0
> seconds with libata taking nearly a minute per-device to recover. =A0=
Ping
> the waitqueue so that the hung task timer knows we're still making
> progress.

I'm now not so sure about this one.  This was implemented before the
change to asynchronously scan ata devices where serial discover could
take inordinate amounts of time.

Jack already reported a scan time reduction of 3 minutes down to 5
seconds with the async code, so I'll drop this patch.

Even if recovery was taking a long time this patch would only move the
hung task timeout backtrace to another location in the kernel that was
dependent on the completion of error handling.

--
Dan
