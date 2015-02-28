From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Sat, 28 Feb 2015 12:59:43 +0100
Message-ID: <54F1ADAF.90808@sandisk.com>
References: <54B63F74.2040702@sandisk.com>
	 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
	 <54ED8B38.10904@sandisk.com>
 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/27/15 22:58, Nicholas A. Bellinger wrote:
> Looking at how your attempting to drive creation + removal of struct
> config_group from within kernel code here:
> 
> target: Add target port registration API
> https://github.com/bvanassche/linux/commit/dbb8bf32db3428ede6ecc688ede1e5e01fc59d88
> 
> is the exactly the wrong approach to take.
> 
> The creation and deletion of struct config_group must be driven by
> user-space, and by user-space only.  No exceptions will be made.

There exists an approach that preserves the ABI of both SCST and LIO,
namely:
* Add empty transport_register_wwn() and transport_unregister_wwn()
  functions in the LIO core.
* Add calls to these functions at the appropriate place in the FC
  and SRP target drivers.
* In the SCST implementation of the unified target driver API, route
  calls to transport_register_wwn() and transport_unregister_wwn() to
  scst_register_target() and scst_unregister_target() respectively.

Bart.
