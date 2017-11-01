From: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: system hung up when offlining CPUs
Date: Wed, 1 Nov 2017 01:47:01 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1711010105260.1942@nanos>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com> <cd524af7-1f20-1956-1e44-92a451053387@gmail.com> <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com> <20170821131809.GA17564@lst.de> <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com>
 <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com> <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com> <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de> <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com> <alpine.DEB.2.20.1709131529400.1874@nanos>
 <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com> <alpine.DEB.2.20.1709161212160.2105@nanos> <alpine.DEB.2.20.1709161630580.2105@nanos> <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com> <alpine.DEB.2.20.1710032328280.2278@nanos> <alpine.DEB.2.20.1710042208400.2406@nanos>
 <3d93387d-30eb-0434-2216-0e6435c633f8@gmail.com> <857c813c-29cd-6e9f-5cde-52421d4d8429@gmail.com> <alpine.DEB.2.20.1710162106400.2037@nanos> <817f0d359fca6830ece5b1fcf207ce65@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <817f0d359fca6830ece5b1fcf207ce65@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 30 Oct 2017, Shivasharan Srikanteshwara wrote:

> In managed-interrupts case, interrupts which were affine to the offlined
> CPU is not getting migrated to another available CPU. But the
> documentation at below link says that "all interrupts" are migrated to a
> new CPU. So not all interrupts are getting migrated to a new CPU then.

Correct.

> https://www.kernel.org/doc/html/v4.11/core-api/cpu_hotplug.html#the-offlin
> e-case
> "- All interrupts targeted to this CPU are migrated to a new CPU"

Well, documentation is not always up to date :)
 
> Once the last CPU in the affinity mask is offlined and a particular IRQ
> is shutdown, is there a way currently for the device driver to get
> callback to complete all outstanding requests on that queue?

No and I have no idea how the other drivers deal with that.

The way you can do that is to have your own hotplug callback which is
invoked when the cpu goes down, but way before the interrupt is shut down,
which is one of the last steps. Ideally this would be a callback in the
generic block code which then calls out to all instances like its done for
the cpu dead state.

Jens, Christoph?

Thanks,

	tglx
