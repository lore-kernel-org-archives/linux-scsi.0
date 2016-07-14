From: Tejun Heo <tj@kernel.org>
Subject: Re: Fluctuating "acceptance" on requested data length in SATA/AHCI
Date: Thu, 14 Jul 2016 17:09:03 -0400
Message-ID: <20160714210903.GA3078@mtj.duckdns.org>
References: <CAGnHSEkPkm3z3Aj+Aaj2p7ZK-UEo0dvXE+6Cj8SdKCt_L7Ei=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEkPkm3z3Aj+Aaj2p7ZK-UEo0dvXE+6Cj8SdKCt_L7Ei=w@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, dgilbert@interlog.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 15, 2016 at 03:10:40AM +0800, Tom Yan wrote:
> I hadn't been able to "locate" a sensible and/or solid point where the
> fluctuation start, but I did notice that the chance of "failure" would
> rise with the requested length. Also, if I boot with
> `libata.force=noncq`, the failure seems to start off from a lower
> point.
> 
> So is that an expected characteristic of SATA/AHCI? Or does that hint
> that there is something wrong in the kernel? And btw, should any block
> limit be set according to this? For example, max_sectors?

Host controllers and drivers have constraints other than max transfer
size such as max scatter gather table entries (how many disconnected
sections can be transferred on one command) and DMA boundary (the
memory boundary that a single DMA transfer can't cross), so if you go
to the high command size, it isn't surprising that commands of the
same length succeed sometimes while not on others.

Thanks.

-- 
tejun
