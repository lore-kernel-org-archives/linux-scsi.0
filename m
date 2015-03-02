From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Sun, 01 Mar 2015 22:59:34 -0800
Message-ID: <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
References: <54B63F74.2040702@sandisk.com>
	 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
	 <54ED8B38.10904@sandisk.com>
	 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
	 <54F1ADAF.90808@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54F1ADAF.90808@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2015-02-28 at 12:59 +0100, Bart Van Assche wrote:
> On 02/27/15 22:58, Nicholas A. Bellinger wrote:
> > Looking at how your attempting to drive creation + removal of struct
> > config_group from within kernel code here:
> > 
> > target: Add target port registration API
> > https://github.com/bvanassche/linux/commit/dbb8bf32db3428ede6ecc688ede1e5e01fc59d88
> > 
> > is the exactly the wrong approach to take.
> > 
> > The creation and deletion of struct config_group must be driven by
> > user-space, and by user-space only.  No exceptions will be made.
> 
> There exists an approach that preserves the ABI of both SCST and LIO,
> namely:
> * Add empty transport_register_wwn() and transport_unregister_wwn()
>   functions in the LIO core.
> * Add calls to these functions at the appropriate place in the FC
>   and SRP target drivers.
> * In the SCST implementation of the unified target driver API, route
>   calls to transport_register_wwn() and transport_unregister_wwn() to
>   scst_register_target() and scst_unregister_target() respectively.
> 

NAK.

I'll not consider any hooks in upstream target code, and certainly not
driver hooks for a control-plane approach unanimously rejected by both
configfs and sysfs maintainers in 2008 and 2010.

The whole point of target_core_fabric_configfs.c is to transparently
reference count fabric driver data structures populated underneath
/sys/kernel/config/target/$FABRIC/, who's design also has the added
bonus of providing module reference counting to drivers 'for free'.

So until you're prepared to evolve on this issue and stop pretending as
if the future didn't already happen, this type of discussion at LSF is a
waste of time.

--nab
