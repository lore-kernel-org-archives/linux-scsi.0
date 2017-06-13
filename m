From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Mon, 12 Jun 2017 23:31:11 -0700
Message-ID: <20170613063111.GA2212@infradead.org>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
 <20170305173528.00006b41@gmx.de>
 <CAL1RGDVBvgzaQTRfWS14=S1M1DuzKGPYzAPWWeQyAASDQ=05Rw@mail.gmail.com>
 <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55205e7e-e1c6-5f09-8dd3-338492728dfe@broadcom.com>
Sender: target-devel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Roland Dreier <roland@purestorage.com>, Sebastian Herbszt <herbszt@gmx.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James,

I like the plan except for one bit:  The staging tree will be a major
pain due to the rules for applying to it and all the whitespace
cleanup junk you'll get.  I would storngly recommend to you to
do this with a non-mainline tree instead.  I'd be happy to help you
maintaining it if you want.

> Questions:
> a) How best to deal with overlapping pci id's ?  E.g. if we do (1) and we
> have an initiator and target driver, there is a lot of adapters that are
> fully functional for target operation, but were sold as primarily an
> initiator adapter. How could we manage target mode enablement without code
> mod or hard pci id partitioning ?   I know individual pci unbind/bind could
> work, but its been frowned upon as a long term option. Same thing goes for
> module parameters to select which ports do what role.

Let's start with a manual bind for the target driver.  A slightly
more fancy option would be to add the PCI IDs to both and reject
the device with -ENXIO if not configured for the right role.
