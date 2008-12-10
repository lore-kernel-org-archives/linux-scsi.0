From: Grant Grundler <grundler@google.com>
Subject: Re: libata / scsi separation
Date: Wed, 10 Dec 2008 09:11:34 -0800
Message-ID: <da824cf30812100911o1f7f23bbi3277dfa3932f8964@mail.gmail.com>
References: <493B022B.3050406@ru.mvista.com>
	 <1228662298.3501.19.camel@localhost.localdomain>
	 <20081209222113.GU25548@parisc-linux.org> <493F2151.6010702@gmail.com>
	 <da824cf30812091829g180b3e45i843e356364bc2f9f@mail.gmail.com>
	 <493F2DA9.7040008@gmail.com>
	 <da824cf30812091923j241f915dmbcb27245c0d0491b@mail.gmail.com>
	 <493F3B33.8010607@gmail.com> <20081210152445.GW25548@parisc-linux.org>
	 <493FE15C.4060907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <493FE15C.4060907@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 10, 2008 at 7:33 AM, Tejun Heo <htejun@gmail.com> wrote:
...
> And yeap we definitely should try to do that too but I don't think
> RW_SG would be as useless as jumbo frames (much less compatibility
> problem and no loss of functionality),

Jumbo frames aren't useless. They just don't apply to the "small message
passing overhead" problem. Users doing bulk data transfer (NAS, FTP, etc)
are pretty happy with TCP Segmentation Offloading (cousin of Jumbo Frames).

> and the actual hardware
> overhead of issuing separate commands for each 4k segment is way
> higher than anything we do along the block and low level driver layers
> in terms of IO access, host bus and ATA (or SAS) bus overhead.

That's true and it was also true gigabit NICs in the 90's. NIC HW vendors
have figured out host to avoid doing MMIO reads/writes during normal IO.
Infiniband has an even more efficient interface that's mostly Host RAM based
(a few MMIO writes). Last time I measured (~2006), TCP stack was 4x the
CPU cost of the HW interface. I don't know what the current ratio is for
any given SATA controller vs libata/SCSI stack, but I'm certain it will
change as new controllers are introduced.

hth,
grant
